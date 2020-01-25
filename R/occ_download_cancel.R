#' Cancel a download creation process.
#'
#' @export
#'
#' @param key (character) A key generated from a request, like that from
#' `occ_download`. Required.
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param pwd (character) User password within GBIF's website. Required. See
#' Details.
#' @param limit Number of records to return. Default: 20
#' @param start Record number to start at. Default: 0
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#'
#' @details Note, these functions only cancel a job in progress. If your
#' download is already prepared for you, this won't do anything to change
#' that.
#'
#' `occ_download_cancel` cancels a specific job by download key - returns
#' success message
#'
#' `occ_download_cancel_staged` cancels all jobs with status `RUNNING`
#' or `PREPARING` - if none are found, returns a message saying so -
#' if some found, they are cancelled, returning message saying so
#'
#' @examples \dontrun{
#' # occ_download_cancel(key="0003984-140910143529206")
#' # occ_download_cancel_staged()
#' }
occ_download_cancel <- function(key, user = NULL, pwd = NULL,
  curlopts = list()) {

  stopifnot(!is.null(key))
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  url <- sprintf('%s/occurrence/download/request/%s', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, opts = c(
    curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)),
    headers = rgbif_ual
  )
  res <- cli$delete(body = FALSE)
  res$raise_for_status()
  if (res$status_code == 204) message("Download sucessfully deleted") else res
}

#' @export
#' @rdname occ_download_cancel
occ_download_cancel_staged <- function(user = NULL, pwd = NULL, limit = 20,
  start = 0, curlopts = list()) {

  hh <- occ_download_list(user, pwd, limit, start, curlopts)$results
  run_or_prep <- hh[ hh$status %in% c("RUNNING","PREPARING"), "key" ]
  if (length(run_or_prep) == 0) return(message("no staged downloads"))
  lapply(run_or_prep, occ_download_cancel, user = user, pwd = pwd)
  invisible()
}
