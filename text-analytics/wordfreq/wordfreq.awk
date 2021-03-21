# wordfreq.awk -- print list of most frequent words while disregarding
# stopwords
# 
# Usage: awk -f wordfreq.awk stopwords textfile

NR==FNR {
  stopwords[$0]
  next
}

{
  # Remove distinction between upper- and lowercase letters
  $0 = tolower($0)
  # Remove punctuation
  gsub(/[^[:alnum:]_[:blank:]]/, "", $0)
  
  for(i = 1; i <= NF; i++)
    if(! ($i in stopwords))
    frq[$i]++
}

END {
  # reverse sort frequency list based on second column
  sort = "sort -k 2nr"

  for(w in frq)
    printf "%s\t%d\n", w, frq[w] | sort
}
