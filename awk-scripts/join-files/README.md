If you have two uniquely sorted files, you can find the intersection
with

$ join a b

If you want the intersection but have 2+ files, they're unsorted,
and/or have duplicates, you can use

```
!a[FILENAME,$0]++ { ++b[$0] }

END {
  for(p in b)
  if(b[p] == ARGC -1)
    print p
}
```
