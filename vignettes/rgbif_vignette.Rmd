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
#> [1] 48001480
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 3465
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 652903162
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 11312029
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 40925784
```

Records for a particular dataset, and only for preserved specimens


```r
occ_count(datasetKey='e707e6da-e143-445d-b41d-529c4a777e8b', basisOfRecord='OBSERVATION')
#> [1] 2563453
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
#> # A tibble: 1 × 4
#>   offset limit endOfRecords count
#>    <int> <int>        <lgl> <int>
#> 1      0   100        FALSE  1795
```


```r
head(out$data)
#> # A tibble: 6 × 26
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 114079693       Mammalia bd0a2b6d-69d1-4650-8bb1-829c8f92035f    359
#> 2 123227024       Mammalia 90d9e8a6-0ce1-472d-b682-3451095dbc5a    359
#> 3 127687936       Mammalia 11f5ca15-8de9-4499-9fd2-368b62ea45cb    359
#> 4 127804685       Mammalia d573804a-0521-41c4-9a8d-ffa2b807a1c6    359
#> 5 127805888       Mammalia 6fa16a5a-560e-432f-ad9e-f93e8bd3e90d    359
#> 6 127820433       Mammalia 3385d731-b373-4d9b-a167-633902b43069    359
#> # ... with 22 more variables: parentKey <int>, parent <chr>,
#> #   canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   numDescendants <int>, numOccurrences <int>, habitats <lgl>,
#> #   nomenclaturalStatus <lgl>, threatStatuses <lgl>, synonym <lgl>,
#> #   kingdom <chr>, phylum <chr>, kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, taxonomicStatus <chr>, rank <chr>, class <chr>,
#> #   extinct <lgl>, order <chr>, orderKey <int>
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`114079693`
#>     rankkey     name
#> 1 114079410 Animalia
#> 
#> $`123227024`
#>     rankkey          name
#> 1 123221530 Gnathostomata
```


```r
out$names[2]
#> $`100375341`
#>   vernacularName language
#> 1     Säugetiere      deu
#> 2    Triconodont      cat
#> 3   Triconodonta      ces
#> 4   Triconodonta      nld
#> 5   Triconodonta      por
#> 6   Trykonodonty      pol
#> 7   Триконодонты      rus
```

Search for a genus


```r
head(name_lookup(query='Cnaemidophorus', rank="genus", return="data"))
#> # A tibble: 6 × 33
#>         key scientificName                           datasetKey  nubKey
#>       <int>          <chr>                                <chr>   <int>
#> 1 128171003 Cnaemidophorus 4cec8fef-f129-4966-89b7-4f8439aba058 1858636
#> 2 125933331 Cnaemidophorus de8934f4-a136-481c-a87a-b0b202b80a31 1858636
#> 3 128091787 Cnaemidophorus 4dd32523-a3a3-43b7-84df-4cda02f15cf7 1858636
#> 4 123576977 Cnaemidophorus fab88965-e69d-4491-a04d-e3198b626e52 1858636
#> 5 123625903 Cnaemidophorus 7ddf754f-d193-4cc9-b351-99906754a03b 1858636
#> 6 115196907 Cnaemidophorus 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 1858636
#> # ... with 29 more variables: parentKey <int>, parent <chr>, phylum <chr>,
#> #   order <chr>, family <chr>, genus <chr>, phylumKey <int>,
#> #   classKey <int>, orderKey <int>, familyKey <int>, genusKey <int>,
#> #   canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <lgl>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>, kingdom <chr>,
#> #   kingdomKey <int>, publishedIn <chr>, accordingTo <chr>, extinct <lgl>,
#> #   constituentKey <chr>
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#> # A tibble: 6 × 26
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 114079693       Mammalia bd0a2b6d-69d1-4650-8bb1-829c8f92035f    359
#> 2 123227024       Mammalia 90d9e8a6-0ce1-472d-b682-3451095dbc5a    359
#> 3 127687936       Mammalia 11f5ca15-8de9-4499-9fd2-368b62ea45cb    359
#> 4 127804685       Mammalia d573804a-0521-41c4-9a8d-ffa2b807a1c6    359
#> 5 127805888       Mammalia 6fa16a5a-560e-432f-ad9e-f93e8bd3e90d    359
#> 6 127820433       Mammalia 3385d731-b373-4d9b-a167-633902b43069    359
#> # ... with 22 more variables: parentKey <int>, parent <chr>,
#> #   canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   numDescendants <int>, numOccurrences <int>, habitats <lgl>,
#> #   nomenclaturalStatus <lgl>, threatStatuses <lgl>, synonym <lgl>,
#> #   kingdom <chr>, phylum <chr>, kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, taxonomicStatus <chr>, rank <chr>, class <chr>,
#> #   extinct <lgl>, order <chr>, orderKey <int>
```

Look up the species Helianthus annuus


```r
head(name_lookup(query = 'Helianthus annuus', rank="species", return = 'data'))
#> # A tibble: 6 × 39
#>         key       scientificName                           datasetKey
#>       <int>                <chr>                                <chr>
#> 1 103340289    Helianthus annuus fab88965-e69d-4491-a04d-e3198b626e52
#> 2 127670355    Helianthus annuus 41c06f1a-23da-4445-b859-ec3a8a03b0e2
#> 3   3119195    Helianthus annuus d7dddbf4-2cf0-4f39-9b2a-bb099caae36c
#> 4 114910965    Helianthus annuus ee2aac07-de9a-47a2-b828-37430d537633
#> 5 127670357    Helianthus annuus 41c06f1a-23da-4445-b859-ec3a8a03b0e2
#> 6 101321447 Helianthus annuus L. 66dd0960-2d7d-46ee-a491-87b9adcfe7b1
#> # ... with 36 more variables: parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, order <chr>, family <chr>, genus <chr>,
#> #   species <chr>, kingdomKey <int>, phylumKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <chr>,
#> #   threatStatuses <lgl>, synonym <lgl>, nubKey <int>,
#> #   constituentKey <chr>, classKey <int>, publishedIn <chr>,
#> #   extinct <lgl>, class <chr>, acceptedKey <int>, accepted <chr>,
#> #   accordingTo <chr>, basionymKey <int>, basionym <chr>
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
library("plyr")
out <- name_usage(key=3119195, language="FRENCH", data='vernacularNames')
head(out$data)
#> # A tibble: 6 × 5
#>     vernacularName language                                         source
#>              <chr>    <chr>                                          <chr>
#> 1 common sunflower      eng Database of Vascular Plants of Canada (VASCAN)
#> 2        tournesol      fra Database of Vascular Plants of Canada (VASCAN)
#> 3 garden sunflower      eng Database of Vascular Plants of Canada (VASCAN)
#> 4     grand soleil      fra Database of Vascular Plants of Canada (VASCAN)
#> 5 hélianthe annuel      fra Database of Vascular Plants of Canada (VASCAN)
#> 6           soleil      fra Database of Vascular Plants of Canada (VASCAN)
#> # ... with 2 more variables: sourceTaxonKey <int>, preferred <lgl>
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
#> [1] "Tracheophyta"
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
#> [1] 7707728
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
#> # A tibble: 6 × 3
#>       key               canonicalName       rank
#>     <int>                       <chr>      <chr>
#> 1 2435099               Puma concolor    SPECIES
#> 2 8836300      Puma concolor discolor SUBSPECIES
#> 3 7193927      Puma concolor concolor SUBSPECIES
#> 4 6164624 Puma concolor costaricensis SUBSPECIES
#> 5 6164590       Puma concolor couguar SUBSPECIES
#> 6 6164623      Puma concolor cabrerae SUBSPECIES
```


## Single occurrence records

Get data for a single occurrence. Note that data is returned as a list, with slots for metadata and data, or as a hierarchy, or just data.

Just data


```r
occ_get(key=766766824, return='data')
#>               name       key decimalLatitude decimalLongitude
#> 1 Coloeus monedula 766766824         59.4568          17.9054
#>          issues
#> 1 depunl,gass84
```

Just taxonomic hierarchy


```r
occ_get(key=766766824, return='hier')
#>               name     key    rank
#> 1         Animalia       1 kingdom
#> 2         Chordata      44  phylum
#> 3             Aves     212   class
#> 4    Passeriformes     729   order
#> 5         Corvidae    5235  family
#> 6          Coloeus 4852454   genus
#> 7 Coloeus monedula 6100954 species
```

All data, or leave return parameter blank


```r
occ_get(key=766766824, return='all')
#> $hierarchy
#>               name     key    rank
#> 1         Animalia       1 kingdom
#> 2         Chordata      44  phylum
#> 3             Aves     212   class
#> 4    Passeriformes     729   order
#> 5         Corvidae    5235  family
#> 6          Coloeus 4852454   genus
#> 7 Coloeus monedula 6100954 species
#> 
#> $media
#> list()
#> 
#> $data
#>               name       key decimalLatitude decimalLongitude
#> 1 Coloeus monedula 766766824         59.4568          17.9054
#>          issues
#> 1 depunl,gass84
```

Get many occurrences. `occ_get` is vectorized


```r
occ_get(key=c(766766824, 101010, 240713150, 855998194), return='data')
#>                   name       key decimalLatitude decimalLongitude
#> 1     Coloeus monedula 766766824         59.4568          17.9054
#> 2 Platydoras armatulus    101010              NA               NA
#> 3             Pelosina 240713150        -77.5667         163.5830
#> 4     Sciurus vulgaris 855998194         58.4068          12.0438
#>               issues
#> 1      depunl,gass84
#> 2                   
#> 3 bri,cdround,gass84
#> 4      depunl,gass84
```


## Search for occurrences

By default `occ_search()` returns a `dplyr` like output summary in which the data printed expands based on how much data is returned, and the size of your window. You can search by scientific name:


```r
occ_search(scientificName = "Ursus americanus", limit = 20)
#> Records found [8707] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [5] 
#> No. facets [0] 
#> Args [limit=20, offset=0, scientificName=Ursus americanus, fields=all] 
#> # A tibble: 20 × 68
#>                name        key decimalLatitude decimalLongitude
#>               <chr>      <int>           <dbl>            <dbl>
#> 1  Ursus americanus 1453325042        37.36325        -80.52914
#> 2  Ursus americanus 1453341157        35.44519        -83.75077
#> 3  Ursus americanus 1453341156        35.43836        -83.66423
#> 4  Ursus americanus 1453427952        35.61469        -82.47723
#> 5  Ursus americanus 1453414927        47.90953        -91.95893
#> 6  Ursus americanus 1453456338        25.30959       -100.96966
#> 7  Ursus americanus 1453445710        35.59506        -82.55149
#> 8  Ursus americanus 1453476835        29.24034       -103.30502
#> 9  Ursus americanus 1453456359        25.31110       -100.96992
#> 10 Ursus americanus 1453520782        29.28037       -103.30340
#> 11 Ursus americanus 1455592330        46.34195        -83.98219
#> 12 Ursus americanus 1453471882        43.85200        -72.41200
#> 13 Ursus americanus 1453476285        35.94219        -76.57357
#> 14 Ursus americanus 1453181964        41.79962       -124.14862
#> 15 Ursus americanus 1229610234        44.06062        -71.92692
#> 16 Ursus americanus 1229610216        44.06086        -71.92712
#> 17 Ursus americanus 1253300445        44.65481        -72.67270
#> 18 Ursus americanus 1249277297        35.76789        -75.80894
#> 19 Ursus americanus 1453074812              NA               NA
#> 20 Ursus americanus 1453181995        41.76532       -124.10842
#> # ... with 64 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   dateIdentified <chr>, coordinateUncertaintyInMeters <dbl>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, references <chr>, license <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, rightsHolder <chr>,
#> #   identifier <chr>, verbatimEventDate <chr>, datasetName <chr>,
#> #   collectionCode <chr>, gbifID <chr>, verbatimLocality <chr>,
#> #   occurrenceID <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   institutionCode <chr>, rights <chr>, eventTime <chr>,
#> #   occurrenceRemarks <chr>, identificationID <chr>,
#> #   infraspecificEpithet <chr>, informationWithheld <chr>
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [14820] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [1] 
#> No. facets [0] 
#> Args [limit=20, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 20 × 77
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1437798345        51.03513         4.518690
#> 2  Helianthus annuus 1437786250        50.91574         3.579770
#> 3  Helianthus annuus 1454554504        50.22000         9.630000
#> 4  Helianthus annuus 1273001624        59.32739        10.803912
#> 5  Helianthus annuus 1454554470        49.32000        12.000000
#> 6  Helianthus annuus 1272997264        58.66189         6.721671
#> 7  Helianthus annuus 1454553080        49.75000         9.300000
#> 8  Helianthus annuus 1272995969        59.83241        10.763219
#> 9  Helianthus annuus 1454553865              NA               NA
#> 10 Helianthus annuus 1454555306        48.21000        12.080000
#> 11 Helianthus annuus 1323229476        59.08521        11.036315
#> 12 Helianthus annuus 1454553832        48.42000        10.620000
#> 13 Helianthus annuus 1323241585        59.57240        10.847597
#> 14 Helianthus annuus 1273024475        59.08521        11.036315
#> 15 Helianthus annuus 1454554421        49.31000        12.360000
#> 16 Helianthus annuus 1454554404        49.35000        12.440000
#> 17 Helianthus annuus 1323261789        58.66189         6.721671
#> 18 Helianthus annuus 1305561325        48.57490         7.759700
#> 19 Helianthus annuus 1454554608        49.21000        12.350000
#> 20 Helianthus annuus 1454554593        49.34000        12.530000
#> # ... with 73 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, continent <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, identifier <chr>, verbatimEventDate <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>,
#> #   verbatimCoordinateSystem <chr>, datasetName <chr>, language <chr>,
#> #   gbifID <chr>, occurrenceID <chr>, type <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, institutionCode <chr>, ownerInstitutionCode <chr>,
#> #   datasetID <chr>, accessRights <chr>, bibliographicCitation <chr>,
#> #   locality <chr>, collectionCode <chr>, individualCount <int>,
#> #   elevation <dbl>, elevationAccuracy <dbl>, stateProvince <chr>,
#> #   municipality <chr>, county <chr>, coordinatePrecision <dbl>,
#> #   habitat <chr>, dateIdentified <chr>, identifiedBy <chr>
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#> # A tibble: 1 × 4
#>   offset limit endOfRecords count
#> *  <int> <int>        <lgl> <int>
#> 1    300   200        FALSE 14820
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [8707] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [5] 
#> No. facets [0] 
#> Args [limit=20, offset=0, scientificName=Ursus americanus,
#>      fields=name,basisOfRecord,protocol] 
#> # A tibble: 20 × 3
#>                name    protocol     basisOfRecord
#>               <chr>       <chr>             <chr>
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
#> 11 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 12 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 13 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 14 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 15 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 16 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 17 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 18 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 19 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#> 20 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
```

Most parameters are vectorized, so you can pass in more than one value:


```r
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5)
#> Occ. found [2482598 (577582), 2492010 (3060247), 2498387 (974005)] 
#> Occ. returned [2482598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2482598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2482598 (1), 2492010 (1), 2498387 (1)] 
#> No. facets [2482598 (0), 2492010 (0), 2498387 (0)] 
#> Args [limit=5, offset=0, taxonKey=2482598,2492010,2498387, fields=all] 
#> 3 requests; First 10 rows of data from 2482598
#> 
#> # A tibble: 5 × 66
#>                  name        key decimalLatitude decimalLongitude
#>                 <chr>      <int>           <dbl>            <dbl>
#> 1 Cyanocitta stelleri 1453335137        45.53538        -122.7850
#> 2 Cyanocitta stelleri 1453386383        48.16790        -122.0787
#> 3 Cyanocitta stelleri 1453369911        38.61128        -122.7838
#> 4 Cyanocitta stelleri 1453339220        47.65927        -122.0961
#> 5 Cyanocitta stelleri 1453338402        45.50661        -122.7135
#> # ... with 62 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   dateIdentified <chr>, coordinateUncertaintyInMeters <dbl>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, references <chr>, license <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, rightsHolder <chr>,
#> #   identifier <chr>, informationWithheld <chr>, verbatimEventDate <chr>,
#> #   datasetName <chr>, collectionCode <chr>, gbifID <chr>,
#> #   verbatimLocality <chr>, occurrenceID <chr>, taxonID <chr>,
#> #   catalogNumber <chr>, recordedBy <chr>,
#> #   http...unknown.org.occurrenceDetails <chr>, institutionCode <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>
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

[gbifapi]: http://www.gbif.org/developer/summary
