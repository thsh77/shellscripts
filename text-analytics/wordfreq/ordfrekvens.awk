# ordfrekvens.awk -- print liste over ordfrekvenser i en tekstfil
# 
# awk -f ordfrekvens.awk inputfil.txt

#@load "readfile"

BEGIN {
  #PROCINFO["readfile"] = 1
  #list = readfile("liste.txt");
  print list
  # lav liste over stopord mhp bortfiltrering
  split("de est et in pro", tmp)
  #split("$stopord", tmp)
    for(i in tmp) {
        stopord[tmp[i]]
    }
}

{
  # fjern distinktion mellem små og store bogstaver
  $0 = tolower($0)

  # fjern interpunktion
  gsub(/[^[:alnum:]_[:blank:]]/, "", $0)

  for(i = 1; i <= NF; i++)
    if(! ($i in stopord))
    frekvens[$i]++

}

END {
  # sortér forekomster efter hyppighed
  sort = "sort -k 2nr"

  for(ord in frekvens)
    printf "%s\t%d\n", ord, frekvens[ord] | sort
  close(sort)
}
