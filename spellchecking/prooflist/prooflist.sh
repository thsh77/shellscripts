#!/bin/bash -

#-----------------------------------------------------------------#
# prooflist.sh: Generate list of words not in the ODS dictionary  #
#               for proof-reading XML texts for Tekstnet          #
# Author:       Thomas Hansen, 2023-11-29                         #
#-----------------------------------------------------------------#

PROGRAM=${0##*/}  # Bash version of `basename`

if ! command -v aspell &> /dev/null; then
    echo "Error: 'aspell' command not found. Please install it" >&2
    exit 1
fi

make-list() {
    aspell list \
        --master=tekstnet \
        --lang=da \
        --mode=html < "$1" | sort -u > "${1%.*}"_not-ods.txt
}

if [ "$#" -eq 0 ]; then
    echo "Usage: $PROGRAM file1 [file2 ...]" >&2
    exit 1
fi

for file in "$@"; do
    if [[ "$file" == *.xml ]]; then
        make-list "$file"
    else
        echo "Skipping non-XML file: $file" >&2
    fi
done
