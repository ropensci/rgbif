## Test environments

* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.3.2
* win-builder (devel and release)
* R-hub (Windows R-oldrel, Ubuntu R-release, Fedora R-devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Scott Chamberlain <myrmecocystus@gmail.com>'

License components with restrictions and base license permitting such:
  MIT + file LICENSE
File 'LICENSE':
  YEAR: 2016
  COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 5 downstream dependencies.
  (Summary at https://github.com/ropensci/rgbif/blob/master/revdep/README.md). 
  
* One downstream dependency had problems, but I checked and they are 
unrelated to changes in this package.

* All revdep maintainers were notified of the release.

--------

This version adds many new features, implements a few minor fixes, 
and some bug fixes.

Thanks!
Scott Chamberlain
