#!/bin/bash -
# 
# tei2txt: convert XML files to plain text
# Author: Thomas Hansen 2022-12-14
# Current maintainer: Thomas Hansen
# Copyright/License?
# Where this code belongs?  (Hosts, paths, etc.)
# Project/repo?
# Caveats/gotchas?
# Usage?  (Better to have `-h` and/or `--help` options!)
#_________________________________________________________________________

PROGRAM=${0##*/}  # bash version of `basename`

# Unofficial bash Strict Mode?
#set -euo pipefail
### CAREFUL: IFS=$'\n\t'

CONFIG_FILE='tekstlab.config'
SOURCE_DIR='/home/th/Development/'
DEST_DIR='/home/th/Development/tekstlab/'

###########################################################################
# Define functions


TransformXmlToTxt() {
    
    file=${1##*/}
    
    java -cp /usr/local/lib/saxon/saxon9he.jar net.sf.saxon.Transform \
        -s:"$1" \
        -xsl:tei2txt.xsl \
        -o:"$DEST_DIR${file%.*}".txt
}



###########################################################################
# Main

while IFS= read -r line
do
  echo "Transform ${line%.*}"
  TransformXmlToTxt "$SOURCE_DIR$line"
done < "$CONFIG_FILE"
