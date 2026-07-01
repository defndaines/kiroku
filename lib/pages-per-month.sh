#!/bin/bash
# Reports pages read per month derived from git history.
# Usage: pages-per-month.sh [file ...]

files="$*"

git log --pretty=format:"DATE:%ad" --date=format:"%Y-%m" -p -- $files | awk '
/^DATE:/  { date = substr($0, 6) }
/^[+-]\|/ {
  sign = /^\+/ ? 1 : -1
  n = split($0, f, "|")
  pages = f[8] + 0
  if (pages > 0) monthly[date] += sign * pages
}
END { for (m in monthly) print m, monthly[m] }
' | sort | awk -v doy="$(date +%j)" '
{ printf "%s: %4d pages\n", $1, $2; total += $2 }
END {
  printf "\nTotal:            %4d pages\n", total
  printf "Pages/day (est.): %4.1f (%d days elapsed)\n", total / doy, doy
}'
