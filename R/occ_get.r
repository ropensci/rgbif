#' Get data for GBIF occurrences by occurrence key
#'
#' @export
#' @param key (numeric/integer) one or more occurrence keys. required
#' @param fields (character) Default ("minimal") will return just taxon name,
#' key, latitude, and longitute. 'all' returns all fields. Or specify each
#' field you want returned by name, e.g. fields = c('name',
#' 'decimalLatitude','altitude').
#' @param return Defunct. All components are returned now; index to the
#' one(s) you want
#' @param verbatim Defunct. verbatim records can now be retrieved using 
#' `occ_get_verbatim()`
#' @template occ
#' @return For `occ_get` a list of lists. For `occ_get_verbatim` a data.frame
#' @references <https://www.gbif.org/developer/occurrence#occurrence>
#' @examples \dontrun{
#' occ_get(key=855998194)
#'
#' # many occurrences
#' occ_get(key=c(101010, 240713150, 855998194))
#'
#' # Verbatim data
#' occ_get_verbatim(key=855998194)
#' occ_get_verbatim(key=855998194, fields='all')
#' occ_get_verbatim(key=855998194,
#'  fields=c('scientificName', 'lastCrawled', 'county'))
#' occ_get_verbatim(key=c(855998194, 620594291))
#' occ_get_verbatim(key=c(855998194, 620594291), fields='all')
#' occ_get_verbatim(key=c(855998194, 620594291),
#'    fields=c('scientificName', 'decimalLatitude', 'basisOfRecord'))
#'
#' # curl options, pass in a named list
#' occ_get(key=855998194, curlopts = list(verbose=TRUE))
#' }
occ_get <- function(key, fields="minimal", curlopts=list(), return=NULL,
  verbatim=NULL) {
  pchk(return, "occ_get")
  pchk(verbatim, "occ_get")
  occ_get_helper(FALSE, key, fields, curlopts)
}

#' @export
#' @rdname occ_get
occ_get_verbatim <- function(key, fields="minimal", curlopts=list()) {
  occ_get_helper(TRUE, key, fields, curlopts)
}

occ_get_helper <- function(verbatim, key, fields, curlopts) {
  stopifnot(is.numeric(key))
  assert(fields, "character")
  out <- lapply(key, function(w) {
    path <- "%s/occurrence/%s"
    if (verbatim) path <- file.path(path, "verbatim")
    url <- sprintf(path, gbif_base(), w)
    gbif_GET(url, NULL, verbatim, curlopts)
  })
  fun <- if (verbatim) gbifparser_verbatim else gbifparser
  fun(out, fields = fields)
}
