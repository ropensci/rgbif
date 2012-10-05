# `rgbif`

## About
This set of functions/package will access data from [GBIF](http://www.gbif.org/) using their API methods. 

See documentation the GBIF API here:  
http://data.gbif.org/tutorial/services

## Install

### Install the version from CRAN:

```R
install.packages("rgbif")
require(rgbif)
```

### Install the development version using `install_github` within Hadley's [devtools](https://github.com/hadley/devtools) package.

```R
install.packages("devtools")
require(devtools)

install_github("rgbif", "ropensci")
require(rgbif)
```

## Visualize occurrence data

```R
# A single species
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
gbifmap(input = out) # make a map using vertmap
 
# Many species, colored by species on map
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Buteo regalis')
out <- lapply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 100, latlongdf = T))
gbifmap(out)
```