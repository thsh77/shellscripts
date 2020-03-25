#!/bin/bash

# tirsdagBookFactory produces books that are fit for publishing under the
# Tuesday Project Text Platform

EXITCODE=0
PROGRAM=`basename "$0"`
VERSION='1.0'
#CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
CURRENT_DIR="$( pwd )"
SCRATCHDIR=`mktemp -d -p "$CURRENT_DIR"`
SOURCEDIR='./'
TARGETDIR='/home/th/Development/tirsdagsprojektet/content/books'
STYLESHEET='/home/th/Development/tirsdag-text-factory/xsl/generator.xsl'
all=no

error() {
  echo "$@" 1>&2
  usage_and_exit 1
}

usage() {
 echo "Usage: $PROGRAM [--all] [--?] [--help] [--version] file"
}

usage_and_exit() {
  usage
  exit $1
}

version() {
  echo "$PROGRAM version $VERSION"
}

warning() {
  echo "$@" 1>&2
  EXITCODE=`expr $EXITCODE + 1`
}

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
    -s:"$1" \
    -xsl:$STYLESHEET \
    -o:"$SCRATCHDIR/test"
}

create-colophon() {

  dirname=`ls $SCRATCHDIR`
  
  # Make the Danish colophon
  touch $SCRATCHDIR/$dirname/colophon.md

  TEMPLATE="\n---
  \ntitle: kolofon
  \nlayout: colophon
  \n---
  "

  echo -e $TEMPLATE | tee -a $SCRATCHDIR/$dirname/colophon.md

  # Make the English colophon
  touch $SCRATCHDIR/$dirname/colophon.en.md

  TEMPLATE="\n---
  \ntitle: colophon
  \nlayout: colophon
  \n---
  "

  echo -e $TEMPLATE | tee -a $SCRATCHDIR/$dirname/colophon.en.md

}

cleanup() {

  #Get directory name from temporary dir
  dirname=`ls $SCRATCHDIR`
  
  if [ -d "$TARGETDIR/$dirname" ]
  then
    if test "$all" = "yes" 
    then 
      printf "Doing a full rsync of files to directory: \n\n $TARGETDIR/$dirname \n\n"
      rsync -av $SCRATCHDIR/$dirname/* $TARGETDIR/$dirname/
    else
      printf "Doing partial rsync -- HTML files only -- to directory: \n\n $TARGETDIR/$dirname \n\n"
      rsync -av $SCRATCHDIR/$dirname/*.html $TARGETDIR/$dirname/
    fi
    else
    printf "Making a new directory: \n\n $TARGETDIR/$dirname"
    cp -r $SCRATCHDIR/$dirname $TARGETDIR
  fi

  rm -r $SCRATCHDIR;
}

transform $1 && create-colophon && cleanup 
