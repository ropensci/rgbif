rgbif
=====



[![Build Status](https://travis-ci.org/ropensci/rgbif.svg?branch=master)](https://travis-ci.org/ropensci/rgbif)
[![codecov.io](https://codecov.io/github/ropensci/rgbif/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rgbif?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rgbif)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rgbif)](https://cran.r-project.org/package=rgbif)

`rgbif` gives you access to data from [GBIF](http://www.gbif.org/) via their REST API. GBIF versions their API - we are currently using `v1` of their API. You can no longer use their old API in this package - see `?rgbif-defunct`.

Tutorials:

* [rgbif vignette - the intro to the package](vignettes/rgbif_vignette.Rmd)
* [issues vignette - how to clean GBIF data](vignettes/issues_vignette.Rmd)
* [taxonomic names - examples of some confusing bits](vignettes/taxonomic_names.Rmd)

## Package API

The `rgbif` package API follows the GBIF API, which has the following sections:

* `registry` (<http://www.gbif.org/developer/registry>) - Metadata on datasets, and
contributing organizations, installations, networks, and nodes
    * `rgbif` functions: `dataset_metrics()`, `dataset_search()`, `dataset_suggest()`,
    `datasets()`, `enumeration()`, `enumeration_country()`, `installations()`, `networks()`,
    `nodes()`, `organizations()`
    * Registry also includes the GBIF OAI-PMH service, which includes GBIF registry
    data only. `rgbif` functions: `gbif_oai_get_records()`, `gbif_oai_identify()`,
    `gbif_oai_list_identifiers()`, `gbif_oai_list_metadataformats()`,
    `gbif_oai_list_records()`, `gbif_oai_list_sets()`
* `species` (<http://www.gbif.org/developer/species>) - Species names and metadata
    * `rgbif` functions: `name_backbone()`, `name_lookup()`, `name_suggest()`, `name_usage()`
* `occurrences` (<http://www.gbif.org/developer/occurrence>) - Occurrences, both for
the search and download APIs
    * `rgbif` functions: `occ_count()`, `occ_data()`, `occ_download()`, `occ_download_cancel()`,
    `occ_download_cancel_staged()`, `occ_download_get()`, `occ_download_import()`,
    `occ_download_list()`, `occ_download_meta()`, `occ_get()`, `occ_issues()`,
    `occ_issues_lookup()`, `occ_metadata()`, `occ_search()`

The GBIF `maps` API (<http://www.gbif.org/developer/maps>) is not implemented in `rgbif`,
and are meant more for intergration with web based maps.

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

> Note: Windows users have to first install [Rtools](https://cran.r-project.org/bin/windows/Rtools/) to use devtools

Mac Users:
(in case of errors)

Terminal:

Install gdal : https://github.com/edzer/sfr/blob/master/README.md#macos


```r
brew install openssl
```
R terminal:

```r
install.packages('openssl')
install.packages('rgeos')
install.packages('rgbif')
```
## Search for occurrence data


```r
occ_search(scientificName = "Ursus americanus", limit = 50)
#> Records found [8707]
#> Records returned [50]
#> No. unique hierarchies [1]
#> No. media records [28]
#> No. facets [0]
#> Args [limit=50, offset=0, scientificName=Ursus americanus, fields=all]
#> # A tibble: 50 × 68
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
#> # ... with 40 more rows, and 64 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, genericName <chr>,
#> #   specificEpithet <chr>, taxonRank <chr>, dateIdentified <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, year <int>, month <int>,
#> #   day <int>, eventDate <chr>, modified <chr>, lastInterpreted <chr>,
#> #   references <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, rightsHolder <chr>, identifier <chr>,
#> #   verbatimEventDate <chr>, datasetName <chr>, collectionCode <chr>,
#> #   gbifID <chr>, verbatimLocality <chr>, occurrenceID <chr>,
#> #   taxonID <chr>, catalogNumber <chr>, recordedBy <chr>,
#> #   http...unknown.org.occurrenceDetails <chr>, institutionCode <chr>,
#> #   rights <chr>, eventTime <chr>, occurrenceRemarks <chr>,
#> #   identificationID <chr>, infraspecificEpithet <chr>,
#> #   informationWithheld <chr>
```

Or you can get the taxon key first with `name_backbone()`. Here, we select to only return the occurrence data.


```r
key <- name_backbone(name='Helianthus annuus', kingdom='plants')$speciesKey
occ_search(taxonKey=key, limit=20)
#> Records found [9920]
#> Records returned [20]
#> No. unique hierarchies [1]
#> No. media records [4]
#> No. facets [0]
#> Args [limit=20, offset=0, taxonKey=3119195, fields=all]
#> # A tibble: 20 × 76
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1433793045        59.66860         16.54260
#> 2  Helianthus annuus 1434024463        63.71620         20.31250
#> 3  Helianthus annuus 1433858538        60.27530         16.88070
#> 4  Helianthus annuus 1453439357        25.66662       -100.25580
#> 5  Helianthus annuus 1436223234        59.85510         17.78900
#> 6  Helianthus annuus 1453443879        24.12030       -110.33479
#> 7  Helianthus annuus 1453421897        33.94156       -117.31729
#> 8  Helianthus annuus 1453463012        25.91457       -100.23617
#> 9  Helianthus annuus 1436147509        59.85470         17.79090
#> 10 Helianthus annuus 1450388036        56.60630         16.64840
#> 11 Helianthus annuus 1455582533        33.73523       -117.39047
#> 12 Helianthus annuus 1453470435        38.68366       -121.17481
#> 13 Helianthus annuus 1433648018        60.83520         15.66670
#> 14 Helianthus annuus 1428322921        59.89010         17.66020
#> 15 Helianthus annuus 1428270308        59.88990         17.66030
#> 16 Helianthus annuus 1249279611        34.04810       -117.79884
#> 17 Helianthus annuus 1428303565        59.89020         17.66080
#> 18 Helianthus annuus 1455567216        34.14489       -117.18974
#> 19 Helianthus annuus 1315048347        34.04377       -116.94136
#> 20 Helianthus annuus 1253308332        29.67463        -95.44804
#> # ... with 72 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, individualCount <int>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, genericName <chr>,
#> #   specificEpithet <chr>, taxonRank <chr>, coordinatePrecision <dbl>,
#> #   elevation <dbl>, elevationAccuracy <dbl>, depth <dbl>,
#> #   depthAccuracy <dbl>, stateProvince <chr>, year <int>, month <int>,
#> #   day <int>, eventDate <chr>, modified <chr>, lastInterpreted <chr>,
#> #   license <chr>, identifiers <chr>, facts <chr>, relations <chr>,
#> #   geodeticDatum <chr>, class <chr>, countryCode <chr>, country <chr>,
#> #   identifier <chr>, catalogNumber <chr>, institutionCode <chr>,
#> #   locality <chr>, county <chr>, collectionCode <chr>, gbifID <chr>,
#> #   occurrenceID <chr>, identifiedBy <chr>, dateIdentified <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, references <chr>,
#> #   rightsHolder <chr>, verbatimEventDate <chr>, datasetName <chr>,
#> #   verbatimLocality <chr>, taxonID <chr>, recordedBy <chr>,
#> #   http...unknown.org.occurrenceDetails <chr>, rights <chr>,
#> #   eventTime <chr>, identificationID <chr>, occurrenceRemarks <chr>
```

## Search for many species

Get the keys first with `name_backbone()`, then pass to `occ_search()`


```r
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_backbone(name=x)$speciesKey, USE.NAMES=FALSE)
occ_search(taxonKey=keys, limit=5, hasCoordinate=TRUE)
#> Occ. found [2480598 (18), 2492010 (3043822), 2498387 (971634)]
#> Occ. returned [2480598 (5), 2492010 (5), 2498387 (5)]
#> No. unique hierarchies [2480598 (1), 2492010 (1), 2498387 (1)]
#> No. media records [2480598 (1), 2492010 (1), 2498387 (1)]
#> No. facets [2480598 (0), 2492010 (0), 2498387 (0)]
#> Args [hasCoordinate=TRUE, limit=5, offset=0,
#>      taxonKey=2480598,2492010,2498387, fields=all]
#> 3 requests; First 10 rows of data from 2480598
#>
#> # A tibble: 5 × 82
#>                      name        key decimalLatitude decimalLongitude
#>                     <chr>      <int>           <dbl>            <dbl>
#> 1 Accipiter erythronemius  920169861      -20.552437        -56.64104
#> 2 Accipiter erythronemius  920184036      -20.760288        -56.71314
#> 3 Accipiter erythronemius 1001096527      -27.580000        -58.66000
#> 4 Accipiter erythronemius 1001096518      -27.920000        -59.14000
#> 5 Accipiter erythronemius  686297260        5.266667        -60.73333
#> # ... with 78 more variables: issues <chr>, datasetKey <chr>,
#> #   publishingOrgKey <chr>, publishingCountry <chr>, protocol <chr>,
#> #   lastCrawled <chr>, lastParsed <chr>, crawlId <int>, extensions <chr>,
#> #   basisOfRecord <chr>, taxonKey <int>, kingdomKey <int>,
#> #   phylumKey <int>, classKey <int>, orderKey <int>, familyKey <int>,
#> #   genusKey <int>, speciesKey <int>, scientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, year <int>, month <int>,
#> #   day <int>, eventDate <chr>, lastInterpreted <chr>, license <chr>,
#> #   identifiers <chr>, facts <chr>, relations <chr>, geodeticDatum <chr>,
#> #   class <chr>, countryCode <chr>, country <chr>, recordedBy <chr>,
#> #   catalogNumber <chr>, institutionCode <chr>, locality <chr>,
#> #   collectionCode <chr>, gbifID <chr>, modified <chr>, identifier <chr>,
#> #   created <chr>, occurrenceID <chr>, associatedSequences <chr>,
#> #   higherClassification <chr>, taxonID <chr>, sex <chr>,
#> #   establishmentMeans <chr>, continent <chr>, references <chr>,
#> #   institutionID <chr>, dynamicProperties <chr>, fieldNumber <chr>,
#> #   language <chr>, type <chr>, preparations <chr>,
#> #   occurrenceStatus <chr>, rights <chr>, higherGeography <chr>,
#> #   verbatimEventDate <chr>, nomenclaturalCode <chr>,
#> #   georeferenceVerificationStatus <chr>, endDayOfYear <chr>,
#> #   datasetName <chr>, verbatimLocality <chr>, otherCatalogNumbers <chr>,
#> #   startDayOfYear <chr>, accessRights <chr>, collectionID <chr>
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

![plot of chunk unnamed-chunk-10](inst/assets/img/unnamed-chunk-10-1.png)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rgbif/issues).
* License: MIT
* Get citation information for `rgbif` in R doing `citation(package = 'rgbif')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

- - -

This package is part of a richer suite called [spocc - Species Occurrence Data](https://github.com/ropensci/spocc), along with several other packages, that provide access to occurrence records from multiple databases.

- - -

