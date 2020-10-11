#! /bin/bash

ls -l $* | awk '

# filesum: list files and total size in bytes
# input: long listing produced by "ls -l"

# 1 output column headers
BEGIN { print "BYTES" , "\t", "FILE" }

# 2 test for 9 fields; files begin with "-"
NF == 9 && /^-/ {
        sum += $5
        ++filenum
        print $5, "\t", $9
}

# 3 test for 9 fields; directory begins with "d"
NF == 9 && /^d/ {
        print "<dir>", "\t", $9
}

# 4 test for ls -lR line ./dir:
$1 ~ /^\..*:$/ {
        print "\t" $0
}

# 5 once all is done
END {
        # print total file size and number of files
        print "Total: ", sum, "bytes (" filenum " files)"
}'
