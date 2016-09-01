#' Spell check search term for occurrence searches
#'
#' @export
#' @param search (character) query term
#' @template occ
#' @return A boolean if search term spelled correctly, or if not spelled
#' correctly with no suggested alternatives. If spelled incorrectly and
#' suggested alternatives given, we give back a list with slots
#' "correctlySpelled" (boolean) and "suggestions" (list)
#'
#' @examples \dontrun{
#' # incorrectly spelled, with suggested alternative
#' occ_spellcheck(search = "kajsdkla")
#'
#' # incorrectly spelled, without > 1 suggested alternative
#' occ_spellcheck(search = "helir")
#'
#' # incorrectly spelled, without no alternatives
#' occ_spellcheck(search = "asdfadfasdf")
#'
#' # correctly spelled,  alternatives
#' occ_spellcheck(search = "helianthus")
#' }
occ_spellcheck <- function(search, ...) {
  url <- paste0(gbif_base(), '/occurrence/search')
  tt <- gbif_GET2(url, list(q = search, spellCheck = "true", limit = 0), TRUE, ...)
  if (!"suggestions" %in% names(tt$spellCheckResponse)) {
    tt$spellCheckResponse$correctlySpelled
  } else {
    tt$spellCheckResponse
  }
}

gbif_GET2 <- function(url, args, parse=FALSE, ...){
  temp <- GET(url, query = args, make_rgbif_ua(), ...)

  if (temp$status_code == 204) stop("Status: 204 - not found", call. = FALSE)
  if (temp$status_code > 200) {
    mssg <- c_utf8(temp)
    if (grepl("html", mssg)) {
      stop("500 - Server error", call. = FALSE)
    }
    if (length(mssg) == 0 || nchar(mssg) == 0) mssg <- http_status(temp)$message
    if (temp$status_code == 503) mssg <- http_status(temp)$message
    stop(mssg, call. = FALSE)
  }
  stopifnot(temp$headers$`content-type` == 'application/json')
  jsonlite::fromJSON(c_utf8(temp), parse)
}
