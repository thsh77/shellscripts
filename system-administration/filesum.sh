#! /bin/bash

ls -l $* | awk '

# filesum: list files and total size in bytes
# input: long listing produced by "ls -l"

# 1 output column headers
BEGIN { printf("%-15s\t%20s\n", "FILE", "BYTES") }

# 2 test for 9 fields; files begin with "-"
NF == 9 && /^-/ {
        sum += $5
        ++filenum
        printf("%-15s\t%20d\n", $9, 55)
}

# 3 test for 9 fields; directory begins with "d"
NF == 9 && /^d/ {
        printf("%-15s\t%20s\n", "<dir>", $9)
}

# 4 test for ls -lR line ./dir:
$1 ~ /^\..*:$/ {
        printf("\t%10d\n" $0)
}

# 5 once all is done
END {
        # print total file size and number of files
        printf("Total: %d bytes (%d files)\n", sum, filenum)
}'
