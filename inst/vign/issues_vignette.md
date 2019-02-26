<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Cleaning data using GBIF issues}
%\VignetteEncoding{UTF-8}
-->



Cleaning data using GBIF issues
======

`rgbif` now has the ability to clean data retrieved from GBIF based on GBIF issues. These issues are returned in data retrieved from GBIF, e.g., through the `occ_search()` function. Inspired by `magrittr`, we've setup a workflow for cleaning data based on using the operator `%>%`. You don't have to use it, but as we show below, it can make the process quite easy.

Note that you can also query based on issues, e.g., `occ_search(taxonKey=1, issue='DEPTH_UNLIKELY')`. However, we imagine it's more likely that you want to search for occurrences based on a taxonomic name, or geographic area, not based on issues, so it makes sense to pull data down, then clean as needed using the below workflow with `occ_issues()`.

Note that `occ_issues()` only affects the data element in the gbif class that is returned from a call to `occ_search()`. Maybe in a future version we will remove the associated records from the hierarchy and media elements as they are remove from the data element.

`occ_issues()` also works with data from `occ_download()`.

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
#> [1] 9206251
```

Then pass to `occ_search()`


```r
(res <- occ_search(taxonKey=key, limit=100))
#> Records found [43757] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [82] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 x 98
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
#> # … with 90 more rows, and 92 more variables: publishingOrgKey <chr>,
#> #   networkKeys <chr>, installationKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
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
#> #   identificationRemarks <chr>, habitat <chr>, elevation <dbl>,
#> #   elevationAccuracy <dbl>, recordNumber <chr>,
#> #   ownerInstitutionCode <chr>, identifiedBy <chr>,
#> #   dataGeneralizations <chr>, samplingProtocol <chr>
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
#> Records found [43757] 
#> Records returned [97] 
#> No. unique hierarchies [1] 
#> No. media records [82] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 97 x 98
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
#> # … with 87 more rows, and 92 more variables: publishingOrgKey <chr>,
#> #   networkKeys <chr>, installationKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
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
#> #   identificationRemarks <chr>, habitat <chr>, elevation <dbl>,
#> #   elevationAccuracy <dbl>, recordNumber <chr>,
#> #   ownerInstitutionCode <chr>, identifiedBy <chr>,
#> #   dataGeneralizations <chr>, samplingProtocol <chr>
```

Note also that we've set up `occ_issues()` so that you can pass in issue names without having to quote them, thereby speeding up data cleaning.

Next, we can remove data with certain issues just as easily by using a `-` sign in front of the variable, like this, removing data with issues `depunl` and `mdatunl`.


```r
res %>%
  occ_issues(-depunl, -mdatunl)
#> Records found [43757] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [82] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 x 98
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
#> # … with 90 more rows, and 92 more variables: publishingOrgKey <chr>,
#> #   networkKeys <chr>, installationKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
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
#> #   identificationRemarks <chr>, habitat <chr>, elevation <dbl>,
#> #   elevationAccuracy <dbl>, recordNumber <chr>,
#> #   ownerInstitutionCode <chr>, identifiedBy <chr>,
#> #   dataGeneralizations <chr>, samplingProtocol <chr>
```

## Expand issue codes to full names

Another thing we can do with `occ_issues()` is go from issue codes to full issue names in case you want those in your dataset (here, showing only a few columns to see the data better for this demo):


```r
out <- res %>% occ_issues(mutate = "expand")
head(out$data[,c(1,5)])
#> # A tibble: 6 x 2
#>          key issues                                         
#>        <int> <chr>                                          
#> 1 1993715633 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 2 1993719684 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 3 1986597827 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 4 1990684625 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 5 1986613930 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 6 1990684609 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
```


## Add columns

Sometimes you may want to have each type of issue as a separate column.

Split out each issue type into a separate column, with number of columns equal to number of issue types


```r
out <- res %>% occ_issues(mutate = "split")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 x 7
#>   name               cdround gass84 cucdmis zerocd cudc  scientificName    
#>   <chr>              <chr>   <chr>  <chr>   <chr>  <chr> <chr>             
#> 1 Helianthus annuus… y       y      n       n      n     Helianthus annuus…
#> 2 Helianthus annuus… y       y      n       n      n     Helianthus annuus…
#> 3 Helianthus annuus… y       y      n       n      n     Helianthus annuus…
#> 4 Helianthus annuus… y       y      n       n      n     Helianthus annuus…
#> 5 Helianthus annuus… y       y      n       n      n     Helianthus annuus…
#> 6 Helianthus annuus… y       y      n       n      n     Helianthus annuus…
```

## Expand and add columns

Or you can expand each issue type into its full name, and split each issue into a separate column.


```r
out <- res %>% occ_issues(mutate = "split_expand")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 x 7
#>   name  COORDINATE_ROUN… GEODETIC_DATUM_… COUNTRY_COORDIN… ZERO_COORDINATE
#>   <chr> <chr>            <chr>            <chr>            <chr>          
#> 1 Heli… y                y                n                n              
#> 2 Heli… y                y                n                n              
#> 3 Heli… y                y                n                n              
#> 4 Heli… y                y                n                n              
#> 5 Heli… y                y                n                n              
#> 6 Heli… y                y                n                n              
#> # … with 2 more variables: COUNTRY_DERIVED_FROM_COORDINATES <chr>,
#> #   scientificName <chr>
```

## Wrap up

We hope this helps users get just the data they want, and nothing more. Let us know if you have feedback on data cleaning functionality in `rgbif` at _info@ropensci.org_ or at [https://github.com/ropensci/rgbif/issues](https://github.com/ropensci/rgbif/issues).
