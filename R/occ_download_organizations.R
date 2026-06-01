#' List organizations for a download
#'
#' @export
#'
#' @param key A key generated from a request, like that from [occ_download()]
#' @param organizationTitle (character) Organization title filter. Optional.
#' @param sortBy (character) Sort field. One of `ORGANIZATION_TITLE`,
#' `COUNTRY_CODE` or `RECORD_COUNT`. Optional.
#' @param sortOrder (character) Sort order. One of `ASC` or `DESC`. Optional.
#' @param limit (integer/numeric) Number of records to return. Default: 20,
#' Max: 1000
#' @param start (integer/numeric) Record number to start at. Default: 0
#' @param curlopts list of named curl options passed on to
#' \code{\link[crul]{HttpClient}}. see \code{curl::curl_options}
#' for curl options
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a list with two slots:
#' 
#' - meta: a single row data.frame with columns: `offset`, `limit`,
#' `endofrecords`, `count`
#' - results: a tibble with the results, with columns: `downloadKey`,
#' `organizationKey`, `organizationTitle`, `numberRecords`,
#' `publishingCountryCode`
#' 
#' @examples \dontrun{
#' occ_download_organizations(key="0024953-260519110011954")
#' occ_download_organizations(key="0024953-260519110011954", limit = 3)
#' occ_download_organizations(
#'   key="0024953-260519110011954",
#'   organizationTitle = "University of Alaska Museum of the North"
#' )
#' occ_download_organizations(key="0024953-260519110011954", sortBy = "RECORD_COUNT",
#'   sortOrder = "DESC")
#' }
occ_download_organizations <- function(key, organizationTitle = NULL,
  sortBy = NULL, sortOrder = NULL, limit = 20, start = 0,
  curlopts = list(http_version = 2)) {

  assert(key, "character")
  assert(organizationTitle, "character")
  assert(sortBy, "character")
  assert(sortOrder, "character")
  assert(limit, c("integer", "numeric"))
  assert(start, c("integer", "numeric"))
  stopifnot(!is.null(key))
  url <- sprintf('%s/occurrence/download/%s/organizations', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  args <- rgbif_compact(list(
    organizationTitle = organizationTitle,
    sortBy = sortBy,
    sortOrder = sortOrder,
    limit = limit,
    offset = start
  ))
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
