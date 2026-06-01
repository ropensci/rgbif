#' List countries for a download
#'
#' @export
#'
#' @param key A key generated from a request, like that from [occ_download()]
#' @param sortBy (character) Sort field. One of `COUNTRY_CODE` or
#' `RECORD_COUNT`. Optional.
#' @param sortOrder (character) Sort order. One of `ASC` or `DESC`. Optional.
#' @template occ
#' @template downloadlimstart
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a list with two slots:
#' 
#' - meta: a single row data.frame with columns: `offset`, `limit`,
#' `endofrecords`, `count`
#' - results: a tibble with the results, with columns: `downloadKey`,
#' `countryCode`, `numberRecords`
#' 
#' @examples \dontrun{
#' occ_download_countries(key="0003983-140910143529206")
#' occ_download_countries(key="0003983-140910143529206", limit = 3)
#' occ_download_countries(key="0003983-140910143529206", limit = 3, start = 10)
#' occ_download_countries(key="0003983-140910143529206", sortBy = "RECORD_COUNT",
#'   sortOrder = "DESC")
#' }
occ_download_countries <- function(key, sortBy = NULL, sortOrder = NULL,
  limit = 20, start = 0, curlopts = list(http_version = 2)) {

  assert(key, "character")
  assert(sortBy, "character")
  assert(sortOrder, "character")
  assert(limit, c("integer", "numeric"))
  assert(start, c("integer", "numeric"))
  stopifnot(!is.null(key))
  url <- sprintf('%s/occurrence/download/%s/countries', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  args <- rgbif_compact(list(sortBy = sortBy, sortOrder = sortOrder,
                             limit = limit, offset = start))
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
