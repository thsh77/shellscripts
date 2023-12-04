#!/bin/bash -

#-----------------------------------------------------------------#
# proofread.sh: Use aspell to interactively proof-read a          #
#               text in an XML file for Tekstnet. Please note     #
#               that the individual dictionary tekstnet must be   #
#               available in /usr/lib/aspell.                     #
# Author:       Thomas Hansen, 2023-11-29                         #
#-----------------------------------------------------------------#

PROGRAM=${0##*/}  # Bash version of `basename`

if ! command -v aspell &> /dev/null; then
    echo "Error: 'aspell' command not found. Please install it" >&2
    exit 1
fi

proof-read() {
    aspell check \
        --master=tekstnet \
        --home-dir=. \
        --personal="${1%.*}"_proof.dict \
        --lang=da \
        --mode=html "$1"
}

if [ "$#" -eq 0 ]; then
    echo "Usage: $PROGRAM file1 [file2 ...]" >&2
    exit 1
fi

for file in "$@"; do
    if [[ "$file" == *.xml ]]; then
        proof-read "$file"
    else
        echo "Skipping non-XML file: $file" >&2
    fi
done
