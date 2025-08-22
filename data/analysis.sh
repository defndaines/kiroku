# 2025 Reading

## Total Book Count

tail -n +8 2025-reading.md | wc -l

tail -n +11 2025-graphic-novels.md | wc -l

## Authors

tail -n +8 2025-reading.md | cut -d \| -f 3 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n

tail -n +8 2025-reading.md | cut -d \| -f 3 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n | grep -v " 1 "

## Publication Year

### Books older than 10 year

# tail -n +8 2025-reading.md | cut -d \| -f 4 | sort | sed -n '1,/2015/p' | wc -l

### Books from last year (roughly)

grep -c '| 202[45]' 2025-reading.md

## Countries

tail -n +8 2025-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n

tail -n +8 2025-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -nr | head

### Show ten most populous countries from which I haven’t year read a book
grep '\[ ]' countries-read.md | head | sed 's/- \[ ] \([^:]*\).*/\1/'

### Filter out the major English-native countries.

tail -n +8 2025-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | grep -v "U\." | grep -v Canada | grep -v Australia | sort -u

tail -n +8 2025-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | grep -v "U\." | grep -v Canada | grep -v Australia | sort | uniq -c | sort -nr | head

### Count of non-U.S/U.K./Canada/Australia work

tail -n +8 2025-reading.md | grep -v Canada | grep -v Australia | grep -vc "U\.[SK]\."

## Genres

### Fiction count

tail -n +8 2025-reading.md | grep -vc "nonfiction"

tail -n +11 2025-graphic-novels.md | grep -vc "nonfiction"

### Nonfiction count

tail -n +8 2025-reading.md | grep -c "nonfiction"

tail -n +11 2025-graphic-novels.md | grep -c "nonfiction"

### Genre full list

tail -n +8 2025-reading.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c

tail -n +11 2025-graphic-novels.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c

### Most common genres

tail -n +8 2025-reading.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c | grep -v reread | grep -v novella | grep -v "short story" | grep -v "Hugo finalist" | sort -nr | head

## Formats

tail -n +8 2025-reading.md | cut -d \| -f 7 | sort | uniq -c

tail -n +11 2025-graphic-novels.md | cut -d \| -f 7 | sort | uniq -c

## Ratings

tail -n +8 2025-reading.md | cut -d \| -f 6 | sort -n | uniq -c

tail -n +8 2025-reading.md | cut -d \| -f 6 | awk '{s+=$1}END{print "average:",s/NR}' RS="\n"

### 5.0 Books

grep " 5.0 " 2025-reading.md | cut -d \| -f 2-3

## Page Count

tail -n +8 2025-reading.md | cut -d \| -f 8 | sort -n

tail -n +8 2025-reading.md | cut -d \| -f 8 | awk '{s+=$1}END{print "average:",s/NR}' RS="\n"

tail -n +11 2025-graphic-novels.md | cut -d \| -f 8 | sort -n

tail -n +11 2025-graphic-novels.md | cut -d \| -f 8 | awk '{s+=$1}END{print "average:",s/NR}' RS="\n"

## Sort in context (e.g., rating [6] or pages [8])

tail -n +8 2025-reading.md | sort -t\| -k 6 -n

tail -n +8 2025-reading.md | sort -t\| -k 8 -n

# Awards

## Hugo Novels Read

sed -n '1,/## Novella/p' hugo-award.md | grep -c '\[x\]'

### Books (i.e., skip movies and series watched)

sed -n '1,/## Dramatic/p' hugo-award.md | grep -c '\[x\]'

## Nebula Novels Read

sed -n '1,/## Novella/p' nebula-award.md | grep -c '\[x\]'

### Books (i.e., skip movies and series watched)

sed -n '1,/## Ray Bradbury Award/p' nebula-award.md | grep -c '\[x\]'

## Other awards (for loop audits)

grep "^Count:" [a-z]*.md

for award in booker-prize.md british-fantasy-award.md andrew-carnegie-medal-for-excellence.md \
  arthur-c-clarke-award.md dublin-literary-award.md golden-poppy-book-award.md \
  great-american-novels.md ignyte-award.md kirkus-prize.md locus-award.md \
  mythopoeic-award.md national-book-award.md nobel-prize-in-literature.md \
  nommo-award.md ohioana-book-award.md pulitzer-prize.md \
  ursula-k-le-guin-prize.md walter-scott-prize.md womens-prize.md \
  world-fantasy-award.md; do
  head -1 $award
  grep "^Count" $award
  grep '\[x\]' $award | sort | uniq -c | wc -l
done

for award in booker-prize.md british-fantasy-award.md andrew-carnegie-medal-for-excellence.md \
  arthur-c-clarke-award.md dublin-literary-award.md golden-poppy-book-award.md \
  hugo-award.md ignyte-award.md kirkus-prize.md locus-award.md \
  mythopoeic-award.md national-book-award.md nobel-prize-in-literature.md \
  nebula-award.md nommo-award.md ohioana-book-award.md pulitzer-prize.md \
  ursula-k-le-guin-prize.md walter-scott-prize.md womens-prize.md \
  world-fantasy-award.md great-american-novels.md nyt-100-best-21st-century.md; do
  head -1 $award
  count=$(grep "^Count:" ${award} | sed 's/Count: //')
  total=$(grep -c "^- \[" ${award})
  pct=$((count * 100 / total))
  echo "  ${count} (${pct}%)"
done

## Analysis of individual awards when there are different categories.

for award in british-fantasy-award.md andrew-carnegie-medal-for-excellence.md booker-prize.md \
  golden-poppy-book-award.md hugo-award.md ignyte-award.md kirkus-prize.md \
  locus-award.md mythopoeic-award.md national-book-award.md nebula-award.md \
  nommo-award.md ohioana-book-award.md pulitzer-prize.md womens-prize.md \
  world-fantasy-award.md; do
  head -1 $award
  lines=($(grep -n "^## " ${award} | sed 's/:.*//'))
  for i in $(seq ${#lines[@]}); do
    if [[ $i -eq "${#lines[@]}" ]]; then
      until="\$"
    else
      until=${lines[$((i + 1))]}
    fi
    sed -n "${lines[i]},${lines[i]}p" ${award}
    count=$(sed -n "${lines[i]},${until}p" ${award} | grep -c '\[x\]')
    total=$(sed -n "${lines[i]},${until}p" ${award} | grep -c '^- \[')
    pct=$((count * 100 / total))
    echo "  ${count} (${pct}% of ${total})"
  done
  echo ""
done

## Yearly (since 2024) Analysis

git diff c10334f countries-read.md

for f in [a-z]*.md; do
  head -1 "$f"
  git diff c10334f "$f" | grep "^[-+]Count:"
done

## TBR Documents

### Tags

cut -d \| -f 8 data/audiobooks.md | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c

cut -d \| -f 8 data/audiobooks.md | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c | grep -v reread | grep -v novella | grep -v "\[own]" | grep -v Audible | sort -n | tail

cut -d \| -f 7 data/ebooks.md | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c

cut -d \| -f 7 data/ebooks.md | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c | grep -v "\[own]" | sort -n | tail

cut -d \| -f 7 data/printbooks.md | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c

cut -d \| -f 7 data/printbooks.md | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | grep -v "not owned" | sort | uniq -c | sort -n | tail

cat <(cut -d \| -f 8 data/audiobooks.md) <(cut -d \| -f 7 data/ebooks.md) <(cut -d \| -f 7 data/printbooks.md) | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c

cat <(cut -d \| -f 8 data/audiobooks.md) <(cut -d \| -f 7 data/ebooks.md) <(cut -d \| -f 7 data/printbooks.md) | sed 's/([^)]*)//g' | sed 's/,/\n/g' | awk '{$1=$1};1' | grep -v "\-\d\+$" | sort | uniq -c |  grep -v "\[own]" | sort -n | tail

### 10 short books

sort -t \| -k 6 -n data/ebooks.md | grep -v "| title |" | grep -v "| --- |" | head | cut -d \| -f 2-6,8

sort -t \| -k 6 -n data/printbooks.md | grep -v "| title |" | grep -v "| --- |" | head | cut -d \| -f 2-6,8

sort -t \| -k 7 -n data/audiobooks.md | grep -v "| title |" | grep -v "| --- |" | head | cut -d \| -f 2-7,9

### 10 long books

sort -t \| -k 6 -nr data/ebooks.md | head -10 | cut -d \| -f 2-6,8

sort -t \| -k 6 -nr data/printbooks.md | head -10 | cut -d \| -f 2-6,8

sort -t \| -k 7 -nr data/audiobooks.md | head -10 | cut -d \| -f 2-7,9

### 10 obscure books

sort -t \| -k 9 -n data/ebooks.md | head -12 | tail -10 | cut -d \| -f 2-6,8-9

sort -t \| -k 9 -n data/printbooks.md | head -12 | tail -10 | cut -d \| -f 2-6,8-9

sort -t \| -k 10 -n data/audiobooks.md | head -12 | tail -10 | cut -d \| -f 2-7,9-10

### 10 popular books

sort -t \| -k 9 -nr data/ebooks.md | head | cut -d \| -f 2-6,8

sort -t \| -k 9 -nr data/printbooks.md | head | cut -d \| -f 2-6,8

sort -t \| -k 10 -nr data/audiobooks.md | head | cut -d \| -f 2-7,9

### re-sort

(head -n 2 data/ebooks.md && tail -n +3 data/ebooks.md | sort -t \| -k 8 -rn) > data/tmp.md && mv data/tmp.md data/ebooks.md

(head -n 2 data/audiobooks.md && tail -n +3 data/audiobooks.md | sort -t \| -k 9 -rn) > data/tmp.md && mv data/tmp.md data/audiobooks.md

(head -n 2 data/printbooks.md && tail -n +3 data/printbooks.md | sort -t \| -k 8 -rn) > data/tmp.md && mv data/tmp.md data/printbooks.md
