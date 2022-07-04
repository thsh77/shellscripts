# wordfreq_matrix takes a stopwordlist and converts a bunch of text files to
# document vectors. Usage: awk -f wordfreq_matrix stopwords file1 file2 ... 


NR == FNR {
     stopwords[$0]
     next
}

{
    $0 = tolower($0)
    gsub(/[^[:alnum:]_[:blank:]]/, "", $0)
    for(i = 1; i <= NF; i++)
      if(! ($i in stopwords))
        allwords[$i]++
}

FILENAME == ARGV[ARGIND] {
    $0 = tolower($0)
    gsub(/[^[:alnum:]_[:blank:]]/, "", $0)
    for (i = 1; i <= NF; i++)
        words[ARGIND][$i]++
}

END {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for (w in allwords) 
        printf "%-10s", w
        printf "\n"
       
    for (i = 2; i <= ARGIND; i++) {
        for (w in allwords){
            if (w in words[i]) 
                printf "%-10d", words[i][w] 
            else printf "%-10d", 0
        }
        printf "\n"
    }
}
