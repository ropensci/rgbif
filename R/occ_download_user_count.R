#' Count downloads for a user.
#'
#' @export
#'
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param pwd (character) User password within GBIF's website. Required. See
#' Details.
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a single integer with the total number of downloads for the user.
#'
#' @details
#' Credentials can be set in a number of ways. See [occ_download] for
#' details.
#'
#' @examples \dontrun{
#' occ_download_user_count(user="sckott")
#' }
occ_download_user_count <- function(user = NULL, pwd = NULL,
  curlopts = list(http_version = 2)) {

  user <- check_user(user)
  pwd <- check_pwd(pwd)
  stopifnot(!is.null(user), !is.null(pwd))
  url <- sprintf('%s/occurrence/download/user/%s/count', gbif_base(), user)
  cli <- crul::HttpClient$new(
    url = url, opts = c(
      curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)
    ), headers = c(
      rgbif_ual, `Content-Type` = "application/json",
      Accept = "application/json"
    )
  )
  res <- cli$get()
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  tt <- res$parse("UTF-8")
  as.integer(tt)
}
