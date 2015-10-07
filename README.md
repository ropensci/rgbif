rgbif
=====



[![Build Status](https://api.travis-ci.org/ropensci/rgbif.png?branch=master)](https://travis-ci.org/ropensci/rgbif)
[![Build status](https://ci.appveyor.com/api/projects/status/jili6du1ssi4ktbg/branch/master)](https://ci.appveyor.com/project/sckott/rgbif/branch/master)
[![codecov.io](https://codecov.io/github/ropensci/rgbif/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rgbif?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rgbif)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rgbif)](http://cran.rstudio.com/web/packages/rgbif)

`rgbif` gives you access to data from [GBIF](http://www.gbif.org/) via their REST API. GBIF versions their API - we are currently using `v1` of their API. You can no longer use their old API in this package - see `?rgbif-defunct`.

## Installation


```r
install.packages("rgbif")
```

Alternatively, install development version


```r
install.packages("devtools")
devtools::install_github("ropensci/rgbif")
```


```r
library("rgbif")
```

> Note: Windows users have to first install [Rtools](http://cran.r-project.org/bin/windows/Rtools/) to use devtools

## Search for occurrence data


```r
occ_search(scientificName = "Ursus americanus", limit = 50)
#> Records found [7293] 
#> Records returned [50] 
#> No. unique hierarchies [1] 
#> No. media records [50] 
#> Args [scientificName=Ursus americanus, limit=50, offset=0, fields=all] 
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

Or you can get the taxon key first with `name_backbone()`. Here, we select to only return the occurrence data.


```r
key <- name_backbone(name='Helianthus annuus', kingdom='plants')$speciesKey
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

## Search for many species

Get the keys first with `name_backbone()`, then pass to `occ_search()`


```r
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_backbone(name=x)$speciesKey, USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5, hasCoordinate=TRUE)
#> Occ. found [2480598 (20), 2492010 (1925796), 2498387 (590036)] 
#> Occ. returned [2480598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2480598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2480598 (1), 2492010 (5), 2498387 (5)] 
#> Args [taxonKey=2480598,2492010,2498387, hasCoordinate=TRUE, limit=5,
#>      offset=0, fields=all] 
#> First 10 rows of data from 2480598
#> 
#>                      name        key decimalLatitude decimalLongitude
#> 1 Accipiter erythronemius  920184036       -20.76029        -56.71314
#> 2 Accipiter erythronemius  920169861       -20.55244        -56.64104
#> 3 Accipiter erythronemius 1001096527       -27.58000        -58.66000
#> 4 Accipiter erythronemius 1001096518       -27.92000        -59.14000
#> 5 Accipiter erythronemius  686297260         5.26667        -60.73333
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
#>      countryCode (chr), country (chr), recordedBy (chr), catalogNumber
#>      (chr), institutionCode (chr), locality (chr), collectionCode (chr),
#>      gbifID (chr), modified (chr), identifier (chr), created (chr),
#>      occurrenceID (chr), associatedSequences (chr), taxonID (chr),
#>      higherClassification (chr), sex (chr), elevation (dbl),
#>      elevationAccuracy (dbl), institutionID (chr), dynamicProperties
#>      (chr), language (chr), type (chr), preparations (chr), rights (chr),
#>      verbatimElevation (chr), recordNumber (chr), verbatimEventDate (chr),
#>      higherGeography (chr), nomenclaturalCode (chr),
#>      georeferenceVerificationStatus (chr), datasetName (chr),
#>      occurrenceRemarks (chr), bibliographicCitation (chr), accessRights
#>      (chr), collectionID (chr), georeferenceSources (chr)
```

## Maps

Make a simple map of species occurrences.


```r
splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_backbone(name=x)$speciesKey, USE.NAMES=FALSE)
dat <- occ_search(taxonKey=keys, limit=100, return='data', hasCoordinate=TRUE)
library('plyr')
datdf <- ldply(dat)
gbifmap(datdf)
```

![plot of chunk unnamed-chunk-8](inst/assets/img/unnamed-chunk-8-1.png) 

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rgbif/issues).
* License: MIT
* Get citation information for `rgbif` in R doing `citation(package = 'rgbif')`

- - -

This package is part of a richer suite called [SPOCC Species Occurrence Data](https://github.com/ropensci/spocc), along with several other packages, that provide access to occurrence records from multiple databases.

- - -

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
