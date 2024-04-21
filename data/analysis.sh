# 2024 Reading

## Total Book Count

tail -n +9 2024-reading.md | wc -l

## Authors

tail -n +9 2024-reading.md | cut -d \| -f 3 | sort | uniq -c | sort -n

## Publication Year

### Books older than 10 year

tail -n +9 2024-reading.md | cut -d \| -f 4 | sort | sed -n '1,/2014/p' | wc -l

### Books from last year (roughly)

grep -c '| 202[34]' 2024-reading.md

## Countries

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | sort | uniq -c | sort -n

### Non-U.S. or U.K. works

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | sed 's/^ *//' | sed 's/ *$//' | grep -v "U\." | sort -u

### Count of non-U.[SK]. work

tail -n +9 2024-reading.md | cut -d \| -f 5 | sed 's/, /\n/g' | grep -vc "U\."

## Genres

### Fiction count

tail -n +9 2024-reading.md | grep -vc "nonfiction"

### Nonfiction count

tail -n +9 2024-reading.md | grep -c "nonfiction"

### Genre full list

tail -n +9 2024-reading.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c

### Most common genres

tail -n +9 2024-reading.md | cut -d \| -f 9 | sed 's/,/\n/g' | awk '{$1=$1};1' | sort | uniq -c | grep -v "graphic novel" | grep -v "reread" | grep -v "novella" | sort -n | tail

## Formats

tail -n +9 2024-reading.md | cut -d \| -f 7 | sort | uniq -c

## Ratings

tail -n +9 2024-reading.md | cut -d \| -f 6 | sort -n | uniq -c

### 5.0 Books

tail -n +9 2024-reading.md | grep " 5.0 " | cut -d \| -f 2-3

## Page Count

tail -n +9 2024-reading.md | cut -d \| -f 8 | sort -n

# Awards

## Hugo Novels Read

sed -n '1,/Best Novella/p' hugo-award.md | grep -c '\[x\]'

sed -n '1,/Best Dramatic/p' hugo-award.md | grep -c '\[x\]'

## Nebula Novels Read

sed -n '1,/Best Novella/p' nebula-award.md | grep -c '\[x\]'

sed -n '1,/Best Script/p' nebula-award.md | grep -c '\[x\]'

## Other awards

for award in booker-prize.md locus-award.md nobel-literature.md national-book-award.md pulitzer.md womens.md world-fantasy.md; do
  echo $award
  grep -c '\[x\]' $award
done
