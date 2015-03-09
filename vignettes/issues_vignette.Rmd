<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Cleaning data using GBIF issues}
-->



Cleaning data using GBIF issues
======

`rgbif` now has the ability to clean data retrieved from GBIF based on GBIF issues. These issues are returned in data retrieved from GBIF, e.g., through the `occ_search()` function. Inspired by `magrittr`, we've setup a workflow for cleaning data based on using the operator `%>%`. You don't have to use it, but as we show below, it can make the process quite easy.

Note that you can also query based on issues, e.g., `occ_search(taxonKey=1, issue='DEPTH_UNLIKELY')`. However, we imagine it's more likely that you want to search for occurrences based on a taxonomic name, or geographic area, not based on issues, so it makes sense to pull data down, then clean as needed using the below workflow with `occ_issues()`.

Note that `occ_issues()` only affects the data element in the gbif class that is returned from a call to `occ_search()`. Maybe in a future version we will remove the associated records from the hierarchy and media elements as they are remove from the data element.

You also get issues data back with `occ_get()`, but `occ_issues()` doesn't yet support working with data from `occ_get()`.

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
library('rgbif')
```

## Get some data

Get taxon key for _Helianthus annuus_


```r
(key <- name_suggest(q='Helianthus annuus', rank='species')$key[1])
#> [1] 3119195
```

Then pass to `occ_search()`


```r
(res <- occ_search(taxonKey=key, limit=100))
#> Records found [20369] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [taxonKey=3119195, limit=100, offset=0, fields=all] 
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
#>      (dbl), elevationAccuracy (dbl), depth (dbl), depthAccuracy (dbl),
#>      habitat (chr), fieldNotes (chr), municipality (chr),
#>      informationWithheld (chr)
```

## Examine issues

The dataset `gbifissues` can be retrieved using the function `gbif_issues()`. The dataset's first column `code` is a code that is used by default in the results from `occ_search()`, while the second column `issue` is the full issue name given by GBIF. The third column is a full description of the issue. 


```r
head(gbif_issues())
#>    code                              issue
#> 1   bri            BASIS_OF_RECORD_INVALID
#> 2   ccm         CONTINENT_COUNTRY_MISMATCH
#> 3   cdc CONTINENT_DERIVED_FROM_COORDINATES
#> 4 conti                  CONTINENT_INVALID
#> 5  cdiv                 COORDINATE_INVALID
#> 6 cdout            COORDINATE_OUT_OF_RANGE
#>                                                                                                    description
#> 1 The given basis of record is impossible to interpret or seriously different from the recommended vocabulary.
#> 2                                                       The interpreted continent and country do not match up.
#> 3                  The interpreted continent is based on the coordinates, not the verbatim string information.
#> 4                                                                      Uninterpretable continent values found.
#> 5                                      Coordinate value given in some form but GBIF is unable to interpret it.
#> 6                                        Coordinate has invalid lat/lon values out of their decimal max range.
```

You can query to get certain issues


```r
gbif_issues()[ gbif_issues()$code %in% c('cdround','cudc','gass84','txmathi'), ]
#>       code                            issue
#> 10 cdround               COORDINATE_ROUNDED
#> 12    cudc COUNTRY_DERIVED_FROM_COORDINATES
#> 23  gass84     GEODETIC_DATUM_ASSUMED_WGS84
#> 39 txmathi           TAXON_MATCH_HIGHERRANK
#>                                                                                                                                 description
#> 10                                                                                  Original coordinate modified by rounding to 5 decimals.
#> 12                                                The interpreted country is based on the coordinates, not the verbatim string information.
#> 23 Indicating that the interpreted coordinates assume they are based on WGS84 datum as the datum was either not indicated or interpretable.
#> 39                                        Matching to the taxonomic backbone can only be done on a higher rank and not the scientific name.
```

The code `cdround` represents the GBIF issue `COORDINATE_ROUNDED`, which means that 

> Original coordinate modified by rounding to 5 decimals.

The content for this information comes from [http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html](http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html). 

## Parse data based on issues

Now that we know a bit about GBIF issues, you can parse your data based on issues. Using the data generated above, and using the function `%>%` imported from `magrittr`, we can get only data with the issue `gass84`, or `GEODETIC_DATUM_ASSUMED_WGS84` (Note how the records returned goes down to 98 instead of the initial 100).


```r
res %>%
  occ_issues(gass84)
#> Records found [20369] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [taxonKey=3119195, limit=100, offset=0, fields=all] 
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
#>      (dbl), elevationAccuracy (dbl), depth (dbl), depthAccuracy (dbl),
#>      habitat (chr), fieldNotes (chr), municipality (chr),
#>      informationWithheld (chr)
```

Note also that we've set up `occ_issues()` so that you can pass in issue names without having to quote them, thereby speeding up data cleaning. 

Next, we can remove data with certain issues just as easily by using a `-` sign in front of the variable, like this, removing data with issues `gass84` and `mdatunl`, leaving us with only 2 records.


```r
res %>% 
  occ_issues(-gass84, -mdatunl)
#> Records found [20369] 
#> Records returned [0] 
#> No. unique hierarchies [1] 
#> No. media records [20] 
#> Args [taxonKey=3119195, limit=100, offset=0, fields=all] 
#> First 10 rows of data
```

## Expand issue codes to full names

Another thing we can do with `occ_issues()` is go from issue codes to full issue names in case you want those in your dataset (here, showing only a few columns to see the data better for this demo):


```r
out <- res %>% occ_issues(mutate = "expand")
head(out$data[,c(1,5)])
#>                name
#> 1 Helianthus annuus
#> 2 Helianthus annuus
#> 3 Helianthus annuus
#> 4 Helianthus annuus
#> 5 Helianthus annuus
#> 6 Helianthus annuus
#>                                                                             issues
#> 1                                  COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 2 COORDINATE_ROUNDED,COUNTRY_DERIVED_FROM_COORDINATES,GEODETIC_DATUM_ASSUMED_WGS84
#> 3 COORDINATE_ROUNDED,COUNTRY_DERIVED_FROM_COORDINATES,GEODETIC_DATUM_ASSUMED_WGS84
#> 4 COORDINATE_ROUNDED,COUNTRY_DERIVED_FROM_COORDINATES,GEODETIC_DATUM_ASSUMED_WGS84
#> 5                                  COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 6                                  COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
```


## Add columns

Sometimes you may want to have each type of issue as a separate column. 

Split out each issue type into a separate column, with number of columns equal to number of issue types


```r
out <- res %>% occ_issues(mutate = "split")
head(out$data[,c(1,5:10)])
#>                name cdround gass84 cudc depunl cucdmis
#> 1 Helianthus annuus       y      y    n      n       n
#> 2 Helianthus annuus       y      y    y      n       n
#> 3 Helianthus annuus       y      y    y      n       n
#> 4 Helianthus annuus       y      y    y      n       n
#> 5 Helianthus annuus       y      y    n      n       n
#> 6 Helianthus annuus       y      y    n      n       n
#>                             datasetKey
#> 1 6ac3f774-d9fb-4796-b3e9-92bf6c81c084
#> 2 50c9509d-22c7-4a22-a47d-8c48425ef4a7
#> 3 50c9509d-22c7-4a22-a47d-8c48425ef4a7
#> 4 50c9509d-22c7-4a22-a47d-8c48425ef4a7
#> 5 6ac3f774-d9fb-4796-b3e9-92bf6c81c084
#> 6 6ac3f774-d9fb-4796-b3e9-92bf6c81c084
```

## Expand and add columns

Or you can expand each issue type into its full name, and split each issue into a separate column.


```r
out <- res %>% occ_issues(mutate = "split_expand")
head(out$data[,c(1,5:10)])
#>                name COORDINATE_ROUNDED GEODETIC_DATUM_ASSUMED_WGS84
#> 1 Helianthus annuus                  y                            y
#> 2 Helianthus annuus                  y                            y
#> 3 Helianthus annuus                  y                            y
#> 4 Helianthus annuus                  y                            y
#> 5 Helianthus annuus                  y                            y
#> 6 Helianthus annuus                  y                            y
#>   COUNTRY_DERIVED_FROM_COORDINATES DEPTH_UNLIKELY
#> 1                                n              n
#> 2                                y              n
#> 3                                y              n
#> 4                                y              n
#> 5                                n              n
#> 6                                n              n
#>   COUNTRY_COORDINATE_MISMATCH                           datasetKey
#> 1                           n 6ac3f774-d9fb-4796-b3e9-92bf6c81c084
#> 2                           n 50c9509d-22c7-4a22-a47d-8c48425ef4a7
#> 3                           n 50c9509d-22c7-4a22-a47d-8c48425ef4a7
#> 4                           n 50c9509d-22c7-4a22-a47d-8c48425ef4a7
#> 5                           n 6ac3f774-d9fb-4796-b3e9-92bf6c81c084
#> 6                           n 6ac3f774-d9fb-4796-b3e9-92bf6c81c084
```

## Wrap up

We hope this helps users get just the data they want, and nothing more. Let us know if you have feedback on data cleaning functionality in `rgbif` at _info@ropensci.org_ or at [https://github.com/ropensci/rgbif/issues](https://github.com/ropensci/rgbif/issues).
