# Usage: awk -f sentence_tokenizer.awk input.txt

BEGIN { 
  split("f.eks. forb. m.fl. bl.a. m.", tmp)
  for(i in tmp) {
    abbrev[tmp[i]]
    }
}
{
  for(i = 1; i <= NF; i++)
    if(($i in abbrev))
      printf "%s ", $i
    else
      printf "%s ", gensub(/([.!?])/, "\\1\n", "g", $i)
}
