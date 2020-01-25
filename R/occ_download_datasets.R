#' List datasets for a download
#'
#' @export
#'
#' @param key A key generated from a request, like that from [occ_download()]
#' @template occ
#' @template downloadlimstart
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a list with two slots:
#' 
#' - meta: a single row data.frame with columns: `offset`, `limit`,
#' `endofrecords`, `count`
#' - results: a tibble with the results, of three columns: `downloadKey`,
#' `datasetKey`, `numberRecords`
#' 
#' @examples \dontrun{
#' occ_download_datasets(key="0003983-140910143529206")
#' occ_download_datasets(key="0003983-140910143529206", limit = 3)
#' occ_download_datasets(key="0003983-140910143529206", limit = 3, start = 10)
#' }
occ_download_datasets <- function(key, limit = 20, start = 0,
  curlopts = list()) {

  assert(key, "character")
  assert(limit, c("integer", "numeric"))
  assert(start, c("integer", "numeric"))
  stopifnot(!is.null(key))
  url <- sprintf('%s/occurrence/download/%s/datasets', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  args <- rgbif_compact(list(limit = limit, offset = start))
  tmp <- cli$get(query = args)
  if (tmp$status_code > 203) {
  	if (length(tmp$content) == 0) tmp$raise_for_status()
  	stop(tmp$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(tmp$response_headers$`content-type` == 'application/json')
  tt <- tmp$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, flatten = TRUE)
  prep_output(out)
}
