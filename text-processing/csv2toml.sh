#!/bin/bash

##################################################################
#
# csv2toml is designed for transforming a csv file to a TOML hash
# table. The input file has to look like this:
#
#    id , name , lifetime
#    adam , Adam , 1550-1602
#    eve , Eve , 1542-1619
#
# to render this
#
#    [adam]
#     name = "Adam"
#     lifetime = "1550-1602"
#    [eve]
#     name = "Eve"
#     lifetime = "1542-1619"
#
##################################################################


awk -F'[[:space:]]*,[[:space:]]*' -v s1="\"" '
FNR==1 {
  for(i=2;i<=NF;i++){
    gsub(/^ +| +$/,"",$i)
    arr[i]=$i
  }
  next
}
{
  print "["$1"]"
  for(i=2;i<=NF;i++){
    print "  "arr[i]" = "s1 $i s1
  }
}' "$@"

