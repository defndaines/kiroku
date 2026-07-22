#!/bin/bash
# Reports total pages per genre/tag from a reading table, double-counting
# pages across every tag a book has. Sorted by total pages descending.
# Usage: pages-per-genre.sh <file> [file ...]

files="$*"

awk -F' *\\| *' '
FNR == 1 { header_seen = 0; pages_col = 0; tags_col = 0 }
!header_seen {
  if ($0 !~ /[A-Za-z0-9]/) next
  for (i = 1; i <= NF; i++) {
    field = tolower($i)
    if (field == "pages") pages_col = i
    if (field == "tags") tags_col = i
  }
  if (pages_col && tags_col) header_seen = 1
  next
}
$0 ~ /---/ { next }
{
  pages = $pages_col
  gsub(/[^0-9]/, "", pages)
  if (pages == "") next
  total += pages

  n = split($tags_col, tag_arr, ",")
  for (i = 1; i <= n; i++) {
    tag = tag_arr[i]
    gsub(/^ +| +$/, "", tag)
    gsub(/\[[^]]*\]\([^)]*\)/, "", tag)
    if (tag != "") totals[tag] += pages
  }
}
END {
  for (tag in totals) printf "%5d  %5.1f%%  %s\n", totals[tag], totals[tag] * 100 / total, tag
}
' $files | sort -rn
