# sort.awk sorts multiline records alphabetically

BEGIN {
  RS=""
  ORS="\n\n"
  FS=OFS="\n"
  PROCINFO["sorted_in"]="@val_str_asc"
}

{
  a[NR] = $0
}

END {
  for(i in a) 
    print a[i]
}
