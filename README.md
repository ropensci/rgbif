# rgbif <img src="man/figures/logo.png" align="right" alt="" width="120">

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![cran checks](https://badges.cranchecks.info/worst/rgbif.svg)](https://cran.r-project.org/web/checks/check_results_rgbif.html)
[![R-CMD-check](https://github.com/ropensci/rgbif/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/rgbif/actions?query=workflow%3AR-CMD-check)
[![real-requests](https://github.com/ropensci/rgbif/workflows/R-check-real-requests/badge.svg)](https://github.com/ropensci/rgbif/actions?query=workflow%3AR-check-real-requests)
[![codecov.io](https://codecov.io/github/ropensci/rgbif/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rgbif?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rgbif)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rgbif)](https://cran.r-project.org/package=rgbif)
[![DOI](https://zenodo.org/badge/2273724.svg)](https://zenodo.org/badge/latestdoi/2273724)

**rgbif** is an R package which gives you access to [GBIF](https://www.gbif.org/) mediated data via its [REST API](https://www.gbif.org/developer/summary). 

**GBIF** (the Global Biodiversity Information Facility) is an international network and data infrastructure funded by the world's governments and aimed at providing anyone, anywhere, open access to data about all types of life on Earth.

## Installation

```r
install.packages("rgbif") # CRAN version
```

```r
pak::pkg_install("ropensci/rgbif") # dev version
```

```r 
install.packages("rgbif", repos="https://dev.ropensci.org") # dev version
```

## Getting Started 

There are several long-form articles that can help get you started:

* [Getting Started](https://docs.ropensci.org/rgbif/articles/rgbif.html)
* [Getting Occurrence Data From GBIF](https://docs.ropensci.org/rgbif/articles/getting_occurrence_data.html)
* [Working With Taxonomic Names](https://docs.ropensci.org/rgbif/articles/taxonomic_names.html)

Most GBIF users are interested in getting lat-lon occurrence records. 

```r 
occ_search(scientificName = "Pan troglodytes")
occ_data(scientificName = "Pan troglodytes")
```

It is usually better to get occurrence records using a **taxonKey**. See the article [Working With Taxonomic Names](https://docs.ropensci.org/rgbif/articles/taxonomic_names.html). 

```r 
taxonKey <- name_backbone("Pan troglodytes")$usageKey
occ_search(taxonKey = taxonKey)
```

GBIF **strongly recommends** the use of `occ_download()` rather than `occ_search()` for serious research projects. See article [Getting Occurrence Data From GBIF](https://docs.ropensci.org/rgbif/articles/getting_occurrence_data.html). 

> If repeated requests are made to the GBIF search API via `occ_search()`, users will be temporatily paused for 5 seconds. Please use `occ_download()` for bulk downloads.

It is required to set up your [GBIF credentials](https://docs.ropensci.org/rgbif/articles/gbif_credentials.html) to make downloads from GBIF. 

```r
occ_download(pred("taxonKey", 5219534)) # 5219534 is the taxonKey for Pan troglodytes
```

## Citation 

Under the terms of the GBIF data user agreement, users who download data agree to cite a DOI. Please see GBIF’s [citation guidelines](https://www.gbif.org/citation-guidelines) and [Citing GBIF Mediated Data](https://docs.ropensci.org/rgbif/articles/gbif_citations.html).

Please also cite **rgbif** by running `citation(package = "rgbif")`.

## Contributors

This list honors all contributors in alphabetical order. Code contributors are in bold.

[adamdsmith](https://github.com/adamdsmith) - [AgustinCamacho](https://github.com/AgustinCamacho) - [AldoCompagnoni](https://github.com/AldoCompagnoni) - [AlexPeap](https://github.com/AlexPeap) - [andzandz11](https://github.com/andzandz11) - [AshleyWoods](https://github.com/AshleyWoods) - [AugustT](https://github.com/AugustT) - [barthoekstra](https://github.com/barthoekstra) - **[benmarwick](https://github.com/benmarwick)** - [cathynewman](https://github.com/cathynewman) - [cboettig](https://github.com/cboettig) - [coyotree](https://github.com/coyotree) - **[damianooldoni](https://github.com/damianooldoni)** - [dandaman](https://github.com/dandaman) - [djokester](https://github.com/djokester) - [dlebauer](https://github.com/dlebauer) - **[dmcglinn](https://github.com/dmcglinn)** - **[dmi3kno](https://github.com/dmi3kno)** -  [dnoesgaard](https://github.com/dnoesgaard) - [DupontCai](https://github.com/DupontCai) - [ecology-data-science](https://github.com/ecology-data-science) - [EDiLD](https://github.com/EDiLD) - [elgabbas](https://github.com/elgabbas) - [emhart](https://github.com/emhart) - [fxi](https://github.com/fxi) - [ghost](https://github.com/ghost) - [gkburada](https://github.com/gkburada) - [hadley](https://github.com/hadley) - [Huasheng12306](https://github.com/Huasheng12306) - [ibartomeus](https://github.com/ibartomeus) - **[JanLauGe](https://github.com/JanLauGe)** - **[jarioksa](https://github.com/jarioksa)** - **[jeroen](https://github.com/jeroen)** - **[jhnwllr](https://github.com/jhnwllr)** - [jhpoelen](https://github.com/jhpoelen) - [jivelasquezt](https://github.com/jivelasquezt) - [jkmccarthy](https://github.com/jkmccarthy) - **[johnbaums](https://github.com/johnbaums)** - [jtgiermakowski](https://github.com/jtgiermakowski) - [jwhalennds](https://github.com/jwhalennds) - **[karthik](https://github.com/karthik)** - [kgturner](https://github.com/kgturner) - [Kim1801](https://github.com/Kim1801) - [ljuliusson](https://github.com/ljuliusson) - [ljvillanueva](https://github.com/ljvillanueva) - [luisDVA](https://github.com/luisDVA) - [martinpfannkuchen](https://github.com/martinpfannkuchen) - **[MattBlissett](https://github.com/MattBlissett)** - [MattOates](https://github.com/MattOates) - [maxhenschell](https://github.com/maxhenschell) - **[mdsumner](https://github.com/mdsumner)** - [no-la-ngo](https://github.com/no-la-ngo) - [Octoberweather](https://github.com/Octoberweather) - [omahs](https://github.com/omahs) - [Pakillo](https://github.com/Pakillo) - **[peterdesmet](https://github.com/peterdesmet)** - [PhillRob](https://github.com/PhillRob) - **[PietrH](https://github.com/PietrH)** - [poldham](https://github.com/poldham) - [qgroom](https://github.com/qgroom) - [raymondben](https://github.com/raymondben) - [rossmounce](https://github.com/rossmounce) - [sacrevert](https://github.com/sacrevert) - [sagitaninta](https://github.com/sagitaninta) - **[sckott](https://github.com/sckott)** - [scottsfarley93](https://github.com/scottsfarley93) - [simon-tarr](https://github.com/simon-tarr) - **[SriramRamesh](https://github.com/SriramRamesh)** - [stevenpbachman](https://github.com/stevenpbachman) - [stevensotelo](https://github.com/stevensotelo) - **[stevenysw](https://github.com/stevenysw)** - [TomaszSuchan](https://github.com/TomaszSuchan) - [tphilippi](https://github.com/tphilippi) - [vandit15](https://github.com/vandit15) - [vervis](https://github.com/vervis) - **[vijaybarve](https://github.com/vijaybarve)** - [willgearty](https://github.com/willgearty) - [Xuletajr](https://github.com/Xuletajr) - [yvanlebras](https://github.com/yvanlebras) - [zixuan75](https://github.com/zixuan75)

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rgbif/issues).
* License: MIT
* Get citation information for `rgbif` in R doing `citation(package = 'rgbif')`
* Please note that this package is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

There are similar GBIF clients in other languages :

* [Python](https://github.com/sckott/pygbif)
* [Ruby](https://github.com/sckott/gbifrb)
* [PHP](https://gitlab.res-telae.cat/restelae/php-gbif)

This package is part of [spocc](https://github.com/ropensci/spocc), along with several other packages, that provide access to occurrence records from multiple data sources.

