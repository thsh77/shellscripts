#!/bin/bash

##################################################################
#
# tsv2toml is designed for transforming a tsv file to a TOML hash
# table. The input file has to look like this:
#
#    lemmatext1  explanationtext1
#    lemmatext2  explanationtext2
#
# to render this
#
#    [n1]
#     lemma = "lemmatext1"
#     note= "explanationtext1"
#
#    [n2]
#     lemma = "lemmatext2"
#     note= "explanationtext2"
#
##################################################################


awk -v FS='\t' -v s1="\"" '
BEGIN {n=1}
{
  gsub(/\r/, "") # remove carriage return chars
  print "[n"n"]"
  print "  lemma = "s1 $1 s1
  print "  note  = "s1 $2 s1
  {print " "}
  {n++}
}' "$@"
