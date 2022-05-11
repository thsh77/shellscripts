#!/bin/bash

curl -H "Content-Type: application/json" \
  -XPOST "localhost:9200/all/_bulk?pretty&refresh" \
  --data-binary "@$1"
