## Test environments

* local windows, R 4.2.3
* windows latest R "release" version (GitHub Actions)
* ubuntu latest, R "release" version (GitHub Actions)
* macOS latest, R "release" version (GitHub Actions)
* winbuilder (R-devel, 2026-08-17 r90424)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

I have run R CMD check on 22 reverse dependencies (summary below).
Reverse dependency check results: <https://github.com/ropensci/rgbif/actions/runs/32135299024>

* 21 packages: OK
* 1 package with new issues: occCite (0.6.2)

The occCite package has test failures due to changes in rgbif's data structure. I have contacted the 
maintainer (Hannah Owens, hannah.owens@gmail.com) via email.

## Breaking changes

This release includes a major breaking change: the default taxonomy has changed 
from GBIF Backbone to COL (Catalogue of Life) Extended Release. 

**Backward compatibility**: Existing code using numeric taxonomic keys will 
continue to work. The package automatically detects numeric keys and switches 
to the GBIF Backbone taxonomy with a warning message, giving users time to 
migrate at their own pace.

**Migration support**: 
* A new function `gbif_to_col()` helps users convert existing GBIF Backbone 
  numeric keys to COL XR alpha-numeric keys
* A comprehensive migration guide vignette is included
* See NEWS.md for full details

--------

Hello,

This version includes a major taxonomy migration (GBIF Backbone to COL XR along with new features and bug fixes.

Thanks!
John Waller