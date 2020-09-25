#! /bin/bash

CURRENT_DIR="$( pwd )"

for f in $CURRENT_DIR/*;
do
  fname=`basename "$f" .xml`
  echo '<li><a href="/dokument/'$fname'">'$fname'</a></li>'
done
