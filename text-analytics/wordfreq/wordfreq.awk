# ordfrekvens.awk -- print liste over ordfrekvenser i en tekstfil
# 
# awk -f ordfrekvens.awk inputfil.txt

#@load "readfile"
# Cf https://stackoverflow.com/a/32747544/8860865

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
  # sortér forekomster efter hyppighed
  sort = "sort -k 2nr"

  for(w in frq)
    printf "%s\t%d\n", w, frq[w] | sort
}
