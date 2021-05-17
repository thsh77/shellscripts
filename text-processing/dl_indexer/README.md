# Brug

Scriptet kan både indeksere almindelige tekster og breve. Brugen er
den samme:

```
$ ./dl_indexer.sh -o indexfil.json bang-h_letters/
```

Derefter oplades den genererede JSON-fil til en Elasticsearch-server
på localhost port 9200 sådan:

```
curl -H "Content-Type: application/json" -XPOST "localhost:9200/bangsbreve/_bulk?pretty&refresh" --data-binary "@bang-indexfil.json"
```

# Kendte fejl

Denne fejl

```
Processing content/books/brahe-t_observationes-geographicae
Content to index!
Now indexing:  books/brahe-t_observationes-geographicae/001
Error: yaml: line 856: could not find expected ':'
```

skyldtes at der var en samling af tegnet '-', som bevirkede at
ekstrakt af partheader ikke fungerede. 


