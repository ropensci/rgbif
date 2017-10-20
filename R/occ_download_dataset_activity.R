#' Lists the downloads activity of a dataset
#'
#' @export
#'
#' @param dataset (character) A dataset key
#' @template occ
#' @return a list with slots of offset, limit, endOfRecords, count, and results.
#' results has an array of the downloads for the dataset
#'
#' @examples \dontrun{
#' res <- occ_download_dataset_activity("7f2edc10-f762-11e1-a439-00145eb45e9a")
#' res
#' res$count
#' }
occ_download_dataset_activity <- function(dataset, curlopts = list()) {
  url <- sprintf('%s/occurrence/download/dataset/%s', gbif_base(), dataset)
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
