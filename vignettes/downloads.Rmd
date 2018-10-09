<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Downloads}
%\VignetteEncoding{UTF-8}
-->



GBIF Downloads
==============

GBIF provides two ways to get occurrence data: through the
`/occurrence/search` route (see `occ_search()` and `occ_data()`),
or via the `/occurrence/download` route (many functions, see below).
`occ_search()`/`occ_data()` are more appropriate for smaller data, while
`occ_download*()` functions are more appropriate for larger data requests.
Note that the download service is equivalent to downloading a dataset
from the GBIF website - but doing it here makes it reproducible
(and easier once you learn the ropes)!

The download functions are:

- `occ_download()` - Start a download
- `occ_download_prep()` - Prepare a download request
- `occ_download_queue()` - Start many downloads in a queue
- `occ_download_meta()` - Get metadata progress on a single download
- `occ_download_list()` - List your downloads
- `occ_download_cancel()` - Cancel a download
- `occ_download_cancel_staged()` - Cancels any jobs with status `RUNNING`
or `PREPARING`
- `occ_download_get()` - Retrieve a download
- `occ_download_import()` - Import a download from local file system
- `occ_download_datasets()` - List datasets for a download
- `occ_download_dataset_activity()` - Lists the downloads activity of a dataset

`occ_download()` is the function to start off with when using the GBIF download
service. With it you can specify what query you want. Unfortunately, the interfaces
to the search vs. download services are different, so we couldn't make the `rgbif`
interface to `occ_search`/`occ_data` the same as `occ_download`.

Be aware that you can only perform 3 downloads simultaneously, so plan wisely.
To help with this limitation, we are working on a queue helper, but it's not
ready yet.

Let's take a look at how to use the download functions:

## Load rgbif


```r
library("rgbif")
```

## Kick off a download

Instead of passing parameters like `taxonkey = 12345` in `occ_search`, for downloads
we pass the whole thing as a character string **because** you can use operators
other than `=` (equal to).


```r
(res <- occ_download('taxonKey = 7264332', 'hasCoordinate = TRUE'))
#> <<gbif download>>
#>   Username: sckott
#>   E-mail: myrmecocystus@gmail.com
#>   Download key: 0000796-171109162308116
```

What `occ_download` returns is not the data itself!  When you send the request to
GBIF, they have to prepare it first, then when it's done you can download it.

What `occ_download` returns is some useful metadata that tells you about the
download, and helps us check and know when the download is done.


## Check download status

After running `occ_download`, we can pass the resulting object to
`occ_download_meta` - with primary goal of checking the download status.


```r
occ_download_meta(res)
#> <<gbif download metadata>>
#>   Status: PREPARING
#>   Format: DWCA
#>   Download key: 0000796-171109162308116
#>   Created: 2017-11-10T19:30:32.328+0000
#>   Modified: 2017-11-10T19:30:44.590+0000
#>   Download link: http://api.gbif.org/v1/occurrence/download/request/0000796-171109162308116.zip
#>   Total records: 1425
#>   Request:
#>     type:  and
#>     predicates:
#>       > type: equals, key: TAXON_KEY, value: 7264332
#>       > type: equals, key: HAS_COORDINATE, value: TRUE
```

Continue running `occ_download_meta` until the `Status` value is `SUCCEEDED`
or `KILLED`. If it is `KILLED` that means something went wrong - get in touch
with us. If `SUCCEEDED`, then you can proceed to the next step (downloading
the data with `occ_download_get`).

Before we go to the next step, there's another function to help you out.

With `occ_download_list` you can get an overview of all your download
requests, with


```r
x <- occ_download_list()
x$results <- tibble::as_tibble(x$results)
x
#> $meta
#>   offset limit endofrecords count
#> 1      0    20        FALSE   211
#>
#> $results
#> # A tibble: 20 x 18
#>                        key                    doi
#>  *                   <chr>                  <chr>
#>  1 0000796-171109162308116 doi:10.15468/dl.nv3r5p
#>  2 0000739-171109162308116 doi:10.15468/dl.jmachn
#>  3 0000198-171109162308116 doi:10.15468/dl.t5wjpe
#>  4 0000122-171020152545675 doi:10.15468/dl.yghxj7
#>  5 0000119-171020152545675 doi:10.15468/dl.qiowtc
#>  6 0000115-171020152545675 doi:10.15468/dl.tdbkzn
#>  7 0010067-170714134226665 doi:10.15468/dl.ro6qj1
#>  8 0010066-170714134226665 doi:10.15468/dl.bhekhi
#>  9 0010065-170714134226665 doi:10.15468/dl.xy4nfp
#> 10 0010064-170714134226665 doi:10.15468/dl.hsqp84
#> 11 0010062-170714134226665 doi:10.15468/dl.h2apik
#> 12 0010061-170714134226665 doi:10.15468/dl.1srstq
#> 13 0010059-170714134226665 doi:10.15468/dl.2me5hk
#> 14 0010058-170714134226665 doi:10.15468/dl.sjmxvf
#> 15 0010057-170714134226665 doi:10.15468/dl.f28182
#> 16 0010056-170714134226665 doi:10.15468/dl.4t2qim
#> 17 0010055-170714134226665 doi:10.15468/dl.lumz7s
#> 18 0010054-170714134226665 doi:10.15468/dl.wfkgqm
#> 19 0010053-170714134226665 doi:10.15468/dl.fintow
#> 20 0010050-170714134226665 doi:10.15468/dl.a2h9gu
#> # ... with 16 more variables: license <chr>, created <chr>, modified <chr>,
#> #   status <chr>, downloadLink <chr>, size <dbl>, totalRecords <int>,
#> #   numberDatasets <int>, request.creator <chr>, request.format <chr>,
#> #   request.notificationAddresses <list>, request.sendNotification <lgl>,
#> #   request.predicate.type <chr>, request.predicate.predicates <list>,
#> #   request.predicate.key <chr>, request.predicate.value <chr>
```

## Canceling downloads

If for some reason you need to cancel a download you can do so with
`occ_download_cancel` or `occ_download_cancel_staged`.

`occ_download_cancel` cancels a job by download key, while `occ_download_cancel_staged`
cancels all jobs in `PREPARING` or `RUNNING` stage.

## Fetch data

After you see the `SUCCEEDED` status on calling `occ_download_meta`, you can
then download the data using `occ_download_get`.


```r
(dat <- occ_download_get("0000796-171109162308116"))
#> <<gbif downloaded get>>
#>   Path: ./0000796-171109162308116.zip
#>   File size: 0.35 MB
```

This only download data to your machine - it does not read it into R.
You can now move on to importing into R.

## Import data into R

Pass the output of `occ_download_get` directly to `occ_download_import` -
they can be piped together if you like.


```r
occ_download_get("0000796-171109162308116") %>% occ_download_import()
# OR
dat <- occ_download_get("0000796-171109162308116")
occ_download_import(dat)
#> # A tibble: 1,425 x 235
#>        gbifID abstract accessRights accrualMethod accrualPeriodicity
#>         <int>    <lgl>        <chr>         <lgl>              <lgl>
#>  1 1667184715       NA                         NA                 NA
#>  2 1667182218       NA                         NA                 NA
#>  3 1667179996       NA                         NA                 NA
#>  4 1667179527       NA                         NA                 NA
#>  5 1667171607       NA                         NA                 NA
#>  6 1667165448       NA                         NA                 NA
#>  7 1667163154       NA                         NA                 NA
#>  8 1667162324       NA                         NA                 NA
#>  9 1667162162       NA                         NA                 NA
#> 10 1667161552       NA                         NA                 NA
#> # ... with 1,415 more rows, and 230 more variables: accrualPolicy <lgl>,
#> #   alternative <lgl>, audience <lgl>, available <lgl>,
#> #   bibliographicCitation <lgl>, conformsTo <lgl>, contributor <lgl>,
#> #   coverage <lgl>, created <lgl>, creator <lgl>, date <lgl>,
#> #   dateAccepted <lgl>, dateCopyrighted <lgl>, dateSubmitted <lgl>,
#> #   description <lgl>, educationLevel <lgl>, extent <lgl>, format <lgl>,
#> #   hasFormat <lgl>, hasPart <lgl>, hasVersion <lgl>, identifier <chr>,
#>
#> ... cut for brevity
```

## Citing download data

The nice thing about data retrieved via GBIF's download service is that they
provide DOIs for each download, so that you can give a link that resolves to
the download with metadata on GBIF's website. And it makes for a nice citation.

Using the funciton `gbif_citaiton` we can get citations for our downloads,
with the output from `occ_download_get` or `occ_download_meta`.


```r
occ_download_meta(res) %>% gbif_citation()
#> $download
#> [1] "GBIF Occurrence Download https://doi.org/10.15468/dl.ohjevv Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2017-11-10"
#>
#> $datasets
#> NULL
```

You'll notice that the `datasets` slot is `NULL` - because when using `occ_download_meta`,
we don't yet have any information about which datasets are in the download.

But if you use `occ_download_get` you then have the individual datasets, and we
can get citatations for each idividual dataset in addition to the entire download.


```r
occ_download_get("0000796-171109162308116") %>% gbif_citation()
#> $download
#> [1] "GBIF Occurrence Download https://doi.org/10.15468/dl.nv3r5p Accessed from R via rgbif (https://github.com/ropensci/rgbif) on 2017-11-10"
#>
#> $datasets
#> $datasets[[1]]
#> <<rgbif citation>>
#>    Citation: Office of Environment & Heritage (2017). OEH Atlas of NSW
#>         Wildlife. Occurrence Dataset https://doi.org/10.15468/14jd9g accessed
#>         via GBIF.org on 2017-11-10.. Accessed from R via rgbif
#>         (https://github.com/ropensci/rgbif) on 2017-11-10
#>    Rights: This work is licensed under a Creative Commons Attribution (CC-BY)
#>         4.0 License.
#>
#> $datasets[[2]]
#> <<rgbif citation>>
#>    Citation: Creuwels J (2017). Naturalis Biodiversity Center (NL) - Botany.
#>         Naturalis Biodiversity Center. Occurrence Dataset
#>         https://doi.org/10.15468/ib5ypt accessed via GBIF.org on 2017-11-10..
#>         Accessed from R via rgbif (https://github.com/ropensci/rgbif) on
#>         2017-11-10
#>    Rights: To the extent possible under law, the publisher has waived all
#>         rights to these data and has dedicated them to the Public Domain (CC0
#>         1.0). Users may copy, modify, distribute and use the work, including
#>         for commercial purposes, without restriction.
#>
#> ... cutoff for brevity
```

Here, we get the overall citation as well as citations (and data rights) for each dataset.

Please do cite the data you use from GBIF!
