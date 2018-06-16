#' List datasets for a download
#'
#' @export
#'
#' @param key A key generated from a request, like that from
#' \code{occ_download}
#' @template occ
#' @return a list with slots of offset, limit, endOfRecords, count, and results.
#' results has an array of the datasets
#' @note see [downloads] for an overview of GBIF downloads methods
#'
#' @examples \dontrun{
#' occ_download_datasets(key="0003983-140910143529206")
#' }
occ_download_datasets <- function(key, curlopts = list()) {
  stopifnot(!is.null(key))
  url <- sprintf('%s/occurrence/download/%s/datasets', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  tmp <- cli$get()
  if (tmp$status_code > 203) {
  	if (length(tmp$content) == 0) tmp$raise_for_status()
  	stop(tmp$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(tmp$response_headers$`content-type` == 'application/json')
  tt <- tmp$parse("UTF-8")
  jsonlite::fromJSON(tt, FALSE)
}
