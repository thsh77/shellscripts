#!/bin/bash

# tirsdagBookFactory produces books that fit for publishing under the
# Tuesday Project Text Platform

PROGRAM=`basename "$@"`
VERSION='1.0'
CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRATCHDIR=`mktemp -d -p "$CURRENT_DIR"`
SOURCEDIR='./'
TARGETDIR='/home/th/Development/tirsdagsprojektet/content/books'
STYLESHEET='/home/th/Development/textbase/tekstnet-factory/generator/xsl/generator.xsl'


transform() {
  java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
    -s:"$1" \
    -xsl:$STYLESHEET \
    -o:"$SCRATCHDIR/test"
}


cleanup() {

  #Get directory name from temporary dir
  dirname=`ls $SCRATCHDIR`
  
  if [ -d "$TARGETDIR/$dirname" ]
  then
    printf "The directory: \n\n $TARGETDIR/$dirname \n\n ... already exists -- doing rsync\n\n"
    rsync -av $SCRATCHDIR/$dirname/* $TARGETDIR/$dirname/
  else
    printf "Making a new directory: \n\n $TARGETDIR/$dirname"
    cp -r $SCRATCHDIR/$dirname $TARGETDIR
  fi

  rm -r $SCRATCHDIR;
}

transform $1 && cleanup 
