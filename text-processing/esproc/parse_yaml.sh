#!/bin/bash

s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @ | tr @ \")

sed -e "/^\($w\):$s$/{
        H
        d
        }
        /^$s-$s$w/{
        x
        G
        s/$s-$s\(.*\)$/\1HEJ/
      }" $1
# -e  s/^\($w\):$s$/$fs\1$fs:[]/p 
#  $1
#    -e "s/^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$/\1$fs\2$fs : HEJ $fs\3$fs/p" \
#    -e "s/^\($s\)\($w\)$s:$s\(.*\)$s\$/\1$fs\2$fs : $fs\3$fs/p" $1
#        s/$s-$s\($w\)/- HEJ/


awk 's{if(/\s*-\s*"[^"]*"/) next; else s=0} /authors:/{s=1}1' $1


sed  '
  /authors/ {
    :a
    $be
    N
    /\n[[:space:]]*-[[:space:]]"[^\n]*"[^\n]*$/ba
    s/\n.*\(\n\)/\1/
   # P;D
   P
    :e
    s/\n.*//
  }
' $1
