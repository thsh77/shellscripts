#!/bin/bash

# tei-to-text extracts text from a TEI P5 file in simple text form

transform() {

  # First map tei prefix to namespace, then match every div element
  # and then all relevant content subelements and output its textual
  # content wrapped in newlines.

  xmlstarlet sel \
    -N tei="http://www.tei-c.org/ns/1.0" \
    -t -m '//tei:div' \
    -m 'tei:head | tei:p | tei:lg | tei:note | tei:figure | tei:app' -n -v '.' -n \
  $i
}

cleanup() {
  
  # In case there are multiple blank lines these are to be reduced 
  # to one. Use par to format paragraphs
  
  sed ':a; /^\n*$/{ s/\n//; N;  ba};'
}

for i in "$@"
do
  transform | cleanup | par > $(basename "$i" .xml).text
done

