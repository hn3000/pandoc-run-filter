
There are `find .. -name '*.hs' -type f -print|wc -l`{run=bash} haskell files here:
```{ run=bash style=code}
find .. -type f -name '*.hs' -print
```


```{ run=bash style=code .table}
find .. -name '*.hs' | xargs wc -l|awk 'BEGIN { print "file,lines" } { print  $2 "," $1 }'
```
Table: Files and size in number-of-lines.
