<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Tutorial for using the old GBIF API}
-->

rgbif tutorial
--------------

*Note: this vignette works with the current version on CRAN that works with the old GBIF API.*

The `rgbif` package interacts with the API services of the Global Biodiversity Information Facility [GBIF](http://www.gbif.org/). GBIF currently holds 377,177,914 indexed records, ~10K datasets, and 419
publishers (i.e., dataset submitters).

This tutorial will go through three use cases to demonstrate the kinds of things possible in `rgbif`.

* Counts taxon concept records matching a range of filters.
* Returns summary counts of occurrence records by one-degree cell.
* occurrencelist searches for taxon concept records matching a range
of filters.
* densitylist gets density of occurrence records by one-degree cell.
* Search by taxon to retrieve number of records in GBIF.

## Install and load package from GitHub


```r
install.packages("rgbif")
```



```r
library(rgbif)
```


## Counts taxon concept records matching a range of filters.


```r
occurrencecount(scientificname = "Helianthus annuus", coordinatestatus = TRUE, 
    year = 2005, maxlatitude = 20)
```

```
[1] 138
```


Count many taxa


```r
lapply(c("Helianthus debilis", "Abies procera", "Astragalus"), function(x) occurrencecount(scientificname = x, 
    coordinatestatus = TRUE))
```

```
[[1]]
[1] 26

[[2]]
[1] 573

[[3]]
[1] 945
```


## Return summary counts of occurrence records by one-degree cell for a single taxon, country, dataset, data publisher or data network


```r
out <- densitylist(originisocountrycode = "CA")
head(gbifdata(out))
```

```
  cellid minLatitude maxLatitude minLongitude maxLongitude count
1  46913          40          41          -67          -66    44
2  46914          40          41          -66          -65   519
3  46915          40          41          -65          -64   475
4  46916          40          41          -64          -63   432
5  46917          40          41          -63          -62    55
6  46918          40          41          -62          -61   143
```


## Occurrencelist searches for taxon concept records matching a range of filters.

A simple example


```r
dat <- occurrencelist(scientificname = "Accipiter erythronemius", coordinatestatus = TRUE, 
    maxresults = 10)
gbifdata(dat)
```

```
                 taxonName occurrenceID     country decimalLatitude
1  Accipiter erythronemius    352220558   Argentina         -31.133
2  Accipiter erythronemius    213206174 W. Colombia           3.767
3  Accipiter erythronemius    699199195   Argentina         -25.861
4  Accipiter erythronemius    699199198   Argentina         -25.911
5  Accipiter erythronemius    621073311   Argentina         -27.352
6  Accipiter erythronemius    621073312   Argentina         -27.352
7  Accipiter erythronemius    621073310   Argentina         -27.352
8  Accipiter erythronemius    699199204   Argentina         -25.861
9  Accipiter erythronemius    699417490      Guyana           5.267
10 Accipiter erythronemius    686297260      Guyana           5.267
   decimalLongitude  catalogNumber earliestDateCollected
1            -59.02 YPM ORN 065671            1961-04-30
2            -76.75    Skin-470489                  <NA>
3            -54.52          39196                  <NA>
4            -54.36          38199                  <NA>
5            -65.60          42228                  <NA>
6            -65.60          42227                  <NA>
7            -65.60          42229                  <NA>
8            -54.52          38015                  <NA>
9            -60.73           3998            2001-04-03
10           -60.73          93439            2001-04-03
   latestDateCollected
1           1961-04-30
2                 <NA>
3                 <NA>
4                 <NA>
5                 <NA>
6                 <NA>
7                 <NA>
8                 <NA>
9           2001-04-03
10          2001-04-03
```


Search for many species and make a map


```r
splist <- c("Accipiter erythronemius", "Junco hyemalis", "Aix sponsa")
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
gbifmap_list(out)
```

![plot of chunk occurrencelist_many](figure/occurrencelist_many.png) 


## densitylist provides access to records showing the density of occurrence records from the GBIF Network by one-degree cell.

A simple example


```r
out <- densitylist(originisocountrycode = "US")
gbifmap_dens(out)
```

![plot of chunk densitylist2](figure/densitylist2.png) 


## Search by taxon to retrieve number of records in GBIF.


```r
taxoncount("Puma concolor")
```

```
[1] 91
```



```r
taxoncount("Helianthus annuus")
```

```
[1] 142
```

