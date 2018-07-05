rgbif 1.0.2
===========

### MINOR IMPROVEMENTS

* significant change to `occ_download_queue()`: sleep time between successive calls to check on the status of download requests is now 10 seconds or greater. This shouldn't slow down your use of `occ_download_queue()` much because most requests should take more than the 10 seconds to be prepared (#313)
* add tests for download queue method (#315)
* explicitly `@importFrom` fxns used from `lazyeval` package to avoid check note (#316)
* remove `reshape2` and `maps` packages from Suggests (#317)

### BUG FIXES

* fix bug in `name_usage()`: we were screwing up parsing of issues column when single taxon keys passed in (#314)

rgbif 1.0.0
===========

### NEW FEATURES

* `occ_issues()` now works with download data and arbitrary data.frame's (#193)
* New downloads queueing tools: gains functions `occ_download_prep()` for preparing a download request without executing it, and `occ_download_queue()`  for kicking off many download jobs while respecting GBIF's downloads rate limits. See also internal R6 classes for dealing with queuing: `DownReq`, `GifQueue`. See `?occ_download_queue` to get started (#266) (#305) (#311)
* New function `map_fetch()` working with the GBIF maps API <https://www.gbif.org/developer/maps>. See `?map_fetch` to get started (#238) (#269) (#284) thanks to @JanLauGe for the work on this
* `name_lookup()` gains `origin` parameter (#288) (#293) thanks @peterdesmet and @damianooldoni
* `name_lookup()` and `name_usage()` gain internal paging - just as `occ_search()`/`occ_data()` have (#291) (see also #281) thanks @damianooldoni 
* new import `lazyeval`, and new suggests `png` and `raster`
* `occ_search()`/`occ_data()` gain parameter `skip_validate` (boolean) to skip or not stkip WKT validation by the `wicket` package

### MINOR IMPROVEMENTS

* removed warnings about parameters that were removed in previous versions of the package (#189)
* add citation file (#189)
* updated `name_usage()` to check params that now only allow 1 value: name, language, datasetKey, rank (#287)
* `occ_count()` loses `nubKey`, `catalogNumber`, and `hostCountry` as those parameters are no longer accepted by GBIF

### BUG FIXES

* fixed bug in `name_usage()`, was screwing something up internally (#286)
* fixed bug in `occ_data()`: curl options weren't being passed through (#297)
* fixed geometry usage in `occ_search()`/`occ_data()` - skipping the wicket validation and constructing WKT by hand from bounding box (if bounding box given) - the validation that wicket does isn't what GBIF wants (#303)
* add `fill` parameter to  `occ_download_import()` to pass on to `fill` in `data.table::fread`, and set `fill=TRUE` as default.  (#292)
* better failure for `occ_download()` (#300)
* fix bug in `occ_download()` in which a single `taxonKey` passed in was failing (#283)
* `name_usage()` was ignoring `datasetKey` and `uuid` parameters (#290)

### DEFUNCT AND DEPRECATED

* `gbifmap()` has been removed, see the package `mapr` for similar functionality and `map_fetch()` in this package to use the GBIF map API (#298)


rgbif 0.9.9
===========

### NEW FEATURES

* Gains new functions `occ_download_datasets` and `occ_download_dataset_activity` to list datasets for a download,
and list the downloads activity of a dataset (#275) (#276)
* Gains a new vignette covering working with GBIF downloads 
in `rgbif` (#262)

### MINOR IMPROVEMENTS

* Guidance added to docs for downloads functions on length of the
request body (#263)
* Changed authentication details (user name, password, email) for 
downloads to allow any of the options: pass in as arguments,
store as R options, store as environment variables (#187)
* `gbif_citation()` function gains an S3 method for passing the 
output of `occ_download_meta()` to it. In addition, for downloads
`gbif_citation()` now returns a citation for the entire download 
(including) its DOI, in addition to citations for each dataset (#274) 
thanks @dnoesgaard

### BUG FIXES

* Fix documentation bug in `occ_count()`: `georeferenced` had a 
misleading description of what the value `FALSE` did (#265)
* Fixed bug in `gbifmap()` - was failing in some cases - better
error handlingn now (#271) thanks @TomaszSuchan
* Fixed `occ_download_cancel_staged()`: it wasn't passing on authentication
parameters correctly (#280)


rgbif 0.9.8
===========

### NEW FEATURES

* The GBIF API supports passing in many instances of the same
parameter for some parameters on some routes. Previously we
didn't support this feature, but now we do. See the
`?many-values` manual file for details. added docs to
individual functions that support this, and added additional
tests (#200) (#260) (#261)
* We've removed `V8` dependency and replaced with C++ based
WKT parser package `wicket`. We still use `rgeos` for some
WKT parsing. rgbif functions that use wicket: `gbif_bbox2wkt`,
`gbif_wkt2bbox`, `check_wkt` (#243)
* `httr` replaced with `crul` for HTTP reqeusts. As part of
this change, the `...` parameter was replaced in most functions
by `curlopts` which expects a list. Some functions require
a `...` parameter for facet inputs, so `...` is retained
with the addition of `curltops` parameter. A result of this
change is that whereas in the past parameters that were not
defined in a function that also had a `...` parameter
would essentially silently ignore that undefined parameter,
but with functions where `...` was removed a misspelled
or undefined parameter will cause an error with message (#256)

### MINOR IMPROVEMENTS

* moved to markdown docs (#258)
* namespacing calls to base R pkgs instead of importing them

### BUG FIXES

* Fixed problem in `occ_download_import()` to allow import
of csv type download in addition to darwin core archive.
additional change to `occ_download_get` to add `format`
attribute stating which format (#246)
* fix to `occ_download_import` adding `fill=TRUE` to
the `data.table::fread` call (#257)


rgbif 0.9.7
===========

### NEW FEATURES

* `occ_dowload` gains new parameter `body` to allow users to pass in
JSON or a list for the query instead of passing in statements to
`...`. See examples in `?occ_dowload`.

### MINOR IMPROVEMENTS

* Now using `tibble` for compact data.frame output for
`occ_download_import` instead of bespoke internal solution (#240)
* Moved all GBIF API requests to use `https` instead of `http` (#244)
* Improved print method for `occ_download_meta`

### BUG FIXES

* Fix to `occ_download` to structure query correctly when
`type=within` and `geometry` used because the structure is slightly
different than when not using `geometry` (#242)
* Fixed `occ_download` to allow `OR` queries for many values of a
parameter, e.g., `taxonKey=2475470,2480946` will be queried correctly
now as essentially `taxonKey=2475470` or `taxonKey=2480946` (#245)


rgbif 0.9.6
===========

### BUG FIXES

* Fixed a bug in `parsenames()` caused by some slots in the list
being `NULL` (#237)
* Fixed some failing tests: `occ_facet()` tests were failing due to
changes in GBIF API (#239)
* Fixes to `gbif_oai_get_records()` for slight changes in `oai`
dependency pkg (#236)


rgbif 0.9.5
===========

### NEW FEATURES

* `occ_search()` now has faceted search. This feature is not in `occ_data()`
as that function focuses on getting occurrence data quickly, so will not
do get facet data. This means that a new slot is available in the output
object from `occ_search()`, namely `facets`. Note that `rgbif` has had
faceted search for the species search route (`name_lookup()`) and the
registry search route (`dataset_search()`) for quite a while. (#215)
* new function (`occ_facet()`) to facilitate retrieving only
facet data, so no occurrence data is retrieved. (#215) (#229)
* A suite of new parameters added to `occ_search()` and
`occ_data()` following addition the GBIF search API: `subgenusKey`,
`repatriated`, `phylumKey`, `kingdomKey`,
`classKey`, `orderKey`, `familyKey`, `genusKey`, `establishmentMeans`,
`protocol`, `license`, `organismId`, `publishingOrg`, `stateProvince`,
`waterBody`, `locality` (#216) (#224)
* New parameter `spellCheck` added to `occ_search()` and
`occ_data()` that if `TRUE` spell checks anything passed to the `search`
parameter (same as `q` parameter on GBIF API; which is a full text
search) (#227)
* New function `occ_spellcheck` to spell check search terms, returns
`TRUE` if no spelling problems, or a list with info on suggestions
if not.
* Both `occ_search()` and `occ_data()` now have ability to support
queries where `limit=0`, which for one should be possible and not
fail as we did previously, and second, this makes it so that you
can do faceted searches (See above) and not have to wait for occurrence
records to be returned. (#222)
* `MULTIPOLYGON` well known text features now supported in the GBIF
API. Previously, you could not query `geometry` with more than
one polygon (`POLYGON`), but now you can. (#222)

### MINOR IMPROVEMENTS

* Improved docs for `occ_count()`, especially for the set of
allowed parameter options that the GBIF count API supports
* `occ_count()` gains new parameter `typeStatus` to indicate the
specimen type status.
* When no results found, the `data` slot now returns `NULL` instead
of a character string

### BUG FIXES

* Fixes to `gbif_photos()`: 1) Mapbox URLs to their JS and CSS assets
were out of date, and API key needed. 2) In RStudio, the `table` view
was outputting errors due to serving files on `localhost:<port>`
instead of simply opening the file; fixed now by checking platform
and using simple open file command appropriate for the OS. (#228) (#235)


rgbif 0.9.4
===========

### NEW FEATURES

* Now using `tibble` in most of the package when the output is
a data.frame (#204)
* New vignette _Taxonomic Names_ for discussing some common names
problems users may run into, and some strategies for dealing with
taxonomic names when using GBIF (#208) (#209)

### MINOR IMPROVEMENTS

* Replaced `is()` with `inherits()`, no longer importing `methods()` (#219)
* Improved docs for registry functions. Not all options were listed
for the `data` parameter, now they are (#210)
* Fixed documentation error in `gbifmap()` man file (#212) thanks to @rossmounce

### BUG FIXES

* Fixed bug in internal parser within `occ_download()`, in which
strings to parse were not being parsed correctly if spaces weren't in
the right place, should be more robust now, and added tests (#217). Came
from https://discuss.ropensci.org/t/rgbif-using-geometry-in-occ-download/395
* The parameter `type` was being silently ignored in a number of
registry functions. fixed that. (#211)


rgbif 0.9.3
===========

### NEW FEATURES

* `occ_data()` and `occ_search()` gain ability to more flexibly deal with inputs to the
`geometry` parameter. Previously, long WKT strings passed to `occ_search()` or
`occ_data()` would fail because URIs can only be so long. Another option is to use
the download API (see `?downloads`). This version adds the ability to choose what to
do with long WKT strings via the `geom_big` parameter: `asis` (same as previous version),
`bbox` which detects if a WKT sting is likely too long, and creates a bounding box from the
WKT string then once data is retrived, clips the result to the original WKT string; `axe`
uses the `geoaxe` package to chop up the input WKT polygon into many, with toggles in the
new parameters `geom_size` and `geom_n`. (#197) (#199)
* As part of this change, when >1 geometry value passed, or if `geom_big="axe"`, then
named elements of the output get names `geom1`, `geom2`, `geom3`, etc. instead of the
input WKT strings - this is because WKT strings can be very long, and make for very
awkward named access to elements. The original WKT strings can still be accessed via
`attr(result, "args")$geometry`

### MINOR IMPROVEMENTS

* code tidying throughout the package

### BUG FIXES

* Fix parsing bug in `name_usage()` function, see commit [e88cf01cc11cb238d44222346eaeff001c0c637e](https://github.com/ropensci/rgbif/commit/e88cf01cc11cb238d44222346eaeff001c0c637e)
* Fix to tests to use new `testthat` fxn names, e.g., `expect_gt()`
instead of `expect_more_than()`
* Fix to `occ_download()` to parse error correctly when empty body passed from
GBIF (#202)


rgbif 0.9.2
===========

### NEW FEATURES

* New function `occ_data()` - its primary purpose to perform faster data requests. Whereas
`occ_search()` gives you lots of data, including taxonomic hierarchies and media records,
`occ_data()` only gives occurrence data. (#190)

### MINOR IMPROVEMENTS

* Replaced `XML` with `xml2` (#192)
* Speed ups to the following functions due to use of `data.table::rbindlist()` for
fast list to data.frame coercion: `name_lookup()`, `name_backbone()`, `name_suggest()`,
`name_usage()`, and `parsenames()` (#191)
* Changes to `httr` usage to comply with changes in `httr >= v1.1.0`: now setting
encoding explicitly to `UTF-8` and parsing all data manually, using the internal
function `function(x) content(x, "text", encoding = "UTF-8")` (#195)

### BUG FIXES

* Fix to internal function `move_col()` to not fail on fields that don't exist.
Was failing sometimes when no latitude or longitude columns were returned. (#196)

rgbif 0.9.0
===============

### NEW FEATURES

* New set of functions (`gbif_oai_*()`) for working with
GBIF registry OAI-PMH service. Now importing `oai` package to
make working with GBIF's OAI-PMH service easier (#183)
* Added code of conduct (#180)
* Now sending user-agent header with all requests from this
package to GBIF's servers indicating what version of rgbif
and that it's an ropensci package. Looks like
`r-curl/0.9.4 httr/1.0.0 rOpenSci(rgbif/0.9.0)`, with whatever
versions of each package you're using. We also pass a user-agent
string with the header `X-USER-AGENT` in case the `useragent`
header gets stripped somewhere along the line (#185)
* New function `gbif_citation()` helps get citations for datasets
eith using the occurrence search API via `occ_search()` or the
downloads API via `occ_downlad()` (#178) (#179)

### MINOR IMPROVEMENTS

* Using `importFrom` instead of `import` in all cases now.
* Parameter `collectorName` changed to `recordedBy` (#184)

### BUG FIXES

* Fix to `occ_download_meta()` print method to handle 1 or more predicate results (#186)
* Fix to `occ_issues()` to work with `return=data` and `return=all` `occ_search()` output (#188)

rgbif 0.8.9
===============

### MINOR IMPROVEMENTS

* Updated `terraformer.js` javascript code included in the package
along with an update in that codebase (#156)
* The `email` parameter now `NULL` by default in the function
`occ_download()`, so that if not provided or not set in options,
then function fails. (#173)
* Additional explanation added to the `?downloads` help file.
* Added internal checks to `elevation()` to check for coordinates that
are impossible (e.g., latitude > 90), not complete (e.g., lat given,
long not given), or points at `0,0` (just warns, doesn't stop). (#176)
thanks @luisDVA
* General code tidying across package

### BUG FIXES

* A route changed for getting images for a taxon within the `/species`
route, fix to function `name_usage()` (#174)
* Fix to `occ_search()` to remove a block of code to do synonym checking.
This block of code was used if the parameter `scientificName` was passed,
and checked if the name given was a synonym; if yes, we used the accepted
name according to the GBIF backbone taxonomy; if no, we proceeded with the
name given by the user. We removed the block of code because the GBIF
API now essentially does this behind the scenes server side. See
https://github.com/gbif/gbif-api for examples. (#175)

rgbif 0.8.8
===============

### MINOR IMPROVEMENTS

* Additional tests added for `gbif_photos()` and `gbif_names()` (#170)

### BUG FIXES

* Fixed a few tests that were not passing on CRAN.

rgbif 0.8.6
===============

### NEW FEATURES

* New set of functions with names `occ_download*()` for working with the GBIF download API. This is the same service as using the GBIF website, but via an API. See `?downloads`. (#154) (#167)

### MINOR IMPROVEMENTS

* Explicitly import non-base R pkg functions, so importing from `utils`, `methods`, and `stats` (#166)

### BUG FIXES

* Fixed problem with `httr` `v1` where empty list not allowed to pass to
the `query` parameter in `GET` (#163)


rgbif 0.8.4
===============

### NEW FEATURES

* New functions for the `/enumerations` GBIF API route: `enumeration()`
and `enumeration_country()`. Many parts of the GBIF API make use of
enumerations, i.e. controlled vocabularies for specific topics - and are
available via these functions. (#152)

### IMPROVEMENTS

* `elevation()` now requires an API key (#148)
* The `V8` package an Import now, used to do WKT read/create with use of
the Javascript library Terraformer (http://terraformer.io/). Replaces
packages `sp` and `rgeos`, which are no longer imported (#155)
* Changed `occ_search()` parameter `spatialIssues` to
`hasGeospatialIssues` (#151)
* Added note to docs about difference between `/search` and `/count`
services, and how they work. (#150)
* Added tests for habitat parameter in `name_lookup()` (#149)
* Dropped `plyr` from Imports (#159)
* Dropped `stringr` from Imports (#160)
* Dropped `maps` and `grid` packages from Imports (#161)

### BUG FIXES

* Looping over records with `limit` and `start` parameters was in some
cases resulting in duplicate records returned. Problem fixed. (#157)

rgbif 0.8.0
===============

### IMPROVEMENTS

* All example moved to `\dontrun` (#139)
* README fixes for html (#141)
* Fixed documentation in `occ_search()` to give correct values for default and max limit
and start parameters (#145)
* Changed internal `GET` helper function to properly pass on error message (#144)
* Replaced `assertthat::assert_that()` with `stopifnot()` to have one less dependency (#134)
* Fixed `occ_search()` to allow ability to query by only publishingCountry, that is, with no
other parameters if desired (#137)

### BUG FIXES

* Fixed bug in internal `GET()` helper function to just pass `NULL` to the `query` parameter when
the list of length 0 passed, since it caused requests to fail in some cases.
* Fix to `name_lookup()` to force a logical entry for certain parameters - before this fix
if the correct logical param was not passed, the GBIF API went with its default parameter (#135)
* Fixed bug in `name_backbone()` due to change in `namelkupparser()` helper function - fixes
parsing for verbose output (#136)
* Fixed some broken URLs in `occ_search()` documentation (#140)


rgbif 0.7.7
===============

### NEW FEATURES

* New function `occ_issues()` to subset data from `occ_search()` based on GBIF issues. (#) (#122)
* Related to the last bullet, GBIF issues now are returned by default in `occ_search()` results, and are intentionally moved to the beginning of the column order of the data to be more obvious. (#102)
* `occ_search()` now returns all data fields by default. The default setting for the `fields` parameter is `all` - but can be changed. See `?occ_search`
* New function `gbif_names()` to view highlighted terms in name results from a call to `name_lookup()`. (#114)
* New functions: `occ_issues_lookup()` to lookup GBIF issues based on code name or full issue name, and `gbif_issues()` to print the entire issues table.

### IMPROVEMENTS

* Completely replaced `RCurl` with `httr`
* Completely replaced `RJSONIO` with `jsonlite`. Should see slight performance in JSON parsing with `jsonlite`.
* Default number of records in `occ_search()` now 500; was 25. (#113)
* Vignette for old version of GBIF API removed.
* New vignette for cleaning data via GBIF issues added. (#132)
* Functions for working with old GBIF API removed, now defunct. (#116)
* Now better parsing for some functions (`organizations()`, `datasets()`, `networks()`, `nodes()`, `installations()`) to data.frames when possible. (#117)
* Added further help to warn users when searching on ranges in latitude or longitude in `occ_search()` (#123)
* `callopts` parameter changed to `...` throughout all functions. Now pass on options to `httr` as named lists or functions. (#130)
* Beware that GBIF data is becoming Darwin Core compliant - so many parameters throughout this package have changed from sentence_case to camelCase.
* `dataset_search()` and `dataset_suggest()` gain new parameter `publishingOrg`
* Default for `limit` parameter changed to 100 for dataset functions: `dataset_search()`, `dataset_suggest()`, and `datasets()`.
* Default for `limit` parameter changed to 100 for registry functions: `installations()`, `networks()`, `organizations`, and `nodes()`.
* Parameter changes in `networks()`: `name`, `code`, `modifiedsince`, `startindex`, and `maxresults` gone; new parameters `query`, `identifier`, `identifierType`, `limit`, and `start`
* Parameter changes in `nodes()`: new parameters `identifier`, `identifierType`, `limit`, and `start`

### BUG FIXES

* `occ_search()` failed sometimes on species that were not found. Fixed. (#112)
* Added better handling of some server errors to pass on to user. (#115) (#118)
* Fixed incorrect parsing for some cases in `occ_search()` (#119)
* Fixed bad parsing on output from `name_lookup()` (#120)
* Fixed single map option in `gbif_photos()` that caused map with no data. (#121)
* Fixed some parameter names in `name_()` functions according to changes in the GBIF API spec, and fixed documentation to align with GBIF API changes, and added note about maximum limit. (#124) (#127) (#129) Thanks to @willgearty !
* Fixed internals of `occ_search()` so that user can pass in multiple values to the `issue` parameter. (#107)
* Fixed URL to tutorial on ropensci website (#105) Thanks @fxi !

rgbif 0.7.0
===============

### NEW FEATURES

* `occ_search()` now has a `dplyr` like summary output when `return='all'`. See `?occ_search` for examples. You can still easily access all data, by indexing to `meta`, `hierarchy`, `data`, or `media` via e.g., `$data`, `['data']`, or `[['data']]`. (#95)
* Media now returned from the GBIF API. Thus, in `occ_search()`, we now return a media slot in the output list by default.
* New function `gbif_photos()` to view media files (photos in the wild or of museum specimens). Two options are available, `which='map'` creates a single map which presents the image when the user clicks on the point, and `which='table'` in which a table has one row for each image, presenting the image and an interactive map with the single point. (#88)
* Two new packages are imported: `sp` and `whisker`

### IMPROVEMENTS

* GBIF updated their API, now at v1. URL endpoints in `rgbif` changed accordingly. (#92)
* GBIF switched to using 2-letter country codes. Take note. (#90)
* GBIF switched all parameters to `camelCase` from `under_score` style - changed accordingly in `rgbif`.
* Using package custom version of `plyr::compact()` instead of importing from `plyr`.
* In `name_lookup()` removed `facet_only` parameter as it doesn't do anything - use `limit=0` instead. Further, added two new slots of output: `hierarchy` and `names` (for common/vernacular names) (#96). The output can be determined by user via the `return` parameter.
* In `name_suggest()`, if the field `higherClassificationMap` is selected to be returned via the `fields` parameter, a list is returned with a data frame, and a list of the hierarchies separately. If `higherClassificationMap` is not selected, only a data frame is returned.
* `occ_search()` gains new parameters  `mediatype` and `issue` (#93), with detailed list of possible options for the `issue` parameter. Gains new examples for searching for images, examples of calls that will throw errors.
* Updated the vignette.

### BUG FIXES

* Added better error message to `check_wkt()`.
* `facet_only` parameter removed from `dataset_search()` function as it doesn't do anything - use `limit=0` instead.
* Fixed some examples that didn't work correctly.

rgbif 0.6.3
===============

### IMPROVEMENTS

* Added functions `gbif_bbox2wkt()` and `gbif_wkt2bbox()` to convert a bounding box to wkt and a wkt object to a bounding box, respectively. Copied from the `spocc` package. Prefixes to fxn names will avoid conflicts.
* Now spitting out more informative error messages when WKT strings passed in are not properly formed, either from `rgeos::readWKT` or from the returned response from GBIF.

rgbif 0.6.2
===============

### BUG FIXES

* `gbifmap()` was throwing an error because it was looking for two variables `latitude` and `longitude`, which had been changed to `decimalLatitude` and `decimalLongitude`, respectively, in other functions in this package. Fixed. (#81)
* `occ_get()` was updated to include changes in the GBIF API for this endpoint. The fix included fixing the parser for verbatim results, see `rgbif::gbifparser_verbatim`. (#83)
* Fixed bugs in `elevation()` - it was expecting column names to be latitude and longitude, whereas inputs from other `rgbif` functions have changed to decimalLatitude and decimalLongitude.
* Fixed bug in `count_facet()` introduced b/c GBIF no longer accepts hostCountry or nubKey parameters.

### IMPROVEMENTS

* `gist()`, `stylegeojson()`, and `togeojson()` functions now listed as deprecated. Their functionality moved to the `spocc` package (http://cran.r-project.org/web/packages/spocc/index.html). These functions will be removed from this package in a future version. (#82)
* Added a quick sanity test for `gbifmap()`.
* Added tests for `occ_get()` for when `verbatim=TRUE`, which gives back different data than when `verbatim=FALSE`.

rgbif 0.6.0
===============

### BUG FIXES

* A number of variables changed names to better follow the Darwin Core standard. `latitude` is now `decimalLatitude`. `longitude` is now `decimalLongitude`. `clazz` is now `class`. Code in this package changed to accomodate these changes. `date` is now `eventDate`. `georeferenced` is now `hasCoordinate`. Beware of these changes in your own code using `rgbif` - find and replace for these should be easy.
* Changed `altitude` parameter in `occ_search()` to `elevation` - should have been `elevation` the whole time.
* `occ_count()` function with parameter changes: `nubKey` parameter in changed to `taxonKey`. New parameter `protocol`. Parameter `catalogNumber` gone. Parameter `hostCountry` gone. These parameters are still in the function definition, but if called they throw a useful warning telling you the correct parameter names. (#76)
* Fixed bug in `name_lookup()` function that was labeling facet outputs incorrectly. (#77)

### IMPROVEMENTS

* Better checking and parsing of response data from GBIF: Across all functions, we now check that the response content type is `application/json`, then parse JSON ourselves using `RJSONIO::fromJSON` (instead of httr doing it).
* Across all functions, we now return all potenital character class columns as character class (instead of factor), by passing `stringsAsFactors = FALSE` to all `data.frame()` calls.
* Now using assertthat package in various places to give better error messages when the wrong input is passed to a function.
* Four parameters have name changes in the `occ_search()` function. These parameters are still in the function definition, but if called they throw a useful warning telling you the correct parameter names. (#75)
* Updated docs in `name_usage`, `name_backbone`, `name_lookup`, and `name_suggest` functions.
* `sourceId` parameter in `name_usage()` function doesn't work so error message is thrown when used.

### NEW FEATURES

* New function `check_wkt()` to check that well known text string is the right format. (#68)
* New dataset typestatus to look up possible specimen typeStatus values. See #74 for more information.
* GBIF added some new parameters for use in the `occ_search()` function. `scientificName`: search for a species by name (instead of `taxonKey`). `continent`: search by continent. `lastInterpreted`: search by last time GBIF modified the record. `recordNumber`: search by the data collector's specimen record number - this is different from the GBIF record number. `typeStatus`: search by specimen type status. (#74)
* Note that given the new parameters many more options are available for implicit faceted search in which you can pass many values in a vector to do multiple searches like `parameterName = c(x, y, z)`. These parameters are: `taxonKey`, `scientificName`, `datasetKey`, `catalogNumber`, `collectorName`, `geometry`, `country`, `recordNumber`, `search`, `institutionCode`, `collectionCode`, `decimalLatitude`, `decimalLongitude`, `depth`, `year`, `typeStatus`, `lastInterpreted`, and `continent`. This isn't faceted search server side - this is just looping your different values of the parameter against the GBIF API.
* Range queries are a new feature in the GBIF API. Some parameters in `occ_search()` now support range queries: `decimalLatitude`,`decimalLongitude`,`depth`,`elevation`,`eventDate`,`lastInterpreted`,`month`, and `year`. Do a range query for example by `depth=50,100` to ask for occurrences where depth was recorded between 50 and 100 meters. Note that this syntax `depth=c(50,100)` will perform two separate searches, one for `depth=50` and one for `depth=100`. (#71)

rgbif 0.5.0
===============

### IMPROVEMENTS

* Changed name of country_codes() function to gbif_country_codes() to avoid conflicts with other packages.
* Replaced sapply() with vapply() throughout the package as it is more robust and can be faster.
* Added a startup message to the package.
* gbifmap() now plots a map with ggplot2::coord_fixed(ratio=1) so that you don't get wonky maps.
* occ_count() now accepts a call to query publishingCountry with a single parameter (country), to list occurrence counts by publishing country.
* occ_get() and occ_search() lose parameter minimal, and in its place gains parameter fields, in which you can request fields='minimal' to get just name, taxon key, lat and long. Or set to 'all' to get all fields, or selection the fields you want by passing in a vector of field names.

### BUG FIXES

* Updated base url for the GIBF parser function parsenames()
* isocodes dataset now with documentation.

### NEW FEATURES

* New function count_facet() to do facetted count search, as GBIF doesn't allow faceted searches against the count API.
* New function elevation() to get elevation data for a data.frame of lat/long points, or a list of lat/long points. This function uses the Google Elevation API (https://developers.google.com/maps/documentation/elevation/).
* New function installations() to get metadata on installations.

rgbif 0.4.1
===============

### BUG FIXES

* Improved handling of limit parameter in occ_search() so that the correct number of occurrences are returned.
* Fixed various tests that were broken.

### IMPROVEMENTS

* Added missing limit argument in datasets() function man file, also function gains start and callopts parameters.

rgbif 0.4.0
===============

### IMPROVEMENTS

* Data object isocodes gains new column gbif_names, the GBIF specific names for countries.
* Added in deprecation messages throughtout package for functions and arguments that are deprecated.
* tests moved to tests/testthat from inst/tests.
* Vignettes now in vignettes/ directory.

### NEW FEATURES

* New function dataset_suggest(), a quick autocomplete service that returns up to 20 datasets.
* New function name_backbone() looks up names against the GBIF backbone taxonomy.
* New function name_suggest(), a quick autocomplete service that returns up to 20 name usages.
* New function occ_metadata() to search dataset metadata.
* New function parsenames() that parses taxonomic names and returns their components.

rgbif 0.3.9
===============

### IMPROVEMENTS

* Added back in functions, and .Rd files, from old version or rgbif that interacts with the old GBIF API.
* Updated vignette to work with new GBIF API and fxns.

### NEW FEATURES

* Added functions to interact with the new GBIF API, notably: country_codes(), dataset_metrics(), dataset_search(), datasets(), name_lookup(), gbifmap(), gist(), name_lookup(), name_usage(), networks(), nodes(), occ_count(), occ_get(), occ_search(), organizations(), stylegeojson(), togeojson(). See the README for a crosswalk from old functions to new ones.

### BUG FIXES

* test files moved from inst/tests/ to tests/testthat/

rgbif 0.3.2
===============

### BUG FIXES

* Removed georeferencedonly parameter - is deprecated in the GBIF API


rgbif 0.3.0
===============

### IMPROVEMENTS

* Added S3 objects: Output from calls to occurrencelist() and occurrence list_many() now of class gbiflist, and output from calls to densitylist() now of class gbifdens.
* Slight changes to gbifmaps() function.
* url parameter in all functions moved into the function itself as the base GBIF API url doesn't need to be specified by user.
* Vignette added.

### NEW FEATURES

* Added function country_codes() to look up 2 character ISO country codes for use in searches.
* Added function occurrencelist_many() to handle searches of many species.
* Added functions togeojson() and stylegeosjon() to convert a data.frame with lat/long columns to geojson file format, and to add styling to data.frames before using togeojson() .
* occurrencelist() and occurrencelist_many() gain argument fixnames, which lets user change species names in output data.frame according to a variety of scenarios.
* taxonsearch() gains argument accepted_status to accept only those names that have a status of accepted. In addition, this function has significant changes, and examples, to improve performance.


rgbif 0.2.0
===============

### IMPROVEMENTS

* Improved code style, and simplified code in some functions.

### NEW FEATURES

* occurrencelist() now handles scientific notation when maxresults are given in that form.
* occurencelist() now can retrieve any number of records; was previously a max of 1000 records.

### BUG FIXES

* Demo "List" was returning incorrect taxon names - corrected now.
* Removed unused parameter 'latlongdf' in occurencelist().


rgbif 0.1.5
===============

### IMPROVEMENTS

* Changed all functions to use RCurl instead of httr as httr was presenting some problems.
* Two function, capwords and gbifxmlToDataFrame, added with documentation as internal functions.

### NEW FEATURES

* Added function density_spplist to get a species list or data.frame of species and their counts for any degree cell.
* Added function densitylist to access to records showing the density of occurrence records from the GBIF Network by one-degree cell.
* Added function gbifmap to make a simple map to visualize GBIF data.
* Added function occurrencecount to count taxon concept records matching a range of filters.

DEPRECATED

* gbifdatause removed, was just a function to return the data sharing agreement from GBIF.


rgbif 0.1.0
===============

### NEW FEATURES

* released to CRAN
