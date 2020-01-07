#!/bin/bash

# tirsdagBookFactory produces books that fit for publishing under the
# Tuesday Project Text Platform

PROGRAM=`basename "$@"`
VERSION='1.0'
CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRATCHDIR=`mktemp -d -p "$CURRENT_DIR"`
SOURCEDIR='./'
TARGETDIR='~/Desktop/'
STYLESHEET='/home/th/Development/textbase/tekstnet-factory/generator/xsl/generator.xsl'

transform() {
  java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
    -s:"$1" \
    -xsl:$STYLESHEET \
    -o:"$SCRATCHDIR/test"
}

cleanup() {

  dirname=`ls $SCRATCHDIR`
  
  if [ -d "/home/th/Desktop/$dirname" ]
  then
    echo The directory $dirname already exists -- doing rsync
    rsync $SCRATCHDIR/$dirname/* /home/th/Desktop/$dirname/
  else
    echo Make new dir
    cp -r $SCRATCHDIR/$dirname /home/th/Desktop/
  fi

  rm -r $SCRATCHDIR;
}

transform $1 && cleanup 
