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

Note: Windows users have to first install [Rtools](http://cran.r-project.org/bin/windows/Rtools/).

### Packages `rgbif` depends on
+ XML
+ RCurl (>= 1.6)
+ plyr
+ ggplot2
+ maps
+ roxygen2 (as a suggest)

## Visualize occurrence data

```R
# A single species
out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 100)
gbifmap(input = out) # make a map using vertmap
```

<a href="http://www.flickr.com/photos/recology_/8057005912/" title="gbif_onespecies2 by scottlus, on Flickr"><img src="http://farm9.staticflickr.com/8170/8057005912_08fea48c42.jpg" width="500" height="362" alt="gbif_onespecies2"></a>

```R
# Many species, colored by species on map
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Buteo regalis')
out <- lapply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 100))
gbifmap(out)
```

<a href="http://www.flickr.com/photos/recology_/8057000598/" title="gbifmap_manyspecies by scottlus, on Flickr"><img src="http://farm9.staticflickr.com/8038/8057000598_9542052842_z.jpg" width="640" height="388" alt="gbifmap_manyspecies"></a>