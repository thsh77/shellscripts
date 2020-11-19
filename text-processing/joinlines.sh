#! /bin/bash

# Normalize whitespace and join alle lines to one

awk '{printf( $0)}' $1
