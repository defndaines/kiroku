#!/bin/bash
# Reports average rating per tag across all *-reading.md tables,
# double-counting a book across every tag it lists. Sorted by average
# rating descending, rendered as an aligned markdown table.
#
# Graphic novels are tracked differently across years: in 2023/2024 they're
# mixed into *-reading.md and marked with a "graphic novel" tag, but from
# 2025 on they live in separate *-graphic-novels.md files. Included by
# default; pass -x to exclude them from both cases.
#
# Usage: average-rating-by-tag.sh [-t|--threshold N] [-x|--exclude-graphic-novels]

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

threshold=3
exclude_graphic_novels=0

while [ $# -gt 0 ]; do
  case "$1" in
    -t|--threshold)
      threshold="$2"
      shift 2
      ;;
    -x|--exclude-graphic-novels)
      exclude_graphic_novels=1
      shift
      ;;
    *)
      echo "Usage: $(basename "$0") [-t|--threshold N] [-x|--exclude-graphic-novels]" >&2
      exit 1
      ;;
  esac
done

files=("$REPO_DIR"/*-reading.md)
if [ "$exclude_graphic_novels" -eq 0 ]; then
  files+=("$REPO_DIR"/*-graphic-novels.md)
fi

(echo "Tag|Count|Average"
awk -F' *\\| *' -v exclude_gn="$exclude_graphic_novels" '
FNR == 1 { header_seen = 0; rcol = 0; tcol = 0 }
!header_seen {
  if ($0 !~ /[A-Za-z0-9]/) next
  for (i = 1; i <= NF; i++) {
    field = tolower($i)
    if (field == "rating") rcol = i
    if (field == "tags" || field == "genre") tcol = i
  }
  if (rcol && tcol) header_seen = 1
  next
}
$0 ~ /---/ { next }
{
  if (exclude_gn && $tcol ~ /graphic novel/) next

  n = split($tcol, parts, ",")
  for (i = 1; i <= n; i++) {
    tag = parts[i]
    gsub(/^ +| +$/, "", tag)
    if (tag != "") {
      sum[tag] += $rcol
      count[tag]++
    }
  }
}
END {
  for (tag in count)
    printf "%s|%d|%.2f\n", tag, count[tag], sum[tag] / count[tag]
}
' "${files[@]}" | awk -F'|' -v min="$threshold" '$2 >= min' | sort -t'|' -k3 -rn) |
  awk -F'|' '
  {
    for (i = 1; i <= NF; i++) {
      gsub(/^ +| +$/, "", $i)
      a[NR, i] = $i
      if (length($i) > w[i]) w[i] = length($i)
    }
    cols = NF; rows = NR
  }
  END {
    for (r = 1; r <= rows; r++) {
      printf "|"
      for (i = 1; i <= cols; i++) printf " %-" w[i] "s |", a[r, i]
      printf "\n"
      if (r == 1) {
        printf "|"
        for (i = 1; i <= cols; i++) {
          dashes = ""
          for (j = 0; j < w[i]; j++) dashes = dashes "-"
          printf " %s |", dashes
        }
        printf "\n"
      }
    }
  }
  '
