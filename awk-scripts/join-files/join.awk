!a[FILENAME,$0]++ { ++b[$0] } 
END { 
  for(p in b) 
    if (b[p] == ARGC - 1) 
    print p 
}
