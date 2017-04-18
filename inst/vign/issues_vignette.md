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
#> Records found [14820] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [2] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 × 98
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1437798345        51.03513         4.518690
#> 2  Helianthus annuus 1437786250        50.91574         3.579770
#> 3  Helianthus annuus 1454554504        50.22000         9.630000
#> 4  Helianthus annuus 1273001624        59.32739        10.803912
#> 5  Helianthus annuus 1454554470        49.32000        12.000000
#> 6  Helianthus annuus 1272997264        58.66189         6.721671
#> 7  Helianthus annuus 1454553080        49.75000         9.300000
#> 8  Helianthus annuus 1272995969        59.83241        10.763219
#> 9  Helianthus annuus 1454553865              NA               NA
#> 10 Helianthus annuus 1454555306        48.21000        12.080000
#> # ... with 90 more rows, and 94 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, genericName <chr>,
#> #   specificEpithet <chr>, taxonRank <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, continent <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, identifier <chr>, verbatimEventDate <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>,
#> #   verbatimCoordinateSystem <chr>, datasetName <chr>, language <chr>,
#> #   gbifID <chr>, occurrenceID <chr>, type <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, institutionCode <chr>, ownerInstitutionCode <chr>,
#> #   datasetID <chr>, accessRights <chr>, bibliographicCitation <chr>,
#> #   locality <chr>, collectionCode <chr>, individualCount <int>,
#> #   elevation <dbl>, elevationAccuracy <dbl>, stateProvince <chr>,
#> #   municipality <chr>, county <chr>, coordinatePrecision <dbl>,
#> #   habitat <chr>, dateIdentified <chr>, identifiedBy <chr>,
#> #   references <chr>, recordNumber <chr>, institutionID <chr>,
#> #   dynamicProperties <chr>, associatedTaxa <chr>, startDayOfYear <chr>,
#> #   verbatimElevation <chr>, collectionID <chr>, verbatimLocality <chr>,
#> #   fieldNotes <chr>, higherGeography <chr>, endDayOfYear <chr>,
#> #   higherClassification <chr>, rightsHolder <chr>, rights <chr>,
#> #   occurrenceRemarks <chr>, footprintWKT <chr>, occurrenceStatus <chr>,
#> #   footprintSRS <chr>, eventID <chr>, fieldNumber <chr>
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
#> Records found [14820] 
#> Records returned [36] 
#> No. unique hierarchies [1] 
#> No. media records [2] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 36 × 98
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1273001624        59.32739        10.803912
#> 2  Helianthus annuus 1272997264        58.66189         6.721671
#> 3  Helianthus annuus 1272995969        59.83241        10.763219
#> 4  Helianthus annuus 1323229476        59.08521        11.036315
#> 5  Helianthus annuus 1323241585        59.57240        10.847597
#> 6  Helianthus annuus 1273024475        59.08521        11.036315
#> 7  Helianthus annuus 1323261789        58.66189         6.721671
#> 8  Helianthus annuus 1305561325        48.57490         7.759700
#> 9  Helianthus annuus 1425285026        59.21189        10.284695
#> 10 Helianthus annuus 1323319952        59.08830        10.060628
#> # ... with 26 more rows, and 94 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, genericName <chr>,
#> #   specificEpithet <chr>, taxonRank <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, continent <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, identifier <chr>, verbatimEventDate <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>,
#> #   verbatimCoordinateSystem <chr>, datasetName <chr>, language <chr>,
#> #   gbifID <chr>, occurrenceID <chr>, type <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, institutionCode <chr>, ownerInstitutionCode <chr>,
#> #   datasetID <chr>, accessRights <chr>, bibliographicCitation <chr>,
#> #   locality <chr>, collectionCode <chr>, individualCount <int>,
#> #   elevation <dbl>, elevationAccuracy <dbl>, stateProvince <chr>,
#> #   municipality <chr>, county <chr>, coordinatePrecision <dbl>,
#> #   habitat <chr>, dateIdentified <chr>, identifiedBy <chr>,
#> #   references <chr>, recordNumber <chr>, institutionID <chr>,
#> #   dynamicProperties <chr>, associatedTaxa <chr>, startDayOfYear <chr>,
#> #   verbatimElevation <chr>, collectionID <chr>, verbatimLocality <chr>,
#> #   fieldNotes <chr>, higherGeography <chr>, endDayOfYear <chr>,
#> #   higherClassification <chr>, rightsHolder <chr>, rights <chr>,
#> #   occurrenceRemarks <chr>, footprintWKT <chr>, occurrenceStatus <chr>,
#> #   footprintSRS <chr>, eventID <chr>, fieldNumber <chr>
```

Note also that we've set up `occ_issues()` so that you can pass in issue names without having to quote them, thereby speeding up data cleaning.

Next, we can remove data with certain issues just as easily by using a `-` sign in front of the variable, like this, removing data with issues `depunl` and `mdatunl`.


```r
res %>%
  occ_issues(-depunl, -mdatunl)
#> Records found [14820] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [2] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 × 98
#>                 name        key decimalLatitude decimalLongitude
#>                <chr>      <int>           <dbl>            <dbl>
#> 1  Helianthus annuus 1437798345        51.03513         4.518690
#> 2  Helianthus annuus 1437786250        50.91574         3.579770
#> 3  Helianthus annuus 1454554504        50.22000         9.630000
#> 4  Helianthus annuus 1273001624        59.32739        10.803912
#> 5  Helianthus annuus 1454554470        49.32000        12.000000
#> 6  Helianthus annuus 1272997264        58.66189         6.721671
#> 7  Helianthus annuus 1454553080        49.75000         9.300000
#> 8  Helianthus annuus 1272995969        59.83241        10.763219
#> 9  Helianthus annuus 1454553865              NA               NA
#> 10 Helianthus annuus 1454555306        48.21000        12.080000
#> # ... with 90 more rows, and 94 more variables: issues <chr>,
#> #   datasetKey <chr>, publishingOrgKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   scientificName <chr>, kingdom <chr>, phylum <chr>, order <chr>,
#> #   family <chr>, genus <chr>, species <chr>, genericName <chr>,
#> #   specificEpithet <chr>, taxonRank <chr>,
#> #   coordinateUncertaintyInMeters <dbl>, continent <chr>, year <int>,
#> #   month <int>, day <int>, eventDate <chr>, modified <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, identifier <chr>, verbatimEventDate <chr>,
#> #   nomenclaturalCode <chr>, dataGeneralizations <chr>,
#> #   verbatimCoordinateSystem <chr>, datasetName <chr>, language <chr>,
#> #   gbifID <chr>, occurrenceID <chr>, type <chr>, catalogNumber <chr>,
#> #   recordedBy <chr>, institutionCode <chr>, ownerInstitutionCode <chr>,
#> #   datasetID <chr>, accessRights <chr>, bibliographicCitation <chr>,
#> #   locality <chr>, collectionCode <chr>, individualCount <int>,
#> #   elevation <dbl>, elevationAccuracy <dbl>, stateProvince <chr>,
#> #   municipality <chr>, county <chr>, coordinatePrecision <dbl>,
#> #   habitat <chr>, dateIdentified <chr>, identifiedBy <chr>,
#> #   references <chr>, recordNumber <chr>, institutionID <chr>,
#> #   dynamicProperties <chr>, associatedTaxa <chr>, startDayOfYear <chr>,
#> #   verbatimElevation <chr>, collectionID <chr>, verbatimLocality <chr>,
#> #   fieldNotes <chr>, higherGeography <chr>, endDayOfYear <chr>,
#> #   higherClassification <chr>, rightsHolder <chr>, rights <chr>,
#> #   occurrenceRemarks <chr>, footprintWKT <chr>, occurrenceStatus <chr>,
#> #   footprintSRS <chr>, eventID <chr>, fieldNumber <chr>
```

## Expand issue codes to full names

Another thing we can do with `occ_issues()` is go from issue codes to full issue names in case you want those in your dataset (here, showing only a few columns to see the data better for this demo):


```r
out <- res %>% occ_issues(mutate = "expand")
head(out$data[,c(1,5)])
#> # A tibble: 6 × 2
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
#> # A tibble: 6 × 7
#>                name refuriiv   bri  cudc cdround gass84 cucdmis
#>               <chr>    <chr> <chr> <chr>   <chr>  <chr>   <chr>
#> 1 Helianthus annuus        y     n     n       n      n       n
#> 2 Helianthus annuus        y     n     n       n      n       n
#> 3 Helianthus annuus        n     y     y       n      n       n
#> 4 Helianthus annuus        n     n     n       y      y       n
#> 5 Helianthus annuus        n     n     y       n      n       n
#> 6 Helianthus annuus        n     n     n       y      y       n
```

## Expand and add columns

Or you can expand each issue type into its full name, and split each issue into a separate column.


```r
out <- res %>% occ_issues(mutate = "split_expand")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 × 7
#>                name REFERENCES_URI_INVALID BASIS_OF_RECORD_INVALID
#>               <chr>                  <chr>                   <chr>
#> 1 Helianthus annuus                      y                       n
#> 2 Helianthus annuus                      y                       n
#> 3 Helianthus annuus                      n                       y
#> 4 Helianthus annuus                      n                       n
#> 5 Helianthus annuus                      n                       n
#> 6 Helianthus annuus                      n                       n
#> # ... with 4 more variables: COUNTRY_DERIVED_FROM_COORDINATES <chr>,
#> #   COORDINATE_ROUNDED <chr>, GEODETIC_DATUM_ASSUMED_WGS84 <chr>,
#> #   COUNTRY_COORDINATE_MISMATCH <chr>
```

## Wrap up

We hope this helps users get just the data they want, and nothing more. Let us know if you have feedback on data cleaning functionality in `rgbif` at _info@ropensci.org_ or at [https://github.com/ropensci/rgbif/issues](https://github.com/ropensci/rgbif/issues).
