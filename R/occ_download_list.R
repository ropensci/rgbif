#' Lists the downloads created by a user.
#'
#' @export
#'
#' @param user A user name, look at option "gbif_user" first
#' @param pwd Your password, look at option "gbif_pwd" first
#' @param limit Number of records to return. Default: 20
#' @param start Record number to start at. Default: 0
#' @param ... Further args passed to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' occ_download_list(user="sckott")
#' occ_download_list(user="sckott", limit = 5)
#' occ_download_list(user="sckott", start = 21)
#' }

occ_download_list <- function(user=getOption("gbif_user"), pwd=getOption("gbif_pwd"),
                              limit = 20, start = 0, ...) {

  stopifnot(!is.null(user), !is.null(pwd))
  url <- sprintf('http://api.gbif.org/v1/occurrence/download/user/%s', user)
  args <- rgbif_compact(list(limit = limit, offset = start))
  res <- GET(url, query = args, config = c(
    content_type_json(),
    accept_json(),
    authenticate(user = user, password = pwd),
    list(...)$config),
    make_rgbif_ua()
  )
  tt <- c_utf8(res)
  out <- jsonlite::fromJSON(tt)
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
