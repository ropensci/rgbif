<!-- README.md is generated from README.Rmd. Please edit that file and knit -->



# rgbif <img src="man/figures/logo.png" align="right" alt="" width="120">

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/rgbif)](https://cranchecks.info/pkgs/rgbif)
[![R-CMD-check](https://github.com/ropensci/rgbif/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/rgbif/actions/)
[![codecov.io](https://codecov.io/github/ropensci/rgbif/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rgbif?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rgbif)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rgbif)](https://cran.r-project.org/package=rgbif)
[![DOI](https://zenodo.org/badge/2273724.svg)](https://zenodo.org/badge/latestdoi/2273724)

`rgbif` gives you access to data from [GBIF][] via their REST API. GBIF versions their API - we are currently using `v1` of their API. You can no longer use their old API in this package - see `?rgbif-defunct`.

Please cite rgbif. Run the following to get the appropriate citation for the version you're using:

```r
citation(package = "rgbif")
```

To get started, see:

* rgbif vignette (https://docs.ropensci.org/rgbif/articles/rgbif.html): an introduction to the package's main functionalities.
* Function reference (https://docs.ropensci.org/rgbif/reference/index.html): an overview of all `rgbif` functions.
* Articles (https://docs.ropensci.org/rgbif/articles/index.html): vignettes/tutorials on how to download data, clean data, and work with taxonomic names.
* Occurrence manual (https://books.ropensci.org/occurrences/): a book covering a suite of R packages used for working with biological occurrence data.

Check out the `rgbif` [paper][] for more information on this package and the sister [Python][pygbif] and [Ruby][gbifrb] clients.

Note: Maximum number of records you can get with `occ_search()` and `occ_data()` is 100,000. See https://www.gbif.org/developer/occurrence

## Installation


```r
install.packages("rgbif")
```

Or, install development version


```r
install.packages("remotes")
remotes::install_github("ropensci/rgbif")
```


```r
library("rgbif")
```

> Note: Windows users have to first install Rtools (https://cran.r-project.org/bin/windows/Rtools/) to use devtools

Mac Users:
(in case of errors)

Terminal:

Install gdal : https://github.com/edzer/sfr/blob/master/README.md#macos

```
brew install openssl
```

in R:


```r
install.packages('openssl')
install.packages('rgeos')
install.packages('rgbif')
```

## Screencast

<a href="https://vimeo.com/127119010"><img src="man/figures/README-screencast.png" width="400"></a>


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rgbif/issues).
* License: MIT
* Get citation information for `rgbif` in R doing `citation(package = 'rgbif')`
* Please note that this project is released with a [Contributor Code of Conduct][coc].
By participating in this project you agree to abide by its terms.

- - -

This package is part of [spocc](https://github.com/ropensci/spocc), along with several other packages, that provide access to occurrence records from multiple data sources.

- - -

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[mapr]: https://github.com/ropensci/mapr
[paper]: https://peerj.com/preprints/3304/
[GBIF]: https://www.gbif.org/
[pygbif]: https://github.com/sckott/pygbif
[gbifrb]: https://github.com/sckott/gbifrb
[coc]: https://github.com/ropensci/rgbif/blob/master/.github/CODE_OF_CONDUCT.md
