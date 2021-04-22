#!/bin/bash

###########################################################
#
# testing: ./tst.sh content/books/brahe-t_de-nova-stella
#
#
############################################################


PROGRAM=$(basename "$0")
VERSION=1.0
EXITCODE=0


version(){
  echo "$PROGRAM version $VERSION"
}


outfile=

while getopts :o opt
do
  case $opt in
     o)  outfile="$2"
      ;;
    '?')  echo "ERROR" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))

for dir in $(find "$@" -type d )
do
  #path=$(dirname ${f##./})/$(basename ${f%.*})
  #echo $path
  if [ -e "$dir/_index.md" ]
  then
    echo "File '_index.md' exists; now get the header"

    # Get the YAML header from the index file, and pipe it through yq
    # to convert output to JSON
    header=$(awk '/---/{f=!f; next}f' "$dir/_index.md" | yq -j read -)
    #echo "Printing header:"
    #echo "$header"

    # Extract basic workinfo from _index.md file
    workinfo=$( jq -c '{
    worktitle: .["title"], 
    authors, 
    editors, 
    periods,
    languages, 
    series, 
    tags }' <<< "$header")

  else 
    echo "Fatal: _index.md in $dir does not exist"
    exit 1
  fi

  # Process HTML files constituting chapters and parts of the texts in
  # current folder. Note that current solution

  if [ -f "$dir/001.html" ]
  then
    echo "There's content to index"
  else
    echo "Fatal: in $dir there's nothing to index"
    exit 1
  fi

  for i in $(find "$dir" -type f -name "*[0-9].html")
  do
    # Retrieve path name excluding the /content part
    path=$(dirname "${i#content/}")/$(basename "${i%.*}")
    
    # Retrieve YAML header
    partheader=$(awk '/---/{f=!f; next}f' "$i" | yq -j read -)
    
    # Retrieve text view
    view=$(
    awk '
      BEGIN { RS = "([A|N]</button>|<[^>]+>|\\||{{% images/figure %}})"
              ORS=" "
      }
      NR > 5 {
              m = 1
              gsub(/[ \t\n]+/, " ")
      } m
        ' "$i")
    
    # Integrate partheader in a textobject
    textobject=$(jq -c  --arg workinfo "$workinfo" \
                    --arg path "$path" \
                    --arg view "$view" \
                    '. + {path: $path, view: $view}' <<< "$partheader")
    
    # Integrate workinfo in textobject
    textobject=$(jq -s '.[0] + .[1]' <(echo "$workinfo") <(echo "$textobject") )
    echo "$textobject"
    ##touch testfile
    echo "$textobject" >> $outfile

  done

done
