## Test environments

* local OS X install, R 3.5.2 Patched
* ubuntu 14.04 (on travis-ci), R 3.5.2
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

License components with restrictions and base license permitting such:
  MIT + file LICENSE
File 'LICENSE':
  YEAR: 2019
  COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 7 reverse dependencies.
  (Summary at <https://github.com/ropensci/rgbif/blob/master/revdep/README.md>). Two notes were found and were unrelated to this package; one for non-ASCII characters and another for a package not available which has been archived on CRAN.

--------

This version adds more documentation, swaps out a remote webservice in the elevation() function, changes resulting data.frames in few key functions, and fixed a few bugs.

Thanks!
Scott Chamberlain
