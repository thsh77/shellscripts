# Vectors are read, space-separated, from stdin; sum of squares goes
# to stdout. The empty line produces 0
# Usage: awk -f sum_of_squares.awk
# 3 1 4 1 5 9
# 133
#
# 0

{
  s=0;
  for(i=1; i<=NF; i++)
    s+=$i*$i;
  print s
}
