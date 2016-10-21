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
#> [1] 87413102
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 2852
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 575185262
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 10280278
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 39044249
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
#> Source: local data frame [1 x 4]
#> 
#>   offset limit endOfRecords  count
#>    <int> <int>        <lgl>  <int>
#> 1      0   100        FALSE 153739
```


```r
head(out$data)
#> Source: local data frame [6 x 30]
#> 
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 120818499       Mammalia 64fa10f0-ca43-4f53-aa88-621ec9ea2b50    359
#> 2 120825138       Mammalia 1ddab917-15d1-4d69-a455-5bd397af5a9c    359
#> 3 120821803       Mammalia f6b35f74-08c3-43a2-a4b6-53b6fe1c0cf6    359
#> 4 120823251       Mammalia 7b3f4866-9369-45a9-b2a8-bcd0b144d500    359
#> 5 120674802       Mammalia dbfacc33-350a-4620-976f-4d3a441aa242    359
#> 6 121062106       Mammalia bc1a1eb3-243d-4e87-b9fa-d35fe0800230    359
#> Variables not shown: parentKey <int>, parent <chr>, kingdom <chr>, phylum
#>   <chr>, kingdomKey <int>, phylumKey <int>, classKey <int>, canonicalName
#>   <chr>, taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#>   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <lgl>,
#>   threatStatuses <lgl>, synonym <lgl>, class <chr>, nameType <chr>,
#>   taxonID <chr>, authorship <chr>, publishedIn <chr>, order <chr>, family
#>   <chr>, orderKey <int>, familyKey <int>, extinct <lgl>.
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`120818499`
#>     rankkey     name
#> 1 120818320 Animalia
#> 2 120818322 Chordata
#> 
#> $`120825138`
#>     rankkey     name
#> 1 120825136 Animalia
#> 2 120825137 Chordata
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
#> Source: local data frame [6 x 35]
#> 
#>         key                  scientificName
#>       <int>                           <chr>
#> 1   1858636 Cnaemidophorus Wallengren, 1862
#> 2 113100610 Cnaemidophorus Wallengren, 1862
#> 3 100555508 Cnaemidophorus Wallengren, 1862
#> 4 120772811                  Cnaemidophorus
#> 5 120903940                  Cnaemidophorus
#> 6 115196907                  Cnaemidophorus
#> Variables not shown: datasetKey <chr>, nubKey <int>, parentKey <int>,
#>   parent <chr>, kingdom <chr>, phylum <chr>, order <chr>, family <chr>,
#>   genus <chr>, kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey
#>   <int>, familyKey <int>, genusKey <int>, canonicalName <chr>, authorship
#>   <chr>, nameType <chr>, taxonomicStatus <chr>, rank <chr>, numDescendants
#>   <int>, numOccurrences <int>, extinct <lgl>, habitats <lgl>,
#>   nomenclaturalStatus <chr>, threatStatuses <lgl>, synonym <lgl>, class
#>   <chr>, taxonID <chr>, publishedIn <chr>, accordingTo <chr>, acceptedKey
#>   <int>, accepted <chr>.
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#> Source: local data frame [6 x 30]
#> 
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 120818499       Mammalia 64fa10f0-ca43-4f53-aa88-621ec9ea2b50    359
#> 2 120825138       Mammalia 1ddab917-15d1-4d69-a455-5bd397af5a9c    359
#> 3 120821803       Mammalia f6b35f74-08c3-43a2-a4b6-53b6fe1c0cf6    359
#> 4 120823251       Mammalia 7b3f4866-9369-45a9-b2a8-bcd0b144d500    359
#> 5 120674802       Mammalia dbfacc33-350a-4620-976f-4d3a441aa242    359
#> 6 121062106       Mammalia bc1a1eb3-243d-4e87-b9fa-d35fe0800230    359
#> Variables not shown: parentKey <int>, parent <chr>, kingdom <chr>, phylum
#>   <chr>, kingdomKey <int>, phylumKey <int>, classKey <int>, canonicalName
#>   <chr>, taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#>   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <lgl>,
#>   threatStatuses <lgl>, synonym <lgl>, class <chr>, nameType <chr>,
#>   taxonID <chr>, authorship <chr>, publishedIn <chr>, order <chr>, family
#>   <chr>, orderKey <int>, familyKey <int>, extinct <lgl>.
```

Look up the species Helianthus annuus


```r
head(name_lookup(query = 'Helianthus annuus', rank="species", return = 'data'))
#> Source: local data frame [6 x 39]
#> 
#>         key       scientificName                           datasetKey
#>       <int>                <chr>                                <chr>
#> 1 100336353 Helianthus annuus L. 16c3f9cb-4b19-4553-ac8e-ebb90003aa02
#> 2   3119195 Helianthus annuus L. d7dddbf4-2cf0-4f39-9b2a-bb099caae36c
#> 3 113584542 Helianthus annuus L. cbb6498e-8927-405a-916b-576d00a6289b
#> 4 103340289    Helianthus annuus fab88965-e69d-4491-a04d-e3198b626e52
#> 5 114910965    Helianthus annuus ee2aac07-de9a-47a2-b828-37430d537633
#> 6 115006874 Helianthus annuus L. b4af7484-5acd-4804-8211-d738f13832c7
#> Variables not shown: nubKey <int>, parentKey <int>, parent <chr>, kingdom
#>   <chr>, order <chr>, family <chr>, genus <chr>, species <chr>, kingdomKey
#>   <int>, classKey <int>, orderKey <int>, familyKey <int>, genusKey <int>,
#>   speciesKey <int>, canonicalName <chr>, authorship <chr>, nameType <chr>,
#>   rank <chr>, numDescendants <int>, numOccurrences <int>, habitats <chr>,
#>   nomenclaturalStatus <chr>, threatStatuses <lgl>, synonym <lgl>, class
#>   <chr>, basionymKey <int>, basionym <chr>, phylum <chr>, phylumKey <int>,
#>   taxonomicStatus <chr>, extinct <lgl>, taxonID <chr>, accordingTo <chr>,
#>   publishedIn <chr>, acceptedKey <int>, accepted <chr>.
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
library("plyr")
out <- name_usage(key=3119195, language="FRENCH", data='vernacularNames')
head(out$data)
#> Source: local data frame [6 x 6]
#> 
#>            vernacularName language country sourceTaxonKey
#>                     <chr>    <chr>   <chr>          <int>
#> 1 Gewöhnliche Sonnenblume      deu      DE      116782143
#> 2             Sonnenblume      deu      NA      101321447
#> 3                 alizeti      swa      NA      101321447
#> 4        annual sunflower      eng      NA      102234356
#> 5        common sunflower      eng      NA      102234356
#> 6                 girasol      spa      NA      101321447
#> Variables not shown: source <chr>, preferred <lgl>.
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
#> Source: local data frame [6 x 3]
#> 
#>       key             canonicalName       rank
#>     <int>                     <chr>      <chr>
#> 1 6164620      Puma concolor cougar SUBSPECIES
#> 2 6164600       Puma concolor coryi SUBSPECIES
#> 3 6164604  Puma concolor stanleyana SUBSPECIES
#> 4 6164610 Puma concolor hippolestes SUBSPECIES
#> 5 6164622        Puma concolor puma SUBSPECIES
#> 6 7193927    Puma concolor concolor SUBSPECIES
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
#>           issues
#> 1  depunl,gass84
#> 2               
#> 3 cdround,gass84
#> 4  depunl,gass84
```


## Search for occurrences

By default `occ_search()` returns a `dplyr` like output summary in which the data printed expands based on how much data is returned, and the size of your window. You can search by scientific name:


```r
occ_search(scientificName = "Ursus americanus", limit = 20)
#> Records found [7919] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [19] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0, fields=all] 
#> Source: local data frame [20 x 66]
#> 
#>                name        key decimalLatitude decimalLongitude
#>               <chr>      <int>           <dbl>            <dbl>
#> 1  Ursus americanus 1253300445        44.65481        -72.67270
#> 2  Ursus americanus 1229610216        44.06086        -71.92712
#> 3  Ursus americanus 1249277297        35.76789        -75.80894
#> 4  Ursus americanus 1229610234        44.06062        -71.92692
#> 5  Ursus americanus 1249296297        39.08590       -105.24586
#> 6  Ursus americanus 1272078411        44.41793        -72.70709
#> 7  Ursus americanus 1253314877        49.25782       -122.82786
#> 8  Ursus americanus 1249284297        43.68723        -72.32891
#> 9  Ursus americanus 1257415362        44.32746        -72.41007
#> 10 Ursus americanus 1262389246        43.80871        -72.20964
#> 11 Ursus americanus 1253317181        43.64214        -72.52494
#> 12 Ursus americanus 1265898376        31.42900       -110.41299
#> 13 Ursus americanus 1269542933        37.40447        -79.97860
#> 14 Ursus americanus 1265904845        43.98639        -72.06242
#> 15 Ursus americanus 1265598200        44.34088        -72.46131
#> 16 Ursus americanus 1265898355        31.44575       -110.38744
#> 17 Ursus americanus 1269542955        37.45911        -80.55145
#> 18 Ursus americanus 1265570591        34.15615       -117.97805
#> 19 Ursus americanus 1269542930        37.35996        -79.87252
#> 20 Ursus americanus 1265601519        35.66365        -83.70645
#> Variables not shown: issues <chr>, datasetKey <chr>, publishingOrgKey
#>   <chr>, publishingCountry <chr>, protocol <chr>, lastCrawled <chr>,
#>   lastParsed <chr>, extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#>   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#>   familyKey <int>, genusKey <int>, speciesKey <int>, scientificName <chr>,
#>   kingdom <chr>, phylum <chr>, order <chr>, family <chr>, genus <chr>,
#>   species <chr>, genericName <chr>, specificEpithet <chr>, taxonRank
#>   <chr>, dateIdentified <chr>, year <int>, month <int>, day <int>,
#>   eventDate <chr>, modified <chr>, lastInterpreted <chr>, references
#>   <chr>, identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum
#>   <chr>, class <chr>, countryCode <chr>, country <chr>, rightsHolder
#>   <chr>, identifier <chr>, verbatimEventDate <chr>, datasetName <chr>,
#>   gbifID <chr>, verbatimLocality <chr>, collectionCode <chr>, occurrenceID
#>   <chr>, taxonID <chr>, license <chr>, catalogNumber <chr>, recordedBy
#>   <chr>, http...unknown.org.occurrenceDetails <chr>, institutionCode
#>   <chr>, rights <chr>, eventTime <chr>, occurrenceRemarks <chr>,
#>   identificationID <chr>, infraspecificEpithet <chr>,
#>   coordinateUncertaintyInMeters <dbl>.
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [31357] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [13] 
#> Args [taxonKey=3119195, limit=20, offset=0, fields=all] 
#> Source: local data frame [20 x 81]
#> 
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1249279611        34.04810       -117.79884
#> 2  Helianthus annuus 1248872560        37.81227         -8.82959
#> 3  Helianthus annuus 1248887127        38.53339         -8.94263
#> 4  Helianthus annuus 1248873088        38.53339         -8.94263
#> 5  Helianthus annuus 1253308332        29.67463        -95.44804
#> 6  Helianthus annuus 1249286909        32.58747        -97.10081
#> 7  Helianthus annuus 1265544678        32.58747        -97.10081
#> 8  Helianthus annuus 1262385911        32.78328        -96.70352
#> 9  Helianthus annuus 1262375813        29.82586        -95.45604
#> 10 Helianthus annuus 1262379231        34.04911       -117.80066
#> 11 Helianthus annuus 1270045172        33.92958       -117.37322
#> 12 Helianthus annuus 1269541227              NA               NA
#> 13 Helianthus annuus 1265590198        25.76265       -100.25513
#> 14 Helianthus annuus 1265560496        34.12861       -118.20700
#> 15 Helianthus annuus 1265590525        29.86693        -95.64667
#> 16 Helianthus annuus 1272087563        28.51021        -96.81979
#> 17 Helianthus annuus 1265895094        42.87784       -112.43226
#> 18 Helianthus annuus 1265553900        34.12932       -118.20648
#> 19 Helianthus annuus 1269543851        29.50991        -94.50006
#> 20 Helianthus annuus 1265899487        19.45194        -96.95945
#> Variables not shown: issues <chr>, datasetKey <chr>, publishingOrgKey
#>   <chr>, publishingCountry <chr>, protocol <chr>, lastCrawled <chr>,
#>   lastParsed <chr>, extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#>   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#>   familyKey <int>, genusKey <int>, speciesKey <int>, scientificName <chr>,
#>   kingdom <chr>, phylum <chr>, order <chr>, family <chr>, genus <chr>,
#>   species <chr>, genericName <chr>, specificEpithet <chr>, taxonRank
#>   <chr>, dateIdentified <chr>, year <int>, month <int>, day <int>,
#>   eventDate <chr>, modified <chr>, lastInterpreted <chr>, references
#>   <chr>, identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum
#>   <chr>, class <chr>, countryCode <chr>, country <chr>, rightsHolder
#>   <chr>, identifier <chr>, verbatimEventDate <chr>, datasetName <chr>,
#>   gbifID <chr>, verbatimLocality <chr>, collectionCode <chr>, occurrenceID
#>   <chr>, taxonID <chr>, license <chr>, catalogNumber <chr>, recordedBy
#>   <chr>, http...unknown.org.occurrenceDetails <chr>, institutionCode
#>   <chr>, rights <chr>, eventTime <chr>, identificationID <chr>,
#>   infraspecificEpithet <chr>, institutionID <chr>, nomenclaturalCode
#>   <chr>, dataGeneralizations <chr>, footprintWKT <chr>, county <chr>,
#>   municipality <chr>, language <chr>, occurrenceStatus <chr>, footprintSRS
#>   <chr>, ownerInstitutionCode <chr>, higherClassification <chr>,
#>   reproductiveCondition <chr>, identifiedBy <chr>, collectionID <chr>,
#>   occurrenceRemarks <chr>, coordinateUncertaintyInMeters <dbl>,
#>   informationWithheld <chr>.
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#> Source: local data frame [1 x 4]
#> 
#>   offset limit endOfRecords count
#>    <int> <int>        <lgl> <int>
#> 1    300   200        FALSE 31357
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [7919] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [19] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0,
#>      fields=name,basisOfRecord,protocol] 
#> Source: local data frame [20 x 3]
#> 
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
#> Occ. found [7192170 (1175), 6173536 (57), 2498387 (775440)] 
#> Occ. returned [7192170 (5), 6173536 (5), 2498387 (5)] 
#> No. unique hierarchies [7192170 (1), 6173536 (1), 2498387 (1)] 
#> No. media records [7192170 (5), 6173536 (1), 2498387 (5)] 
#> Args [taxonKey=7192170,6173536,2498387, limit=5, offset=0, fields=all] 
#> First 10 rows of data from 7192170
#> 
#> Source: local data frame [5 x 74]
#> 
#>                  name        key decimalLatitude decimalLongitude  issues
#>                 <chr>      <int>           <dbl>            <dbl>   <chr>
#> 1 Cyanocitta stelleri 1147228297        34.73360        -119.9871        
#> 2 Cyanocitta stelleri 1147146899        39.61584        -120.5881 cdround
#> 3 Cyanocitta stelleri 1147243804        39.61584        -120.5881 cdround
#> 4 Cyanocitta stelleri 1147178506        39.61584        -120.5881 cdround
#> 5 Cyanocitta stelleri 1147191815        39.61584        -120.5881 cdround
#> Variables not shown: datasetKey <chr>, publishingOrgKey <chr>,
#>   publishingCountry <chr>, protocol <chr>, lastCrawled <chr>, lastParsed
#>   <chr>, extensions <chr>, basisOfRecord <chr>, establishmentMeans <chr>,
#>   taxonKey <int>, kingdomKey <int>, phylumKey <int>, classKey <int>,
#>   orderKey <int>, familyKey <int>, genusKey <int>, speciesKey <int>,
#>   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>, family
#>   <chr>, genus <chr>, species <chr>, genericName <chr>, specificEpithet
#>   <chr>, infraspecificEpithet <chr>, taxonRank <chr>, continent <chr>,
#>   stateProvince <chr>, year <int>, month <int>, day <int>, eventDate
#>   <chr>, modified <chr>, lastInterpreted <chr>, references <chr>,
#>   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#>   class <chr>, countryCode <chr>, country <chr>, institutionID <chr>,
#>   county <chr>, language <chr>, gbifID <chr>, type <chr>, occurrenceStatus
#>   <chr>, catalogNumber <chr>, vernacularName <chr>, institutionCode <chr>,
#>   rights <chr>, behavior <chr>, identifier <chr>, verbatimEventDate <chr>,
#>   nomenclaturalCode <chr>, higherGeography <chr>, endDayOfYear <chr>,
#>   georeferenceVerificationStatus <chr>, locality <chr>, verbatimLocality
#>   <chr>, collectionCode <chr>, occurrenceID <chr>, recordedBy <chr>,
#>   startDayOfYear <chr>, occurrenceRemarks <chr>, accessRights <chr>.
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
