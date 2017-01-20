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
#> [1] 47653413
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 3317
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 629378292
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 11905048
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 40175279
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
#> 1      0   100        FALSE  1722
```


```r
head(out$data)
#> # A tibble: 6 × 26
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 120820591       Mammalia 81e739b4-cba8-46d9-8104-5ea487c2dd20    359
#> 2 115197859       Mammalia 672aca30-f1b5-43d3-8a2b-c1606125fa1b    359
#> 3 115199929       Mammalia cbb6498e-8927-405a-916b-576d00a6289b    359
#> 4 115499069       Mammalia 36ad3207-1190-47ad-868e-b09d6c0aeec2    359
#> 5 120674802       Mammalia dbfacc33-350a-4620-976f-4d3a441aa242    359
#> 6 120824215       Mammalia 1570f557-12da-4cb6-ad4f-819bc5963f38    359
#> # ... with 22 more variables: parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>,
#> #   constituentKey <chr>, extinct <lgl>, taxonID <chr>
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`120820591`
#>     rankkey     name
#> 1 120820566 Animalia
#> 2 120820567 Chordata
#> 
#> $`115197859`
#>     rankkey     name
#> 1 115197858 Animalia
```


```r
out$names[2]
#> $`104045725`
#>   vernacularName
#> 1        mammals
```

Search for a genus


```r
head(name_lookup(query='Cnaemidophorus', rank="genus", return="data"))
#> # A tibble: 6 × 34
#>         key scientificName                           datasetKey  nubKey
#>       <int>          <chr>                                <chr>   <int>
#> 1 125933331 Cnaemidophorus de8934f4-a136-481c-a87a-b0b202b80a31 1858636
#> 2 115196907 Cnaemidophorus 16c3f9cb-4b19-4553-ac8e-ebb90003aa02 1858636
#> 3 115216121 Cnaemidophorus cbb6498e-8927-405a-916b-576d00a6289b 1858636
#> 4 115346496 Cnaemidophorus cbb6498e-8927-405a-916b-576d00a6289b 1858636
#> 5 125855950 Cnaemidophorus 4cec8fef-f129-4966-89b7-4f8439aba058 1858636
#> 6 123576977 Cnaemidophorus fab88965-e69d-4491-a04d-e3198b626e52 1858636
#> # ... with 30 more variables: parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, order <chr>, family <chr>, genus <chr>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, canonicalName <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <lgl>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>, authorship <chr>,
#> #   nameType <chr>, taxonID <chr>, constituentKey <chr>, extinct <lgl>,
#> #   publishedIn <chr>, accordingTo <chr>
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#> # A tibble: 6 × 26
#>         key scientificName                           datasetKey nubKey
#>       <int>          <chr>                                <chr>  <int>
#> 1 120820591       Mammalia 81e739b4-cba8-46d9-8104-5ea487c2dd20    359
#> 2 115197859       Mammalia 672aca30-f1b5-43d3-8a2b-c1606125fa1b    359
#> 3 115199929       Mammalia cbb6498e-8927-405a-916b-576d00a6289b    359
#> 4 115499069       Mammalia 36ad3207-1190-47ad-868e-b09d6c0aeec2    359
#> 5 120674802       Mammalia dbfacc33-350a-4620-976f-4d3a441aa242    359
#> 6 120824215       Mammalia 1570f557-12da-4cb6-ad4f-819bc5963f38    359
#> # ... with 22 more variables: parentKey <int>, parent <chr>,
#> #   kingdom <chr>, phylum <chr>, kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <chr>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>,
#> #   constituentKey <chr>, extinct <lgl>, taxonID <chr>
```

Look up the species Helianthus annuus


```r
head(name_lookup(query = 'Helianthus annuus', rank="species", return = 'data'))
#> # A tibble: 6 × 40
#>         key                           scientificName
#>       <int>                                    <chr>
#> 1 103340289                        Helianthus annuus
#> 2 114910965                        Helianthus annuus
#> 3 124614878                     Helianthus annuus L.
#> 4 115452008 'Helianthus annuus' phyllody phytoplasma
#> 5 101321447                     Helianthus annuus L.
#> 6 118749457                     Helianthus annuus L.
#> # ... with 38 more variables: datasetKey <chr>, parentKey <int>,
#> #   parent <chr>, kingdom <chr>, phylum <chr>, order <chr>, family <chr>,
#> #   genus <chr>, species <chr>, kingdomKey <int>, phylumKey <int>,
#> #   orderKey <int>, familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   canonicalName <chr>, nameType <chr>, taxonomicStatus <chr>,
#> #   rank <chr>, numDescendants <int>, numOccurrences <int>, taxonID <chr>,
#> #   habitats <chr>, nomenclaturalStatus <chr>, threatStatuses <lgl>,
#> #   synonym <lgl>, nubKey <int>, classKey <int>, authorship <chr>,
#> #   class <chr>, publishedIn <chr>, accordingTo <chr>, extinct <lgl>,
#> #   constituentKey <chr>, basionymKey <int>, basionym <chr>,
#> #   acceptedKey <int>, accepted <chr>
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
library("plyr")
out <- name_usage(key=3119195, language="FRENCH", data='vernacularNames')
head(out$data)
#> # A tibble: 6 × 6
#>            vernacularName language country
#>                     <chr>    <chr>   <chr>
#> 1 Gewöhnliche Sonnenblume      deu      DE
#> 2             Sonnenblume      deu    <NA>
#> 3                 alizeti      swa    <NA>
#> 4        annual sunflower      eng    <NA>
#> 5        common sunflower      eng    <NA>
#> 6                 girasol      spa    <NA>
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
#> # A tibble: 6 × 3
#>       key               canonicalName       rank
#>     <int>                       <chr>      <chr>
#> 1 2435099               Puma concolor    SPECIES
#> 2 7193927      Puma concolor concolor SUBSPECIES
#> 3 6164624 Puma concolor costaricensis SUBSPECIES
#> 4 6164590       Puma concolor couguar SUBSPECIES
#> 5 6164623      Puma concolor cabrerae SUBSPECIES
#> 6 6164589      Puma concolor anthonyi SUBSPECIES
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
#> Records found [8424] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [16] 
#> No. facets [0] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0, fields=all] 
#> # A tibble: 20 × 67
#>                name        key decimalLatitude decimalLongitude
#>               <chr>      <int>           <dbl>            <dbl>
#> 1  Ursus americanus 1229610234        44.06062        -71.92692
#> 2  Ursus americanus 1253300445        44.65481        -72.67270
#> 3  Ursus americanus 1229610216        44.06086        -71.92712
#> 4  Ursus americanus 1249277297        35.76789        -75.80894
#> 5  Ursus americanus 1249296297        39.08590       -105.24586
#> 6  Ursus americanus 1253314877        49.25782       -122.82786
#> 7  Ursus americanus 1249284297        43.68723        -72.32891
#> 8  Ursus americanus 1272078411        44.41793        -72.70709
#> 9  Ursus americanus 1262389246        43.80871        -72.20964
#> 10 Ursus americanus 1257415362        44.32746        -72.41007
#> 11 Ursus americanus 1253317181        43.64214        -72.52494
#> 12 Ursus americanus 1270045018        44.35271        -72.53303
#> 13 Ursus americanus 1306574101        44.34088        -72.46131
#> 14 Ursus americanus 1265898376        31.42900       -110.41299
#> 15 Ursus americanus 1269541796        41.02228        -74.79251
#> 16 Ursus americanus 1265898452        43.80871        -72.20964
#> 17 Ursus americanus 1269542935        37.45838        -80.55127
#> 18 Ursus americanus 1265595722        35.61069        -83.83539
#> 19 Ursus americanus 1265598494        44.36404        -72.74876
#> 20 Ursus americanus 1315062645        34.18098       -118.09706
#> # ... with 63 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   dateIdentified <chr>, year <int>, month <int>, day <int>,
#> #   eventDate <chr>, modified <chr>, lastInterpreted <chr>,
#> #   references <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, rightsHolder <chr>, identifier <chr>,
#> #   verbatimEventDate <chr>, datasetName <chr>, verbatimLocality <chr>,
#> #   gbifID <chr>, collectionCode <chr>, occurrenceID <chr>, taxonID <chr>,
#> #   recordedBy <chr>, catalogNumber <chr>,
#> #   http...unknown.org.occurrenceDetails <chr>, institutionCode <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>,
#> #   occurrenceRemarks <chr>, infraspecificEpithet <chr>,
#> #   coordinateUncertaintyInMeters <dbl>
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [21970] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [15] 
#> No. facets [0] 
#> Args [taxonKey=3119195, limit=20, offset=0, fields=all] 
#> # A tibble: 20 × 67
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1249279611        34.04810       -117.79884
#> 2  Helianthus annuus 1315048347        34.04377       -116.94136
#> 3  Helianthus annuus 1305118889        18.40386        -66.04487
#> 4  Helianthus annuus 1249286909        32.58747        -97.10081
#> 5  Helianthus annuus 1253308332        29.67463        -95.44804
#> 6  Helianthus annuus 1262375813        29.82586        -95.45604
#> 7  Helianthus annuus 1262385911        32.78328        -96.70352
#> 8  Helianthus annuus 1265544678        32.58747        -97.10081
#> 9  Helianthus annuus 1262379231        34.04911       -117.80066
#> 10 Helianthus annuus 1265560496        34.12861       -118.20700
#> 11 Helianthus annuus 1269541227              NA               NA
#> 12 Helianthus annuus 1265895094        42.87784       -112.43226
#> 13 Helianthus annuus 1272087563        28.51021        -96.81979
#> 14 Helianthus annuus 1265590525        29.86693        -95.64667
#> 15 Helianthus annuus 1270045172        33.92958       -117.37322
#> 16 Helianthus annuus 1265553900        34.12932       -118.20648
#> 17 Helianthus annuus 1269543851        29.50991        -94.50006
#> 18 Helianthus annuus 1305119137        11.86735        -83.93555
#> 19 Helianthus annuus 1265590989        34.19005       -117.31644
#> 20 Helianthus annuus 1315048128        34.03212       -117.47091
#> # ... with 63 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   dateIdentified <chr>, year <int>, month <int>, day <int>,
#> #   eventDate <chr>, modified <chr>, lastInterpreted <chr>,
#> #   references <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, rightsHolder <chr>, identifier <chr>,
#> #   verbatimEventDate <chr>, datasetName <chr>, verbatimLocality <chr>,
#> #   gbifID <chr>, collectionCode <chr>, occurrenceID <chr>, taxonID <chr>,
#> #   recordedBy <chr>, catalogNumber <chr>,
#> #   http...unknown.org.occurrenceDetails <chr>, institutionCode <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, occurrenceRemarks <chr>,
#> #   informationWithheld <chr>
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#> # A tibble: 1 × 4
#>   offset limit endOfRecords count
#> *  <int> <int>        <lgl> <int>
#> 1    300   200        FALSE 21970
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [8424] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [16] 
#> No. facets [0] 
#> Args [scientificName=Ursus americanus, limit=20, offset=0,
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
#> Occ. found [2482598 (577278), 2492010 (3058729), 2498387 (973551)] 
#> Occ. returned [2482598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2482598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2482598 (5), 2492010 (5), 2498387 (1)] 
#> No. facets [] 
#> Args [taxonKey=2482598,2492010,2498387, limit=5, offset=0, fields=all] 
#> First 10 rows of data from 2482598
#> 
#> # A tibble: 5 × 65
#>                  name        key decimalLatitude decimalLongitude
#>                 <chr>      <int>           <dbl>            <dbl>
#> 1 Cyanocitta stelleri 1229615253        49.18573        -123.9761
#> 2 Cyanocitta stelleri 1249299363        38.46463        -120.0399
#> 3 Cyanocitta stelleri 1249289074        49.30474        -123.1404
#> 4 Cyanocitta stelleri 1249293270        40.58712        -111.6279
#> 5 Cyanocitta stelleri 1227772105        49.18573        -123.9761
#> # ... with 61 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   dateIdentified <chr>, year <int>, month <int>, day <int>,
#> #   eventDate <chr>, modified <chr>, lastInterpreted <chr>,
#> #   references <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, rightsHolder <chr>, identifier <chr>,
#> #   verbatimEventDate <chr>, datasetName <chr>, verbatimLocality <chr>,
#> #   gbifID <chr>, collectionCode <chr>, occurrenceID <chr>, taxonID <chr>,
#> #   recordedBy <chr>, catalogNumber <chr>,
#> #   http...unknown.org.occurrenceDetails <chr>, institutionCode <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>,
#> #   coordinateUncertaintyInMeters <dbl>
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
