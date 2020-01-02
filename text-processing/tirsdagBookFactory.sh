#!/bin/bash

# tirsdagBookFactory produces books that fit for publishing under the
# Tuesday Project Text Platform

PROGRAM=`basename "$@"`
VERSION='1.0'
SOURCE_DIR='/home/th/Development/textbase/tekstnet-factory/generator/xml/'
TARGET_DIR='/home/th/Development/tirsdagsprojektet/content/books/'
STYLESHEET='/home/th/Development/textbase/tekstnet-factory/generator/xsl/generator.xsl'

java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
  -s:$SOURCE_DIR"$1" \
  -xsl:$STYLESHEET \
  -o:"/home/th/Desktop/testHTML"
