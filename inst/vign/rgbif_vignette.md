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
#> [1] 19756387
```

Records for **Puma concolor** with lat/long data (georeferened) only. Note that `hasCoordinate` in `occ_search()` is the same as `georeferenced` in `occ_count()`.


```r
occ_count(taxonKey=2435099, georeferenced=TRUE)
#> [1] 4628
```

All georeferenced records in GBIF


```r
occ_count(georeferenced=TRUE)
#> [1] 991539311
```

Records from Denmark


```r
denmark_code <- isocodes[grep("Denmark", isocodes$name), "code"]
occ_count(country=denmark_code)
#> [1] 29429637
```

Number of records in a particular dataset


```r
occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#> [1] 4591
```

All records from 2012


```r
occ_count(year=2012)
#> [1] 52829793
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
#>    <int> <int> <lgl>        <int>
#> 1      0   100 FALSE         1044
```


```r
head(out$data)
#> # A tibble: 6 x 25
#>      key scientificName datasetKey nubKey parentKey parent kingdom phylum
#>    <int> <chr>          <chr>       <int>     <int> <chr>  <chr>   <chr> 
#> 1 1.35e8 Mammalia       7b3f4866-…    359 135080672 Chord… Animal… Chord…
#> 2 1.35e8 Mammalia       1ddab917-…    359 135215962 Chord… Animal… Chord…
#> 3 1.35e8 Mammalia       97b24147-…    359 135216923 Chord… Animal… Chord…
#> 4 1.35e8 Mammalia       f3a1e772-…    359 135229685 Chord… Animal… Chord…
#> 5 1.44e8 Mammalia       3c188f76-…    359 143969855 Chord… Animal… Chord…
#> 6 1.35e8 Mammalia       128fd844-…    359 135080507 Chord… Animal… Chord…
#> # … with 17 more variables: kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, origin <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <lgl>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>, taxonID <chr>
```


```r
out$facets
#> NULL
```


```r
out$hierarchies[1:2]
#> $`135080673`
#>     rankkey     name
#> 1 135080671 Animalia
#> 2 135080672 Chordata
#> 
#> $`135215963`
#>     rankkey     name
#> 1 135215961 Animalia
#> 2 135215962 Chordata
```


```r
out$names[2]
#> NULL
```

Search for a genus


```r
head(name_lookup(query='Cnaemidophorus', rank="genus", return="data"))
#> # A tibble: 6 x 35
#>      key scientificName datasetKey nubKey parentKey parent phylum order
#>    <int> <chr>          <chr>       <int>     <int> <chr>  <chr>  <chr>
#> 1 1.33e8 Cnaemidophorus 4cec8fef-… 1.86e6 133063901 Ptero… Arthr… Lepi…
#> 2 1.53e8 Cnaemidophorus 7ddf754f-… 1.86e6 153048732 Ptero… Arthr… Lepi…
#> 3 1.53e8 Cnaemidophorus d16563e0-… 1.86e6 152672840 Ptero… Arthr… Lepi…
#> 4 1.24e8 Cnaemidophorus fab88965-… 1.86e6 104446806 Ptero… Arthr… Lepi…
#> 5 1.53e8 Cnaemidophorus 4dd32523-… 1.86e6 152565575 Ptero… Arthr… Lepi…
#> 6 1.52e8 Cnaemidophorus 23905003-… 1.86e6 152121874 Ptero… Arthr… Lepi…
#> # … with 27 more variables: family <chr>, genus <chr>, phylumKey <int>,
#> #   classKey <int>, orderKey <int>, familyKey <int>, genusKey <int>,
#> #   canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, origin <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <lgl>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>, kingdom <chr>,
#> #   kingdomKey <int>, taxonID <chr>, publishedIn <chr>, extinct <lgl>,
#> #   accordingTo <chr>, constituentKey <chr>
```

Search for the class mammalia


```r
head(name_lookup(query='mammalia', return = 'data'))
#> # A tibble: 6 x 25
#>      key scientificName datasetKey nubKey parentKey parent kingdom phylum
#>    <int> <chr>          <chr>       <int>     <int> <chr>  <chr>   <chr> 
#> 1 1.35e8 Mammalia       7b3f4866-…    359 135080672 Chord… Animal… Chord…
#> 2 1.35e8 Mammalia       1ddab917-…    359 135215962 Chord… Animal… Chord…
#> 3 1.35e8 Mammalia       97b24147-…    359 135216923 Chord… Animal… Chord…
#> 4 1.35e8 Mammalia       f3a1e772-…    359 135229685 Chord… Animal… Chord…
#> 5 1.44e8 Mammalia       3c188f76-…    359 143969855 Chord… Animal… Chord…
#> 6 1.35e8 Mammalia       128fd844-…    359 135080507 Chord… Animal… Chord…
#> # … with 17 more variables: kingdomKey <int>, phylumKey <int>,
#> #   classKey <int>, canonicalName <chr>, authorship <chr>, nameType <chr>,
#> #   taxonomicStatus <chr>, rank <chr>, origin <chr>, numDescendants <int>,
#> #   numOccurrences <int>, habitats <lgl>, nomenclaturalStatus <lgl>,
#> #   threatStatuses <lgl>, synonym <lgl>, class <chr>, taxonID <chr>
```

Look up the species Helianthus annuus


```r
head(name_lookup(query = 'Helianthus annuus', rank="species", return = 'data'))
#> # A tibble: 6 x 40
#>      key scientificName datasetKey nubKey parentKey parent kingdom phylum
#>    <int> <chr>          <chr>       <int>     <int> <chr>  <chr>   <chr> 
#> 1 1.35e8 Helianthus an… 29d2d5a6-… 9.21e6 148402516 Aster… Plantae Trach…
#> 2 1.28e8 Helianthus an… 41c06f1a-… 9.21e6 146770884 Amara… Plantae <NA>  
#> 3 1.46e8 Helianthus an… 6a97172b-… 9.21e6 147653302 Helia… <NA>    <NA>  
#> 4 1.15e8 Helianthus an… ee2aac07-… 9.21e6 144238801 Helia… Plantae Trach…
#> 5 1.35e8 Helianthus an… f82a4f7f-… 9.21e6 152142298 Aster… Plantae Trach…
#> 6 1.35e8 Helianthus an… 278c9199-… 9.21e6 147652468 Aster… Plantae Trach…
#> # … with 32 more variables: order <chr>, family <chr>, species <chr>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, speciesKey <int>, canonicalName <chr>,
#> #   nameType <chr>, taxonomicStatus <chr>, rank <chr>, origin <chr>,
#> #   numDescendants <int>, numOccurrences <int>, taxonID <chr>,
#> #   habitats <chr>, nomenclaturalStatus <chr>, threatStatuses <chr>,
#> #   synonym <lgl>, class <chr>, genus <chr>, genusKey <int>,
#> #   authorship <chr>, acceptedKey <int>, accepted <chr>,
#> #   publishedIn <chr>, accordingTo <chr>, constituentKey <chr>,
#> #   basionymKey <int>, basionym <chr>
```

The function `name_usage()` works with lots of different name endpoints in GBIF, listed at [http://www.gbif.org/developer/species#nameUsages](http://www.gbif.org/developer/species#nameUsages).


```r
name_usage(key=3119195, language="FRENCH", data='vernacularNames')
#> $meta
#> # A tibble: 1 x 3
#>   offset limit endOfRecords
#>    <int> <int> <lgl>       
#> 1      0   100 TRUE        
#> 
#> $data
#> # A tibble: 0 x 0
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
#>       key canonicalName                rank      
#>     <int> <chr>                        <chr>     
#> 1 2435099 Puma concolor                SPECIES   
#> 2 6164622 Puma concolor puma           SUBSPECIES
#> 3 6164589 Puma concolor anthonyi       SUBSPECIES
#> 4 6164618 Puma concolor browni         SUBSPECIES
#> 5 8951716 Puma concolor borbensis      SUBSPECIES
#> 6 8860878 Puma concolor capricornensis SUBSPECIES
```


## Single occurrence records

Get data for a single occurrence. Note that data is returned as a list, with slots for metadata and data, or as a hierarchy, or just data.

Just data


```r
occ_get(key=855998194, return='data')
#>         key                  scientificName decimalLatitude
#> 1 855998194 Sciurus vulgaris Linnaeus, 1758        58.40677
#>   decimalLongitude         issues
#> 1         12.04386 cdround,gass84
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
#>         key                  scientificName decimalLatitude
#> 1 855998194 Sciurus vulgaris Linnaeus, 1758        58.40677
#>   decimalLongitude         issues
#> 1         12.04386 cdround,gass84
```

Get many occurrences. `occ_get` is vectorized


```r
occ_get(key=c(855998194, 1425976049, 240713150), return='data')
#>          key                  scientificName decimalLatitude
#> 1  855998194 Sciurus vulgaris Linnaeus, 1758        58.40677
#> 2 1425976049  Cygnus cygnus (Linnaeus, 1758)        58.26546
#> 3  240713150            Pelosina Brady, 1879       -77.56670
#>   decimalLongitude         issues
#> 1        12.043857 cdround,gass84
#> 2         7.651751 cdround,gass84
#> 3       163.583000         gass84
```


## Search for occurrences

By default `occ_search()` returns a `dplyr` like output summary in which the data printed expands based on how much data is returned, and the size of your window. You can search by scientific name:


```r
occ_search(scientificName = "Ursus americanus", limit = 20)
#> Records found [12042] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> No. facets [0] 
#> Args [limit=20, offset=0, scientificName=Ursus americanus, fields=all] 
#> # A tibble: 20 x 74
#>       key scientificName decimalLatitude decimalLongitude issues datasetKey
#>     <int> <chr>                    <dbl>            <dbl> <chr>  <chr>     
#>  1 1.99e9 Ursus america…            29.2            -81.8 cdrou… 50c9509d-…
#>  2 1.99e9 Ursus america…            45.3            -76.8 cdrou… 50c9509d-…
#>  3 1.99e9 Ursus america…            47.7           -122.  cdrou… 50c9509d-…
#>  4 1.99e9 Ursus america…            32.6           -109.  cdrou… 50c9509d-…
#>  5 1.99e9 Ursus america…            33.1            -91.9 cdrou… 50c9509d-…
#>  6 1.99e9 Ursus america…            27.7            -81.5 gass84 50c9509d-…
#>  7 1.99e9 Ursus america…            30.1           -103.  cdrou… 50c9509d-…
#>  8 1.99e9 Ursus america…            39.4           -120.  cdrou… 50c9509d-…
#>  9 1.99e9 Ursus america…            35.7            -76.6 cdrou… 50c9509d-…
#> 10 1.99e9 Ursus america…            33.1            -91.9 cdrou… 50c9509d-…
#> 11 1.99e9 Ursus america…            45.5            -93.1 cdrou… 50c9509d-…
#> 12 1.99e9 Ursus america…            45.4            -93.1 cdrou… 50c9509d-…
#> 13 1.99e9 Ursus america…            31.9            -94.7 cdrou… 50c9509d-…
#> 14 1.99e9 Ursus america…            45.4            -93.2 cdrou… 50c9509d-…
#> 15 1.99e9 Ursus america…            45.4            -93.2 cdrou… 50c9509d-…
#> 16 1.99e9 Ursus america…            44.9            -62.7 cdrou… 50c9509d-…
#> 17 1.99e9 Ursus america…            40.9           -121.  gass84 50c9509d-…
#> 18 1.99e9 Ursus america…            39.0           -120.  cdrou… 50c9509d-…
#> 19 1.99e9 Ursus america…            38.9           -120.  cdrou… 50c9509d-…
#> 20 1.99e9 Ursus america…            35.6            -82.9 cdrou… 50c9509d-…
#> # … with 68 more variables: publishingOrgKey <chr>, networkKeys <chr>,
#> #   installationKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, acceptedTaxonKey <int>,
#> #   acceptedScientificName <chr>, kingdom <chr>, phylum <chr>,
#> #   order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   taxonomicStatus <chr>, dateIdentified <chr>, stateProvince <chr>,
#> #   year <int>, month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, references <chr>, license <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, rightsHolder <chr>,
#> #   identifier <chr>, verbatimEventDate <chr>, datasetName <chr>,
#> #   gbifID <chr>, verbatimLocality <chr>, collectionCode <chr>,
#> #   occurrenceID <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   institutionCode <chr>, rights <chr>, eventTime <chr>,
#> #   identificationID <chr>, name <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, occurrenceRemarks <chr>,
#> #   infraspecificEpithet <chr>, informationWithheld <chr>
```

Or to be more precise, you can search for names first, make sure you have the right name, then pass the GBIF key to the `occ_search()` function:


```r
key <- name_suggest(q='Helianthus annuus', rank='species')$key[1]
occ_search(taxonKey=key, limit=20)
#> Records found [43757] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [16] 
#> No. facets [0] 
#> Args [limit=20, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 20 x 91
#>       key scientificName decimalLatitude decimalLongitude issues datasetKey
#>     <int> <chr>                    <dbl>            <dbl> <chr>  <chr>     
#>  1 1.99e9 Helianthus an…            34.0           -117.  cdrou… 50c9509d-…
#>  2 1.99e9 Helianthus an…            33.4           -118.  cdrou… 50c9509d-…
#>  3 1.99e9 Helianthus an…            33.8           -118.  cdrou… 50c9509d-…
#>  4 1.99e9 Helianthus an…            53.9             10.9 cdrou… 6ac3f774-…
#>  5 1.99e9 Helianthus an…            27.7            -97.3 cdrou… 50c9509d-…
#>  6 1.99e9 Helianthus an…            52.6             10.1 cdrou… 6ac3f774-…
#>  7 1.99e9 Helianthus an…            26.2            -98.2 cdrou… 50c9509d-…
#>  8 2.01e9 Helianthus an…            31.5            -97.1 cdrou… 50c9509d-…
#>  9 1.99e9 Helianthus an…            29.8            -95.2 cdrou… 50c9509d-…
#> 10 2.01e9 Helianthus an…            31.6           -106.  cdrou… 50c9509d-…
#> 11 2.01e9 Helianthus an…            27.5            -99.5 cdrou… 50c9509d-…
#> 12 1.95e9 Helianthus an…           -37.8            175.  gass84 50c9509d-…
#> 13 1.82e9 Helianthus an…            59.8             17.5 gass84 38b4c89f-…
#> 14 1.95e9 Helianthus an…           -37.8            175.  gass84 50c9509d-…
#> 15 1.82e9 Helianthus an…            56.6             16.4 cdrou… 38b4c89f-…
#> 16 1.84e9 Helianthus an…            34.1           -116.  gass84 50c9509d-…
#> 17 1.82e9 Helianthus an…            56.6             16.6 cdrou… 38b4c89f-…
#> 18 1.81e9 Helianthus an…            25.7           -100.  cdrou… 50c9509d-…
#> 19 1.81e9 Helianthus an…            25.6           -100.  cdrou… 50c9509d-…
#> 20 1.84e9 Helianthus an…            33.9           -117.  cdrou… 50c9509d-…
#> # … with 85 more variables: publishingOrgKey <chr>, networkKeys <chr>,
#> #   installationKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, acceptedTaxonKey <int>,
#> #   acceptedScientificName <chr>, kingdom <chr>, phylum <chr>,
#> #   order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   taxonomicStatus <chr>, dateIdentified <chr>, stateProvince <chr>,
#> #   year <int>, month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, references <chr>, license <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, rightsHolder <chr>,
#> #   identifier <chr>, verbatimEventDate <chr>, datasetName <chr>,
#> #   gbifID <chr>, verbatimLocality <chr>, collectionCode <chr>,
#> #   occurrenceID <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   institutionCode <chr>, rights <chr>, eventTime <chr>,
#> #   identificationID <chr>, name <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, occurrenceRemarks <chr>,
#> #   locality <chr>, individualCount <int>, continent <chr>, county <chr>,
#> #   municipality <chr>, identificationVerificationStatus <chr>,
#> #   language <chr>, type <chr>, occurrenceStatus <chr>,
#> #   vernacularName <chr>, taxonConceptID <chr>, informationWithheld <chr>,
#> #   endDayOfYear <chr>, startDayOfYear <chr>, datasetID <chr>,
#> #   accessRights <chr>, higherClassification <chr>,
#> #   identificationRemarks <chr>, habitat <chr>
```

Like many functions in `rgbif`, you can choose what to return with the `return` parameter, here, just returning the metadata:


```r
occ_search(taxonKey=key, return='meta')
#> # A tibble: 1 x 4
#>   offset limit endOfRecords count
#> *  <int> <int> <lgl>        <int>
#> 1    300   200 FALSE        43757
```

You can choose what fields to return. This isn't passed on to the API query to GBIF as they don't allow that, but we filter out the columns before we give the data back to you.


```r
occ_search(scientificName = "Ursus americanus", fields=c('name','basisOfRecord','protocol'), limit = 20)
#> Records found [12042] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> No. facets [0] 
#> Args [limit=20, offset=0, scientificName=Ursus americanus,
#>      fields=name,basisOfRecord,protocol] 
#> # A tibble: 20 x 2
#>    protocol    basisOfRecord    
#>    <chr>       <chr>            
#>  1 DWC_ARCHIVE HUMAN_OBSERVATION
#>  2 DWC_ARCHIVE HUMAN_OBSERVATION
#>  3 DWC_ARCHIVE HUMAN_OBSERVATION
#>  4 DWC_ARCHIVE HUMAN_OBSERVATION
#>  5 DWC_ARCHIVE HUMAN_OBSERVATION
#>  6 DWC_ARCHIVE HUMAN_OBSERVATION
#>  7 DWC_ARCHIVE HUMAN_OBSERVATION
#>  8 DWC_ARCHIVE HUMAN_OBSERVATION
#>  9 DWC_ARCHIVE HUMAN_OBSERVATION
#> 10 DWC_ARCHIVE HUMAN_OBSERVATION
#> 11 DWC_ARCHIVE HUMAN_OBSERVATION
#> 12 DWC_ARCHIVE HUMAN_OBSERVATION
#> 13 DWC_ARCHIVE HUMAN_OBSERVATION
#> 14 DWC_ARCHIVE HUMAN_OBSERVATION
#> 15 DWC_ARCHIVE HUMAN_OBSERVATION
#> 16 DWC_ARCHIVE HUMAN_OBSERVATION
#> 17 DWC_ARCHIVE HUMAN_OBSERVATION
#> 18 DWC_ARCHIVE HUMAN_OBSERVATION
#> 19 DWC_ARCHIVE HUMAN_OBSERVATION
#> 20 DWC_ARCHIVE HUMAN_OBSERVATION
```

Most parameters are vectorized, so you can pass in more than one value:


```r
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5)
#> Occ. found [2482598 (709564), 9362842 (3822355), 2498387 (1248740)] 
#> Occ. returned [2482598 (5), 9362842 (5), 2498387 (5)] 
#> No. unique hierarchies [2482598 (1), 9362842 (1), 2498387 (1)] 
#> No. media records [2482598 (5), 9362842 (5), 2498387 (5)] 
#> No. facets [2482598 (0), 9362842 (0), 2498387 (0)] 
#> Args [limit=5, offset=0, taxonKey=2482598,9362842,2498387, fields=all] 
#> 3 requests; First 10 rows of data from 2482598
#> 
#> # A tibble: 5 x 71
#>      key scientificName decimalLatitude decimalLongitude issues datasetKey
#>    <int> <chr>                    <dbl>            <dbl> <chr>  <chr>     
#> 1 1.99e9 Cyanocitta st…            16.7            -92.7 cdrou… 50c9509d-…
#> 2 1.99e9 Cyanocitta st…            32.9           -106.  cdrou… 50c9509d-…
#> 3 1.99e9 Cyanocitta st…            32.9           -106.  cdrou… 50c9509d-…
#> 4 1.99e9 Cyanocitta st…            32.9           -106.  cdrou… 50c9509d-…
#> 5 1.99e9 Cyanocitta st…            32.9           -106.  cdrou… 50c9509d-…
#> # … with 65 more variables: publishingOrgKey <chr>, networkKeys <chr>,
#> #   installationKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, acceptedTaxonKey <int>,
#> #   acceptedScientificName <chr>, kingdom <chr>, phylum <chr>,
#> #   order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   taxonomicStatus <chr>, dateIdentified <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, stateProvince <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, references <chr>, license <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, rightsHolder <chr>,
#> #   identifier <chr>, verbatimEventDate <chr>, datasetName <chr>,
#> #   gbifID <chr>, verbatimLocality <chr>, collectionCode <chr>,
#> #   occurrenceID <chr>, taxonID <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   institutionCode <chr>, rights <chr>, eventTime <chr>,
#> #   identificationID <chr>, name <chr>
```


********************

## Maps

Using thet GBIF map web tile service, making a raster and visualizing it.


```r
x <- map_fetch(taxonKey = 2480498, year = 2000:2017)
library(raster)
plot(x)
```

![plot of chunk gbifmap1](figure/gbifmap1-1.png)

[gbifapi]: https://www.gbif.org/developer/summary
