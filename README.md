# `rgbif`

Install from CRAN:
install.packages("rgbif")
require(rgbif)

Install using `install_github` within Hadley's [devtools](https://github.com/hadley/devtools) package.

```R
install.packages("devtools")
require(devtools)
# Install this developmental branch
install_github("rgbif", "vijaybarve")
require(rgbif)
# Install stable version from rOpenSci repository
install_github("rgbif", "ropensci")
require(rgbif)
```

This set of functions/package will access data from [GBIF](http://www.gbif.org/) using their API methods. 

See documentation the GBIF API here:  
http://data.gbif.org/tutorial/services