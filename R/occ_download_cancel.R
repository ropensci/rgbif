#' Cancel a download cretion process.
#'
#' @export
#'
#' @param key A key generated from a request, like that from
#' `occ_download`. Required.
#' @param user (character) User name within GBIF's website. Required.
#' @param pwd (character) User password within GBIF's website. Required.
#' @template occ
#'
#' @details Note, this only cancels a job in progress. If your download is
#' already prepared for you, this won't do anything to change that.
#'
#' @examples \dontrun{
#' # occ_download_cancel(key="0003984-140910143529206")
#' }
occ_download_cancel <- function(key, user=getOption("gbif_user"),
                                pwd=getOption("gbif_pwd"), curlopts = list()) {
  stopifnot(!is.null(key))
  url <- sprintf('%s/occurrence/download/request/%s', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, opts = c(
    curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd), verbose = TRUE),
    headers = rgbif_ual
  )
  res <- cli$delete(body = FALSE)
  res$raise_for_status()
  if (res$status_code == 204) message("Download sucessfully deleted") else res
}

#' @export
#' @rdname occ_download_cancel
occ_download_cancel_staged <- function() {
  hh <- occ_download_list()$results
  run_or_prep <- hh[ hh$status %in% c("RUNNING","PREPARING"), "key" ]
  lapply(run_or_prep, occ_download_cancel)
  invisible()
}
