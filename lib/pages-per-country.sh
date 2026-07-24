#!/bin/bash
# Reports total pages per country from a reading table, double-counting
# pages across every country a book lists. Sorted by total pages descending.
# Usage: pages-per-country.sh <file> [file ...]

files="$*"

awk -F' *\\| *' '
FNR == 1 { header_seen = 0; pages_col = 0; country_col = 0 }
!header_seen {
  if ($0 !~ /[A-Za-z0-9]/) next
  for (i = 1; i <= NF; i++) {
    field = tolower($i)
    if (field == "pages") pages_col = i
    if (field == "country") country_col = i
  }
  if (pages_col && country_col) header_seen = 1
  next
}
$0 ~ /---/ { next }
{
  pages = $pages_col
  gsub(/[^0-9]/, "", pages)
  if (pages == "") next
  total += pages

  n = split($country_col, country_arr, ",")
  for (i = 1; i <= n; i++) {
    country = country_arr[i]
    gsub(/^ +| +$/, "", country)
    gsub(/\[[^]]*\]\([^)]*\)/, "", country)
    if (country != "") totals[country] += pages
  }
}
END {
  for (country in totals) printf "%5d  %5.1f%%  %s\n", totals[country], totals[country] * 100 / total, country
}
' $files | sort -rn
