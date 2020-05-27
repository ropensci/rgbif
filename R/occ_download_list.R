#' Lists the downloads created by a user.
#'
#' @export
#'
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param pwd (character) User password within GBIF's website. Required. See
#' Details.
#' @template occ
#' @template downloadlimstart
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return a list with two slots:
#' 
#' - meta: a single row data.frame with columns: `offset`, `limit`,
#' `endofrecords`, `count`
#' - results: a tibble with the nested data flattened, with many 
#' columns with the same `request.` prefix
#' 
#' @examples \dontrun{
#' occ_download_list(user="sckott")
#' occ_download_list(user="sckott", limit = 5)
#' occ_download_list(user="sckott", start = 21)
#' }
occ_download_list <- function(user = NULL, pwd = NULL, limit = 20, start = 0,
  curlopts = list()) {

  out <- ocl_help(user, pwd, limit, start, curlopts, TRUE)
  out$results$size <- getsize(out$results$size)
  prep_output(out)
}

ocl_help <- function(user = NULL, pwd = NULL, limit = 20, start = 0,
  curlopts = list(), flatten = TRUE) {

  assert(limit, c("integer", "numeric"))
  assert(start, c("integer", "numeric"))
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
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  tt <- res$parse("UTF-8")
  jsonlite::fromJSON(tt, flatten = flatten)
}
