#!/bin/bash

##################################################################
#
# csv2toml is designed for transforming a csv file to a TOML hash
# table. The input file has to look like this:
#
#    id,name,sortname,lifetime,description
#    adam,Adam,"First, Adam",1550-1602,"Very early example of a man"
#    eve,Eve,"First, Eve",1542-1619,"Very early example of a woman"
#
# to render this
#
#    [adam]
#     name = "Adam"
#     sortname = ""First, Adam""
#     lifetime = "1550-1602"
#     description = ""Very early example of a man""
#    [eve]
#     name = "Eve"
#     sortname = ""First, Eve""
#     lifetime = "1542-1619"
#     description = ""Very early example of a woman""
#
##################################################################


awk -v FPAT='[^,]*|("[^"]*")+' -v s1="\"" '
FNR==1{
  for(i=2;i<=NF;i++){
    gsub(/^ +| +$/,"",$i)
    arr[i]=$i
  }
  next
}
{
  print "["$1"]"
  #for(i=2;i<=NF;i++){
  for(i=2;i<=5;i++){                # Limit the processing to max. 5 fields
    print "  "arr[i]" = "s1 $i s1
  }
}' "$@"
