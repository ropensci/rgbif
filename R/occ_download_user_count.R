#' Count downloads for a user.
#'
#' @export
#'
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param pwd (character) User password within GBIF's website. Required. See
#' Details.
#' @param from (character) Optional. Start date in format `YYYY-MM-DD`. Only
#' downloads created on or after this date will be counted.
#' @param status (character) Optional. Filter by download status. One of
#' `"PREPARING"`, `"RUNNING"`, `"SUCCEEDED"`, `"CANCELLED"`, `"KILLED"`,
#' `"FAILED"`, `"SUSPENDED"`, or `"FILE_ERASED"`.
#' @template occ
#' @return a single integer with the total number of downloads for the user.
#'
#' @details
#' For `user` and `pwd` parameters, you can set them in one of three ways:
#'
#' - Set them in your `.Rprofile` file with the names `gbif_user` and `gbif_pwd`
#' - Set them in your `.Renviron`/`.bash_profile` (or similar) file with the
#' names `GBIF_USER` and `GBIF_PWD`
#' - Simply pass strings to each of the parameters in the function call
#'
#' See `?Startup` for help.
#'
#' @examples \dontrun{
#' occ_download_user_count(user="jwaller", pwd="your_password")
#' occ_download_user_count(user="jwaller", pwd="your_password", from="2023-01-01")
#' occ_download_user_count(user="jwaller", pwd="your_password", status="SUCCEEDED")
#' }
occ_download_user_count <- function(user = NULL, pwd = NULL, from = NULL, 
  status = NULL, curlopts = list(http_version = 2)) {

  user <- check_user(user)
  pwd <- check_pwd(pwd)
  assert(from, "character")
  assert(status, "character")
  stopifnot(!is.null(user), !is.null(pwd))
  url <- sprintf('%s/occurrence/download/user/%s/count', gbif_base(), user)
  args <- rgbif_compact(list(from = from, status = status))
  cli <- crul::HttpClient$new(
    url = url, 
    opts = c(curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)),
    headers = c(rgbif_ual, `Content-Type` = "application/json",
      Accept = "application/json")
  )
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  tt <- res$parse("UTF-8")
  as.integer(tt)
}
