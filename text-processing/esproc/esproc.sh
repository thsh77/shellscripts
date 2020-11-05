#!/bin/bash
#
# esproc - process yaml/html file for elasticsearch indexing
#
#


make_index () {

  awk '

  function document_id(file, a, n){
    n = split(file, a, "/")
    work_id = a[n-1]
    filename = a[n]
    sub(".html", "", filename)
    printf("  \"id\" : \"%s_%s\"", work_id, filename)
  }


  /title/ {
    print 'title' 
  }
  
  #END { document_id($file) }
  '
}

#find $1 -type f -name '_index.md'
#while read file
#do
#  #title=$(awk '/title/ {print $0}' $file)
#  echo "HEJ"
#done

worktitle=$(awk '
  BEGIN { FS = ":" }
  /^title/ {print "\"title\" : "$2 }
  ' $1/_index.md)

find $1 -type f -name '*[0-9].html' | sort |
while read file
do 
  echo "doc$((i++))"" = {"
  echo $worktitle
  awk '
  BEGIN { FS = ":" }
    /^title/ { print "\"chapter\" : "$2 }
    ' $file
  #cat $1/_index.md
  #make_index
  printf "\n}\n"
done

echo $te
#find $1 -type f -name '_index.md'
#while read file
##do
#  echo HEJ
#done
