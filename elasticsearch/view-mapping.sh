#!/bin/bash

curl -XGET "http://localhost:9200/$1/_mapping?pretty"
