#!/bin/bash

# tirsdagBookFactory produces books that fit for publishing under the
# Tuesday Project Text Platform

PROGRAM=`basename "$@"`
VERSION='1.0'
CURRENT_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMP_DIR=`mktemp -d -p "$CURRENT_DIR"`
SOURCE_DIR='./'
TARGET_DIR='./'
STYLESHEET='/home/th/Development/textbase/tekstnet-factory/generator/xsl/generator.xsl'

transform() {
  java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
    -s:"$1" \
    -xsl:$STYLESHEET \
    -o:"$TMP_DIR/test"
}

#if [ -d "$TARGET_DIR$(basename "$1" .txt)" ]
#then
#  echo "Directory exists at " "$TARGET_DIR$(basename "$1" .txt)"
#fi

transform $1

