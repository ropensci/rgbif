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
#> Records found [45844] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [84] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 x 103
#>    key   scientificName decimalLatitude decimalLongitude issues datasetKey
#>    <chr> <chr>                    <dbl>            <dbl> <chr>  <chr>     
#>  1 1990… Helianthus an…            52.6            10.1  cdrou… 6ac3f774-…
#>  2 2235… Helianthus an…            51.2             4.45 ""     7f5e4129-…
#>  3 1990… Helianthus an…            26.2           -98.2  cdrou… 50c9509d-…
#>  4 2247… Helianthus an…            58.4            11.9  cdrou… 38b4c89f-…
#>  5 1993… Helianthus an…            34.0          -117.   cdrou… 50c9509d-…
#>  6 1986… Helianthus an…            27.7           -97.3  cdrou… 50c9509d-…
#>  7 1993… Helianthus an…            33.4          -118.   cdrou… 50c9509d-…
#>  8 1990… Helianthus an…            53.9            10.9  cdrou… 6ac3f774-…
#>  9 1986… Helianthus an…            33.8          -118.   cdrou… 50c9509d-…
#> 10 2247… Helianthus an…            55.7            14.2  gass84 38b4c89f-…
#> # … with 90 more rows, and 97 more variables: publishingOrgKey <chr>,
#> #   networkKeys <chr>, installationKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   taxonomicStatus <chr>, coordinateUncertaintyInMeters <dbl>,
#> #   year <int>, month <int>, day <int>, eventDate <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, catalogNumber <chr>, recordedBy <chr>,
#> #   institutionCode <chr>, locality <chr>, gbifID <chr>,
#> #   collectionCode <chr>, name <chr>, individualCount <int>,
#> #   continent <chr>, stateProvince <chr>, references <chr>,
#> #   rightsHolder <chr>, identifier <chr>, informationWithheld <chr>,
#> #   nomenclaturalCode <chr>, municipality <chr>, datasetName <chr>,
#> #   identificationVerificationStatus <chr>, language <chr>,
#> #   occurrenceID <chr>, type <chr>, taxonID <chr>, vernacularName <chr>,
#> #   datasetID <chr>, samplingProtocol <chr>, accessRights <chr>,
#> #   reproductiveCondition <chr>, dateIdentified <chr>, modified <chr>,
#> #   http...unknown.org.nick <chr>, verbatimEventDate <chr>,
#> #   verbatimLocality <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>, county <chr>,
#> #   occurrenceStatus <chr>, taxonConceptID <chr>, endDayOfYear <chr>,
#> #   startDayOfYear <chr>, higherClassification <chr>,
#> #   occurrenceRemarks <chr>, elevation <dbl>, recordNumber <chr>,
#> #   georeferencedBy <chr>, associatedTaxa <chr>,
#> #   http...unknown.org.recordId <chr>, otherCatalogNumbers <chr>,
#> #   collectionID <chr>, georeferenceSources <chr>, habitat <chr>,
#> #   identificationRemarks <chr>
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
#>         type
#> 1 occurrence
#> 2 occurrence
#> 3 occurrence
#> 4 occurrence
#> 5 occurrence
#> 6 occurrence
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
#>          type
#> 10 occurrence
#> 12 occurrence
#> 23 occurrence
#> 39 occurrence
```

The code `cdround` represents the GBIF issue `COORDINATE_ROUNDED`, which means that

> Original coordinate modified by rounding to 5 decimals.

The content for this information comes from [http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html](http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html).

## Parse data based on issues

Now that we know a bit about GBIF issues, you can parse your data based on issues. Using the data generated above, and using the function `%>%` imported from `magrittr`, we can get only data with the issue `gass84`, or `GEODETIC_DATUM_ASSUMED_WGS84` (Note how the records returned goes down to 98 instead of the initial 100).


```r
res %>%
  occ_issues(gass84)
#> Records found [45844] 
#> Records returned [99] 
#> No. unique hierarchies [1] 
#> No. media records [84] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 99 x 103
#>    key   scientificName decimalLatitude decimalLongitude issues datasetKey
#>    <chr> <chr>                    <dbl>            <dbl> <chr>  <chr>     
#>  1 1990… Helianthus an…            52.6             10.1 cdrou… 6ac3f774-…
#>  2 1990… Helianthus an…            26.2            -98.2 cdrou… 50c9509d-…
#>  3 2247… Helianthus an…            58.4             11.9 cdrou… 38b4c89f-…
#>  4 1993… Helianthus an…            34.0           -117.  cdrou… 50c9509d-…
#>  5 1986… Helianthus an…            27.7            -97.3 cdrou… 50c9509d-…
#>  6 1993… Helianthus an…            33.4           -118.  cdrou… 50c9509d-…
#>  7 1990… Helianthus an…            53.9             10.9 cdrou… 6ac3f774-…
#>  8 1986… Helianthus an…            33.8           -118.  cdrou… 50c9509d-…
#>  9 2247… Helianthus an…            55.7             14.2 gass84 38b4c89f-…
#> 10 2236… Helianthus an…            26.2            -98.2 cdrou… 50c9509d-…
#> # … with 89 more rows, and 97 more variables: publishingOrgKey <chr>,
#> #   networkKeys <chr>, installationKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   taxonomicStatus <chr>, coordinateUncertaintyInMeters <dbl>,
#> #   year <int>, month <int>, day <int>, eventDate <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, catalogNumber <chr>, recordedBy <chr>,
#> #   institutionCode <chr>, locality <chr>, gbifID <chr>,
#> #   collectionCode <chr>, name <chr>, individualCount <int>,
#> #   continent <chr>, stateProvince <chr>, references <chr>,
#> #   rightsHolder <chr>, identifier <chr>, informationWithheld <chr>,
#> #   nomenclaturalCode <chr>, municipality <chr>, datasetName <chr>,
#> #   identificationVerificationStatus <chr>, language <chr>,
#> #   occurrenceID <chr>, type <chr>, taxonID <chr>, vernacularName <chr>,
#> #   datasetID <chr>, samplingProtocol <chr>, accessRights <chr>,
#> #   reproductiveCondition <chr>, dateIdentified <chr>, modified <chr>,
#> #   http...unknown.org.nick <chr>, verbatimEventDate <chr>,
#> #   verbatimLocality <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>, county <chr>,
#> #   occurrenceStatus <chr>, taxonConceptID <chr>, endDayOfYear <chr>,
#> #   startDayOfYear <chr>, higherClassification <chr>,
#> #   occurrenceRemarks <chr>, elevation <dbl>, recordNumber <chr>,
#> #   georeferencedBy <chr>, associatedTaxa <chr>,
#> #   http...unknown.org.recordId <chr>, otherCatalogNumbers <chr>,
#> #   collectionID <chr>, georeferenceSources <chr>, habitat <chr>,
#> #   identificationRemarks <chr>
```

Note also that we've set up `occ_issues()` so that you can pass in issue names without having to quote them, thereby speeding up data cleaning.

Next, we can remove data with certain issues just as easily by using a `-` sign in front of the variable, like this, removing data with issues `depunl` and `mdatunl`.


```r
res %>%
  occ_issues(-depunl, -mdatunl)
#> Records found [45844] 
#> Records returned [100] 
#> No. unique hierarchies [1] 
#> No. media records [84] 
#> No. facets [0] 
#> Args [limit=100, offset=0, taxonKey=9206251, fields=all] 
#> # A tibble: 100 x 103
#>    key   scientificName decimalLatitude decimalLongitude issues datasetKey
#>    <chr> <chr>                    <dbl>            <dbl> <chr>  <chr>     
#>  1 1990… Helianthus an…            52.6            10.1  cdrou… 6ac3f774-…
#>  2 2235… Helianthus an…            51.2             4.45 ""     7f5e4129-…
#>  3 1990… Helianthus an…            26.2           -98.2  cdrou… 50c9509d-…
#>  4 2247… Helianthus an…            58.4            11.9  cdrou… 38b4c89f-…
#>  5 1993… Helianthus an…            34.0          -117.   cdrou… 50c9509d-…
#>  6 1986… Helianthus an…            27.7           -97.3  cdrou… 50c9509d-…
#>  7 1993… Helianthus an…            33.4          -118.   cdrou… 50c9509d-…
#>  8 1990… Helianthus an…            53.9            10.9  cdrou… 6ac3f774-…
#>  9 1986… Helianthus an…            33.8          -118.   cdrou… 50c9509d-…
#> 10 2247… Helianthus an…            55.7            14.2  gass84 38b4c89f-…
#> # … with 90 more rows, and 97 more variables: publishingOrgKey <chr>,
#> #   networkKeys <chr>, installationKey <chr>, publishingCountry <chr>,
#> #   protocol <chr>, lastCrawled <chr>, lastParsed <chr>, crawlId <int>,
#> #   extensions <chr>, basisOfRecord <chr>, taxonKey <int>,
#> #   kingdomKey <int>, phylumKey <int>, classKey <int>, orderKey <int>,
#> #   familyKey <int>, genusKey <int>, speciesKey <int>,
#> #   acceptedTaxonKey <int>, acceptedScientificName <chr>, kingdom <chr>,
#> #   phylum <chr>, order <chr>, family <chr>, genus <chr>, species <chr>,
#> #   genericName <chr>, specificEpithet <chr>, taxonRank <chr>,
#> #   taxonomicStatus <chr>, coordinateUncertaintyInMeters <dbl>,
#> #   year <int>, month <int>, day <int>, eventDate <chr>,
#> #   lastInterpreted <chr>, license <chr>, identifiers <chr>, facts <chr>,
#> #   relations <chr>, geodeticDatum <chr>, class <chr>, countryCode <chr>,
#> #   country <chr>, catalogNumber <chr>, recordedBy <chr>,
#> #   institutionCode <chr>, locality <chr>, gbifID <chr>,
#> #   collectionCode <chr>, name <chr>, individualCount <int>,
#> #   continent <chr>, stateProvince <chr>, references <chr>,
#> #   rightsHolder <chr>, identifier <chr>, informationWithheld <chr>,
#> #   nomenclaturalCode <chr>, municipality <chr>, datasetName <chr>,
#> #   identificationVerificationStatus <chr>, language <chr>,
#> #   occurrenceID <chr>, type <chr>, taxonID <chr>, vernacularName <chr>,
#> #   datasetID <chr>, samplingProtocol <chr>, accessRights <chr>,
#> #   reproductiveCondition <chr>, dateIdentified <chr>, modified <chr>,
#> #   http...unknown.org.nick <chr>, verbatimEventDate <chr>,
#> #   verbatimLocality <chr>, http...unknown.org.occurrenceDetails <chr>,
#> #   rights <chr>, eventTime <chr>, identificationID <chr>, county <chr>,
#> #   occurrenceStatus <chr>, taxonConceptID <chr>, endDayOfYear <chr>,
#> #   startDayOfYear <chr>, higherClassification <chr>,
#> #   occurrenceRemarks <chr>, elevation <dbl>, recordNumber <chr>,
#> #   georeferencedBy <chr>, associatedTaxa <chr>,
#> #   http...unknown.org.recordId <chr>, otherCatalogNumbers <chr>,
#> #   collectionID <chr>, georeferenceSources <chr>, habitat <chr>,
#> #   identificationRemarks <chr>
```

## Expand issue codes to full names

Another thing we can do with `occ_issues()` is go from issue codes to full issue names in case you want those in your dataset (here, showing only a few columns to see the data better for this demo):


```r
out <- res %>% occ_issues(mutate = "expand")
head(out$data[,c(1,5)])
#> # A tibble: 6 x 2
#>   key        issues                                         
#>   <chr>      <chr>                                          
#> 1 1990684609 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 2 2235291308 ""                                             
#> 3 1990481993 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 4 2247028617 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 5 1993715633 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
#> 6 1986613930 COORDINATE_ROUNDED,GEODETIC_DATUM_ASSUMED_WGS84
```


## Add columns

Sometimes you may want to have each type of issue as a separate column.

Split out each issue type into a separate column, with number of columns equal to number of issue types


```r
out <- res %>% occ_issues(mutate = "split")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 x 7
#>   name   cdround gass84 gdativ scientificName  datasetKey  publishingOrgKey
#>   <chr>  <chr>   <chr>  <chr>  <chr>           <chr>       <chr>           
#> 1 Helia… y       y      n      Helianthus ann… 6ac3f774-d… bb646dff-a905-4…
#> 2 Helia… n       n      n      Helianthus ann… 7f5e4129-0… 4d3ceea8-5699-4…
#> 3 Helia… y       y      n      Helianthus ann… 50c9509d-2… 28eb1a3f-1c15-4…
#> 4 Helia… y       y      n      Helianthus ann… 38b4c89f-5… b8323864-602a-4…
#> 5 Helia… y       y      n      Helianthus ann… 50c9509d-2… 28eb1a3f-1c15-4…
#> 6 Helia… y       y      n      Helianthus ann… 50c9509d-2… 28eb1a3f-1c15-4…
```

## Expand and add columns

Or you can expand each issue type into its full name, and split each issue into a separate column.


```r
out <- res %>% occ_issues(mutate = "split_expand")
head(out$data[,c(1,5:10)])
#> # A tibble: 6 x 7
#>   name  COORDINATE_ROUN… GEODETIC_DATUM_… GEODETIC_DATUM_… scientificName
#>   <chr> <chr>            <chr>            <chr>            <chr>         
#> 1 Heli… y                y                n                Helianthus an…
#> 2 Heli… n                n                n                Helianthus an…
#> 3 Heli… y                y                n                Helianthus an…
#> 4 Heli… y                y                n                Helianthus an…
#> 5 Heli… y                y                n                Helianthus an…
#> 6 Heli… y                y                n                Helianthus an…
#> # … with 2 more variables: datasetKey <chr>, publishingOrgKey <chr>
```

## Wrap up

We hope this helps users get just the data they want, and nothing more. Let us know if you have feedback on data cleaning functionality in `rgbif` at _info@ropensci.org_ or at [https://github.com/ropensci/rgbif/issues](https://github.com/ropensci/rgbif/issues).
