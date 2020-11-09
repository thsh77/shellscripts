#!/bin/bash

##################################################################
#
# text2yaml is designed for transforming a csv file to a TOML hash
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


awk '
BEGIN {
  print "---\n"
}
NR == 1 {
  nc = NF
  for(c=1; c<=NF;c++){
    h[c] = $c
  }
}
NR > 1 {
  for(c=1; c<=NF;c++){
    printf h[c] ": " $c "\n"
  }
  print ""
}
END {
  print "---"
}
' "$@"

