#!/bin/bash

##########################################################################
# Title      :	head.sh - replacement for the "head" command
# Author     :	Heiner Steven (hs)
# Date       :	16.01.1996
# Requires   :	-
# Category   :	File Utilities
# SCCS-Id.   :	@(#) head.sh	1.2 02/04/13
##########################################################################
# Description
#
##########################################################################

PN=`basename "$0"`			# Program name
VER='1.2'

Usage () {
    echo >&2 "$PN - display first few lines of files, $VER (hs '96)
usage: $PN [-line] [file ...]

If no number of lines is given, the default is 10."
    exit 1
}

Msg () {
    for i
    do echo "$PN: $i" >&2
    done
}

Fatal () { Msg "$@"; exit 1; }

while [ $# -gt 0 ]
do
    case "$1" in
	--)	shift; break;;
	-h)	Usage;;
	-[0-9]*)
		Lines=`echo "$1" | sed 's:^-::'`;;
	-*)	Usage;;
	*)	break;;			# First file name
    esac
    shift
done

exec sed "${Lines:-10}q" "$@"

