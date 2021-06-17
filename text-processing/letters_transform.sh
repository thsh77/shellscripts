#!/bin/bash

#
# letters_transform.sh -- take a directory of DSL-TEI letters,
# transform and deploy them
#

CURRENT_DIR=$(pwd)
SCRATCHDIR=$(mktemp -d -p "$CURRENT_DIR")
STYLESHEET='/home/th/Development/tirsdag-text-factory/xsl/letter.xsl'
TARGETDIR='/home/th/Development/tirsdagsprojektet/content/books'

while test $# -gt 0
  do
    case $1 in
    --all | -a )
      all=yes
      ;;
    --help | -h )
      usage_and_exit 0
      ;;
    --version | -v )
      version
      exit 0
      ;;
    --test | -t )
      TARGETDIR='/home/th/Development/dl_develop/content/books'
      #exit 0
      ;;
    -*)
      error "Unrecognized option: $1"
      ;;
    *)
      break
      ;;
    esac
  shift
done

transform() {
  java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
      -s:"$*" \
      -xsl:"$STYLESHEET" \
      -o:"$SCRATCHDIR"
}

rename(){
  # Rename xml files with html file extension
  for file in "$SCRATCHDIR"/*.xml; do
    mv -- "$file" "$SCRATCHDIR"/"$(basename "$file" .xml)".html
  done
}

cleanup() {

    if [ -d "$TARGETDIR/$dir" ]
    then
      if test "$all" = "yes"
      then
      echo Full rsync of files to "$TARGETDIR"/"$dir"
      rsync -av "$SCRATCHDIR"/* "$TARGETDIR"/"$dir"/
      else
        echo Partial rsync \(HTML files only\) to "$TARGETDIR"/"$dir"
      rsync -av "$SCRATCHDIR"/*.html "$TARGETDIR"/"$dir"/
      fi
      else
    echo Making new directory "$TARGETDIR"/"$dir"
    mkdir -p "$TARGETDIR"/"$dir"
    cp -r "$SCRATCHDIR"/* "$TARGETDIR"/"$dir"
    fi
}

while IFS= read -r dir
do 
  echo Transforming letters in "$dir"
  transform "$@"
  rename
  cleanup
done <  <(find "$@" -maxdepth 0 -type d)
