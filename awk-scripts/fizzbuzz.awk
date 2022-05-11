# Fizzbuzz
#
# Usage: for i in $(seq 10 16); do echo $i | awk -f fizzbuzz.awk; done

$0%3==0 {
  s="fizz"
}
$0%5==0 {
  s=s"buzz"
}
s { 
  print s
}
!s {
  print $0
}
