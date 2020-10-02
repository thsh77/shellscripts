#! /bash/bin

# gres is global regular expression substitution. Like grep it
# searches for at pattern in a file

$ cat gres
if [ $# -lt 3 ]
then
  echo Usage: gres pattern replacement file >&2
  exit 1
fi

pattern=$1
replacement=$2
if [ -f $3 ]
then
  file=$3
else
  echo $3 is not a file. >&2
  exit 1
fi
A="` echo | tr '\012' '\001' `"

sed -e "s$A$pattern$A$replacement$A $file
