#' Check for downloads already in your GBIF account
#'
#' @export
#' @inheritParams occ_download
#' @param refresh (logical) refresh your list of downloads. on the first
#' request of each R session we'll cache your stored GBIF occurrence
#' downloads locally. you can refresh this list by setting `refresh=TRUE`;
#' if you're in the same R session, and you've done many download requests,
#' then refreshing may be a good idea if you're using this function
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @examples \dontrun{
#' occ_download_cached(pred_gte("elevation", 12000L))
#' occ_download_cached(pred("catalogNumber", 217880))
#' occ_download_cached(pred_gte("decimalLatitude", 65),
#'   pred_lte("decimalLatitude", -65), type="or")
#' 
#' occ_download_cached(pred_gte("elevation", 12000L))
#' occ_download_cached(pred_gte("elevation", 12000L), refresh = TRUE)
#' 
#' occ_download_cached(
#'   pred_gt("elevation", 5000),
#'   pred_in("basisOfRecord", c('HUMAN_OBSERVATION','OBSERVATION','MACHINE_OBSERVATION')),
#'   pred("country", "US"),
#'   pred("hasCoordinate", TRUE),
#'   pred("hasGeospatialIssue", FALSE),
#'   pred_gte("year", 1999),
#'   pred_lte("year", 2011),
#'   pred_gte("month", 3),
#'   pred_lte("month", 8)
#' )
#' }
occ_download_cached <- function(..., body = NULL, type = "and", format = "DWCA",
  user = NULL, pwd = NULL, email = NULL, refresh = FALSE,
  curlopts = list()) {

  z <- occ_download_prep(..., body = body, type = type, format = format,
    user = user, pwd = pwd, email = email, curlopts = curlopts)
  usr <- dl_user_preds(user, pwd, refresh)
  tmp <- dl_match(z, usr, age = NULL)
  out <- NA_character_
  if (tmp$matched && !tmp$expired) out <- tmp$key
  tmp$message
  structure(out, class = "occ_download", user = z$user, email = z$email,
    format = z$format)
}
