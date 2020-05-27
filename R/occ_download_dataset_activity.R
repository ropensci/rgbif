#' Lists the downloads activity of a dataset
#'
#' @export
#'
#' @param dataset (character) A dataset key
#' @template occ
#' @template downloadlimstart
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a list with two slots:
#' 
#' - meta: a single row data.frame with columns: `offset`, `limit`,
#' `endofrecords`, `count`
#' - results: a tibble with the nested data flattened, with many 
#' columns with the same `download.` or `download.request.` prefixes
#' 
#' @examples \dontrun{
#' res <- occ_download_dataset_activity("7f2edc10-f762-11e1-a439-00145eb45e9a")
#' res
#' res$meta
#' res$meta$count
#' 
#' # pagination
#' occ_download_dataset_activity("7f2edc10-f762-11e1-a439-00145eb45e9a",
#' limit = 3000)
#' occ_download_dataset_activity("7f2edc10-f762-11e1-a439-00145eb45e9a",
#' limit = 3, start = 10)
#' }
occ_download_dataset_activity <- function(dataset, limit = 20, start = 0,
  curlopts = list()) {

  assert(dataset, "character")
  assert(limit, c("integer", "numeric"))
  assert(start, c("integer", "numeric"))
  url <- sprintf('%s/occurrence/download/dataset/%s', gbif_base(), dataset)
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
