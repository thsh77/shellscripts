#!/bin/bash

# tirsdagBookFactory produces books that fit for publishing under the
# Tuesday Project Text Platform
EXITCODE=0
PROGRAM=`basename "$0"`
VERSION='1.0'
#CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
COUNTER=0
numfiles=(*)
numfiles=${#numfiles[@]}
CURRENT_DIR="$( pwd )"
DIRNAME=`basename "$CURRENT_DIR"`
SCRATCHDIR=`mktemp -d -p "$CURRENT_DIR"`
DIRECTORY=`cd $SCRATCHDIR && mkdir $DIRNAME`
SOURCEDIR='./'
TARGETDIR='/home/th/Development/tirsdagsprojektet/content/letters'
STYLESHEET='/home/th/Development/tirsdag-text-factory/xsl/letter.xsl'
TESTDIR=`dirname "$i"`
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
    -s:"$i" \
    -xsl:$STYLESHEET \
    -o:$SCRATCHDIR/$DIRNAME/$(basename "$i" .xml).html
   # -o:"$SCRATCHDIR/$(basename "$i" .xml).html"
}


cleanup() {

  if [ -d "$TARGETDIR/$DIRNAME" ]
  then
    if test "$all" = "yes" 
    then 
      printf "Doing a full rsync of files to directory: \n\n $TARGETDIR/$DIRNAME \n\n"
      rsync -av $SCRATCHDIR/$DIRNAME/* $TARGETDIR/$DIRNAME/
    else
      printf "Doing partial rsync -- HTML files only -- to directory: \n\n $TARGETDIR/$DIRNAME \n\n"
      rsync -av $SCRATCHDIR/$DIRNAME/*.html $TARGETDIR/$DIRNAME/
    fi
    else
    printf "Making a new directory: \n\n $TARGETDIR/$DIRNAME"
    cp -r $SCRATCHDIR/$DIRNAME $TARGETDIR
  fi

  rm -r $SCRATCHDIR;
}

for i in "$@"
do
  COUNTER=$((COUNTER+1));
  echo Now transforming "$i" "($COUNTER" of "$numfiles)"
  transform; 
done

cleanup
