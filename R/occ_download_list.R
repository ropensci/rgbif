#' Lists the downloads created by a user.
#'
#' @export
#'
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param pwd (character) User password within GBIF's website. Required. See
#' Details.
#' @param limit Number of records to return. Default: 20
#' @param start Record number to start at. Default: 0
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#'
#' @examples \dontrun{
#' occ_download_list(user="sckott")
#' occ_download_list(user="sckott", limit = 5)
#' occ_download_list(user="sckott", start = 21)
#' }

occ_download_list <- function(user = NULL, pwd = NULL, limit = 20, start = 0,
  curlopts = list()) {

  user <- check_user(user)
  pwd <- check_pwd(pwd)
  stopifnot(!is.null(user), !is.null(pwd))
  url <- sprintf('%s/occurrence/download/user/%s', gbif_base(), user)
  args <- rgbif_compact(list(limit = limit, offset = start))
  cli <- crul::HttpClient$new(
    url = url, opts = c(
      curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)
    ), headers = c(
      rgbif_ual, `Content-Type` = "application/json",
      Accept = "application/json"
    )
  )
  res <- cli$get(query = args)
  tt <- res$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, flatten = TRUE)
  out$results$size <- getsize(out$results$size)
  list(
    meta = data.frame(offset = out$offset, limit = out$limit,
                      endofrecords = out$endOfRecords, count = out$count),
    results = out$results
  )
}

getsize <- function(x) {
  round(x/10 ^ 6, 2)
}
