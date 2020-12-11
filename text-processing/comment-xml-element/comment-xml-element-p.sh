#!/bin/bash

# comment-xml-element surrounds an XML element with comments
# Usage


sed '/<p[^>]*>/,/<\/p>/{
    :top
    N
    s/*\n//
    /<\/p>/!b top 
    s@\(<p[^>]*>.*<\/p>\)@<!--\1-->@g
      
  }' $1
