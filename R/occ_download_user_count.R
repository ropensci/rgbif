#' Count downloads for a user.
#'
#' @export
#'
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param from (character) Optional. Start date in format `YYYY-MM-DD`. Only
#' downloads created on or after this date will be counted.
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a single integer with the total number of downloads for the user.
#'
#' @details
#' Username can be set in a number of ways. See [occ_download] for
#' details.
#'
#' @examples \dontrun{
#' occ_download_user_count(user="sckott")
#' occ_download_user_count(user="sckott", from="2023-01-01")
#' }
occ_download_user_count <- function(user = NULL, from = NULL,
  curlopts = list(http_version = 2)) {

  user <- check_user(user)
  assert(from, "character")
  url <- sprintf('%s/occurrence/download/user/%s/count', gbif_base(), user)
  args <- rgbif_compact(list(from = from))
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
