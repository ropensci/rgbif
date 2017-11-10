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
#> [1] 30282795
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 3862
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 790874302
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 26590598
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 46002702
```

Records for a particular dataset, and only for preserved specimens


```r
occ_count(datasetKey='e707e6da-e143-445d-b41d-529c4a777e8b', basisOfRecord='OBSERVATION')
#> [1] 0
```

## Search for taxon names

Get possible values to be used in taxonomic rank arguments in functions


```r
taxrank()
#> [1] "kingdom"       "phylum"        "class"         "order"        
#> [5] "family"        "genus"         "species"       "subspecies"   
#> [9] "infraspecific"
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
#> # A tibble: 1 x 4
#>   offset limit endOfRecords count
#>    <int> <int>        <lgl> <int>
#> 1      0   100        FALSE  1332
```


```r
head(out$data)
#> # A tibble: 6 x 26
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 114091654       Mammalia 30f55c63-a829-4cb2-9676-3b1b6f981567    359
#> 2 127804986       Mammalia ec532910-dec5-4ca9-9814-f6d1c02ced77    359
#> 3 117910746       Mammalia a43ec6d8-7b8a-4868-ad74-56b824c75698    359
#> 4 134843305       Mammalia 29d2d5a6-db22-4abd-b784-9ab2f9757c3c    359
#> 5 134844570       Mammalia 089ede6e-6496-4638-915e-f28f016c2f89    359
#> 6 134843651       Mammalia 0c0ac27f-c7cb-4a1a-b5d7-6d9a386b2c53    359
#> # ... with 22 more variables: canonicalName <chr>, authorship <chr>,
#> #   nameType <chr>, origin <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, taxonomicStatus <chr>, rank <chr>, class <chr>,
#> #   taxonID <chr>, extinct <lgl>
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`127804986`
#>     rankkey     name
#> 1 127804984 Animalia
#> 2 127804985 Chordata
#> 
#> $`117910746`
#>     rankkey     name
#> 1 117898234 Animalia
#> 2 117910745 Chordata
```


```r
out$names[2]
#> $`100371916`
#>   vernacularName language
#> 1     Säugetiere      deu
```

Search for a genus


```r
head(name_lookup(query='Cnaemidophorus', rank="genus", return="data"))
#> # A tibble: 6 x 34
#>         key scientificName                           datasetKey  nubKey
#>       <int>          <chr>                                <chr>   <int>
#> 1 135332978 Cnaemidophorus cbb6498e-8927-405a-916b-576d00a6289b 1858636
#> 2 133063907 Cnaemidophorus 4cec8fef-f129-4966-89b7-4f8439aba058 1858636
#> 3 135538772 Cnaemidophorus 4dd32523-a3a3-43b7-84df-4cda02f15cf7 1858636
#> 4 135795882 Cnaemidophorus 7ddf754f-d193-4cc9-b351-99906754a03b 1858636
#> 5 134031474 Cnaemidophorus 23905003-5ee5-4326-b1bb-3a2fd6250df3 1858636
#> 6 137249919 Cnaemidophorus d16563e0-e718-45a9-a20f-3e9fc20613da 1858636
#> # ... with 30 more variables: parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, order <chr>, family <chr>, genus <chr>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, canonicalName <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, origin <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <lgl>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>, nameType <chr>,
#> #   taxonID <chr>, authorship <chr>, publishedIn <chr>, extinct <lgl>,
#> #   constituentKey <chr>
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#> # A tibble: 6 x 26
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 114091654       Mammalia 30f55c63-a829-4cb2-9676-3b1b6f981567    359
#> 2 127804986       Mammalia ec532910-dec5-4ca9-9814-f6d1c02ced77    359
#> 3 117910746       Mammalia a43ec6d8-7b8a-4868-ad74-56b824c75698    359
#> 4 134843305       Mammalia 29d2d5a6-db22-4abd-b784-9ab2f9757c3c    359
#> 5 134844570       Mammalia 089ede6e-6496-4638-915e-f28f016c2f89    359
#> 6 134843651       Mammalia 0c0ac27f-c7cb-4a1a-b5d7-6d9a386b2c53    359
#> # ... with 22 more variables: canonicalName <chr>, authorship <chr>,
#> #   nameType <chr>, origin <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, taxonomicStatus <chr>, rank <chr>, class <chr>,
#> #   taxonID <chr>, extinct <lgl>
```

Look up the species Helianthus annuus


```r
head(name_lookup(query = 'Helianthus annuus', rank="species", return = 'data'))
#> # A tibble: 6 x 42
#>         key    scientificName                           datasetKey
#>       <int>             <chr>                                <chr>
#> 1   3119195 Helianthus annuus d7dddbf4-2cf0-4f39-9b2a-bb099caae36c
#> 2 134854463 Helianthus annuus f82a4f7f-6f84-4b58-82e6-6b41ec9a1f49
#> 3 114910965 Helianthus annuus ee2aac07-de9a-47a2-b828-37430d537633
#> 4 134843454 Helianthus annuus 29d2d5a6-db22-4abd-b784-9ab2f9757c3c
#> 5 127670355 Helianthus annuus 41c06f1a-23da-4445-b859-ec3a8a03b0e2
#> 6 134856103 Helianthus annuus 278c9199-be97-4fd0-9c6c-6c46c4e2369e
#> # ... with 39 more variables: constituentKey <chr>, nubKey <int>,
#> #   parentKey <int>, parent <chr>, kingdom <chr>, phylum <chr>,
#> #   order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   canonicalName <chr>, authorship <chr>, publishedIn <chr>,
#> #   nameType <chr>, taxonomicStatus <chr>, rank <chr>, origin <chr>,
#> #   numDescendants <int>, numOccurrences <int>, extinct <lgl>,
#> #   habitats <chr>, nomenclaturalStatus <chr>, threatStatuses <lgl>,
#> #   synonym <lgl>, class <chr>, taxonID <chr>, acceptedKey <int>,
#> #   accepted <chr>, accordingTo <chr>, nameKey <int>, basionymKey <int>,
#> #   basionym <chr>
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
library("plyr")
out <- name_usage(key=3119195, language="FRENCH", data='vernacularNames')
head(out$data)
#> # A tibble: 6 x 6
#>   taxonKey   vernacularName language
#>      <int>            <chr>    <chr>
#> 1  3119195 common sunflower      eng
#> 2  3119195        tournesol      fra
#> 3  3119195 garden sunflower      eng
#> 4  3119195     grand soleil      fra
#> 5  3119195 hélianthe annuel      fra
#> 6  3119195           soleil      fra
#> # ... with 3 more variables: source <chr>, sourceTaxonKey <int>,
#> #   preferred <lgl>
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
#> # A tibble: 6 x 3
#>       key           canonicalName       rank
#>     <int>                   <chr>      <chr>
#> 1 2435099           Puma concolor    SPECIES
#> 2 8916934    Puma concolor bangsi SUBSPECIES
#> 3 6164599    Puma concolor azteca SUBSPECIES
#> 4 6164589  Puma concolor anthonyi SUBSPECIES
#> 5 8951716 Puma concolor borbensis SUBSPECIES
#> 6 6164618    Puma concolor browni SUBSPECIES
```


## Single occurrence records

Get data for a single occurrence. Note that data is returned as a list, with slots for metadata and data, or as a hierarchy, or just data.

Just data


```r
occ_get(key=855998194, return='data')
#>               name       key decimalLatitude decimalLongitude
#> 1 Sciurus vulgaris 855998194        58.40677         12.04386
#>                 issues
#> 1 cdround,gass84,rdatm
```

Just taxonomic hierarchy


```r
occ_get(key=855998194, return='hier')
#>               name     key    rank
#> 1         Animalia       1 kingdom
#> 2         Chordata      44  phylum
#> 3         Mammalia     359   class
#> 4         Rodentia    1459   order
#> 5        Sciuridae    9456  family
#> 6          Sciurus 2437489   genus
#> 7 Sciurus vulgaris 8211070 species
```

All data, or leave return parameter blank


```r
occ_get(key=855998194, return='all')
#> $hierarchy
#>               name     key    rank
#> 1         Animalia       1 kingdom
#> 2         Chordata      44  phylum
#> 3         Mammalia     359   class
#> 4         Rodentia    1459   order
#> 5        Sciuridae    9456  family
#> 6          Sciurus 2437489   genus
#> 7 Sciurus vulgaris 8211070 species
#> 
#> $media
#> list()
#> 
#> $data
#>               name       key decimalLatitude decimalLongitude
#> 1 Sciurus vulgaris 855998194        58.40677         12.04386
#>                 issues
#> 1 cdround,gass84,rdatm
```

Get many occurrences. `occ_get` is vectorized


```r
occ_get(key=c(855998194, 1425976049, 240713150), return='data')
#>               name        key decimalLatitude decimalLongitude
#> 1 Sciurus vulgaris  855998194        58.40677        12.043857
#> 2    Cygnus cygnus 1425976049        58.26546         7.651751
#> 3         Pelosina  240713150       -77.56670       163.582993
#>                 issues
#> 1 cdround,gass84,rdatm
#> 2       cdround,gass84
#> 3   bri,cdround,gass84
```


## Search for occurrences

By default `occ_search()` returns a `dplyr` like output summary in which the data printed expands based on how much data is returned, and the size of your window. You can search by scientific name:


```r
occ_search(scientificName = "Ursus americanus", limit = 20)
#> Records found [9770] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [17] 
#> No. facets [0] 
#> Args [limit=20, offset=0, scientificName=Ursus americanus, fields=all] 
#> # A tibble: 20 x 68
#>                name        key decimalLatitude decimalLongitude
#>               <chr>      <int>           <dbl>            <dbl>
#>  1 Ursus americanus 1671722060        33.47152        -91.64752
#>  2 Ursus americanus 1453325042        37.36325        -80.52914
#>  3 Ursus americanus 1453341157        35.44519        -83.75077
#>  4 Ursus americanus 1453341156        35.43836        -83.66423
#>  5 Ursus americanus 1453427952        35.61469        -82.47723
#>  6 Ursus americanus 1453456359        25.31110       -100.96992
#>  7 Ursus americanus 1453476835        29.20453       -103.23501
#>  8 Ursus americanus 1453414927        47.90953        -91.95893
#>  9 Ursus americanus 1453456338        25.30959       -100.96966
#> 10 Ursus americanus 1453445710        35.59506        -82.55149
#> 11 Ursus americanus 1457591001        38.93946       -119.94679
#> 12 Ursus americanus 1500285318        45.51560        -69.35556
#> 13 Ursus americanus 1455592330        46.34195        -83.98219
#> 14 Ursus americanus 1571069736        25.25062       -100.94652
#> 15 Ursus americanus 1500319247        32.89649       -109.48065
#> 16 Ursus americanus 1453476285        35.94219        -76.57357
#> 17 Ursus americanus 1457595069        46.59933        -84.46328
#> 18 Ursus americanus 1500222058        25.34884       -100.91091
#> 19 Ursus americanus 1500223333        45.38687        -76.10825
#> 20 Ursus americanus 1453520782        29.29163       -103.37046
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
#> #   verbatimLocality <chr>, collectionCode <chr>, gbifID <chr>,
#> #   occurrenceID <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   institutionCode <chr>, rights <chr>, identificationID <chr>,
#> #   eventTime <chr>, occurrenceRemarks <chr>, informationWithheld <chr>,
#> #   infraspecificEpithet <chr>
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [18377] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [1] 
#> No. facets [0] 
#> Args [limit=20, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 20 x 89
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#>  1 Helianthus annuus 1433793045        59.66859         16.54257
#>  2 Helianthus annuus 1434024463        63.71622         20.31247
#>  3 Helianthus annuus 1563876655              NA               NA
#>  4 Helianthus annuus 1436147509        59.85465         17.79089
#>  5 Helianthus annuus 1436223234        59.85509         17.78900
#>  6 Helianthus annuus 1450388036        56.60630         16.64841
#>  7 Helianthus annuus 1499896133        58.76637         16.24997
#>  8 Helianthus annuus 1499929475        59.85530         17.79055
#>  9 Helianthus annuus 1669229145        59.85530         17.79055
#> 10 Helianthus annuus 1669043510        59.74332         17.78161
#> 11 Helianthus annuus 1669900943        57.73119         16.13173
#> 12 Helianthus annuus 1669884935        56.64750         12.85256
#> 13 Helianthus annuus 1669797382        55.72320         13.18386
#> 14 Helianthus annuus 1669882522        58.53514         16.50554
#> 15 Helianthus annuus 1670276641        57.30363         11.90345
#> 16 Helianthus annuus 1675823397        38.38880       -105.00800
#> 17 Helianthus annuus 1669981909        57.72138         11.94415
#> 18 Helianthus annuus 1670011022        59.85046         17.68560
#> 19 Helianthus annuus 1670291603        59.15281         18.17448
#> 20 Helianthus annuus 1670396073        59.70498         16.51416
#> # ... with 85 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, individualCount <int>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, genericName <chr>,
#> #   specificEpithet <chr>, taxonRank <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, continent <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, rightsHolder <chr>, county <chr>, municipality <chr>,
#> #   identificationVerificationStatus <chr>, language <chr>, gbifID <chr>,
#> #   type <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   occurrenceStatus <chr>, vernacularName <chr>, institutionCode <chr>,
#> #   taxonConceptID <chr>, eventTime <chr>, identifier <chr>,
#> #   informationWithheld <chr>, endDayOfYear <chr>, locality <chr>,
#> #   collectionCode <chr>, occurrenceID <chr>, recordedBy <chr>,
#> #   startDayOfYear <chr>, datasetID <chr>, accessRights <chr>,
#> #   higherClassification <chr>, dateIdentified <chr>, elevation <dbl>,
#> #   stateProvince <chr>, references <chr>, recordNumber <chr>,
#> #   habitat <chr>, verbatimEventDate <chr>, associatedTaxa <chr>,
#> #   verbatimLocality <chr>, verbatimElevation <chr>, identifiedBy <chr>,
#> #   identificationID <chr>, occurrenceRemarks <chr>, institutionID <chr>,
#> #   higherGeography <chr>
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#> # A tibble: 1 x 4
#>   offset limit endOfRecords count
#> *  <int> <int>        <lgl> <int>
#> 1    300   200        FALSE 18377
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [9770] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [17] 
#> No. facets [0] 
#> Args [limit=20, offset=0, scientificName=Ursus americanus,
#>      fields=name,basisOfRecord,protocol] 
#> # A tibble: 20 x 3
#>                name    protocol     basisOfRecord
#>               <chr>       <chr>             <chr>
#>  1 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  2 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  3 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  4 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  5 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  6 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  7 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  8 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
#>  9 Ursus americanus DWC_ARCHIVE HUMAN_OBSERVATION
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
#> Occ. found [2482598 (578560), 2492010 (3065897), 2498387 (979138)] 
#> Occ. returned [2482598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2482598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2482598 (5), 2492010 (5), 2498387 (5)] 
#> No. facets [2482598 (0), 2492010 (0), 2498387 (0)] 
#> Args [limit=5, offset=0, taxonKey=2482598,2492010,2498387, fields=all] 
#> 3 requests; First 10 rows of data from 2482598
#> 
#> # A tibble: 5 x 67
#>                  name        key decimalLatitude decimalLongitude
#>                 <chr>      <int>           <dbl>            <dbl>
#> 1 Cyanocitta stelleri 1453342305        46.14702        -123.6545
#> 2 Cyanocitta stelleri 1453373156        23.67272        -105.4548
#> 3 Cyanocitta stelleri 1453355963        37.76899        -122.4758
#> 4 Cyanocitta stelleri 1453325920        38.48213        -122.8734
#> 5 Cyanocitta stelleri 1453338402        45.50661        -122.7135
#> # ... with 63 more variables: issues <chr>, datasetKey <chr>,
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
#> #   verbatimLocality <chr>, collectionCode <chr>, gbifID <chr>,
#> #   occurrenceID <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   institutionCode <chr>, rights <chr>, eventTime <chr>,
#> #   identificationID <chr>, occurrenceRemarks <chr>,
#> #   informationWithheld <chr>
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
