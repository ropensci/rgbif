## Test environments

* local windows, R 4.1.2
* local macOS 11.6.3 (GitHub Actions), R 4.1.2
* ubuntu 18.04 (on GitHub Actions), R 4.1.2

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

* I have run R CMD check on the 14 reverse dependencies. Reverse dependency checks at <https://github.com/ropensci/rgbif/actions?query=workflow%3Arevdep>. No problems were found related to this package.

--------

Hello,

I am the new rgbif maintainer.

R CMD CHECK might fail on Linux environments because of a known issue with sf. 
https://github.com/r-spatial/sf/issues/1899

This version fixes many bugs and adds some additional capabilities.

Thanks!
John Waller