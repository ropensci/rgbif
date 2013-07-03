<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->

rgbif vignette - Seach and retrieve data from the Global Biodiverity Information Facilty (GBIF)
======

### About the package

`rgbif` is an R package to search and retrieve data from the Global Biodiverity Information Facilty (GBIF). `rgbif` wraps R code around the [GBIF API][gbifapi] to allow you to talk to the BISON database from R. 

********************

### Info

XXXX

********************

#### Install rgbif


```r
# install.packages('devtools'); library(devtools);
# install_github('rbison', 'ropensci')
library(rgbif)
library(XML)
library(RCurl)
```

```
Loading required package: bitops
```

```r
library(plyr)
library(ggplot2)
library(maps)
```


********************

#### Get a list of the data networks in GBIF - and you can use the networkkey number to seach for occurrences for the specific provider in other functions


```r
# Test the function for a few networks
networks(maxresults = 5)
```

```
                                           names_ networkkey
1 Biological Collection Access Service for Europe          4
2                                         HerpNET          6
3             Mammal Networked Information System          1
4          Ocean Biogeographic Information System          3
5                         Plant Genetic Resources          2
```

```r

# By name
networks("ORNIS")
```

```
        names_ networkkey
gbifKey  ORNIS          8
```


********************

#### Get a list of the data providers in GBIF - and you can use the dataproviderkey number to seach for occurrences for the specific provider in other functions


```r
# Test the function for a few providers
providers(maxresults = 5)
```

```
                                                       names_
1                                    Białowieża National Park
2                                 Harvard University Herbaria
3 National Museum of Natural History, Smithsonian Institution
4 Reserva Natural de la Sociedad Civil Tenasucá de Pedro Palo
5                                    Université de Strasbourg
  dataproviderkey
1             219
2             214
3             220
4             533
5             215
```

```r

# By data provider name
providers("University of Texas-Austin")
```

```
                            names_ dataproviderkey
gbifKey University of Texas-Austin             192
```


********************

#### Get a list of the data resources in GBIF - and you can use the resourcekey number to seach for occurrences for the specific resource in other functions


```r
# Test the function for a few resources
resources(maxresults = 5)
```

```
                                                                                                          names_
1                 FADA Nematomorpha: World checklist of freshwater Nematomorpha species in the Catalogue of Life
2 HymIS Rhopalosomatidae: Hymenoptera Information System, Rhopalosomatidae of the world in the Catalogue of Life
3                                  WoRMS Gnathostomulida: World list of Gnathostomulida in the Catalogue of Life
4                                           Lista de especies de animales Reserva Natural Tenasucá de Pedro Palo
5                                            Lista de especies de plantas Reserva Natural Tenasucá de Pedro Palo
  resourcekey
1       14909
2       14908
3       14910
4       14906
5       14907
```

```r

# By name
head(resources("Flora"))
```

```
                                                                                                                                         names_
1                                                                                                                              Flora Costa Rica
2                                                                                                              Flora of Japan Specimen Database
3                                                                                                                     Flora of the Stołowe Mts.
4                                                                                                                      Flora Mycologica Iberica
5                                                                                                                   Flora acuática de Querétaro
6 Flora acuática vascular de las regiones hidrológicas R66 (Lagos Cráter del Nevado de Toluca) y R67 (Río Amacuzac-Lagunas de Zempoala), México
  resourcekey
1        8134
2       14644
3       11324
4         252
5       13190
6       13193
```


********************

#### Get number of occurrences for a set of search parameters

```r
occurrencecount(scientificname = "Accipiter erythronemius", coordinatestatus = TRUE)
```

```
[1] 12
```

```r
occurrencecount(scientificname = "Helianthus annuus", coordinatestatus = TRUE, 
    year = 2005, maxlatitude = 20)
```

```
[1] 129
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

#### Seach by taxon to retrieve number of records per taxon found in GBIF

```r
taxoncount(scientificname = "Puma concolor")
```

```
[1] 87
```

```r
taxoncount(scientificname = "Helianthus annuus")
```

```
[1] 138
```

```r
taxoncount(rank = "family")
```

```
[1] 474730
```


********************

#### Get taxonomic information on a specific taxon or taxa in GBIF by their taxon concept keys


```r
out <- taxonsearch(scientificname = "Puma concolor")
head(taxonget(out$gbifkey[[3]]))
```

```
      sciname taxonconceptkeys    rank
1    Protozoa                7 kingdom
2  Acritarcha              107  phylum
3 Apicomplexa               57  phylum
4    Cercozoa               38  phylum
5   Choanozoa               97  phylum
6  Ciliophora               10  phylum
```


********************

#### Search for taxa in GBIF


```r
taxonsearch(scientificname = "Puma concolor", rank = "species", maxresults = 10)
```

```
    gbifkey      status          name    rank  sci
1  51665069 unconfirmed Puma concolor species true
2  50010499 unconfirmed Puma concolor species true
3  51680225 unconfirmed Puma concolor species true
4  51043628 unconfirmed Puma concolor species true
5  51697831 unconfirmed Puma Concolor species true
6  61655924 unconfirmed Puma Concolor species true
7  61655934 unconfirmed Puma Concolor species true
8  51052820 unconfirmed Puma concolor species true
9  50374614 unconfirmed Puma Concolor species true
10 50289443 unconfirmed Puma concolor species true
                                        source primary
1                            Mammals Specimens    true
2                Macaulay Library - Audio Data    true
3                            Mammals specimens    true
4                         Vertebrate specimens    true
5                             Mammal specimens    true
6  Mammalogy Collection - Royal Ontario Museum    true
7  Mammalogy Collection - Royal Ontario Museum    true
8                             Mammal specimens    true
9                                      mammals    true
10                            Mammal Specimens    true
```

```r
taxonsearch(scientificname = "Puma concolor", rank = "species", dataproviderkey = 1)
```

```
  gbifkey   status          name    rank  sci                 source
1 2435099 accepted Puma concolor species true GBIF Backbone Taxonomy
  primary
1    true
```


********************

#### Get data for a single occurrence. Note that data is returned as a list, so you have to convert to a data.frame, etc. as you wish

```r
occurrenceget(key = 13749100)
```

```
$dataProvider
$dataProvider$name
[1] "Biologiezentrum Linz Oberoesterreich"

$dataProvider$dataResources
$dataProvider$dataResources$dataResource
$dataProvider$dataResources$dataResource$name
[1] "Biologiezentrum Linz"

$dataProvider$dataResources$dataResource$rights
[1] "free"

$dataProvider$dataResources$dataResource$citation
[1] "Biologiezentrum Linz Oberoesterreich: Biologiezentrum Linz"

$dataProvider$dataResources$dataResource$occurrenceRecords
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$catalogNumber
[1] "1687588"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$collectionCode
[1] "Biologiezentrum Linz"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$coordinateUncertaintyInMeters
[1] "500"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$country
[1] "AUT"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$decimalLatitude
[1] "47.81"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$decimalLongitude
[1] "13.98"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$institutionCode
[1] "LI"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$minimumElevationInMeters
[1] "1506"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$earliestDateCollected
[1] "1947-09-27"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$latestDateCollected
[1] "1947-09-27"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon$TaxonConcept
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon$TaxonConcept$hasName
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon$TaxonConcept$hasName$TaxonName
$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon$TaxonConcept$hasName$TaxonName$nameComplete
[1] "Oxytelus laqueatus Marsham"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon$TaxonConcept$hasName$TaxonName$scientific
[1] "true"



$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxon$TaxonConcept$.attrs
                                         gbifKey 
                                       "1039975" 
                                           about 
"http://data.gbif.org/ws/rest/taxon/get/1039975" 
attr(,"namespaces")
                                            
                                         "" 
http://www.w3.org/1999/02/22-rdf-syntax-ns# 
                                      "rdf" 



$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$identifiedTo$Identification$taxonName
[1] "Oxytelus laqueatus Marsham"



$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$locality
[1] "Kasberghütte= E484"

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$gbifNotes
[1] "Data from GBIF data index - original values."

$dataProvider$dataResources$dataResource$occurrenceRecords$TaxonOccurrence$.attrs
                                               gbifKey 
                                            "13749100" 
                                                 about 
"http://data.gbif.org/ws/rest/occurrence/get/13749100" 
attr(,"namespaces")
                                            
                                         "" 
http://www.w3.org/1999/02/22-rdf-syntax-ns# 
                                      "rdf" 



$dataProvider$dataResources$dataResource$.attrs
                                         gbifKey 
                                          "1104" 
                                           about 
"http://data.gbif.org/ws/rest/resource/get/1104" 
attr(,"namespaces")
                                            
                                         "" 
http://www.w3.org/1999/02/22-rdf-syntax-ns# 
                                      "rdf" 



$dataProvider$.attrs
                                       gbifKey 
                                          "16" 
                                         about 
"http://data.gbif.org/ws/rest/provider/get/16" 
attr(,"namespaces")
                                            
                                         "" 
http://www.w3.org/1999/02/22-rdf-syntax-ns# 
                                      "rdf" 
```


********************


```r
out <- occurrencelist(scientificname = "Puma concolor", coordinatestatus = TRUE, 
    maxresults = 20)
```


Note that the default object printed from a call to `occurrencelist` is a list that contains:

+ NumberFound: number of occurrences found in search results.
+ TaxonNames: Unique list of taxonomic names in search results.
+ Coordinates: Min and max latitude and longitude of all occurrences.
+ Countries: Countries contained in results set.


```r
out
```

```
$NumberFound
[1] 20

$TaxonNames
[1] "PUMA CONCOLOR"     "PUMA ? CONCOLOR ?"

$Coordinates
         Stats         numbers
1  MinLatitude         2.58333
2  MaxLatitude       6.3166667
3 MinLongitude -121.4166666667
4 MaxLongitude           -71.9

$Countries
[1] "GUYANA" "CANADA"
```


Where do you get data after a call to the `occurrencelist` function? This is where `gbifdata` comes in. By default a call to `gbifdata` prints a minimal data.frame with just rows *name*, *latitude*, and *longitude*.


```r
gbifdata(out)
```

```
           taxonName decimalLatitude decimalLongitude
1      Puma concolor           2.833           -59.52
2      Puma concolor          49.017          -122.78
3      Puma concolor          45.383           -71.90
4      Puma concolor           6.317           -60.27
5      Puma concolor           2.583           -59.93
6      Puma concolor           6.317           -60.27
7      Puma concolor          45.383           -71.90
8      Puma concolor          49.750          -126.75
9      Puma concolor          52.333          -121.42
10     Puma concolor           2.833           -59.52
11     Puma concolor           2.833           -59.52
12     Puma concolor          49.600          -126.62
13 Puma ? concolor ?          45.850           -66.23
14     Puma concolor           2.833           -59.52
15     Puma concolor          49.600          -126.57
16     Puma concolor           2.945           -59.25
17     Puma concolor           6.317           -60.27
18     Puma concolor           2.833           -59.52
19     Puma concolor           2.583           -59.93
20     Puma concolor           3.091           -59.26
```


Though you can get more detailed data by calling *minimal=FALSE*.


```r
gbifdata(out, minimal = FALSE)
```

```
           taxonName country decimalLatitude decimalLongitude
1      Puma concolor  GUYANA           2.833           -59.52
2      Puma concolor  CANADA          49.017          -122.78
3      Puma concolor  CANADA          45.383           -71.90
4      Puma concolor  GUYANA           6.317           -60.27
5      Puma concolor  GUYANA           2.583           -59.93
6      Puma concolor  GUYANA           6.317           -60.27
7      Puma concolor  CANADA          45.383           -71.90
8      Puma concolor  CANADA          49.750          -126.75
9      Puma concolor  CANADA          52.333          -121.42
10     Puma concolor  GUYANA           2.833           -59.52
11     Puma concolor  GUYANA           2.833           -59.52
12     Puma concolor  CANADA          49.600          -126.62
13 Puma ? concolor ?  CANADA          45.850           -66.23
14     Puma concolor  GUYANA           2.833           -59.52
15     Puma concolor  CANADA          49.600          -126.57
16     Puma concolor  GUYANA           2.945           -59.25
17     Puma concolor  GUYANA           6.317           -60.27
18     Puma concolor  GUYANA           2.833           -59.52
19     Puma concolor  GUYANA           2.583           -59.93
20     Puma concolor  GUYANA           3.091           -59.26
   catalogNumber earliestDateCollected latestDateCollected
1          50431                    NA                  NA
2     3502070001                    NA                  NA
3          15709                    NA                  NA
4          34303                    NA                  NA
5          46326                    NA                  NA
6          34302                    NA                  NA
7          15709                    NA                  NA
8     3409210005                    NA                  NA
9          30415                    NA                  NA
10         32234                    NA                  NA
11         32499                    NA                  NA
12    3309250001                    NA                  NA
13         25844                    NA                  NA
14         32233                    NA                  NA
15    3305050003                    NA                  NA
16         32083                    NA                  NA
17         34301                    NA                  NA
18         50431                    NA                  NA
19         46324                    NA                  NA
20         32395                    NA                  NA
```


And you can get all possible data by specifying *format=darwin*.


```r
out <- occurrencelist(scientificname = "Puma concolor", coordinatestatus = TRUE, 
    format = "darwin", maxresults = 20)
gbifdata(out, minimal = FALSE)
```

```
           taxonName country                stateProvince  county
1      Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
2      Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
3      Puma concolor  CANADA             BRITISH COLUMBIA    <NA>
4  Puma ? concolor ?  CANADA                NEW BRUNSWICK SUNBURY
5      Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
6      Puma concolor  CANADA                       QUEBEC    <NA>
7      Puma concolor  CANADA             BRITISH COLUMBIA CARIBOO
8      Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
9      Puma concolor  CANADA             BRITISH COLUMBIA    <NA>
10     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
11     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
12     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
13     Puma concolor  CANADA             BRITISH COLUMBIA    <NA>
14     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
15     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
16     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
17     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
18     Puma concolor  CANADA                       QUEBEC    <NA>
19     Puma concolor  GUYANA UPPER TAKUTU-UPPER ESSEQUIBO    <NA>
20     Puma concolor  CANADA             BRITISH COLUMBIA    <NA>
         locality decimalLatitude decimalLongitude
1            <NA>           2.833           -59.52
2            <NA>           3.091           -59.26
3            <NA>          49.600          -126.62
4            <NA>          45.850           -66.23
5            <NA>           2.833           -59.52
6            <NA>          45.383           -71.90
7            <NA>          52.333          -121.42
8            <NA>           6.317           -60.27
9            <NA>          49.600          -126.57
10           <NA>           2.583           -59.93
11           <NA>           6.317           -60.27
12           <NA>           2.833           -59.52
13           <NA>          49.750          -126.75
14           <NA>           2.945           -59.25
15           <NA>           6.317           -60.27
16           <NA>           2.583           -59.93
17           <NA>           2.833           -59.52
18     SHERBROOKE          45.383           -71.90
19 DADANAWA RANCH           2.833           -59.52
20 CAMPBELL RIVER          49.017          -122.78
   coordinateUncertaintyInMeters maximumElevationInMeters
1                          2.143                       NA
2                          9.978                       NA
3                             NA                       NA
4                             NA                       NA
5                          2.143                       NA
6                             NA                       NA
7                             NA                       NA
8                         57.262                       NA
9                             NA                       NA
10                         2.857                       NA
11                        57.262                       NA
12                         2.143                       NA
13                            NA                       NA
14                         4.935                       NA
15                        57.262                       NA
16                         2.857                       NA
17                         2.143                       NA
18                            NA                       NA
19                      3772.302                       NA
20                            NA                       NA
   minimumElevationInMeters maximumDepthInMeters minimumDepthInMeters
1                        NA                   NA                   NA
2                        NA                   NA                   NA
3                        NA                   NA                   NA
4                        NA                   NA                   NA
5                        NA                   NA                   NA
6                        NA                   NA                   NA
7                        NA                   NA                   NA
8                        NA                   NA                   NA
9                        NA                   NA                   NA
10                       NA                   NA                   NA
11                       NA                   NA                   NA
12                       NA                   NA                   NA
13                       NA                   NA                   NA
14                       NA                   NA                   NA
15                       NA                   NA                   NA
16                       NA                   NA                   NA
17                       NA                   NA                   NA
18                       NA                   NA                   NA
19                       NA                   NA                   NA
20                       NA                   NA                   NA
             institutionCode collectionCode catalogNumber
1  Royal Ontario Museum: ROM        Mammals         50431
2  Royal Ontario Museum: ROM        Mammals         32395
3  Royal Ontario Museum: ROM        Mammals    3309250001
4  Royal Ontario Museum: ROM        Mammals         25844
5  Royal Ontario Museum: ROM        Mammals         32499
6  Royal Ontario Museum: ROM        Mammals         15709
7  Royal Ontario Museum: ROM        Mammals         30415
8  Royal Ontario Museum: ROM        Mammals         34301
9  Royal Ontario Museum: ROM        Mammals    3305050003
10 Royal Ontario Museum: ROM        Mammals         46324
11 Royal Ontario Museum: ROM        Mammals         34302
12 Royal Ontario Museum: ROM        Mammals         32233
13 Royal Ontario Museum: ROM        Mammals    3409210005
14 Royal Ontario Museum: ROM        Mammals         32083
15 Royal Ontario Museum: ROM        Mammals         34303
16 Royal Ontario Museum: ROM        Mammals         46326
17 Royal Ontario Museum: ROM        Mammals         32234
18                       ROM        Mammals         15709
19                       ROM        Mammals         50431
20                       ROM        Mammals    3502070001
   basisOfRecordString          collector earliestDateCollected
1    PreservedSpecimen         MARQUES, J                  <NA>
2    PreservedSpecimen          BROCK, SE                  <NA>
3    PreservedSpecimen           HART, JL                  <NA>
4    PreservedSpecimen         WRIGHT, BS                  <NA>
5    PreservedSpecimen          BROCK, SE                  <NA>
6    PreservedSpecimen        FLEMING, JH                  <NA>
7    PreservedSpecimen          MUNRO, JA                  <NA>
8    PreservedSpecimen          BROCK, SE                  <NA>
9    PreservedSpecimen            UNKNOWN                  <NA>
10   PreservedSpecimen          BROCK, SE                  <NA>
11   PreservedSpecimen          BROCK, SE                  <NA>
12   PreservedSpecimen          BROCK, SE                  <NA>
13   PreservedSpecimen WALSH, W; HART, JL                  <NA>
14   PreservedSpecimen          BROCK, SE                  <NA>
15   PreservedSpecimen          BROCK, SE                  <NA>
16   PreservedSpecimen          BROCK, SE                  <NA>
17   PreservedSpecimen          BROCK, SE                  <NA>
18             voucher        FLEMING, JH                  <NA>
19             voucher         MARQUES, J                  <NA>
20             voucher            UNKNOWN                  <NA>
   latestDateCollected                                    gbifNotes
1                 <NA> Data from GBIF data index - original values.
2                 <NA> Data from GBIF data index - original values.
3                 <NA> Data from GBIF data index - original values.
4                 <NA> Data from GBIF data index - original values.
5                 <NA> Data from GBIF data index - original values.
6                 <NA> Data from GBIF data index - original values.
7                 <NA> Data from GBIF data index - original values.
8                 <NA> Data from GBIF data index - original values.
9                 <NA> Data from GBIF data index - original values.
10                <NA> Data from GBIF data index - original values.
11                <NA> Data from GBIF data index - original values.
12                <NA> Data from GBIF data index - original values.
13                <NA> Data from GBIF data index - original values.
14                <NA> Data from GBIF data index - original values.
15                <NA> Data from GBIF data index - original values.
16                <NA> Data from GBIF data index - original values.
17                <NA> Data from GBIF data index - original values.
18                <NA> Data from GBIF data index - original values.
19                <NA> Data from GBIF data index - original values.
20                <NA> Data from GBIF data index - original values.
```


********************

#### Maps

##### inspect summary

********************

[gbifapi]: http://data.gbif.org/tutorial/services
