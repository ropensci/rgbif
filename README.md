rgbif
=====



[![Build Status](https://api.travis-ci.org/ropensci/rgbif.png?branch=master)](https://travis-ci.org/ropensci/rgbif)
[![Build status](https://ci.appveyor.com/api/projects/status/jili6du1ssi4ktbg/branch/master)](https://ci.appveyor.com/project/sckott/rgbif/branch/master)
[![Coverage Status](https://coveralls.io/repos/ropensci/rgbif/badge.svg)](https://coveralls.io/r/ropensci/rgbif)

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
#> Records found [6890] 
#> Records returned [50] 
#> No. unique hierarchies [1] 
#> No. media records [50] 
#> Args [scientificName=Ursus americanus, limit=50, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                name        key decimalLatitude decimalLongitude
#> 1  Ursus americanus  891034709        29.23322       -103.29468
#> 2  Ursus americanus 1024328693        34.20990       -118.14681
#> 3  Ursus americanus  891045574        43.73511        -72.52534
#> 4  Ursus americanus  891041363        29.28284       -103.28908
#> 5  Ursus americanus 1050834838        33.11070       -107.70675
#> 6  Ursus americanus  891056344        29.27444       -103.31536
#> 7  Ursus americanus 1042823202        44.34088        -72.46131
#> 8  Ursus americanus 1024180980        34.56844       -119.16081
#> 9  Ursus americanus 1024182262        50.09019       -117.46038
#> 10 Ursus americanus 1024328712        39.51185       -120.16434
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
#>      (chr), country (chr), verbatimEventDate (chr),
#>      http...unknown.org.occurrenceDetails (chr), rights (chr),
#>      rightsHolder (chr), occurrenceID (chr), collectionCode (chr), taxonID
#>      (chr), gbifID (chr), institutionCode (chr), datasetName (chr),
#>      catalogNumber (chr), recordedBy (chr), eventTime (chr), identifier
#>      (chr), identificationID (chr), infraspecificEpithet (chr),
#>      verbatimLocality (chr), occurrenceRemarks (chr), lifeStage (chr),
#>      elevation (dbl), elevationAccuracy (dbl), continent (chr),
#>      stateProvince (chr), georeferencedDate (chr), institutionID (chr),
#>      higherGeography (chr), type (chr), georeferenceSources (chr),
#>      identifiedBy (chr), identificationVerificationStatus (chr),
#>      samplingProtocol (chr), endDayOfYear (chr), otherCatalogNumbers
#>      (chr), preparations (chr), georeferenceVerificationStatus (chr),
#>      individualID (chr), nomenclaturalCode (chr), higherClassification
#>      (chr), locationAccordingTo (chr), verbatimCoordinateSystem (chr),
#>      previousIdentifications (chr), georeferenceProtocol (chr),
#>      identificationQualifier (chr), accessRights (chr), county (chr),
#>      dynamicProperties (chr), locality (chr), language (chr),
#>      georeferencedBy (chr), informationWithheld (chr)
```

Or you can get the taxon key first with `name_backbone()`. Here, we select to only return the occurrence data.


```r
key <- name_backbone(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=20)
#> Records found [20365] 
#> Records returned [20] 
#> No. unique hierarchies [1] 
#> No. media records [11] 
#> Args [taxonKey=3119195, limit=20, offset=0, fields=all] 
#> First 10 rows of data
#> 
#>                 name        key decimalLatitude decimalLongitude
#> 1  Helianthus annuus  922042404        -3.28140         37.52415
#> 2  Helianthus annuus  899948224         1.27890        103.79930
#> 3  Helianthus annuus  891052261        24.82589        -99.58411
#> 4  Helianthus annuus 1038317691       -43.52777        172.62544
#> 5  Helianthus annuus  922044332        21.27114         40.41424
#> 6  Helianthus annuus  922039507        50.31402          8.52341
#> 7  Helianthus annuus  998785009        44.10879          4.66839
#> 8  Helianthus annuus  899970378        32.54041       -117.08731
#> 9  Helianthus annuus  899969160        24.82901        -99.58257
#> 10 Helianthus annuus 1054796860        33.74417       -117.38556
#> ..               ...        ...             ...              ...
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
#>      countryCode (chr), country (chr), gbifID (chr), institutionCode
#>      (chr), catalogNumber (chr), recordedBy (chr), locality (chr),
#>      collectionCode (chr), dateIdentified (chr), modified (chr),
#>      references (chr), verbatimEventDate (chr), verbatimLocality (chr),
#>      http...unknown.org.occurrenceDetails (chr), rights (chr),
#>      rightsHolder (chr), occurrenceID (chr), taxonID (chr),
#>      occurrenceRemarks (chr), datasetName (chr), eventTime (chr),
#>      identifier (chr), identificationID (chr), county (chr), identifiedBy
#>      (chr), stateProvince (chr), recordNumber (chr), verbatimElevation
#>      (chr), georeferenceSources (chr), coordinateAccuracy (dbl), elevation
#>      (dbl), elevationAccuracy (dbl), depth (dbl), depthAccuracy (dbl)
```

## Search for many species

Get the keys first with `name_backbone()`, then pass to `occ_search()`


```r
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_backbone(name=x)$speciesKey, USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5, hasCoordinate=TRUE)
#> Occ. found [2480598 (20), 2492010 (1925244), 2498387 (589710)] 
#> Occ. returned [2480598 (5), 2492010 (5), 2498387 (5)] 
#> No. unique hierarchies [2480598 (1), 2492010 (1), 2498387 (1)] 
#> No. media records [2480598 (1), 2492010 (5), 2498387 (2)] 
#> Args [taxonKey=2480598,2492010,2498387, hasCoordinate=TRUE, limit=5,
#>      offset=0, fields=all] 
#> First 10 rows of data from 2480598
#> 
#>                      name        key decimalLatitude decimalLongitude
#> 1 Accipiter erythronemius  920184036       -20.76029        -56.71314
#> 2 Accipiter erythronemius  920169861       -20.55244        -56.64104
#> 3 Accipiter erythronemius 1001096527       -27.58000        -58.66000
#> 4 Accipiter erythronemius 1001096518       -27.92000        -59.14000
#> 5 Accipiter erythronemius  699417490         5.26667        -60.73333
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
#>      countryCode (chr), country (chr), gbifID (chr), institutionCode
#>      (chr), catalogNumber (chr), recordedBy (chr), locality (chr),
#>      collectionCode (chr), modified (chr), created (chr),
#>      higherClassification (chr), associatedSequences (chr), occurrenceID
#>      (chr), identifier (chr), taxonID (chr), sex (chr), elevation (dbl),
#>      elevationAccuracy (dbl), recordNumber (chr), institutionID (chr),
#>      rights (chr), higherGeography (chr), type (chr), georeferenceSources
#>      (chr), otherCatalogNumbers (chr), bibliographicCitation (chr),
#>      verbatimEventDate (chr), preparations (chr),
#>      georeferenceVerificationStatus (chr), occurrenceRemarks (chr),
#>      accessRights (chr), datasetName (chr), verbatimElevation (chr),
#>      language (chr)
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
