<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->

rgbif vignette - Seach and retrieve data from the Global Biodiverity Information Facilty (GBIF)
======

### About the package

`rgbif` is an R package to search and retrieve data from the Global Biodiverity Information Facilty (GBIF). `rgbif` wraps R code around the [GBIF API][gbifapi] to allow you to talk to GBIF from R. 

********************

#### Install rgbif and dependencies


```r
install.packages("rgbif")
```


#### Load rgbif and dependencies


```r
library(rgbif)
library(XML)
library(RCurl)
library(plyr)
library(ggplot2)
library(maps)
```


********************

#### Get number of occurrences for a set of search parameters

##### Search by type of record, all observational in this case


```r
occ_count(basisOfRecord = "OBSERVATION")
```

```
[1] 286071783
```


##### Records for **Puma concolor** with lat/long data (georeferened) only


```r
occ_count(nubKey = 2435099, georeferenced = TRUE)
```

```
[1] 2541
```


##### All georeferenced records in GBIF


```r
occ_count(georeferenced = TRUE)
```

```
[1] 3.55e+08
```


##### Records from Denmark


```r
occ_count(country = "DENMARK")
```

```
[1] 8628822
```


##### Records from France


```r
occ_count(hostCountry = "FRANCE")
```

```
[1] 17272175
```


##### Number of records in a particular dataset


```r
occ_count(datasetKey = "9e7ea106-0bf8-4087-bb61-dfe4f29e0f17")
```

```
[1] 4591
```


##### All records from 2012


```r
occ_count(year = 2012)
```

```
[1] 31483292
```


##### Records for a particular dataset, and only for preserved specimens


```r
occ_count(datasetKey = "8626bd3a-f762-11e1-a439-00145eb45e9a", basisOfRecord = "PRESERVED_SPECIMEN")
```

```
[1] 550849
```


********************

#### Get possible values to be used in taxonomic rank arguments in functions


```r
taxrank()
```

```
[1] "kingdom"       "phylum"        "class"         "order"        
[5] "family"        "genus"         "species"       "infraspecific"
```


********************

#### Search for taxon information

##### Search for a genus 


```r
name_lookup(query = "Cnaemidophorus", rank = "genus", return = "data")
```

```
         key  nubKey parentKey        parent  kingdom        phylum
1  116755723 1858636 110614854 Pterophoridae Animalia    Arthropoda
2    1858636 1858636      8863 Pterophoridae Animalia    Arthropoda
3  125802004 1858636 125793784 Pterophoridae     <NA>          <NA>
4  124531302 1858636        NA          <NA>     <NA>          <NA>
5  126862804 1858636 126783981 Pterophoridae Animalia    Arthropoda
6  115123697 1858636        NA          <NA>     <NA>          <NA>
7  121309232 1858636 124484006         :) ia    :) ia          <NA>
8  101053441 1858636 100725398 Pterophoridae Animalia    Arthropoda
9  107119486 1858636 107119872 Pterophoridae     <NA>          <NA>
10 107889106 1858636 107894685 Pterophoridae Animalia    Arthropoda
11 115090188 1858636 115103956 Pterophoridae Animalia    Arthropoda
12 103267214 1858636 103295754 Pterophorinae     <NA>          <NA>
13 107119489 6114874 107119872 Pterophoridae     <NA>          <NA>
14   6114874 6114874      8863 Pterophoridae Animalia    Arthropoda
15 107119488 4705260 107119872 Pterophoridae     <NA>          <NA>
16 102383618 3257276 100725398 Pterophoridae Animalia    Arthropoda
17 107119487 3257276 107119872 Pterophoridae     <NA>          <NA>
18   3257276 3257276      8863 Pterophoridae Animalia    Arthropoda
19 125802820 3002148 125806863      Rosaceae     <NA>          <NA>
20   3002148 3002148      5015      Rosaceae  Plantae Magnoliophyta
           clazz       order        family          genus kingdomKey
1        Insecta Lepidoptera Pterophoridae Cnaemidophorus  116630539
2        Insecta Lepidoptera Pterophoridae Cnaemidophorus          1
3        Insecta Lepidoptera Pterophoridae Cnaemidophorus         NA
4           <NA>        <NA>          <NA> Cnaemidophorus         NA
5        Insecta Lepidoptera Pterophoridae Cnaemidophorus  126774927
6           <NA>        <NA>          <NA> Cnaemidophorus         NA
7           <NA>        <NA>          <NA> Cnaemidophorus  124484006
8        Insecta Lepidoptera Pterophoridae Cnaemidophorus  101719444
9           <NA>        <NA> Pterophoridae Cnaemidophorus         NA
10       Insecta Lepidoptera Pterophoridae Cnaemidophorus  107895884
11       Insecta Lepidoptera Pterophoridae Cnaemidophorus  115107543
12          <NA>        <NA>          <NA> Cnaemidophorus         NA
13          <NA>        <NA> Pterophoridae Cnaemidophorus         NA
14       Insecta Lepidoptera Pterophoridae Cnaemidophorus          1
15          <NA>        <NA> Pterophoridae Cnaemidophorus         NA
16       Insecta Lepidoptera Pterophoridae Cnaemidophorus  101719444
17          <NA>        <NA> Pterophoridae Cnaemidophorus         NA
18       Insecta Lepidoptera Pterophoridae Cnaemidophorus          1
19          <NA>     Rosales      Rosaceae           Rosa         NA
20 Magnoliopsida     Rosales      Rosaceae           Rosa          6
   phylumKey  classKey  orderKey familyKey  genusKey   canonicalName
1  116762374 116686069 116843281 110614854 116755723  Cnaemidophorus
2         54       216       797      8863   1858636  Cnaemidophorus
3         NA 125831175 125810165 125793784 125802004  Cnaemidophorus
4         NA        NA        NA        NA 124531302  Cnaemidophorus
5  126774928 126775138 126775421 126783981 126862804  Cnaemidophorus
6         NA        NA        NA        NA 115123697  Cnaemidophorus
7         NA        NA        NA        NA 121309232  Cnaemidophorus
8  102545136 101674726 102306154 100725398 101053441  Cnaemidophorus
9         NA        NA        NA 107119872 107119486  Cnaemidophorus
10 107895861 107895809 107895457 107894685 107889106  Cnaemidophorus
11 115107571 115107384 115106690 115103956 115090188  Cnaemidophorus
12        NA        NA        NA        NA 103267214  Cnaemidophorus
13        NA        NA        NA 107119872 107119486 Euenemidophorus
14        54       216       797      8863   1858636 Euenemidophorus
15        NA        NA        NA 107119872 107119486 Eucnemidophorus
16 102545136 101674726 102306154 100725398 101053441   Cnemidophorus
17        NA        NA        NA 107119872 107119486   Cnemidophorus
18        54       216       797      8863   1858636   Cnemidophorus
19        NA        NA 125837937 125806863 125802820            Rosa
20        49       220       691      5015   3002148            Rosa
                authorship   nameType  rank numOccurrences
1         Wallengren, 1862 WELLFORMED GENUS              0
2         Wallengren, 1862 WELLFORMED GENUS              0
3         Wallengren, 1862 WELLFORMED GENUS              0
4                          WELLFORMED GENUS              0
5                          WELLFORMED GENUS              0
6                          WELLFORMED GENUS              0
7                          WELLFORMED GENUS              0
8         Wallengren, 1860 WELLFORMED GENUS              0
9         Wallengren, 1862 WELLFORMED GENUS              0
10        Wallengren, 1862 WELLFORMED GENUS              0
11        Wallengren, 1862 WELLFORMED GENUS              0
12        Wallengren, 1862 WELLFORMED GENUS              0
13 Pierce & Metcalfe, 1938 WELLFORMED GENUS              0
14 Pierce & Metcalfe, 1938 WELLFORMED GENUS              0
15        Wallengren, 1881 WELLFORMED GENUS              0
16            Zeller, 1867 WELLFORMED GENUS              0
17            Zeller, 1867 WELLFORMED GENUS              0
18            Zeller, 1867 WELLFORMED GENUS              0
19                      L. WELLFORMED GENUS              0
20                      L. WELLFORMED GENUS              0
```


##### Search for the class mammalia


```r
# Look up names like mammalia
name_lookup(class = "mammalia")
```

```
$meta
  offset limit endOfRecords    count
1      0    20        FALSE 20362854

$data
         key nubKey  kingdom kingdomKey      canonicalName
1          1      1 Animalia          1           Animalia
2  115219148     NA  Plantae  115219148            Plantae
3         54     54 Animalia          1         Arthropoda
4  101719444      1 Animalia  101719444           Animalia
5  126774927      1 Animalia  126774927           Animalia
6        216    216 Animalia          1            Insecta
7  124484006     NA    :) ia  124484006               <NA>
8  105901881     NA     <NA>         NA               <NA>
9  102545136     54 Animalia  101719444         Arthropoda
10 126774928     54 Animalia  126774927         Arthropoda
11         6      6  Plantae          6            Plantae
12 105961965     NA     <NA>         NA Cellular organisms
13 126775138    216 Animalia  126774927            Insecta
14        49     49  Plantae          6      Magnoliophyta
15 101674726    216 Animalia  101719444            Insecta
16       220    220  Plantae          6      Magnoliopsida
17 106094935     NA     <NA>         NA          Eukaryota
18 106147866     NA     <NA>         NA       Opisthokonta
19 106148414     NA  Metazoa  106148414            Metazoa
20 106404692     NA  Metazoa  106148414          Eumetazoa
                                   authorship   nameType     rank
1                                             WELLFORMED  KINGDOM
2                                             WELLFORMED  KINGDOM
3                                             WELLFORMED   PHYLUM
4                                             WELLFORMED  KINGDOM
5                                             WELLFORMED  KINGDOM
6                                             WELLFORMED    CLASS
7                                                SCINAME  KINGDOM
8                                                SCINAME UNRANKED
9                                             WELLFORMED   PHYLUM
10                                            WELLFORMED   PHYLUM
11                                            WELLFORMED  KINGDOM
12                                               SCINAME UNRANKED
13                                            WELLFORMED    CLASS
14 Cronquist, Takhtajan & W. Zimmermann, 1966 WELLFORMED   PHYLUM
15                                            WELLFORMED    CLASS
16                                            WELLFORMED    CLASS
17                                            WELLFORMED   DOMAIN
18                                            WELLFORMED UNRANKED
19                                            WELLFORMED  KINGDOM
20                                            WELLFORMED UNRANKED
   numOccurrences parentKey             parent        phylum phylumKey
1               0        NA               <NA>          <NA>        NA
2               0        NA               <NA>          <NA>        NA
3               0         1           Animalia    Arthropoda        54
4               0        NA               <NA>          <NA>        NA
5               0        NA               <NA>          <NA>        NA
6               0        54         Arthropoda    Arthropoda        54
7               0        NA               <NA>          <NA>        NA
8               0        NA               <NA>          <NA>        NA
9               0 101719444           Animalia    Arthropoda 102545136
10              0 126774927           Animalia    Arthropoda 126774928
11              0        NA               <NA>          <NA>        NA
12              0 105901881               root          <NA>        NA
13              0 126774928         Arthropoda    Arthropoda 126774928
14              0         6            Plantae Magnoliophyta        49
15              0 102545136         Arthropoda    Arthropoda 102545136
16              0        49      Magnoliophyta Magnoliophyta        49
17              0 105961965 Cellular organisms          <NA>        NA
18              0 106094935          Eukaryota          <NA>        NA
19              0 106147866       Opisthokonta          <NA>        NA
20              0 106148414            Metazoa          <NA>        NA
           clazz  classKey
1           <NA>        NA
2           <NA>        NA
3           <NA>        NA
4           <NA>        NA
5           <NA>        NA
6        Insecta       216
7           <NA>        NA
8           <NA>        NA
9           <NA>        NA
10          <NA>        NA
11          <NA>        NA
12          <NA>        NA
13       Insecta 126775138
14          <NA>        NA
15       Insecta 101674726
16 Magnoliopsida       220
17          <NA>        NA
18          <NA>        NA
19          <NA>        NA
20          <NA>        NA
```


##### Look up the species Helianthus annuus


```r
name_lookup("Helianthus annuus", rank = "species")
```

```
$meta
  offset limit endOfRecords count
1      0    20        FALSE    69

$data
         key  nubKey parentKey                    parent       kingdom
1  116845199 3119195 116853573                Helianthus       Plantae
2    3119195 3119195   3119134                Helianthus       Plantae
3  125790787 3119195 125809269                Helianthus          <NA>
4  106239436 3119195 106239325                Helianthus Viridiplantae
5  121635316 3119195 124573711                Helianthus          <NA>
6  111449704 3119195 111449703                Helianthus       Plantae
7  108157198      NA 108086589                Asteraceae       Plantae
8  108157199      NA 108086589                Asteraceae       Plantae
9  108157200      NA 108086589                Asteraceae       Plantae
10 115043868 3119195 115091988                Helianthus       Plantae
11 107290518      NA 107290513                Helianthus       Plantae
12 107001935      NA 107105089                Helianthus       Plantae
13 117214133 3119195 117208777                     Virus         Virus
14 117075019 3119195 117061550                Helianthus       Plantae
15 110853779 3119195 116128567                Helianthus       Plantae
16 125879180 3119195 126824197                Helianthus       Plantae
17 124780276 3119195 124852643                Helianthus       Plantae
18 100837541 3119195 102425010                Helianthus       Plantae
19 100019171 3119195 100009008                Helianthus          <NA>
20 125587214 3119195 106573315 unclassified phytoplasmas          <NA>
               order             family      genus kingdomKey  orderKey
1          Asterales         Asteraceae Helianthus  116668764 110610447
2          Asterales         Asteraceae Helianthus          6       414
3          Asterales         Asteraceae Helianthus         NA 125833882
4          Asterales         Asteraceae Helianthus  106147210 106237428
5               <NA>               <NA> Helianthus         NA        NA
6               <NA>         Compositae Helianthus  111449174        NA
7               <NA>         Asteraceae       <NA>  115219148        NA
8               <NA>         Asteraceae       <NA>  115219148        NA
9               <NA>         Asteraceae       <NA>  115219148        NA
10         Asterales         Asteraceae Helianthus  115107585 115106969
11         Asterales         Asteraceae Helianthus  107264512 107289189
12              <NA>         Asteraceae Helianthus  124856107        NA
13              <NA>               <NA>       <NA>  117208777        NA
14         Asterales         Compositae Helianthus  117067772 117058422
15         Asterales         Compositae Helianthus  116127234 116128510
16         Asterales         Asteraceae Helianthus  126775066 126779356
17         Asterales         Compositae Helianthus  124850847 124852488
18         Asterales         Asteraceae Helianthus  102545045 100614495
19         Asterales         Asteraceae Helianthus         NA 100023079
20 Acholeplasmatales Acholeplasmataceae Candidatus         NA 106013100
   familyKey  genusKey     canonicalName authorship   nameType    rank
1  116856030 116853573 Helianthus annuus         L. WELLFORMED SPECIES
2       3065   3119134 Helianthus annuus         L. WELLFORMED SPECIES
3  125799038 125809269 Helianthus annuus         L. WELLFORMED SPECIES
4  106237535 106239325 Helianthus annuus            WELLFORMED SPECIES
5         NA 124573711 Helianthus annuus            WELLFORMED SPECIES
6  111442813 111449703 Helianthus annuus         L. WELLFORMED SPECIES
7  108086589        NA Helianthus annuus         L. WELLFORMED SPECIES
8  108086589        NA Helianthus annuus         L. WELLFORMED SPECIES
9  108086589        NA Helianthus annuus         L. WELLFORMED SPECIES
10 115105473 115091988 Helianthus annuus         L. WELLFORMED SPECIES
11 107289191 107290513 Helianthus annuus         L. WELLFORMED SPECIES
12 107079268 107105089 Helianthus annuus         L. WELLFORMED SPECIES
13        NA        NA Helianthus annuus         L. WELLFORMED SPECIES
14 117068545 117061550 Helianthus annuus         L. WELLFORMED SPECIES
15 116128511 116128567 Helianthus annuus         L. WELLFORMED SPECIES
16 126781795 126824197 Helianthus annuus         L. WELLFORMED SPECIES
17 124852489 124852643 Helianthus annuus         L. WELLFORMED SPECIES
18 102234418 102425010 Helianthus annuus   Linnaeus WELLFORMED SPECIES
19 100025154 100009008 Helianthus annuus   Linnaeus WELLFORMED SPECIES
20 106039581 106155719 Helianthus annuus               SCINAME SPECIES
   numOccurrences        phylum         clazz phylumKey  classKey
1               0          <NA>          <NA>        NA        NA
2               0 Magnoliophyta Magnoliopsida        49       220
3               0          <NA>          <NA>        NA        NA
4               0  Streptophyta          <NA> 106171079        NA
5               0          <NA>          <NA>        NA        NA
6               0 Spermatophyta Dicotyledones 111449175 111449177
7               0          <NA>          <NA>        NA        NA
8               0          <NA>          <NA>        NA        NA
9               0          <NA>          <NA>        NA        NA
10              0 Magnoliophyta Magnoliopsida 115107589 115107444
11              0 Magnoliophyta Magnoliopsida 107240291 107240313
12              0          <NA>          <NA>        NA        NA
13              0          <NA>          <NA>        NA        NA
14              0 Spermatophyta Magnoliopsida 117080124 117074792
15              0 Magnoliophyta Magnoliopsida 116127951 116128467
16              0  Tracheophyta Magnoliopsida 126775067 126775068
17              0  Tracheophyta Magnoliopsida 124851364 124852364
18              0 Magnoliophyta Magnoliopsida 102545123 101741810
19              0          <NA> Equisetopsida        NA 100023390
20              0   Tenericutes    Mollicutes 106355900 106136190
```


********************

#### Get data for a single occurrence. Note that data is returned as a list, with slots for metadata and data, or as a hierarchy, or just data.

##### Just data 


```r
occ_get(key = 773433533, return = "data")
```

```
                  name longitude latitude
1 Helianthus annuus L.      -117    32.85
```


##### Just taxonomic hierarchy


```r
occ_get(key = 773433533, return = "hier")
```

```
                  name     key    rank
1              Plantae       6 kingdom
2        Magnoliophyta      49  phylum
3        Magnoliopsida     220   clazz
4            Asterales     414   order
5           Asteraceae    3065  family
6           Helianthus 3119134   genus
7 Helianthus annuus L. 3119195 species
```


##### All data, or leave return parameter blank


```r
occ_get(key = 773433533, return = "all")
```

```
$hierarch
                  name     key    rank
1              Plantae       6 kingdom
2        Magnoliophyta      49  phylum
3        Magnoliopsida     220   clazz
4            Asterales     414   order
5           Asteraceae    3065  family
6           Helianthus 3119134   genus
7 Helianthus annuus L. 3119195 species

$data
                  name longitude latitude
1 Helianthus annuus L.      -117    32.85
```


##### Get many occurrences. `occ_get` is vectorized


```r
occ_get(key = c(773433533, 101010, 240713150, 855998194, 49819470), return = "data")
```

```
                                   name longitude latitude
1                  Helianthus annuus L.   -117.00    32.85
2  Platydoras costatus (Linnaeus, 1758)    -70.07    -4.35
3                              Pelosina    163.58   -77.57
4       Sciurus vulgaris Linnaeus, 1758     12.04    58.41
5 Phlogophora meticulosa Linnaeus, 1758     13.28    55.72
```


********************

#### Maps

Make a map of **Puma concolor** occurrences


```r
key <- gbif_lookup(name = "Puma concolor", kingdom = "plants")$speciesKey
dat <- occ_search(taxonKey = key, return = "data", limit = 300, minimal = FALSE)
gbifmap(input = dat)
```

![plot of chunk gbifmap1](figure/gbifmap1.png) 


[gbifapi]: http://data.gbif.org/tutorial/services
