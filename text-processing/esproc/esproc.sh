#!/bin/bash
#
# esproc - process yaml/html file for elasticsearch indexing
# Usage: ./esproc.sh brahe-t_de-nova-stella/ | jq -c . > text.json
#
#


shopt -s extglob

x=0

for dir in $@
do
  find $dir -type f -name '*[0-9].html' | sort |

    while read file
    do
      x=$(($x+1))
      # Count the docs, but start from 1
      #echo "doc$((i+++1))"" = {"
      echo "Sidetal: " $x

      work_id=$(        dirname ${file##./})_$(basename ${file%.*})
      work_title=$(     awk -F ":" '/^title:/ {print $2}' $1/_index.md)
      chapter_title=$(  awk -F ":" '/^title/ {print $2}' $file)
      text_block=$(     awk '/<div/,0 {printf $0}' $file)
      view=$(awk -v RS='<[^>]+>' -v ORS='' 'NR > 5 {m=1; gsub(/[ \t\n]+/, " ")}m' $file)
      #printf "{\"index\":{ \"_id\" : \"$((i+++1))\"}}"
      printf "{\"index\":{ \"_id\" : \"$x\"}}"
      printf "\n{"
      printf "\t\"%s\":\"%s\"," work_id $work_id
      printf "\t\"%s\":%s," work_title "$work_title"
      printf "\t\"%s\":%s," chapter_title "$chapter_title"
      printf "\t\"%s\":%s" view \""$view"\"
      printf "\n}\n"
    done
done


