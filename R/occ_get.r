#' Get data for specific GBIF occurrences.
#'
#' @export
#'
#' @param key Occurrence key
#' @param return One of data, hier, meta, or all. If 'data', a data.frame
#' with the data. 'hier' returns the classifications in a list for each record.
#' meta returns the metadata for the entire call. 'all' gives all data back
#' in a list. Ignored if `verbatim=TRUE`.
#' @param verbatim Return verbatim object (TRUE) or cleaned up object (FALSE,
#' default).
#' @param fields (character) Default ('minimal') will return just taxon name,
#' key, latitude, and longitute. 'all' returns all fields. Or specify each
#' field you want returned by name, e.g. fields = c('name',
#' 'decimalLatitude','altitude').
#' @template occ
#'
#' @return A data.frame or list of data.frame's.
#' @references <http://www.gbif.org/developer/occurrence#occurrence>
#'
#' @examples \dontrun{
#' occ_get(key=855998194, return='data')
#' occ_get(key=855998194, 'hier')
#' occ_get(key=855998194, 'all')
#'
#' # many occurrences
#' occ_get(key=c(101010, 240713150, 855998194), return='data')
#'
#' # Verbatim data
#' occ_get(key=855998194, verbatim=TRUE)
#' occ_get(key=855998194, fields='all', verbatim=TRUE)
#' occ_get(key=855998194, fields=c('scientificName', 'lastCrawled', 'county'),
#'   verbatim=TRUE)
#' occ_get(key=c(855998194, 620594291), verbatim=TRUE)
#' occ_get(key=c(855998194, 620594291), fields='all', verbatim=TRUE)
#' occ_get(key=c(855998194, 620594291),
#'    fields=c('scientificName', 'decimalLatitude', 'basisOfRecord'),
#'    verbatim=TRUE)
#'
#' # Pass in curl options
#' occ_get(key=855998194, curlopts = list(verbose=TRUE))
#' }

occ_get <- function(key=NULL, return='all', verbatim=FALSE, fields='minimal',
                    curlopts = list()) {

  stopifnot(is.numeric(key))
  return <- match.arg(return, c("meta", "data", "hier", "all"))

  # Define function to get data
  getdata <- function(x) {
    if (verbatim) {
      url <- sprintf('%s/occurrence/%s/verbatim', gbif_base(), x)
    } else {
      url <- sprintf('%s/occurrence/%s', gbif_base(), x)
    }
    # gbif_GET(url, NULL, FALSE, curlopts)
    # if verbatim=TRUE, attemps to parse to data.frame's
    gbif_GET(url, NULL, verbatim, curlopts)
  }

  # Get data
  if (length(key) == 1) {
    out <- getdata(key)
  } else {
    out <- lapply(key, getdata)
  }

  # parse data
  if (verbatim) {
    gbifparser_verbatim(out, fields = fields)
  } else {
    data <- gbifparser(out, fields = fields)

    if (return == 'data') {
      if (length(key) == 1) {
        data$data
      } else {
        ldfast(lapply(data, "[[", "data"))
      }
    } else
      if (return == 'hier') {
        if (length(key) == 1) {
          data$hierarch
        } else {
          ldfast(lapply(data, "[[", "hierarchy"))
        }
      } else {
        data
      }
  }
}
