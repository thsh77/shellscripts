#!/bin/bash

# comment-xml-element surrounds an XML element with comments
# Usage


sed '/<note[^>]*>/,/<\/note>/{
    :top
    N
    s/*\n//
    /<\/note>/!b top 
    s@\(<note[^>]*>.*<\/note>\)@<!--\1-->@g
      
  }' $1
