#' Wait for an occurrence download to be done
#'
#' @export
#' @param x and object of class `occ_download`
#' @param status_ping (integer) seconds between each [occ_download_meta()]
#' request. default is 5, and cannot be < 3
#' @param curlopts (list) curl options, as named list, passed on to
#' [occ_download_meta()]
#' @param quiet (logical) suppress messages. default: `FALSE`
#' @family downloads
#' @note [occ_download_queue()] is similar, but handles many requests
#' at once; `occ_download_wait` handles one request at a time
#' @return an object of class `occ_download_meta`, see [occ_download_meta()]
#' for details
#' @examples \dontrun{
#' x <- occ_download(
#'   pred("taxonKey", 9206251),
#'   pred_in("country", c("US", "MX")),
#'   pred_gte("year", 1971)
#' )
#' res <- occ_download_wait(x)
#' occ_download_meta(x)
#' }
occ_download_wait <- function(x, status_ping = 5, curlopts = list(),
  quiet = FALSE) {

  assert(x, "occ_download")
  assert(status_ping, c("numeric", "integer"))
  assert(quiet, "logical")
  if (status_ping < 3) stop("ping seconds must be >= 3", call. = FALSE)
  status_pool <- c()
  still_running <- TRUE
  while(still_running) {
    tmp <- occ_download_meta(x, curlopts)
    status_current <- tolower(tmp$status)
    if (length(status_pool) == 0) {
      status_pool <- c(status_pool, status_current)
      mssg(!quiet, "status: ", status_current)
    } else if (length(status_pool) > 0) {
      if (status_current != last(status_pool)) {
        status_pool <- c(status_pool, status_current)
        mssg(!quiet, "status: ", status_current)
      }
    }
    still_running <- !(status_current %in% c('succeeded', 'killed'))
    if (still_running) Sys.sleep(status_ping)
  }
  mssg(!quiet, "download is done, status: ", status_current)
  return(tmp)
}
