# seq 6 | awk '{a[NR]=$1} END{m=int(NR/2)+1; print (NR%2?a[m]:(a[m-1]+a[m])/2)}'

{
  a[NR]=$1 
} 
END { 
  m=int(NR/2)+1
  print (NR%2?a[m]:(a[m-1]+a[m])/2)
}
