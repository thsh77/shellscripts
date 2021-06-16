#!/bin/bash


#
# To do: 
# - build in filtering of form-feed characters: sed 's/\o14//g'
# - build in filtering of sharp parenthesis: sed 's/</\&lt;/g' and 'sed s/>/\&gt;/g'
#

PN=$(basename "$0")                      # Program name
VER='1.0'
#OUTPUTDIR=${PWD##*/}-scan_$(date +%Y-%m-%d_%H_%M)

#mkdir "$OUTPUTDIR"

language='eng'

Usage () {
  echo >&2 "$PN - perform OCR on multiple files with tesseract, version $VER
  usage: $PN [-h] [file ...]"
  exit 1
}


while getopts ":l:hv" opt
do
  case "$opt" in
    l)
      #echo "-l passed ${OPTARG}" >&2
      language=${OPTARG}
      ;;
    #\?)
    #  echo "Invalid option: -${OPTARG}" >&2
    #  exit 1
    #  ;;
    :)
      echo "Option -${OPTARG} requires an argument" >&2
      exit 1
      ;;
    h)      Usage;;
    v)      echo "$PN - perform OCR on multiple files with tesseract, version $VER" >&2
      exit 1;;
    '?')    echo "$0: invalid option -${OPTARG}" >&2
      echo "usage: $0 [-hv] [file ...]" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND - 1))                   #Remove options, leave arguments

#count=1

#perform_ocr(){
#  output_dir="$(mkdir "$dir"/text_`date +%Y-%m-%d_%H_%M`)"
#while read -r file
#do
#  echo "Doing OCR with tesseract (language: ${language}) on ${file}";
#  b=$(basename "${file%.*}"); tesseract -l "${language}" "${file}" "${output_dir}/${b}";
  #echo "OCR" "$count" of "$number_of_files"
  #((count++))
#done <  <(find "$dir" -type f)
#}

filter(){
  # Filter away form-feed (octal '\o14') characters
  # Replace '&', '<', and '>' with entities
  sed -E -e 's/\o14//g' \
    -e 's/\&/\&amp;/g' \
    -e 's/</\&lt;/g' \
    -e 's/>/\&gt;/g' - 
}

while IFS= read -r dir
do
  number_files="$(find "$dir" -maxdepth 1 -type f  | wc -l)"
  file_count=1
  echo Processing "$number_files" files in "$dir"

  outputfile=scanned_"$(date +%Y-%m-%d_%H_%M)"
  touch "$dir"/"$outputfile"
  while read -r file
  do 
    echo Processing "$file" -- "$language" -- number "$file_count" of "$number_files" files
    echo "$file" &>> "$dir"/"$outputfile"_errors.txt
    echo "<pb facs=\"""$(basename "${file%.*}")""\"/>" >> "$dir"/"$outputfile"
    tesseract -l "$language" "$file" - | filter >> "$dir"/"$outputfile" 2>> "$dir"/"$outputfile"_errors.txt
    ((file_count++))
  done <  <(find "$dir" -type f -name "*.jpg" | sort)
done <  <(find "$@" -maxdepth 0 -type d)

