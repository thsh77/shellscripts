#!/bin/bash

curl -XGET 'localhost:9200/_search?pretty' -H "Content-Type: application/json" -d @"$1"

