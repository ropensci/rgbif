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
#> [1] 9206251
```

Then pass to `occ_search()`


```r
(res <- occ_search(taxonKey=key, limit=100))
#> Records found [18377] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [1] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 x 96
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#>  1 Helianthus annuus 1434024463        63.71622         20.31247
#>  2 Helianthus annuus 1433793045        59.66859         16.54257
#>  3 Helianthus annuus 1563876655              NA               NA
#>  4 Helianthus annuus 1436147509        59.85465         17.79089
#>  5 Helianthus annuus 1436223234        59.85509         17.78900
#>  6 Helianthus annuus 1450388036        56.60630         16.64841
#>  7 Helianthus annuus 1499896133        58.76637         16.24997
#>  8 Helianthus annuus 1499929475        59.85530         17.79055
#>  9 Helianthus annuus 1669229145        59.85530         17.79055
#> 10 Helianthus annuus 1669043510        59.74332         17.78161
#> # ... with 90 more rows, and 92 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, individualCount <int>,
#> #   taxonKey <int>, kingdomKey <int>, phylumKey <int>, classKey <int>,
#> #   orderKey <int>, familyKey <int>, genusKey <int>, speciesKey <int>,
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
#> #   higherGeography <chr>, samplingProtocol <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>, datasetName <chr>,
#> #   verbatimCoordinateSystem <chr>, ownerInstitutionCode <chr>,
#> #   bibliographicCitation <chr>
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
#> Records found [18377] 
#> Records returned [98] 
#> No. unique hierarchies [1] 
#> No. media records [1] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 98 x 96
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#>  1 Helianthus annuus 1434024463        63.71622         20.31247
#>  2 Helianthus annuus 1433793045        59.66859         16.54257
#>  3 Helianthus annuus 1436147509        59.85465         17.79089
#>  4 Helianthus annuus 1436223234        59.85509         17.78900
#>  5 Helianthus annuus 1450388036        56.60630         16.64841
#>  6 Helianthus annuus 1499896133        58.76637         16.24997
#>  7 Helianthus annuus 1499929475        59.85530         17.79055
#>  8 Helianthus annuus 1669229145        59.85530         17.79055
#>  9 Helianthus annuus 1669043510        59.74332         17.78161
#> 10 Helianthus annuus 1669900943        57.73119         16.13173
#> # ... with 88 more rows, and 92 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, individualCount <int>,
#> #   taxonKey <int>, kingdomKey <int>, phylumKey <int>, classKey <int>,
#> #   orderKey <int>, familyKey <int>, genusKey <int>, speciesKey <int>,
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
#> #   higherGeography <chr>, samplingProtocol <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>, datasetName <chr>,
#> #   verbatimCoordinateSystem <chr>, ownerInstitutionCode <chr>,
#> #   bibliographicCitation <chr>
```

Note also that we've set up `occ_issues()` so that you can pass in issue names without having to quote them, thereby speeding up data cleaning.

Next, we can remove data with certain issues just as easily by using a `-` sign in front of the variable, like this, removing data with issues `depunl` and `mdatunl`.


```r
res %>%
  occ_issues(-depunl, -mdatunl)
#> Records found [18377] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [1] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 x 96
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#>  1 Helianthus annuus 1434024463        63.71622         20.31247
#>  2 Helianthus annuus 1433793045        59.66859         16.54257
#>  3 Helianthus annuus 1563876655              NA               NA
#>  4 Helianthus annuus 1436147509        59.85465         17.79089
#>  5 Helianthus annuus 1436223234        59.85509         17.78900
#>  6 Helianthus annuus 1450388036        56.60630         16.64841
#>  7 Helianthus annuus 1499896133        58.76637         16.24997
#>  8 Helianthus annuus 1499929475        59.85530         17.79055
#>  9 Helianthus annuus 1669229145        59.85530         17.79055
#> 10 Helianthus annuus 1669043510        59.74332         17.78161
#> # ... with 90 more rows, and 92 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, individualCount <int>,
#> #   taxonKey <int>, kingdomKey <int>, phylumKey <int>, classKey <int>,
#> #   orderKey <int>, familyKey <int>, genusKey <int>, speciesKey <int>,
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
#> #   higherGeography <chr>, samplingProtocol <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>, datasetName <chr>,
#> #   verbatimCoordinateSystem <chr>, ownerInstitutionCode <chr>,
#> #   bibliographicCitation <chr>
```

## Expand issue codes to full names

Another thing we can do with `occ_issues()` is go from issue codes to full issue names in case you want those in your dataset (here, showing only a few columns to see the data better for this demo):


```r
out <- res %>% occ_issues(mutate = "expand")
head(out$data[,c(1,5)])
#> # A tibble: 6 x 2
#>                name
#>               <chr>
#> 1 Helianthus annuus
#> 2 Helianthus annuus
#> 3 Helianthus annuus
#> 4 Helianthus annuus
#> 5 Helianthus annuus
#> 6 Helianthus annuus
#> # ... with 1 more variables: issues <chr>
```


## Add columns

Sometimes you may want to have each type of issue as a separate column.

Split out each issue type into a separate column, with number of columns equal to number of issue types


```r
out <- res %>% occ_issues(mutate = "split")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 x 7
#>                name cdround gass84 rdatm refuriiv
#>               <chr>   <chr>  <chr> <chr>    <chr>
#> 1 Helianthus annuus       y      y     y        n
#> 2 Helianthus annuus       y      y     y        n
#> 3 Helianthus annuus       n      n     n        n
#> 4 Helianthus annuus       y      y     y        n
#> 5 Helianthus annuus       y      y     y        n
#> 6 Helianthus annuus       y      y     y        n
#> # ... with 2 more variables: datasetKey <chr>, publishingOrgKey <chr>
```

## Expand and add columns

Or you can expand each issue type into its full name, and split each issue into a separate column.


```r
out <- res %>% occ_issues(mutate = "split_expand")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 x 7
#>                name COORDINATE_ROUNDED GEODETIC_DATUM_ASSUMED_WGS84
#>               <chr>              <chr>                        <chr>
#> 1 Helianthus annuus                  y                            y
#> 2 Helianthus annuus                  y                            y
#> 3 Helianthus annuus                  n                            n
#> 4 Helianthus annuus                  y                            y
#> 5 Helianthus annuus                  y                            y
#> 6 Helianthus annuus                  y                            y
#> # ... with 4 more variables: RECORDED_DATE_MISMATCH <chr>,
#> #   REFERENCES_URI_INVALID <chr>, datasetKey <chr>, publishingOrgKey <chr>
```

## Wrap up

We hope this helps users get just the data they want, and nothing more. Let us know if you have feedback on data cleaning functionality in `rgbif` at _info@ropensci.org_ or at [https://github.com/ropensci/rgbif/issues](https://github.com/ropensci/rgbif/issues).
