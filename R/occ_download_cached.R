#' Check for downloads already in your GBIF account
#'
#' @export
#' @inheritParams occ_download
#' @param refresh (logical) refresh your list of downloads. on the first
#' request of each R session we'll cache your stored GBIF occurrence
#' downloads locally. you can refresh this list by setting `refresh=TRUE`;
#' if you're in the same R session, and you've done many download requests,
#' then refreshing may be a good idea if you're using this function
#' @param age (integer) number of days after which you want a new
#' download. default: 30
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @examples \dontrun{
#' # these are examples from the package maintainer's account;
#' # outcomes will vary by user
#' occ_download_cached(pred_gte("elevation", 12000L))
#' occ_download_cached(pred("catalogNumber", 217880))
#' occ_download_cached(pred_gte("decimalLatitude", 65),
#'   pred_lte("decimalLatitude", -65), type="or")
#' occ_download_cached(pred_gte("elevation", 12000L))
#' occ_download_cached(pred_gte("elevation", 12000L), refresh = TRUE)
#' }
occ_download_cached <- function(..., body = NULL, type = "and", format = "DWCA",
  user = NULL, pwd = NULL, email = NULL, refresh = FALSE, age = 30,
  curlopts = list()) {

  if (length(list(...)) == 0) stop("please pass in at least 1 predicate")
  z <- occ_download_prep(..., body = body, type = type, format = format,
    user = user, pwd = pwd, email = email, curlopts = curlopts)
  usr <- dl_user_preds(user, pwd, refresh)
  tmp <- dl_match(z, usr, age = age)
  out <- NA_character_
  if (tmp$matched && !tmp$expired) {
    out <- structure(tmp$key, class = "occ_download", user = z$user,
      email = z$email, format = z$format)
  }
  tmp$message
  return(out)
}
