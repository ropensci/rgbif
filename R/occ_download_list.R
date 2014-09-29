#' Lists the downloads created by a user. 
#'
#' @export
#' 
#' @param user A user name, look at option "gbif_user" first
#' @param pwd Your password, look at option "gbif_pwd" first
#' @param ... Further args passed to \code{\link[httr]{GET}}
#'
#' @examples \donttest{
#' occ_download_list(user="sckott")
#' }

occ_download_list <- function(user=getOption("gbif_user"), pwd=getOption("gbif_pwd"), ...)
{
  assert_that(!is.null(user), !is.null(pwd))
  url <- sprintf('http://api.gbif.org/v1/occurrence/download/user/%s', user)
  res <- GET(url, config = c(
    content_type_json(), 
    accept_json(), 
    authenticate(user=user, password=pwd)))
  tt <- content(res, as = "text")
  out <- jsonlite::fromJSON(tt)
  out$results$size <- getsize(out$results$size)
  list(
    meta=data.frame(
      offset=out$offset, limit=out$limit, endofrecords=out$endOfRecords, count=out$count), 
    results=out$results
  )
}

getsize <- function(x) round(x/10^6, 2)
