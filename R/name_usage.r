#' Lookup details for specific names in all taxonomies in GBIF.
#'
#' @export
#' @template otherlimstart
#' @template occ
#' @template nameusage
#' @param return One of data, meta, or all. If data, a data.frame with the
#'    data. meta returns the metadata for the entire call. all gives all data back in a list.
#' @return A list of length two. The first element is metadata. The second is
#' a data.frame
#' @references \url{http://www.gbif.org/developer/species#nameUsages}
#' @details
#' This service uses fuzzy lookup so that you can put in partial names and
#' you should get back those things that match. See examples below.
#'
#' This function is different from \code{name_lookup} in that that function
#' searches for names. This function encompasses a bunch of API endpoints,
#' most of which require that you already have a taxon key, but there is one
#' endpoint that allows name searches (see examples below).
#'
#' Note that \code{data="verbatim"} hasn't been working.
#'
#' Options for the data parameter are: 'all', 'verbatim', 'name', 'parents', 'children',
#' 'related', 'synonyms', 'descriptions','distributions', 'media',
#' 'references', 'speciesProfiles', 'vernacularNames', 'typeSpecimens', 'root'
#'
#' This function used to be vectorized with respect to the \code{data} parameter,
#' where you could pass in multiple values and the function internally loops
#' over each option making separate requests. This has been removed. You can still
#' loop over many options for the \code{data} parameter, just use an \code{lapply}
#' family function, or a for loop, etc.
#' @examples \dontrun{
#' # A single name usage
#' name_usage(key=1)
#'
#' # Name usage for a taxonomic name
#' name_usage(name='Puma', rank="GENUS")
#'
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
#' # Pass on httr options
#' ## here, print progress, notice the progress bar
#' library('httr')
#' # res <- name_usage(name='Puma concolor', limit=300, config=progress())
#' }

name_usage <- function(key=NULL, name=NULL, data='all', language=NULL, datasetKey=NULL, uuid=NULL,
  sourceId=NULL, rank=NULL, shortname=NULL, start=NULL, limit=100, return='all', ...) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("sourceId") %in% calls
  if (any(calls_vec)) {
    stop("Parameters not currently accepted: \n sourceId")
  }

  args <- rgbif_compact(list(language = language, name = name, datasetKey = datasetKey,
                       rank = rank, offset = start, limit = limit, sourceId = sourceId))
  data <- match.arg(data,
      choices = c('all', 'verbatim', 'name', 'parents', 'children',
                'related', 'synonyms', 'descriptions',
                'distributions', 'media', 'references', 'speciesProfiles',
                'vernacularNames', 'typeSpecimens', 'root'), several.ok = FALSE)
  out <- getdata(data, key, uuid, shortname, args, ...)
  # select output
  return <- match.arg(return, c('meta','data','all'))
  switch(return,
         meta = get_meta_nu(out),
         data = name_usage_parse(out),
         all = list(meta = get_meta_nu(out), data = name_usage_parse(out, data))
  )
}

get_meta_nu <- function(x) {
  if (has_meta(x)) data.frame(x[c('offset','limit','endOfRecords')], stringsAsFactors = FALSE) else NA
}

has_meta <- function(x) any(c('offset','limit','endOfRecords') %in% names(x))

getdata <- function(x, key, uuid, shortname, args, ...){
  if (!x == 'all' && is.null(key)) {
    stop('You must specify a key if data does not equal "all"', call. = FALSE)
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
          url <- sprintf('%s/species/root/%s/%s', gbif_base(), uuid, shortname)
        }
  }
  gbif_GET(url, args, FALSE, ...)
}

name_usage_parse <- function(x, y) {
  # many <- c("parents", "related")
  many <- "parents"
  if (has_meta(x) || y %in% many) {
    if (y %in% many) {
      (outtt <- data.table::setDF(data.table::rbindlist(lapply(x, no_zero), use.names = TRUE, fill = TRUE)))
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
