#!/bin/bash
#
# esproc - process yaml/html file for elasticsearch indexing
#
#


awk '

function basename(file, a, n){
  n = split(file, a, "/")
  id = a[1]
  file = a[n]
#  return id file
  printf("id = %s\n file = %s", id, file)
}

END {
#  f = basename(FILENAME)
#  {print f }

{ print basename(FILENAME) }
#{ print FILENAME }
#{ print "id = " id }
#{ print id }
}

' $1
