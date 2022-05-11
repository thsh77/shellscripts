#!/bin/bash

curl -H "Content-Type: application/json" -XDELETE "localhost:9200/$1/"
