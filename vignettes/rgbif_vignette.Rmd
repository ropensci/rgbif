<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{rgbif introduction}
-->



rgbif introduction
======

Seach and retrieve data from the Global Biodiverity Information Facilty (GBIF)

## About the package

`rgbif` is an R package to search and retrieve data from the Global Biodiverity Information Facilty (GBIF). `rgbif` wraps R code around the [GBIF API][gbifapi] to allow you to talk to GBIF from R.


## Get rgbif

Install from CRAN


```r
install.packages("rgbif")
```

Or install the development version from GitHub


```r
devtools::install_github("ropensci/rgbif")
```

Load rgbif


```r
library(rgbif)
```

## Number of occurrences

Search by type of record, all observational in this case


```r
occ_count(basisOfRecord='OBSERVATION')
#> [1] 114419930
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 2807
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 460730787
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 9601329
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 37390636
```

Records for a particular dataset, and only for preserved specimens


```r
occ_count(datasetKey='e707e6da-e143-445d-b41d-529c4a777e8b', basisOfRecord='OBSERVATION')
#> [1] 2120907
```

## Search for taxon names

Get possible values to be used in taxonomic rank arguments in functions


```r
taxrank()
#> [1] "kingdom"       "phylum"        "class"         "order"        
#> [5] "family"        "genus"         "species"       "infraspecific"
```

`name_lookup()` does full text search of name usages covering the scientific and vernacular name, the species description, distribution and the entire classification across all name usages of all or some checklists. Results are ordered by relevance as this search usually returns a lot of results.

By default `name_lookup()` returns five slots of information: meta, data, facets, hierarchies, and names. hierarchies and names elements are named by their matching GBIF key in the `data.frame` in the data slot.


```r
out <- name_lookup(query='mammalia')
```


```r
names(out)
#> [1] "meta"        "data"        "facets"      "hierarchies" "names"
```


```r
out$meta
#>   offset limit endOfRecords  count
#> 1      0   100        FALSE 119401
```


```r
head(out$data)
#>         key          scientificName                           datasetKey
#> 1 125798198                Mammalia 16c3f9cb-4b19-4553-ac8e-ebb90003aa02
#> 2 116665331 Mammalia Linnaeus, 1758 cbb6498e-8927-405a-916b-576d00a6289b
#> 3       359 Mammalia Linnaeus, 1758 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c
#> 4 125826646 Mammalia Linnaeus, 1758 16c3f9cb-4b19-4553-ac8e-ebb90003aa02
#> 5 143044906                Mammalia cbb6498e-8927-405a-916b-576d00a6289b
#> 6 102402290                Mammalia 0938172b-2086-439c-a1dd-c21cb0109ed5
#>   nubKey parentKey        parent   phylum phylumKey  classKey
#> 1    359 137006861      Chordata Chordata 137006861 125798198
#> 2    359 143035196      Chordata Chordata 143035196 116665331
#> 3    359        44      Chordata Chordata        44       359
#> 4    359 137006861      Chordata Chordata 137006861 125826646
#> 5    359 143044905 Macroscelidea Chordata 143035196 143044905
#> 6    359 102545028      Chordata Chordata 102545028 102402290
#>   canonicalName     authorship   nameType  rank numDescendants
#> 1      Mammalia                WELLFORMED CLASS              2
#> 2      Mammalia Linnaeus, 1758 WELLFORMED CLASS           1193
#> 3      Mammalia Linnaeus, 1758 WELLFORMED CLASS          30001
#> 4      Mammalia Linnaeus, 1758 WELLFORMED CLASS              0
#> 5      Mammalia           <NA>       <NA> ORDER              3
#> 6      Mammalia                WELLFORMED CLASS          15187
#>   numOccurrences   taxonID extinct nomenclaturalStatus threatStatuses
#> 1              0   2621711    TRUE                  NA             NA
#> 2              0     18838      NA                  NA             NA
#> 3              0 119459549   FALSE                  NA             NA
#> 4              0      7907      NA                  NA             NA
#> 5              0      <NA>      NA                  NA             NA
#> 6              0      1310      NA                  NA             NA
#>   synonym         class  kingdom kingdomKey
#> 1   FALSE      Mammalia     <NA>         NA
#> 2   FALSE      Mammalia Animalia  116630539
#> 3   FALSE      Mammalia Animalia          1
#> 4   FALSE      Mammalia     <NA>         NA
#> 5   FALSE Macroscelidea Animalia  116630539
#> 6   FALSE      Mammalia Animalia  101719444
#>                                                                                                                                                                                                                      publishedIn
#> 1                                                                                                                                                                                                                           <NA>
#> 2                                                                                                                                                                                                                           <NA>
#> 3 Linnaeus, C. (1758). Systema Naturae per regna tria naturae, secundum classes, ordines, genera, species, cum characteribus, differentiis, synonymis, locis. Editio decima, reformata. Laurentius Salvius: Holmiae. ii, 824 pp.
#> 4                                                                                                                                                                                                                           <NA>
#> 5                                                                                                                                                                                                                           <NA>
#> 6                                                                                                                                                                                                                           <NA>
#>                               accordingTo taxonomicStatus marine    order
#> 1                                    <NA>            <NA>     NA     <NA>
#> 2                                    <NA>            <NA>     NA     <NA>
#> 3 The Catalogue of Life, 3rd January 2011        ACCEPTED   TRUE     <NA>
#> 4                                    <NA>            <NA>     NA     <NA>
#> 5                                    <NA>        ACCEPTED     NA Mammalia
#> 6                                    <NA>            <NA>     NA     <NA>
#>    orderKey species speciesKey acceptedKey accepted family familyKey genus
#> 1        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 2        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 3        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 4        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 5 143044906    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 6        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#>   genusKey
#> 1       NA
#> 2       NA
#> 3       NA
#> 4       NA
#> 5       NA
#> 6       NA
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`125798198`
#>     rankkey     name
#> 1 137006861 Chordata
#> 
#> $`116665331`
#>     rankkey     name
#> 1 116630539 Animalia
#> 2 143035196 Chordata
```


```r
out$names[2]
#> $`116665331`
#>   vernacularName language
#> 1        Mammals      eng
```

Search for a genus


```r
head(name_lookup(query='Cnaemidophorus', rank="genus", return="data"))
#>         key                  scientificName
#> 1 116755723 Cnaemidophorus Wallengren, 1862
#> 2   1858636 Cnaemidophorus Wallengren, 1862
#> 3 125802004 Cnaemidophorus Wallengren, 1862
#> 4 141163021                  Cnaemidophorus
#> 5 143026572                  Cnaemidophorus
#> 6 143105347                  Cnaemidophorus
#>                             datasetKey  nubKey parentKey        parent
#> 1 cbb6498e-8927-405a-916b-576d00a6289b 1858636 143026560 Pterophoridae
#> 2 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c 1858636      8863 Pterophoridae
#> 3 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 1858636 125793784 Pterophoridae
#> 4 7ddf754f-d193-4cc9-b351-99906754a03b 1858636 141163009 Pterophoridae
#> 5 cbb6498e-8927-405a-916b-576d00a6289b 1858636 143026560 Pterophoridae
#> 6 de8934f4-a136-481c-a87a-b0b202b80a31 1858636 143105341 Pterophoridae
#>    kingdom     phylum       order        family          genus kingdomKey
#> 1 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  116630539
#> 2 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus          1
#> 3     <NA>       <NA> Lepidoptera Pterophoridae Cnaemidophorus         NA
#> 4 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  140821094
#> 5 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  116630539
#> 6 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  115107543
#>   phylumKey  classKey  orderKey familyKey  genusKey  canonicalName
#> 1 142985476 142986985 143005160 143026560 116755723 Cnaemidophorus
#> 2        54       216       797      8863   1858636 Cnaemidophorus
#> 3        NA 137009267 125810165 125793784 125802004 Cnaemidophorus
#> 4 140844030 140891424 141139334 141163009 141163021 Cnaemidophorus
#> 5 142985476 142986985 143005160 143026560 143026572 Cnaemidophorus
#> 6 143098345 143099231 143104597 143105341 143105347 Cnaemidophorus
#>         authorship   nameType  rank numDescendants numOccurrences
#> 1 Wallengren, 1862 WELLFORMED GENUS              2              0
#> 2 Wallengren, 1862 WELLFORMED GENUS              4              0
#> 3 Wallengren, 1862 WELLFORMED GENUS              1              0
#> 4             <NA> WELLFORMED GENUS              2              0
#> 5             <NA>       <NA> GENUS              2              0
#> 6             <NA>       <NA> GENUS              1              0
#>     taxonID nomenclaturalStatus threatStatuses synonym   class
#> 1  29079847                  NA             NA   FALSE Insecta
#> 2 115123697                  NA             NA   FALSE Insecta
#> 3   3502919                  NA             NA   FALSE Insecta
#> 4  21949965                  NA             NA   FALSE Insecta
#> 5      <NA>                  NA             NA   FALSE Insecta
#> 6      <NA>                  NA             NA   FALSE Insecta
#>                                               publishedIn    accordingTo
#> 1                                                    <NA>           <NA>
#> 2 K. svenska VetenskAkad. Handl. , (N. F. ) 3, no. 7, 10. Fauna Europaea
#> 3                                                    <NA>           <NA>
#> 4                                                    <NA>           <NA>
#> 5                                                    <NA>           <NA>
#> 6                                                    <NA>           <NA>
#>   taxonomicStatus extinct marine acceptedKey accepted
#> 1            <NA>      NA     NA          NA     <NA>
#> 2        ACCEPTED   FALSE  FALSE          NA     <NA>
#> 3            <NA>      NA     NA          NA     <NA>
#> 4            <NA>      NA     NA          NA     <NA>
#> 5        ACCEPTED      NA     NA          NA     <NA>
#> 6        ACCEPTED      NA     NA          NA     <NA>
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#>         key          scientificName                           datasetKey
#> 1 125798198                Mammalia 16c3f9cb-4b19-4553-ac8e-ebb90003aa02
#> 2 116665331 Mammalia Linnaeus, 1758 cbb6498e-8927-405a-916b-576d00a6289b
#> 3       359 Mammalia Linnaeus, 1758 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c
#> 4 125826646 Mammalia Linnaeus, 1758 16c3f9cb-4b19-4553-ac8e-ebb90003aa02
#> 5 143044906                Mammalia cbb6498e-8927-405a-916b-576d00a6289b
#> 6 102402290                Mammalia 0938172b-2086-439c-a1dd-c21cb0109ed5
#>   nubKey parentKey        parent   phylum phylumKey  classKey
#> 1    359 137006861      Chordata Chordata 137006861 125798198
#> 2    359 143035196      Chordata Chordata 143035196 116665331
#> 3    359        44      Chordata Chordata        44       359
#> 4    359 137006861      Chordata Chordata 137006861 125826646
#> 5    359 143044905 Macroscelidea Chordata 143035196 143044905
#> 6    359 102545028      Chordata Chordata 102545028 102402290
#>   canonicalName     authorship   nameType  rank numDescendants
#> 1      Mammalia                WELLFORMED CLASS              2
#> 2      Mammalia Linnaeus, 1758 WELLFORMED CLASS           1193
#> 3      Mammalia Linnaeus, 1758 WELLFORMED CLASS          30001
#> 4      Mammalia Linnaeus, 1758 WELLFORMED CLASS              0
#> 5      Mammalia           <NA>       <NA> ORDER              3
#> 6      Mammalia                WELLFORMED CLASS          15187
#>   numOccurrences   taxonID extinct nomenclaturalStatus threatStatuses
#> 1              0   2621711    TRUE                  NA             NA
#> 2              0     18838      NA                  NA             NA
#> 3              0 119459549   FALSE                  NA             NA
#> 4              0      7907      NA                  NA             NA
#> 5              0      <NA>      NA                  NA             NA
#> 6              0      1310      NA                  NA             NA
#>   synonym         class  kingdom kingdomKey
#> 1   FALSE      Mammalia     <NA>         NA
#> 2   FALSE      Mammalia Animalia  116630539
#> 3   FALSE      Mammalia Animalia          1
#> 4   FALSE      Mammalia     <NA>         NA
#> 5   FALSE Macroscelidea Animalia  116630539
#> 6   FALSE      Mammalia Animalia  101719444
#>                                                                                                                                                                                                                      publishedIn
#> 1                                                                                                                                                                                                                           <NA>
#> 2                                                                                                                                                                                                                           <NA>
#> 3 Linnaeus, C. (1758). Systema Naturae per regna tria naturae, secundum classes, ordines, genera, species, cum characteribus, differentiis, synonymis, locis. Editio decima, reformata. Laurentius Salvius: Holmiae. ii, 824 pp.
#> 4                                                                                                                                                                                                                           <NA>
#> 5                                                                                                                                                                                                                           <NA>
#> 6                                                                                                                                                                                                                           <NA>
#>                               accordingTo taxonomicStatus marine    order
#> 1                                    <NA>            <NA>     NA     <NA>
#> 2                                    <NA>            <NA>     NA     <NA>
#> 3 The Catalogue of Life, 3rd January 2011        ACCEPTED   TRUE     <NA>
#> 4                                    <NA>            <NA>     NA     <NA>
#> 5                                    <NA>        ACCEPTED     NA Mammalia
#> 6                                    <NA>            <NA>     NA     <NA>
#>    orderKey species speciesKey acceptedKey accepted family familyKey genus
#> 1        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 2        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 3        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 4        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 5 143044906    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#> 6        NA    <NA>         NA          NA     <NA>   <NA>        NA  <NA>
#>   genusKey
#> 1       NA
#> 2       NA
#> 3       NA
#> 4       NA
#> 5       NA
#> 6       NA
```

Look up the species Helianthus annuus


```r
head(name_lookup('Helianthus annuus', rank="species", return = 'data'))
#>         key       scientificName                           datasetKey
#> 1 116845199 Helianthus annuus L. cbb6498e-8927-405a-916b-576d00a6289b
#> 2   3119195 Helianthus annuus L. d7dddbf4-2cf0-4f39-9b2a-bb099caae36c
#> 3 125790787 Helianthus annuus L. 16c3f9cb-4b19-4553-ac8e-ebb90003aa02
#> 4 106239436    Helianthus annuus fab88965-e69d-4491-a04d-e3198b626e52
#> 5 111449704 Helianthus annuus L. 1c1f2cfc-8370-414f-9202-9f00ccf51413
#> 6 124780276 Helianthus annuus L. 19491596-35ae-4a91-9a98-85cf505f1bd3
#>    nubKey parentKey     parent       kingdom     order     family
#> 1 3119195 143073503 Helianthus       Plantae Asterales Asteraceae
#> 2 3119195   3119134 Helianthus       Plantae Asterales Asteraceae
#> 3 3119195 125809269 Helianthus          <NA> Asterales Asteraceae
#> 4      NA 106239325 Helianthus Viridiplantae Asterales Asteraceae
#> 5 3119195 111449703 Helianthus       Plantae      <NA> Compositae
#> 6 3119195 124852643 Helianthus       Plantae Asterales Compositae
#>        genus           species kingdomKey  orderKey familyKey  genusKey
#> 1 Helianthus Helianthus annuus  116668764 143071754 143071759 143073503
#> 2 Helianthus Helianthus annuus          6       414      3065   3119134
#> 3 Helianthus Helianthus annuus         NA 137012188 125799038 125809269
#> 4 Helianthus Helianthus annuus  106147210 106237428 106237535 106239325
#> 5 Helianthus              <NA>  111449174        NA 111442813 111449703
#> 6 Helianthus Helianthus annuus  124850847 124852488 124852489 124852643
#>   speciesKey     canonicalName authorship   nameType    rank
#> 1  116845199 Helianthus annuus         L. WELLFORMED SPECIES
#> 2    3119195 Helianthus annuus         L. WELLFORMED SPECIES
#> 3  125790787 Helianthus annuus         L. WELLFORMED SPECIES
#> 4  106239436 Helianthus annuus            WELLFORMED SPECIES
#> 5         NA Helianthus annuus         L. WELLFORMED SPECIES
#> 6  124780276 Helianthus annuus         L. WELLFORMED SPECIES
#>   numDescendants numOccurrences   taxonID nomenclaturalStatus
#> 1              0              0     57622                  NA
#> 2             36              0 107290518                  NA
#> 3              0              0    112763                  NA
#> 4              2              0      4232                  NA
#> 5              1              0    417215                  NA
#> 6              0              0  19073408                  NA
#>   threatStatuses synonym basionymKey
#> 1             NA   FALSE          NA
#> 2             NA   FALSE     3119205
#> 3             NA   FALSE          NA
#> 4             NA   FALSE          NA
#> 5             NA   FALSE          NA
#> 6             NA   FALSE          NA
#>                                    basionym        phylum phylumKey
#> 1                                      <NA>          <NA>        NA
#> 2 Helianthus lenticularis Douglas ex Lindl. Magnoliophyta        49
#> 3                                      <NA>          <NA>        NA
#> 4                                      <NA>  Streptophyta 106171079
#> 5                                      <NA> Spermatophyta 111449175
#> 6                                      <NA>  Tracheophyta 124851364
#>    classKey         publishedIn                             accordingTo
#> 1        NA                <NA>                                    <NA>
#> 2       220 Sp. pl. 2:904. 1753 Integrated Taxonomic Information System
#> 3        NA                <NA>                                    <NA>
#> 4        NA                <NA>                                    <NA>
#> 5 111449177                <NA>                                    <NA>
#> 6 124852364                <NA>                                    <NA>
#>   taxonomicStatus extinct marine         class subgenus
#> 1            <NA>      NA     NA          <NA>     <NA>
#> 2        ACCEPTED   FALSE  FALSE Magnoliopsida     <NA>
#> 3            <NA>      NA     NA          <NA>     <NA>
#> 4            <NA>      NA     NA          <NA>     <NA>
#> 5        ACCEPTED      NA     NA Dicotyledones     <NA>
#> 6            <NA>      NA     NA Magnoliopsida     <NA>
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
library("plyr")
out <- name_usage(key=3119195, language="FRENCH", data='vernacularNames')
compact(lapply(out$results, function(x) if(x$language=="FRENCH") x else NULL))[1:2]
#> [[1]]
#> NULL
#> 
#> [[2]]
#> NULL
```

The function `name_backbone()` is used to search against the GBIF backbone taxonomy


```r
name_backbone(name='Helianthus', rank='genus', kingdom='plants')
#> $usageKey
#> [1] 3119134
#> 
#> $scientificName
#> [1] "Helianthus L."
#> 
#> $canonicalName
#> [1] "Helianthus"
#> 
#> $rank
#> [1] "GENUS"
#> 
#> $synonym
#> [1] FALSE
#> 
#> $confidence
#> [1] 97
#> 
#> $matchType
#> [1] "EXACT"
#> 
#> $kingdom
#> [1] "Plantae"
#> 
#> $phylum
#> [1] "Magnoliophyta"
#> 
#> $order
#> [1] "Asterales"
#> 
#> $family
#> [1] "Asteraceae"
#> 
#> $genus
#> [1] "Helianthus"
#> 
#> $kingdomKey
#> [1] 6
#> 
#> $phylumKey
#> [1] 49
#> 
#> $classKey
#> [1] 220
#> 
#> $orderKey
#> [1] 414
#> 
#> $familyKey
#> [1] 3065
#> 
#> $genusKey
#> [1] 3119134
#> 
#> $class
#> [1] "Magnoliopsida"
```

The function `name_suggest()` is optimized for speed, and gives back suggested names based on query parameters.


```r
head( name_suggest(q='Puma concolor') )
#>       key              canonicalName       rank
#> 1 2435099              Puma concolor    SPECIES
#> 2 6164602    Puma concolor improcera SUBSPECIES
#> 3 6164611     Puma concolor mayensis SUBSPECIES
#> 4 6164613    Puma concolor schorgeri SUBSPECIES
#> 5 6164591  Puma concolor kaibabensis SUBSPECIES
#> 6 6164603 Puma concolor missoulensis SUBSPECIES
```


## Single occurrence records

Get data for a single occurrence. Note that data is returned as a list, with slots for metadata and data, or as a hierarchy, or just data.

Just data


```r
occ_get(key=766766824, return='data')
#>              name       key decimalLatitude decimalLongitude        issues
#> 1 Corvus monedula 766766824         59.4568          17.9054 depunl,gass84
```

Just taxonomic hierarchy


```r
occ_get(key=766766824, return='hier')
#>              name     key    rank
#> 1        Animalia       1 kingdom
#> 2        Chordata      44  phylum
#> 3            Aves     212   class
#> 4   Passeriformes     729   order
#> 5        Corvidae    5235  family
#> 6          Corvus 2482468   genus
#> 7 Corvus monedula 2482473 species
```

All data, or leave return parameter blank


```r
occ_get(key=766766824, return='all')
#> $hierarchy
#>              name     key    rank
#> 1        Animalia       1 kingdom
#> 2        Chordata      44  phylum
#> 3            Aves     212   class
#> 4   Passeriformes     729   order
#> 5        Corvidae    5235  family
#> 6          Corvus 2482468   genus
#> 7 Corvus monedula 2482473 species
#> 
#> $media
#> list()
#> 
#> $data
#>              name       key decimalLatitude decimalLongitude        issues
#> 1 Corvus monedula 766766824         59.4568          17.9054 depunl,gass84
```

Get many occurrences. `occ_get` is vectorized


```r
occ_get(key=c(766766824,101010,240713150,855998194,49819470), return='data')
#>                     name       key decimalLatitude decimalLongitude
#> 1        Corvus monedula 766766824        59.45680         17.90540
#> 2    Platydoras costatus    101010        -4.35000        -70.06670
#> 3                   none 240713150       -77.56670        163.58299
#> 4       Sciurus vulgaris 855998194        58.40680         12.04380
#> 5 Phlogophora meticulosa  49819470        55.72462         13.28238
#>                    issues
#> 1           depunl,gass84
#> 2          cucdmis,gass84
#> 3 cdround,gass84,txmatnon
#> 4           depunl,gass84
#> 5          cdround,gass84
```


## Search for occurrences

By default `occ_search()` returns a `dplyr` like output summary in which the data printed expands based on how much data is returned, and the size of your window. You can search by scientific name:


```r
occ_search(scientificName = "Ursus americanus", limit = 20)
#> Records found [6890] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                name        key decimalLatitude decimalLongitude
#> 1  Ursus americanus  891034709        29.23322       -103.29468
#> 2  Ursus americanus 1024328693        34.20990       -118.14681
#> 3  Ursus americanus  891045574        43.73511        -72.52534
#> 4  Ursus americanus  891041363        29.28284       -103.28908
#> 5  Ursus americanus 1050834838        33.11070       -107.70675
#> 6  Ursus americanus  891056344        29.27444       -103.31536
#> 7  Ursus americanus 1042823202        44.34088        -72.46131
#> 8  Ursus americanus 1024180980        34.56844       -119.16081
#> 9  Ursus americanus 1024182262        50.09019       -117.46038
#> 10 Ursus americanus 1024328712        39.51185       -120.16434
#> ..              ...        ...             ...              ...
#> Variables not shown: issues (chr), datasetKey (chr), publishingOrgKey
#>      (chr), publishingCountry (chr), protocol (chr), lastCrawled (chr),
#>      lastParsed (chr), extensions (chr), basisOfRecord (chr), taxonKey
#>      (int), kingdomKey (int), phylumKey (int), classKey (int), orderKey
#>      (int), familyKey (int), genusKey (int), speciesKey (int),
#>      scientificName (chr), kingdom (chr), phylum (chr), order (chr),
#>      family (chr), genus (chr), species (chr), genericName (chr),
#>      specificEpithet (chr), taxonRank (chr), dateIdentified (chr), year
#>      (int), month (int), day (int), eventDate (chr), modified (chr),
#>      lastInterpreted (chr), references (chr), identifiers (chr), facts
#>      (chr), relations (chr), geodeticDatum (chr), class (chr), countryCode
#>      (chr), country (chr), verbatimEventDate (chr),
#>      http...unknown.org.occurrenceDetails (chr), rights (chr),
#>      rightsHolder (chr), occurrenceID (chr), collectionCode (chr), taxonID
#>      (chr), gbifID (chr), institutionCode (chr), datasetName (chr),
#>      catalogNumber (chr), recordedBy (chr), eventTime (chr), identifier
#>      (chr), identificationID (chr), infraspecificEpithet (chr),
#>      verbatimLocality (chr), occurrenceRemarks (chr), lifeStage (chr),
#>      elevation (dbl), elevationAccuracy (dbl), continent (chr),
#>      stateProvince (chr), georeferencedDate (chr), institutionID (chr),
#>      higherGeography (chr), type (chr), georeferenceSources (chr),
#>      identifiedBy (chr), identificationVerificationStatus (chr),
#>      samplingProtocol (chr), endDayOfYear (chr), otherCatalogNumbers
#>      (chr), preparations (chr), georeferenceVerificationStatus (chr),
#>      individualID (chr), nomenclaturalCode (chr), higherClassification
#>      (chr), locationAccordingTo (chr), verbatimCoordinateSystem (chr),
#>      previousIdentifications (chr), georeferenceProtocol (chr),
#>      identificationQualifier (chr), accessRights (chr), county (chr),
#>      dynamicProperties (chr), locality (chr), language (chr),
#>      georeferencedBy (chr)
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [20369] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [11] 
#> Args [taxonKey=3119195, limit=20, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                 name        key decimalLatitude decimalLongitude
#> 1  Helianthus annuus  922042404        -3.28140         37.52415
#> 2  Helianthus annuus  899948224         1.27890        103.79930
#> 3  Helianthus annuus  891052261        24.82589        -99.58411
#> 4  Helianthus annuus 1038317691       -43.52777        172.62544
#> 5  Helianthus annuus  922044332        21.27114         40.41424
#> 6  Helianthus annuus  922039507        50.31402          8.52341
#> 7  Helianthus annuus  998785009        44.10879          4.66839
#> 8  Helianthus annuus  899970378        32.54041       -117.08731
#> 9  Helianthus annuus  899969160        24.82901        -99.58257
#> 10 Helianthus annuus 1054796860        33.74417       -117.38556
#> ..               ...        ...             ...              ...
#> Variables not shown: issues (chr), datasetKey (chr), publishingOrgKey
#>      (chr), publishingCountry (chr), protocol (chr), lastCrawled (chr),
#>      lastParsed (chr), extensions (chr), basisOfRecord (chr), taxonKey
#>      (int), kingdomKey (int), phylumKey (int), classKey (int), orderKey
#>      (int), familyKey (int), genusKey (int), speciesKey (int),
#>      scientificName (chr), kingdom (chr), phylum (chr), order (chr),
#>      family (chr), genus (chr), species (chr), genericName (chr),
#>      specificEpithet (chr), taxonRank (chr), year (int), month (int), day
#>      (int), eventDate (chr), lastInterpreted (chr), identifiers (chr),
#>      facts (chr), relations (chr), geodeticDatum (chr), class (chr),
#>      countryCode (chr), country (chr), gbifID (chr), institutionCode
#>      (chr), catalogNumber (chr), recordedBy (chr), locality (chr),
#>      collectionCode (chr), dateIdentified (chr), modified (chr),
#>      references (chr), verbatimEventDate (chr), verbatimLocality (chr),
#>      http...unknown.org.occurrenceDetails (chr), rights (chr),
#>      rightsHolder (chr), occurrenceID (chr), taxonID (chr),
#>      occurrenceRemarks (chr), datasetName (chr), eventTime (chr),
#>      identifier (chr), identificationID (chr), county (chr), identifiedBy
#>      (chr), stateProvince (chr), recordNumber (chr), verbatimElevation
#>      (chr), georeferenceSources (chr), coordinateAccuracy (dbl), elevation
#>      (dbl), elevationAccuracy (dbl), depth (dbl), depthAccuracy (dbl)
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#>   offset limit endOfRecords count
#> 1    300   200        FALSE 20369
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [6890] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0,
#>      fields=name,basisOfRecord,protocol] 
#> First 10 rows of data
#> 
#>                name    protocol      basisOfRecord
#> 1  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 2  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 3  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 4  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 5  Ursus americanus DWC_ARCHIVE PRESERVED_SPECIMEN
#> 6  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 7  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 8  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 9  Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> 10 Ursus americanus DWC_ARCHIVE  HUMAN_OBSERVATION
#> ..              ...         ...                ...
```

Most parameters are vectorized, so you can pass in more than one value:


```r
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5)
#> Occ. found [2482598 (355163), 2492010 (1942009), 2498387 (591977)] 
#> Occ. returned [2482598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2482598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2482598 (5), 2492010 (5), 2498387 (2)] 
#> Args [taxonKey=2482598,2492010,2498387, limit=5, offset=0, fields=all] 
#> First 10 rows of data from 2482598
#> 
#>                  name        key decimalLatitude decimalLongitude
#> 1 Cyanocitta stelleri 1052604494        37.76975        -122.4715
#> 2 Cyanocitta stelleri 1060841957              NA               NA
#> 3 Cyanocitta stelleri  891781350        37.73646        -122.4880
#> 4 Cyanocitta stelleri  891046529        32.82392        -116.5323
#> 5 Cyanocitta stelleri  891056081        37.76811        -122.4737
#> Variables not shown: issues (chr), datasetKey (chr), publishingOrgKey
#>      (chr), publishingCountry (chr), protocol (chr), lastCrawled (chr),
#>      lastParsed (chr), extensions (chr), basisOfRecord (chr), taxonKey
#>      (int), kingdomKey (int), phylumKey (int), classKey (int), orderKey
#>      (int), familyKey (int), genusKey (int), speciesKey (int),
#>      scientificName (chr), kingdom (chr), phylum (chr), order (chr),
#>      family (chr), genus (chr), species (chr), genericName (chr),
#>      specificEpithet (chr), taxonRank (chr), dateIdentified (chr), year
#>      (int), month (int), day (int), eventDate (chr), modified (chr),
#>      lastInterpreted (chr), references (chr), identifiers (chr), facts
#>      (chr), relations (chr), geodeticDatum (chr), class (chr), countryCode
#>      (chr), country (chr), verbatimEventDate (chr), verbatimLocality
#>      (chr), http...unknown.org.occurrenceDetails (chr), rights (chr),
#>      rightsHolder (chr), occurrenceID (chr), collectionCode (chr), taxonID
#>      (chr), occurrenceRemarks (chr), gbifID (chr), institutionCode (chr),
#>      datasetName (chr), catalogNumber (chr), recordedBy (chr), eventTime
#>      (chr), identifier (chr), identificationID (chr), sex (chr), lifeStage
#>      (chr), establishmentMeans (chr), infraspecificEpithet (chr),
#>      continent (chr), stateProvince (chr), startDayOfYear (chr),
#>      preparations (chr), recordNumber (chr), institutionID (chr),
#>      nomenclaturalCode (chr), higherClassification (chr), higherGeography
#>      (chr), type (chr), accessRights (chr), endDayOfYear (chr), county
#>      (chr), locality (chr), occurrenceStatus (chr), language (chr)
```


********************

## Maps

Static map using the ggplot2 package. Make a map of *Puma concolor* occurrences.


```r
key <- name_backbone(name='Puma concolor')$speciesKey
dat <- occ_search(taxonKey=key, return='data', limit=300)
gbifmap(input=dat)
```

![plot of chunk gbifmap1](figure/gbifmap1-1.png) 

[gbifapi]: http://data.gbif.org/tutorial/services
