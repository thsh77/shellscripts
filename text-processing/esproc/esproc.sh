#!/bin/bash
#
# esproc - process yaml/html file for elasticsearch indexing
#
#


parse_yaml () {
  local prefix=$2
  local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @ | tr @ '\034')
  sed -ne "s/^\($s\):/\1/" \
       -e "s/^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$/\1$fs\2$fs\3/p" \
       -e "s/^\($s\)\($w\)$s:$s\(.*\)$s\$/\1$fs\2$fs\3/p" $1

}

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
  #parse_yaml
  echo "doc$((i++))"" = {"
  echo $worktitle
  awk '
  BEGIN { FS = ":" }
    /^title/ { print "\"chapter\" : "$2 }
    ' $file
  #cat $1/_index.md
  #make_index $file
  printf "\n}\n"
done

#echo $te
#find $1 -type f -name '_index.md'
#while read file
##do
#  echo HEJ
#done
