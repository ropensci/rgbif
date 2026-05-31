#' Count downloads for a user.
#'
#' @export
#'
#' @param user (character) your or any other GBIF user name, if left blank
#' will default to user name found in `.Renviron` file.
#' @param from (character) Optional. Start date in format `YYYY-MM-DD`. Only
#' downloads created on or after this date will be counted.
#' @param status (character) Optional. Filter by download status. One of
#' `"PREPARING"`, `"RUNNING"`, `"SUCCEEDED"`, `"CANCELLED"`, `"KILLED"`,
#' `"FAILED"`, `"SUSPENDED"`, or `"FILE_ERASED"`.
#' @template occ
#' @return a single integer with the total number of downloads for the user.
#'
#' @details
#' if left blank will default to user name found in `.Renviron` file.
#'
#' @examples \dontrun{
#' occ_download_user_count(user="jwaller")
#' occ_download_user_count(user="jwaller", from="2023-01-01")
#' occ_download_user_count(user="jwaller", status="SUCCEEDED")
#' }
occ_download_user_count <- function(user = NULL, from = NULL, status = NULL,
  curlopts = list(http_version = 2)) {

  user <- check_user(user)
  assert(from, "character")
  assert(status, "character")
  url <- sprintf('%s/occurrence/download/user/%s/count', gbif_base(), user)
  args <- rgbif_compact(list(from = from, status = status))
  cli <- crul::HttpClient$new(
    url = url, headers = rgbif_ual, opts = curlopts
  )
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  tt <- res$parse("UTF-8")
  as.integer(tt)
}
