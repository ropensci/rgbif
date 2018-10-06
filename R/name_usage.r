#' Lookup details for specific names in all taxonomies in GBIF.
#'
#' @export
#' @template occ
#' @template nameusage
#' @param limit Number of records to return. Default: 100.
#' @param start Record number to start at. Default: 0.
#' @param return One of data, meta, or all. If data, a data.frame with the
#'    data. meta returns the metadata for the entire call. all gives all data
#'    back in a list.
#' @return If `return="all"`, a list of length two, with metadata and data,
#' each as data.frame's. If `return="meta"` only the metadata data.frame,
#' and if `return="data"` only the data data.frame
#' @references <https://www.gbif.org/developer/species#nameUsages>
#' @details
#' This service uses fuzzy lookup so that you can put in partial names and
#' you should get back those things that match. See examples below.
#'
#' This function is different from [name_lookup()] in that that function
#' searches for names. This function encompasses a bunch of API endpoints,
#' most of which require that you already have a taxon key, but there is one
#' endpoint that allows name searches (see examples below).
#'
#' Note that `data="verbatim"` hasn't been working.
#'
#' Options for the data parameter are: 'all', 'verbatim', 'name', 'parents',
#' 'children', 'related', 'synonyms', 'descriptions','distributions', 'media',
#' 'references', 'speciesProfiles', 'vernacularNames', 'typeSpecimens', 'root'
#'
#' This function used to be vectorized with respect to the `data`
#' parameter, where you could pass in multiple values and the function
#' internally loops over each option making separate requests. This has been
#' removed. You can still loop over many options for the `data` parameter,
#' just use an `lapply` family function, or a for loop, etc.
#' 
#' See [name_issues()] for information on name usage issues related to the
#' `issues` column in output from this function
#' 
#' @examples \dontrun{
#' # A single name usage
#' name_usage(key=1)
#'
#' # Name usage for a taxonomic name
#' name_usage(name='Puma', rank="GENUS")
#'
#' # Name usage for all taxa in a dataset 
#' # (set sufficient high limit, but less than 100000)
#' # name_usage(datasetKey = "9ff7d317-609b-4c08-bd86-3bc404b77c42", limit = 10000)
#' # All name usages
#' name_usage()
#'
#' # References for a name usage
#' name_usage(key=2435099, data='references')
#'
#' # Species profiles, descriptions
#' name_usage(key=3119195, data='speciesProfiles')
#' name_usage(key=3119195, data='descriptions')
#' name_usage(key=2435099, data='children')
#'
#' # Vernacular names for a name usage
#' name_usage(key=3119195, data='vernacularNames')
#'
#' # Limit number of results returned
#' name_usage(key=3119195, data='vernacularNames', limit=3)
#'
#' # Search for names by dataset with datasetKey parameter
#' name_usage(datasetKey="d7dddbf4-2cf0-4f39-9b2a-bb099caae36c")
#'
#' # Search for a particular language
#' name_usage(key=3119195, language="FRENCH", data='vernacularNames')
#'
#' # get root usage with a uuid
#' name_usage(data = "root", uuid = "73605f3a-af85-4ade-bbc5-522bfb90d847")
#'
#' # search by language
#' name_usage(language = "spanish")
#'
#' # Pass on curl options
#' name_usage(name='Puma concolor', limit=300, curlopts = list(verbose=TRUE))
#' }

name_usage <- function(key=NULL, name=NULL, data='all', language=NULL,
  datasetKey=NULL, uuid=NULL, rank=NULL, shortname=NULL,
  start=0, limit=100, return='all', curlopts = list()) {

  check_vals(limit, "limit")
  # each of these args must be length=1
  if (!is.null(rank)) stopifnot(length(rank) == 1)
  if (!is.null(name)) stopifnot(length(name) == 1)
  if (!is.null(language)) stopifnot(length(language) == 1)
  if (!is.null(datasetKey)) stopifnot(length(datasetKey) == 1)

  args <- rgbif_compact(list(offset = start, limit = limit,
                             rank = rank,
                             name = name, language = language,
                             datasetKey = datasetKey))
  data <- match.arg(data,
      choices = c('all', 'verbatim', 'name', 'parents', 'children',
                'related', 'synonyms', 'descriptions',
                'distributions', 'media', 'references', 'speciesProfiles',
                'vernacularNames', 'typeSpecimens', 'root'), several.ok = FALSE)
  # paging implementation
  if (limit > 1000) {
    iter <- 0
    sumreturned <- 0
    numreturned <- 0
    outout <- list()
    while (sumreturned < limit) {
      iter <- iter + 1
      tt <- getdata(data, key, uuid, shortname, args, curlopts)
      # if no results, assign numreturned var with 0
      if (identical(tt$results, list())) {
        numreturned <- 0}
      else {
        numreturned <- length(tt$results)}
      sumreturned <- sumreturned + numreturned
      # if less results than maximum
      if ((numreturned > 0) && (numreturned < 1000)) {
        # update limit for metadata before exiting
        limit <- numreturned
        args$limit <- limit
      }
      if (sumreturned < limit) {
        # update args for next query
        args$offset <- args$offset + numreturned
        args$limit <- limit - sumreturned
      }
      outout[[iter]] <- tt
    }
    out <- list()
    out$results <- do.call(c, lapply(outout, "[[", "results"))
    out$offset <- args$offset
    out$limit <- args$limit
    out$endOfRecords <- outout[[iter]]$endOfRecords
  } else {
    # retrieve data in a single query
    out <- getdata(data, key, uuid, shortname, args, curlopts)
  }
  # select output
  return <- match.arg(return, c('meta','data','all'))
  switch(return,
         meta = get_meta_nu(out),
         data = tibble::as_data_frame(name_usage_parse(out, data)),
         all = list(meta = get_meta_nu(out),
                    data = tibble::as_data_frame(name_usage_parse(out, data)))
  )
}

get_meta_nu <- function(x) {
  if (has_meta(x)) {
    tibble::as_data_frame(data.frame(x[c('offset','limit','endOfRecords')],
                                     stringsAsFactors = FALSE))
  } else {
    tibble::data_frame()
  }
}

has_meta <- function(x) any(c('offset','limit','endOfRecords') %in% names(x))

getdata <- function(x, key, uuid, shortname, args, curlopts = list()){
  if (!x == 'all' && is.null(key)) {
    # data can == 'root' if uuid is not null
    if (x != 'root' && !is.null(uuid) || x != 'root' && !is.null(shortname)) {
      stop('You must specify a key if data does not equal "all"',
        call. = FALSE)
    }
  }

  if (x == 'all' && is.null(key)) {
    url <- paste0(gbif_base(), '/species')
  } else {
    if (x == 'all' && !is.null(key)) {
      url <- sprintf('%s/species/%s', gbif_base(), key)
    } else
      if (x %in% c('verbatim', 'name', 'parents', 'children',
                  'related', 'synonyms', 'descriptions',
                  'distributions', 'media', 'references', 'speciesProfiles',
                  'vernacularNames', 'typeSpecimens')) {
        url <- sprintf('%s/species/%s/%s', gbif_base(), key, x)
      } else
        if (x == 'root') {
          z <- if (is.null(uuid)) shortname else uuid
          url <- sprintf('%s/species/root/%s', gbif_base(), z)
        }
  }
  gbif_GET(url, args, FALSE, curlopts)
}

name_usage_parse <- function(x, y) {
  many <- "parents"
  if (has_meta(x) || y %in% many) {
    if (y %in% many) {
      (outtt <- data.table::setDF(
        data.table::rbindlist(
          lapply(x, no_zero), use.names = TRUE, fill = TRUE)))
    } else {
      (outtt <- data.table::setDF(
        data.table::rbindlist(
          lapply(x$results, function(x) {
            lapply(x, function(x) {
              if (length(x) == 0) {
                NA
              } else if (length(x) > 1) {
                paste0(x, collapse = ",")
              } else {
                x
              }
            })
          }),
          use.names = TRUE, fill = TRUE)))
    }
  } else {
    nameusageparser(x)
  }
}

no_zero <- function(x) Filter(function(z) length(z) != 0, x)
