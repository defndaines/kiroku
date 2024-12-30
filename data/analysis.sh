# 2024 Reading

## Total Book Count

tail -n +9 2024-reading.md | wc -l

tail -n +9 2024-reading.md | grep -vc "graphic novel"

tail -n +9 2024-reading.md | grep -c "graphic novel"

## Authors

tail -n +9 2024-reading.md | cut -d \| -f 3 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n

tail -n +9 2024-reading.md | grep -v "graphic novel" | cut -d \| -f 3 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n | grep -v " 1 "

## Publication Year

### Books older than 10 year

tail -n +9 2024-reading.md | cut -d \| -f 4 | sort | sed -n '1,/2014/p' | wc -l

### Books from last year (roughly)

grep -c '| 202[34]' 2024-reading.md

## Countries

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -nr | head

### Non-U.S. or U.K. works

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | grep -v "U\." | sort -u

### Count of non-U.[SK]. work

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | grep -vc "U\."

## Genres

### Fiction count

tail -n +9 2024-reading.md | grep -vc "nonfiction"

tail -n +9 2024-reading.md | grep -v "graphic novel" | grep -vc "nonfiction"

### Nonfiction count

tail -n +9 2024-reading.md | grep -c "nonfiction"

tail -n +9 2024-reading.md | grep -v "graphic novel" | grep -c "nonfiction"

### Genre full list

tail -n +9 2024-reading.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c

tail -n +9 2024-reading.md | grep -v "graphic novel"

### Most common genres

tail -n +9 2024-reading.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c | grep -v "graphic novel" | grep -v manga | grep -v reread | grep -v novella | sort -nr | head

## Formats

tail -n +9 2024-reading.md | cut -d \| -f 7 | sort | uniq -c

tail -n +9 2024-reading.md | grep -v "graphic novel" | cut -d \| -f 7 | sort | uniq -c

tail -n +9 2024-reading.md | grep "graphic novel" | cut -d \| -f 7 | sort | uniq -c

## Ratings

tail -n +9 2024-reading.md | cut -d \| -f 6 | sort -n | uniq -c

### 5.0 Books

tail -n +9 2024-reading.md | grep " 5.0 " | cut -d \| -f 2-3

## Page Count

tail -n +9 2024-reading.md | cut -d \| -f 8 | sort -n

tail -n +9 2024-reading.md | grep -v "graphic novel" | cut -d \| -f 8 | sort -n

## Sort in context

tail -n +9 2024-reading.md | sort -t\| -k 6 -n

# Awards

## Hugo Novels Read

sed -n '1,/Best Novella/p' hugo-award.md | grep -c '\[x\]'

sed -n '1,/Best Dramatic/p' hugo-award.md | grep -c '\[x\]'

## Nebula Novels Read

sed -n '1,/Best Novella/p' nebula-award.md | grep -c '\[x\]'

sed -n '1,/Ray Bradbury Award/p' nebula-award.md | grep -c '\[x\]'

## Other awards

for award in booker-prize.md carnegie-medal.md dublin-award.md golden-poppy.md great-american-novels.md kirkus.md locus-award.md national-book-award.md nobel-literature.md pulitzer.md womens.md world-fantasy.md; do
  echo $award
  grep -c '\[x\]' $award
done

grep "^Count:" [a-z]*.md

## Yearly (since 2023) Analysis

git diff dc21ff7 countries-read.md

for f in [a-z]*.md; do
  head -1 $f
  git diff dc21ff7 $f | grep "^[-+]Count:"
done

## TBR Documents

cut -d \| -f 5 data/audiobooks.txt | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c | grep -v "graphic novel" | grep -v manga | grep -v reread | grep -v novella | sort -n | tail

### 10 short books

sort -t \| -k 4 -n data/ebooks.txt | head

sort -t \| -k 4 -n data/audiobooks.txt | head

### re-sort

sort -t \| -k 3 -rn data/ebooks.txt -o data/ebooks.txt

sort -t \| -k 3 -rn data/audiobooks.txt -o data/audiobooks.txt

sort -t \| -k 3 -rn data/printbooks.txt -o data/printbooks.txt
