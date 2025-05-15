#!/bin/bash

#
# letters_transform.sh -- take a directory of DSL-TEI letters,
# transform and deploy them
#

CURRENT_DIR=$(pwd)
SCRATCHDIR=$(mktemp -d -p "$CURRENT_DIR")
#STYLESHEET='/home/th/dev/tirsdag-text-factory/xsl/letter.xsl'
STYLESHEET='/home/th/dev/tekstnet-xsl/xsl/letter.xsl'
dest='/home/th/dev/tirsdagsprojektet/content/books'
ext='.html'

export lang=da
export persons=true
export places=true

while test $# -gt 0
  do
    case $1 in
    --all | -a )
      all=yes
      ;;
    --english | -e )
      ext='.en.html'
      export lang=en
      #usage_and_exit 0
      ;;
    --nopersons )
      # disable linking of personal names
      export persons=false
      #usage_and_exit 0
      ;;
    --noplaces )
      # disable linkinh of place names
      export places=false
      #usage_and_exit 0
      ;;
    --help | -h )
      usage_and_exit 0
      ;;
    --version | -v )
      version
      exit 0
      ;;
    --test | -t )
      dest='/home/th/Development/dl_develop/content/books'
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
  #java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
  java -jar /usr/local/lib/saxon/saxon-he-11.6.jar \
      -s:"$*" \
      -xsl:"$STYLESHEET" \
      -o:"$SCRATCHDIR" \
      lang="$lang" \
      persons="$persons" \
      places="$places"
}

rename(){
  # Rename xml files with html file extension
  for file in "$SCRATCHDIR"/*.xml; do
    fname="${file##*/}"                              # Remove path
    mv -- "$file" "$SCRATCHDIR"/"${fname%.*}""${ext}"  # Remove file extension
  done
}

cleanup() {

    if [ -d "$dest/$dir" ]
    then
      if test "$all" = "yes"
      then
      echo Full rsync of files to "$dest"/"$dir"
      rsync -av "$SCRATCHDIR"/* "$dest"/"$dir"/
      else
        echo Partial rsync \(HTML files only\) to "$dest"/"$dir"
      rsync -av "$SCRATCHDIR"/*.html "$dest"/"$dir"/
      fi
      else
    echo Making new directory "$dest"/"$dir"
    mkdir -p "$dest"/"$dir"
    cp -r "$SCRATCHDIR"/* "$dest"/"$dir"
    fi
}

while IFS= read -r dir
do
  echo "lang is $lang"
  echo Transforming letters in "$dir"
  transform "$@"
  rename
  cleanup
done <  <(find "$@" -maxdepth 0 -type d)
