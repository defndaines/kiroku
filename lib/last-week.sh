#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

day_of_week=$(date +%u)

# Days until next Sunday (if today is Sunday, next Sunday is 0 days away).
if [ "$day_of_week" -eq 7 ]; then
  days_until_sunday=0
else
  days_until_sunday=$((7 - day_of_week))
fi

next_sunday=$(date -v+${days_until_sunday}d +%Y-%m-%d)
prev_sunday=$(date -v-"${day_of_week}"d +%Y-%m-%d)
git_since="${prev_sunday} 01:00"

output_file="${REPO_DIR}/archives/${next_sunday}.txt"

# Last commit before the cutoff
base_commit=$(git -C "$REPO_DIR" rev-list -1 --before="${git_since}" HEAD)

# Extract added data rows from a file (strips diff +prefix, excludes header/separator).
added_rows() {
  git -C "$REPO_DIR" diff "${base_commit}" HEAD -- "$1" \
    | grep '^+|' \
    | grep -v '^+| --- ' \
    | grep -v '^+| Title |' \
    | sed 's/^+//'
}

reading_lines=$(added_rows "2026-reading.md")
graphic_novel_lines=$(added_rows "2026-graphic-novels.md")

# Section: header, blank line, then entries reversed (oldest first), each
# followed by a blank line.
output_section() {
  local header="$1"
  local lines="$2"

  [ -z "$lines" ] && return

  echo "$header"
  echo ""
  echo "$lines" | tail -r | while IFS= read -r line; do
    echo "$line" | cut -d\| -f2-3 | sed 's/^ /“/; s/ |/”/; s/ $//'
    echo ""
  done
}

{
  if [ -n "$reading_lines" ]; then
    fiction=$(echo "$reading_lines" | grep -ivE "nonfiction|short stor|novella|novelette" || true)
    short_fiction=$(echo "$reading_lines" | grep -iE "short stor|novella|novelette" || true)
    nonfiction=$(echo "$reading_lines" | grep -iE "nonfiction" || true)

    output_section "## Fiction" "$fiction"
    output_section "## Short Fiction" "$short_fiction"
    output_section "## Nonfiction" "$nonfiction"
  fi

  if [ -n "$graphic_novel_lines" ]; then
    gn=$(echo "$graphic_novel_lines" | grep -ivE "manga|manhwa" || true)
    manga=$(echo "$graphic_novel_lines" | grep -iE "manga" || true)
    manhwa=$(echo "$graphic_novel_lines" | grep -iE "manhwa" || true)

    output_section "## Manhwa" "$manhwa"
    output_section "## Manga" "$manga"
    output_section "## Graphic Novels" "$gn"
  fi
} > "$output_file"

echo "Created $output_file"
