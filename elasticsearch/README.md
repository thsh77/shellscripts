## Start Elasticsearch

```
sudo systemctl start elasticsearch.service
```


## Simpel fuldtekstsøgning

Givet følgende søgning:

```json
{ "query" : { "match" : { "view"  : "bryske" }}}
```

giver følgende søgning finder "bryske" i alle indices

```
curl -XGET 'localhost:9200/_search' -H "Content-Type: application/json" -d @simple-query.json
```

## Filtreret søgning

Givet følgende søgnin:

```json
{
  "query":{
    "bool" : {
      "must" : {
        "match": {"view": "bryske"}
      },
      "filter": {
        "term" : { 
          "weight" : 3 }}
    }
  }
}
```

virker med 

```bash
curl -XGET 'localhost:9200/_search' -H "Content-Type: application/json" -d @boolean.json
```
