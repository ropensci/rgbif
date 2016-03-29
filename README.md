rgbif
=====



[![Build Status](https://api.travis-ci.org/ropensci/rgbif.png?branch=master)](https://travis-ci.org/ropensci/rgbif)
[![Build status](https://ci.appveyor.com/api/projects/status/jili6du1ssi4ktbg/branch/master)](https://ci.appveyor.com/project/sckott/rgbif/branch/master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rgbif)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rgbif)](https://cran.r-project.org/package=rgbif)

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
#> Records found [7760] 
#> Records returned [50] 
#> No. unique hierarchies [1] 
#> No. media records [44] 
#> Args [scientificName=Ursus americanus, limit=50, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                name        key decimalLatitude decimalLongitude
#> 1  Ursus americanus 1249277297        35.76789        -75.80894
#> 2  Ursus americanus 1229610234        44.06062        -71.92692
#> 3  Ursus americanus 1253300445        44.65481        -72.67270
#> 4  Ursus americanus 1229610216        44.06086        -71.92712
#> 5  Ursus americanus 1249284297        43.68723        -72.32891
#> 6  Ursus americanus 1249296297        39.08590       -105.24586
#> 7  Ursus americanus 1253314877        49.25782       -122.82786
#> 8  Ursus americanus 1253317181        43.64214        -72.52494
#> 9  Ursus americanus 1257415362        44.32746        -72.41007
#> 10 Ursus americanus 1065590124        38.36662        -79.68283
#> ..              ...        ...             ...              ...
#> Variables not shown: issues (chr), datasetKey (chr), publishingOrgKey
#>      (chr), publishingCountry (chr), protocol (chr), lastCrawled (chr),
#>      lastParsed (chr), extensions (chr), basisOfRecord (chr), taxonKey
#>      (int), kingdomKey (int), phylumKey (int), classKey (int), orderKey
#>      (int), familyKey (int), genusKey (int), speciesKey (int),
#>      scientificName (chr), kingdom (chr), phylum (chr), order (chr),
#>      family (chr), genus (chr), species (chr), genericName (chr),
#>      specificEpithet (chr), infraspecificEpithet (chr), taxonRank (chr),
#>      dateIdentified (chr), year (int), month (int), day (int), eventDate
#>      (chr), modified (chr), lastInterpreted (chr), references (chr),
#>      identifiers (chr), facts (chr), relations (chr), geodeticDatum (chr),
#>      class (chr), countryCode (chr), country (chr), rightsHolder (chr),
#>      identifier (chr), verbatimEventDate (chr), datasetName (chr), gbifID
#>      (chr), verbatimLocality (chr), collectionCode (chr), occurrenceID
#>      (chr), taxonID (chr), license (chr), recordedBy (chr), catalogNumber
#>      (chr), http...unknown.org.occurrenceDetails (chr), institutionCode
#>      (chr), rights (chr), identificationID (chr), eventTime (chr),
#>      occurrenceRemarks (chr), coordinateAccuracy (dbl),
#>      coordinateAccuracyInMeters (dbl), informationWithheld (chr)
```

Or you can get the taxon key first with `name_backbone()`. Here, we select to only return the occurrence data.


```r
key <- name_backbone(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=20)
#> Records found [21737] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [11] 
#> Args [taxonKey=3119195, limit=20, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                 name        key decimalLatitude decimalLongitude
#> 1  Helianthus annuus 1249279611        34.04810       -117.79884
#> 2  Helianthus annuus 1249286909        32.58747        -97.10081
#> 3  Helianthus annuus 1253308332        29.67463        -95.44804
#> 4  Helianthus annuus 1143516596        35.42767       -105.06884
#> 5  Helianthus annuus 1095851641         0.00000          0.00000
#> 6  Helianthus annuus 1088900309        33.95239       -117.32011
#> 7  Helianthus annuus 1135523136        33.96709       -117.99769
#> 8  Helianthus annuus 1088944416        26.20518        -98.26725
#> 9  Helianthus annuus 1135826959              NA               NA
#> 10 Helianthus annuus 1092889365        32.71840       -114.75603
#> ..               ...        ...             ...              ...
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
#>      verbatimLocality (chr), collectionCode (chr), occurrenceID (chr),
#>      taxonID (chr), license (chr), recordedBy (chr), catalogNumber (chr),
#>      http...unknown.org.occurrenceDetails (chr), institutionCode (chr),
#>      rights (chr), eventTime (chr), identificationID (chr),
#>      coordinateAccuracy (dbl), coordinateAccuracyInMeters (dbl),
#>      occurrenceRemarks (chr), elevation (dbl), elevationAccuracy (dbl),
#>      stateProvince (chr), recordNumber (chr), municipality (chr), locality
#>      (chr), language (chr), type (chr), ownerInstitutionCode (chr),
#>      identifiedBy (chr), nomenclaturalCode (chr), institutionID (chr),
#>      dataGeneralizations (chr), footprintWKT (chr), county (chr),
#>      occurrenceStatus (chr), footprintSRS (chr), higherClassification
#>      (chr), collectionID (chr), informationWithheld (chr), depth (dbl),
#>      depthAccuracy (dbl)
```

## Search for many species

Get the keys first with `name_backbone()`, then pass to `occ_search()`


```r
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_backbone(name=x)$speciesKey, USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5, hasCoordinate=TRUE)
#> Occ. found [2480598 (21), 2492010 (2454289), 2498387 (772636)] 
#> Occ. returned [2480598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2480598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2480598 (1), 2492010 (4), 2498387 (5)] 
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
#>      verbatimElevation (chr), recordNumber (chr), nomenclaturalCode (chr),
#>      higherGeography (chr), verbatimEventDate (chr),
#>      georeferenceVerificationStatus (chr), datasetName (chr),
#>      occurrenceRemarks (chr), accessRights (chr), bibliographicCitation
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
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

- - -

This package is part of a richer suite called [SPOCC Species Occurrence Data](https://github.com/ropensci/spocc), along with several other packages, that provide access to occurrence records from multiple databases.

- - -

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
