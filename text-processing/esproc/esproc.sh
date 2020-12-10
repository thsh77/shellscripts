#!/bin/bash


c=1     #Set a counter

for f in $(find . -type f -name "*[0-9].html")

do
  #echo "$(basename $f)"
  #printf "%06d\n" $c 
  path=$(           dirname ${f##./})/$(basename ${f%.*})
  work_id=$(        dirname ${f##./})_$(basename ${f%.*})
  work_title=$(     awk -F ":" '/^title:/ {print $2}' `dirname ${f}`/_index.md)
  chapter_title=$(  awk -F ":" '/^title/ {print $2}' $f)
  view=$(awk -v RS='(<[^>]+>|\\||{{% images/figure %}})' -v ORS=' ' 'NR > 5 {m=1; gsub(/[ \t\n]+/, " ")}m' $f)
  printf "{\"index\":{ \"_id\" : %06d}}" $c
  printf "\n{"
  printf "\t\"%s\":\"%s\"," path $path
  printf "\t\"%s\":\"%s\"," work_id $work_id
  printf "\t\"%s\":%s," work_title "$work_title"
  printf "\t\"%s\":%s," chapter_title "$chapter_title"
  printf "\t\"%s\":%s" view \""$view"\"
  printf "\n}\n"
  ((c++)) 

done
