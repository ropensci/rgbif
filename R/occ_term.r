#' Get occurrence terms.
#'
#' @export
#' @template occ
#'
#' @return A `data.frame` with occurrence term definitions.
#'
#' @references <https://www.gbif.org/developer/occurrence>
#'
#' @examples \dontrun{
#' occ_term()
#'
#' # Pass on curl options
#' occ_term(curlopts = list(verbose = TRUE))
#' }
occ_term <- function(curlopts = list(http_version = 2)) {
  url <- paste0(gbif_base(), "/occurrence/term")
  gbif_GET(url, NULL, parse = TRUE, curlopts = curlopts)
}
