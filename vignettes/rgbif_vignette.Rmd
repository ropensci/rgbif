<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{rgbif introduction}
%\VignetteEncoding{UTF-8}
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
library("rgbif")
```

## Number of occurrences

Search by type of record, all observational in this case


```r
occ_count(basisOfRecord='OBSERVATION')
#> [1] 96939398
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 2759
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 499446693
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 9629372
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 38119758
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
#>   offset limit endOfRecords count
#> 1      0   100        FALSE 96974
```


```r
head(out$data)
#>         key                 scientificName
#> 1 101961729 Mammalia (awaiting allocation)
#> 2 100375341                       Mammalia
#> 3 101961726 Mammalia (awaiting allocation)
#> 4 113391223        Mammalia Linnaeus, 1758
#> 5       359        Mammalia Linnaeus, 1758
#> 6 100348839         Mammalia Linnaeus 1758
#>                             datasetKey parentKey   parent  kingdom
#> 1 714c64e3-2dc1-4bb7-91e4-54be5af4da12 101961726 Mammalia Animalia
#> 2 16c3f9cb-4b19-4553-ac8e-ebb90003aa02        NA     <NA>     <NA>
#> 3 714c64e3-2dc1-4bb7-91e4-54be5af4da12 101959399 Mammalia Animalia
#> 4 cbb6498e-8927-405a-916b-576d00a6289b 113301736 Chordata Animalia
#> 5 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c        44 Chordata Animalia
#> 6 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 100347572 Chordata     <NA>
#>     phylum    order   family kingdomKey phylumKey  classKey  orderKey
#> 1 Chordata Mammalia Mammalia  101859873 101946562 101959399 101961726
#> 2     <NA>     <NA>     <NA>         NA        NA 100375341        NA
#> 3 Chordata Mammalia     <NA>  101859873 101946562 101959399 101961726
#> 4 Chordata     <NA>     <NA>  112707351 113301736 113391223        NA
#> 5 Chordata     <NA>     <NA>          1        44       359        NA
#> 6 Chordata     <NA>     <NA>         NA 100347572 100348839        NA
#>   familyKey canonicalName     authorship   nameType taxonomicStatus   rank
#> 1 101961729      Mammalia                   NO_NAME        ACCEPTED FAMILY
#> 2        NA      Mammalia                SCIENTIFIC            <NA>  CLASS
#> 3        NA      Mammalia                   NO_NAME        ACCEPTED  ORDER
#> 4        NA      Mammalia Linnaeus, 1758 SCIENTIFIC            <NA>  CLASS
#> 5        NA      Mammalia Linnaeus, 1758 SCIENTIFIC        ACCEPTED  CLASS
#> 6        NA      Mammalia Linnaeus, 1758 SCIENTIFIC            <NA>  CLASS
#>   numDescendants numOccurrences habitats nomenclaturalStatus
#> 1            138              0     <NA>                <NA>
#> 2              0              0     <NA>                <NA>
#> 3            139              0     <NA>                <NA>
#> 4           3477              0     <NA>                <NA>
#> 5          30001              0   MARINE                <NA>
#> 6              0              0     <NA>                <NA>
#>   threatStatuses synonym    class nubKey   taxonID extinct
#> 1             NA   FALSE Mammalia     NA      <NA>      NA
#> 2             NA   FALSE Mammalia    359   2621711    TRUE
#> 3             NA   FALSE Mammalia     NA      <NA>      NA
#> 4             NA   FALSE Mammalia    359     18838      NA
#> 5             NA   FALSE Mammalia    359 119459549   FALSE
#> 6             NA   FALSE Mammalia    359      7907      NA
#>                                                                                                                                                                                                                      publishedIn
#> 1                                                                                                                                                                                                                           <NA>
#> 2                                                                                                                                                                                                                           <NA>
#> 3                                                                                                                                                                                                                           <NA>
#> 4                                                                                                                                                                                                                           <NA>
#> 5 Linnaeus, C. (1758). Systema Naturae per regna tria naturae, secundum classes, ordines, genera, species, cum characteribus, differentiis, synonymis, locis. Editio decima, reformata. Laurentius Salvius: Holmiae. ii, 824 pp.
#> 6                                                                                                                                                                                                                           <NA>
#>                               accordingTo species speciesKey acceptedKey
#> 1                                    <NA>    <NA>         NA          NA
#> 2                                    <NA>    <NA>         NA          NA
#> 3                                    <NA>    <NA>         NA          NA
#> 4                                    <NA>    <NA>         NA          NA
#> 5 The Catalogue of Life, 3rd January 2011    <NA>         NA          NA
#> 6                                    <NA>    <NA>         NA          NA
#>   accepted genus genusKey
#> 1     <NA>  <NA>       NA
#> 2     <NA>  <NA>       NA
#> 3     <NA>  <NA>       NA
#> 4     <NA>  <NA>       NA
#> 5     <NA>  <NA>       NA
#> 6     <NA>  <NA>       NA
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`101961729`
#>     rankkey     name
#> 1 101859873 Animalia
#> 2 101946562 Chordata
#> 3 101959399 Mammalia
#> 4 101961726 Mammalia
#> 
#> $`101961726`
#>     rankkey     name
#> 1 101859873 Animalia
#> 2 101946562 Chordata
#> 3 101959399 Mammalia
```


```r
out$names[2]
#> $`113391223`
#>   vernacularName language
#> 1        Mammals      eng
```

Search for a genus


```r
head(name_lookup(query='Cnaemidophorus', rank="genus", return="data"))
#>         key                  scientificName
#> 1 113100610 Cnaemidophorus Wallengren, 1862
#> 2   1858636 Cnaemidophorus Wallengren, 1862
#> 3 100555508 Cnaemidophorus Wallengren, 1862
#> 4 110531263                  Cnaemidophorus
#> 5 100555497                  Cnaemidophorus
#> 6 113212699                  Cnaemidophorus
#>                             datasetKey  nubKey parentKey        parent
#> 1 cbb6498e-8927-405a-916b-576d00a6289b 1858636 113099670 Pterophoridae
#> 2 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c 1858636      8863 Pterophoridae
#> 3 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 1858636 100555506 Pterophoridae
#> 4 7ddf754f-d193-4cc9-b351-99906754a03b 1858636 110531096 Pterophoridae
#> 5 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 1858636 100555496 Pterophoridae
#> 6 cbb6498e-8927-405a-916b-576d00a6289b 1858636 113212683 Pterophoridae
#>    kingdom     phylum       order        family          genus kingdomKey
#> 1 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  112707351
#> 2 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus          1
#> 3     <NA>       <NA> Lepidoptera Pterophoridae Cnaemidophorus         NA
#> 4 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  109354902
#> 5     <NA>       <NA> Lepidoptera Pterophoridae Cnaemidophorus         NA
#> 6 Animalia Arthropoda Lepidoptera Pterophoridae Cnaemidophorus  112707351
#>   phylumKey  classKey  orderKey familyKey  genusKey  canonicalName
#> 1 112710199 112780522 112876893 113099670 113100610 Cnaemidophorus
#> 2        54       216       797      8863   1858636 Cnaemidophorus
#> 3        NA        NA 100555505 100555506 100555508 Cnaemidophorus
#> 4 109380340 109498964 110368094 110531096 110531263 Cnaemidophorus
#> 5        NA        NA 100555495 100555496 100555497 Cnaemidophorus
#> 6 113188372 113191312 113197877 113212683 113212699 Cnaemidophorus
#>         authorship   nameType  rank numDescendants numOccurrences
#> 1 Wallengren, 1862 SCIENTIFIC GENUS              2              0
#> 2 Wallengren, 1862 SCIENTIFIC GENUS              4              0
#> 3 Wallengren, 1862 SCIENTIFIC GENUS              0              0
#> 4                  SCIENTIFIC GENUS              2              0
#> 5                  SCIENTIFIC GENUS              1              0
#> 6                  SCIENTIFIC GENUS              1              0
#>     taxonID habitats nomenclaturalStatus threatStatuses synonym   class
#> 1  29079847       NA                  NA             NA   FALSE Insecta
#> 2 115123697       NA                  NA             NA   FALSE Insecta
#> 3   3502919       NA                  NA             NA   FALSE    <NA>
#> 4  22715482       NA                  NA             NA   FALSE Insecta
#> 5      <NA>       NA                  NA             NA   FALSE    <NA>
#> 6      <NA>       NA                  NA             NA   FALSE Insecta
#>                                               publishedIn    accordingTo
#> 1                                                    <NA>           <NA>
#> 2 K. svenska VetenskAkad. Handl. , (N. F. ) 3, no. 7, 10. Fauna Europaea
#> 3                                                    <NA>           <NA>
#> 4                                                    <NA>           <NA>
#> 5                                                    <NA>           <NA>
#> 6                                                    <NA>           <NA>
#>   taxonomicStatus extinct acceptedKey accepted
#> 1            <NA>      NA          NA     <NA>
#> 2        ACCEPTED   FALSE          NA     <NA>
#> 3            <NA>      NA          NA     <NA>
#> 4            <NA>      NA          NA     <NA>
#> 5        ACCEPTED      NA          NA     <NA>
#> 6        ACCEPTED      NA          NA     <NA>
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#>         key                 scientificName
#> 1 101961729 Mammalia (awaiting allocation)
#> 2 100375341                       Mammalia
#> 3 101961726 Mammalia (awaiting allocation)
#> 4 113391223        Mammalia Linnaeus, 1758
#> 5       359        Mammalia Linnaeus, 1758
#> 6 100348839         Mammalia Linnaeus 1758
#>                             datasetKey parentKey   parent  kingdom
#> 1 714c64e3-2dc1-4bb7-91e4-54be5af4da12 101961726 Mammalia Animalia
#> 2 16c3f9cb-4b19-4553-ac8e-ebb90003aa02        NA     <NA>     <NA>
#> 3 714c64e3-2dc1-4bb7-91e4-54be5af4da12 101959399 Mammalia Animalia
#> 4 cbb6498e-8927-405a-916b-576d00a6289b 113301736 Chordata Animalia
#> 5 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c        44 Chordata Animalia
#> 6 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 100347572 Chordata     <NA>
#>     phylum    order   family kingdomKey phylumKey  classKey  orderKey
#> 1 Chordata Mammalia Mammalia  101859873 101946562 101959399 101961726
#> 2     <NA>     <NA>     <NA>         NA        NA 100375341        NA
#> 3 Chordata Mammalia     <NA>  101859873 101946562 101959399 101961726
#> 4 Chordata     <NA>     <NA>  112707351 113301736 113391223        NA
#> 5 Chordata     <NA>     <NA>          1        44       359        NA
#> 6 Chordata     <NA>     <NA>         NA 100347572 100348839        NA
#>   familyKey canonicalName     authorship   nameType taxonomicStatus   rank
#> 1 101961729      Mammalia                   NO_NAME        ACCEPTED FAMILY
#> 2        NA      Mammalia                SCIENTIFIC            <NA>  CLASS
#> 3        NA      Mammalia                   NO_NAME        ACCEPTED  ORDER
#> 4        NA      Mammalia Linnaeus, 1758 SCIENTIFIC            <NA>  CLASS
#> 5        NA      Mammalia Linnaeus, 1758 SCIENTIFIC        ACCEPTED  CLASS
#> 6        NA      Mammalia Linnaeus, 1758 SCIENTIFIC            <NA>  CLASS
#>   numDescendants numOccurrences habitats nomenclaturalStatus
#> 1            138              0     <NA>                <NA>
#> 2              0              0     <NA>                <NA>
#> 3            139              0     <NA>                <NA>
#> 4           3477              0     <NA>                <NA>
#> 5          30001              0   MARINE                <NA>
#> 6              0              0     <NA>                <NA>
#>   threatStatuses synonym    class nubKey   taxonID extinct
#> 1             NA   FALSE Mammalia     NA      <NA>      NA
#> 2             NA   FALSE Mammalia    359   2621711    TRUE
#> 3             NA   FALSE Mammalia     NA      <NA>      NA
#> 4             NA   FALSE Mammalia    359     18838      NA
#> 5             NA   FALSE Mammalia    359 119459549   FALSE
#> 6             NA   FALSE Mammalia    359      7907      NA
#>                                                                                                                                                                                                                      publishedIn
#> 1                                                                                                                                                                                                                           <NA>
#> 2                                                                                                                                                                                                                           <NA>
#> 3                                                                                                                                                                                                                           <NA>
#> 4                                                                                                                                                                                                                           <NA>
#> 5 Linnaeus, C. (1758). Systema Naturae per regna tria naturae, secundum classes, ordines, genera, species, cum characteribus, differentiis, synonymis, locis. Editio decima, reformata. Laurentius Salvius: Holmiae. ii, 824 pp.
#> 6                                                                                                                                                                                                                           <NA>
#>                               accordingTo species speciesKey acceptedKey
#> 1                                    <NA>    <NA>         NA          NA
#> 2                                    <NA>    <NA>         NA          NA
#> 3                                    <NA>    <NA>         NA          NA
#> 4                                    <NA>    <NA>         NA          NA
#> 5 The Catalogue of Life, 3rd January 2011    <NA>         NA          NA
#> 6                                    <NA>    <NA>         NA          NA
#>   accepted genus genusKey
#> 1     <NA>  <NA>       NA
#> 2     <NA>  <NA>       NA
#> 3     <NA>  <NA>       NA
#> 4     <NA>  <NA>       NA
#> 5     <NA>  <NA>       NA
#> 6     <NA>  <NA>       NA
```

Look up the species Helianthus annuus


```r
head(name_lookup(query = 'Helianthus annuus', rank="species", return = 'data'))
#>         key                             scientificName
#> 1 113584542                       Helianthus annuus L.
#> 2   3119195                       Helianthus annuus L.
#> 3 100336353                       Helianthus annuus L.
#> 4 103340289                          Helianthus annuus
#> 5 102912762 'Helianthus annuus' fasciation phytoplasma
#> 6 103628852                       Helianthus annuus L.
#>                             datasetKey  nubKey parentKey
#> 1 cbb6498e-8927-405a-916b-576d00a6289b 3119195 113584540
#> 2 d7dddbf4-2cf0-4f39-9b2a-bb099caae36c 3119195   3119134
#> 3 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 3119195 100336352
#> 4 fab88965-e69d-4491-a04d-e3198b626e52 3119195 103340270
#> 5 fab88965-e69d-4491-a04d-e3198b626e52 3119195 102912523
#> 6 046bbc50-cae2-47ff-aa43-729fbf53f7c5 3119195 103504882
#>                      parent       kingdom             order
#> 1                Helianthus       Plantae         Asterales
#> 2                Helianthus       Plantae         Asterales
#> 3                Helianthus       Plantae         Asterales
#> 4                Helianthus Viridiplantae         Asterales
#> 5 unclassified phytoplasmas          <NA> Acholeplasmatales
#> 6                Asteraceae       Plantae              <NA>
#>               family      genus           species kingdomKey  orderKey
#> 1         Asteraceae Helianthus Helianthus annuus  113551056 113580333
#> 2         Asteraceae Helianthus Helianthus annuus          6       414
#> 3         Asteraceae Helianthus Helianthus annuus  100325740 100336278
#> 4         Asteraceae Helianthus Helianthus annuus  102974832 103311652
#> 5 Acholeplasmataceae Candidatus Helianthus annuus         NA 102911070
#> 6         Asteraceae       <NA> Helianthus annuus  103198669        NA
#>   familyKey  genusKey speciesKey     canonicalName authorship   nameType
#> 1 113580355 113584540  113584542 Helianthus annuus         L. SCIENTIFIC
#> 2      3065   3119134    3119195 Helianthus annuus         L. SCIENTIFIC
#> 3 100336349 100336352  100336353 Helianthus annuus         L. SCIENTIFIC
#> 4 103311763 103340270  103340289 Helianthus annuus            SCIENTIFIC
#> 5 102911072 102911169  102912762 Helianthus annuus            SCIENTIFIC
#> 6 103504882        NA  103628852 Helianthus annuus         L. SCIENTIFIC
#>      rank numDescendants numOccurrences                         taxonID
#> 1 SPECIES              0              0                           57622
#> 2 SPECIES             36              0                       107290518
#> 3 SPECIES              0              0                          112763
#> 4 SPECIES              2              0                            4232
#> 5 SPECIES              0              0                         1301613
#> 6 SPECIES              0              0 urn:lsid:ipni.org:names:90623-3
#>      habitats nomenclaturalStatus threatStatuses synonym basionymKey
#> 1        <NA>                <NA>             NA   FALSE          NA
#> 2 TERRESTRIAL                <NA>             NA   FALSE     3119205
#> 3        <NA>                <NA>             NA   FALSE          NA
#> 4        <NA>                <NA>             NA   FALSE          NA
#> 5        <NA>                <NA>             NA   FALSE          NA
#> 6        <NA>                <NA>             NA   FALSE          NA
#>                                    basionym        phylum phylumKey
#> 1                                      <NA>          <NA>        NA
#> 2 Helianthus lenticularis Douglas ex Lindl. Magnoliophyta        49
#> 3                                      <NA>          <NA>        NA
#> 4                                      <NA>  Streptophyta 102986054
#> 5                                      <NA>   Tenericutes 102911063
#> 6                                      <NA>          <NA>        NA
#>    classKey         publishedIn                             accordingTo
#> 1        NA                <NA>                                    <NA>
#> 2       220 Sp. pl. 2:904. 1753 Integrated Taxonomic Information System
#> 3 100328106                <NA>                                    <NA>
#> 4        NA                <NA>                                    <NA>
#> 5 102911065                <NA>                                    <NA>
#> 6        NA                <NA>                                    <NA>
#>   taxonomicStatus extinct         class acceptedKey accepted
#> 1            <NA>      NA          <NA>          NA     <NA>
#> 2        ACCEPTED   FALSE Magnoliopsida          NA     <NA>
#> 3            <NA>      NA Magnoliopsida          NA     <NA>
#> 4            <NA>      NA          <NA>          NA     <NA>
#> 5            <NA>      NA    Mollicutes          NA     <NA>
#> 6            <NA>      NA          <NA>          NA     <NA>
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
library("plyr")
out <- name_usage(key=3119195, language="FRENCH", data='vernacularNames')
head(out$data)
#>     vernacularName language sourceTaxonKey preferred source
#> 1      Sonnenblume      deu      101321447        NA   <NA>
#> 2          alizeti      swa      101321447        NA   <NA>
#> 3 annual sunflower      eng      102234356        NA   <NA>
#> 4 common sunflower      eng      102234356        NA   <NA>
#> 5 common sunflower               103340289        NA   <NA>
#> 6          girasol      spa      101321447        NA   <NA>
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
#> $status
#> [1] "ACCEPTED"
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
#> $synonym
#> [1] FALSE
#> 
#> $class
#> [1] "Magnoliopsida"
```

The function `name_suggest()` is optimized for speed, and gives back suggested names based on query parameters.


```r
head( name_suggest(q='Puma concolor') )
#>       key              canonicalName       rank
#> 1 2435099              Puma concolor    SPECIES
#> 2 6164591  Puma concolor kaibabensis SUBSPECIES
#> 3 6164600        Puma concolor coryi SUBSPECIES
#> 4 6164603 Puma concolor missoulensis SUBSPECIES
#> 5 6164604   Puma concolor stanleyana SUBSPECIES
#> 6 6164620       Puma concolor cougar SUBSPECIES
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
occ_get(key=c(766766824, 101010, 240713150, 855998194), return='data')
#>                  name       key decimalLatitude decimalLongitude
#> 1     Corvus monedula 766766824         59.4568          17.9054
#> 2 Platydoras costatus    101010         -4.3500         -70.0667
#> 3            Pelosina 240713150        -77.5667         163.5830
#> 4    Sciurus vulgaris 855998194         58.4068          12.0438
#>           issues
#> 1  depunl,gass84
#> 2 cucdmis,gass84
#> 3 cdround,gass84
#> 4  depunl,gass84
```


## Search for occurrences

By default `occ_search()` returns a `dplyr` like output summary in which the data printed expands based on how much data is returned, and the size of your window. You can search by scientific name:


```r
occ_search(scientificName = "Ursus americanus", limit = 20)
#> Records found [7293] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                name        key decimalLatitude decimalLongitude
#> 1  Ursus americanus 1065590124        38.36662        -79.68283
#> 2  Ursus americanus 1065588899        35.73304        -82.42028
#> 3  Ursus americanus 1065611122        43.94883        -72.77432
#> 4  Ursus americanus 1098894889        23.66893        -99.09625
#> 5  Ursus americanus 1132403409        40.13240       -123.82900
#> 6  Ursus americanus 1088923534        36.93018        -78.25027
#> 7  Ursus americanus 1088932238        32.65219       -108.53674
#> 8  Ursus americanus 1088932273        32.65237       -108.53691
#> 9  Ursus americanus 1088908315        43.86464        -72.34617
#> 10 Ursus americanus 1088950245        44.41015        -72.18191
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
#>      (chr), country (chr), rightsHolder (chr), identifier (chr),
#>      verbatimEventDate (chr), datasetName (chr), gbifID (chr),
#>      collectionCode (chr), occurrenceID (chr), taxonID (chr),
#>      catalogNumber (chr), recordedBy (chr),
#>      http...unknown.org.occurrenceDetails (chr), institutionCode (chr),
#>      rights (chr), eventTime (chr), occurrenceRemarks (chr),
#>      identificationID (chr), verbatimLocality (chr), infraspecificEpithet
#>      (chr), informationWithheld (chr)
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [21517] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [15] 
#> Args [taxonKey=3119195, limit=20, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                 name        key decimalLatitude decimalLongitude
#> 1  Helianthus annuus 1095851641         0.00000          0.00000
#> 2  Helianthus annuus 1088900309        33.95239       -117.32011
#> 3  Helianthus annuus 1135826959              NA               NA
#> 4  Helianthus annuus 1135523136        33.96709       -117.99769
#> 5  Helianthus annuus 1088944416        26.20518        -98.26725
#> 6  Helianthus annuus 1092901911        30.22344        -97.95281
#> 7  Helianthus annuus 1098903927        29.17958       -102.99551
#> 8  Helianthus annuus 1135523412        33.96787       -118.00016
#> 9  Helianthus annuus 1092894334        34.16052       -119.03794
#> 10 Helianthus annuus 1092889365        32.71840       -114.75603
#> ..               ...        ...             ...              ...
#> Variables not shown: issues (chr), datasetKey (chr), publishingOrgKey
#>      (chr), publishingCountry (chr), protocol (chr), lastCrawled (chr),
#>      lastParsed (chr), extensions (chr), basisOfRecord (chr), taxonKey
#>      (int), kingdomKey (int), phylumKey (int), classKey (int), orderKey
#>      (int), familyKey (int), genusKey (int), speciesKey (int),
#>      scientificName (chr), kingdom (chr), phylum (chr), order (chr),
#>      family (chr), genus (chr), species (chr), genericName (chr),
#>      specificEpithet (chr), taxonRank (chr), dateIdentified (chr),
#>      elevation (dbl), elevationAccuracy (dbl), stateProvince (chr), year
#>      (int), month (int), day (int), eventDate (chr), lastInterpreted
#>      (chr), identifiers (chr), facts (chr), relations (chr), geodeticDatum
#>      (chr), class (chr), countryCode (chr), country (chr), rightsHolder
#>      (chr), identifier (chr), recordNumber (chr), locality (chr),
#>      municipality (chr), datasetName (chr), gbifID (chr), collectionCode
#>      (chr), language (chr), occurrenceID (chr), type (chr), catalogNumber
#>      (chr), recordedBy (chr), institutionCode (chr), rights (chr),
#>      ownerInstitutionCode (chr), occurrenceRemarks (chr), identifiedBy
#>      (chr), modified (chr), references (chr), verbatimEventDate (chr),
#>      verbatimLocality (chr), taxonID (chr),
#>      http...unknown.org.occurrenceDetails (chr), eventTime (chr),
#>      identificationID (chr), informationWithheld (chr), coordinateAccuracy
#>      (dbl), depth (dbl), depthAccuracy (dbl), county (chr)
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#>   offset limit endOfRecords count
#> 1    300   200        FALSE 21517
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [7293] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0,
#>      fields=name,basisOfRecord,protocol] 
#> First 10 rows of data
#> 
#>                name    protocol     basisOfRecord
#> 1  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 2  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 3  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 4  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 5  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 6  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 7  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 8  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 9  Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 10 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> ..              ...         ...               ...
```

Most parameters are vectorized, so you can pass in more than one value:


```r
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5)
#> Occ. found [2482598 (355770), 2492010 (1942579), 2498387 (592343)] 
#> Occ. returned [2482598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2482598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2482598 (5), 2492010 (5), 2498387 (4)] 
#> Args [taxonKey=2482598,2492010,2498387, limit=5, offset=0, fields=all] 
#> First 10 rows of data from 2482598
#> 
#>                  name        key decimalLatitude decimalLongitude
#> 1 Cyanocitta stelleri 1065588311        37.26200        -122.3271
#> 2 Cyanocitta stelleri 1052604494        37.76975        -122.4715
#> 3 Cyanocitta stelleri 1065588252        36.54670        -105.1335
#> 4 Cyanocitta stelleri 1065597471        39.11136        -120.1687
#> 5 Cyanocitta stelleri 1065601214        37.41080        -122.2617
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
#>      (chr), country (chr), rightsHolder (chr), identifier (chr),
#>      verbatimEventDate (chr), datasetName (chr), verbatimLocality (chr),
#>      gbifID (chr), collectionCode (chr), occurrenceID (chr), taxonID
#>      (chr), catalogNumber (chr), recordedBy (chr),
#>      http...unknown.org.occurrenceDetails (chr), institutionCode (chr),
#>      rights (chr), eventTime (chr), identificationID (chr),
#>      occurrenceRemarks (chr)
```


********************

## Maps

Static map using the ggplot2 package. Make a map of *Puma concolor* occurrences.


```r
key <- name_backbone(name='Puma concolor')$speciesKey
dat <- occ_search(taxonKey=key, return='data', limit=300)
gbifmap(dat)
```

![plot of chunk gbifmap1](figure/gbifmap1-1.png) 

[gbifapi]: http://data.gbif.org/tutorial/services
