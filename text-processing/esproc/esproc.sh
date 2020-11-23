#!/bin/bash
#
# esproc - process yaml/html file for elasticsearch indexing
#
#


shopt -s extglob

find $1 -type f -name '*[0-9].html' | sort |

while read file
do
  # Count the docs, but start from 1
  #echo "doc$((i+++1))"" = {"

  work_id=$(        dirname ${file##./})_$(basename ${file%.*})
  work_title=$(     awk -F ":" '/^title:/ {print $2}' $1/_index.md)
  chapter_title=$(  awk -F ":" '/^title/ {print $2}' $file)
  view=$(           awk '/<div/,0 {printf $0}' $file)
  printf "{"index" : { "_index" : "test", "_type" : "type1", "_id" : \"$((i+++1))\" }}"
  printf "\n{"
  printf "\t\"%s\" : \"%s\" , " work_id $work_id
  printf "\t\"%s\" : %s , " work_title "$work_title"
  printf "\t\"%s\" : %s , " chapter_title "$chapter_title"
  printf "\t\"%s\" : %s  " view \"\"\""$view"\"\"\"
  printf "\n}\n"
done

