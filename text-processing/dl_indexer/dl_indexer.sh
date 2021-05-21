#!/bin/bash
###########################################################
#
# Usage: ./dl_indexer.sh -o output.json content/books/brahe-t_de-nova-stella
#
#
############################################################


PROGRAM=$(basename "$0")
VERSION=1.0


version(){
  echo "$PROGRAM version $VERSION"
}

count=1
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


# Loop over directories with texts to index

while IFS= read -r dir
do
  #let count++
  #echo "Playing "$dir" no $count"
  if [ -e "$dir/_index.md" ]
  then
    echo "Processing" "$dir"

    # Get YAML header from _index.md file, and convert to JSON
    header=$(awk '/---/{f=!f; next}f' "$dir/_index.md" | yq -j read -)

    # Extract basic workinfo from _index.md file
    workinfo=$( jq -c '{
    worktitle: .["title"],
    authors,
    editors,
    periods,
    languages,
    series,
    tags,
    genres,
    date}' <<< "$header")

  else
    echo "Fatal: _index.md in $dir does not exist"
    #exit 1
    continue
  fi

  # Process HTML files constituting chapters and parts of the texts in
  # current folder. Note that current solution

  if [ -f "$dir/001.html" ]
  then
    echo "Content to index..."
  elif [ -f "$dir/_index.md" ]
  then
    echo "Letters to index..."
  else
    echo "Fatal: in $dir there's nothing to index"
    #exit 1
    continue
  fi

  # Process files in directories
  while read -r file
  do
    # Retrieve path name excluding the /content part
    doc_id=$(dirname "${file#content/}")
    path=$(dirname "${file#content/}")/$(basename "${file%.*}")
    echo "Now indexing: " "$path"

    # Retrieve YAML header
    partheader=$(awk '/---/{f=!f; next}f' "$file" | yq -j read -)
    

    # Retrieve text view
    view=$(
    awk '
      # Strip HTML markup with GNU awks RS (Record Separator) variable
      BEGIN { RS = "([A|N]</button>|<[^>]+>|\\||{{% images/figure %}})"
              ORS=""
      }
      # Whnn over the first line, start indexing
      NR > 1 {
              m = 1
              gsub(/[ \t\n]+/, " ")
      } m
        ' "$file")

    # Integrate partheader in a textobject
    textobject=$(jq -c  --arg workinfo "$workinfo" \
                    --arg doc_id "$doc_id" \
                    --arg path "$path" \
                    --arg view "$view" \
                    '. + {doc_id: $doc_id, path: $path, view: $view}' <<< "$partheader")

    # Integrate workinfo in textobject
    textobject=$(jq -s '.[0] + .[1]' <(echo "$workinfo") <(echo "$textobject") )
    printf "{\"index\":{\"_type\": \"_doc\", \"_id\": %d}}\n" "$count" >> "$outfile"
    echo "$textobject" | jq -c >> "$outfile"
    ((count++))

  done <   <(find "$dir" -type f -name "*[0-9].html")

done <   <(find "$@" -type d) 
