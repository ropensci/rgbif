# `rgbif`

Install the version from CRAN:

```R
install.packages("rgbif")
require(rgbif)
```

Install the development version using `install_github` within Hadley's [devtools](https://github.com/hadley/devtools) package.

```R
install.packages("devtools")
require(devtools)

install_github("rgbif", "ropensci")
require(rgbif)
```

This set of functions/package will access data from [GBIF](http://www.gbif.org/) using their API methods. 

See documentation the GBIF API here:  
http://data.gbif.org/tutorial/services