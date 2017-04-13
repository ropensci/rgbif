#' Search for catalog numbers, collection codes, collector names, and
#' institution codes.
#'
#' @export
#' @param type Type of data, one of catalogNumber, collectionCode, recordedBy,
#' or institutionCode. Unique partial strings work too, like 'cat' for
#' catalogNumber
#' @param q Search term
#' @param limit Number of results, default=5
#' @param pretty Pretty as true (Default) uses cat to print data, `FALSE` gives
#' character strings.
#' @template occ
#'
#' @references <http://www.gbif.org/developer/occurrence#search>
#'
#' @examples \dontrun{
#' # catalog number
#' occ_metadata(type = "catalogNumber", q=122)
#'
#' # collection code
#' occ_metadata(type = "collectionCode", q=12)
#'
#' # institution code
#' occ_metadata(type = "institutionCode", q='GB')
#'
#' # recorded by
#' occ_metadata(type = "recordedBy", q='scott')
#'
#' # data as character strings
#' occ_metadata(type = "catalogNumber", q=122, pretty=FALSE)
#'
#' # Change number of results returned
#' occ_metadata(type = "catalogNumber", q=122, limit=10)
#'
#' # Partial unique type strings work too
#' occ_metadata(type = "cat", q=122)
#'
#' # Pass on curl options
#' occ_metadata(type = "cat", q=122, curlopts = list(verbose = TRUE))
#' }

occ_metadata <- function(type = "catalogNumber", q=NULL, limit=5, pretty=TRUE,
                         curlopts = list()) {

  type <- match.arg(type, c("catalogNumber", "collectionCode", "recordedBy",
                            "institutionCode"))
  url <- sprintf('%s/occurrence/search/%s', gbif_base(), type)
  args <- rgbif_compact(list(q = q, limit = limit))
  out <- gbif_GET(url, args, TRUE, curlopts)

  if (pretty) {
    cat(out, sep = "\n")
  } else {
    out
  }
}
