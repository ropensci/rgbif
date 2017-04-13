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
occ_spellcheck <- function(search, curlopts = list()) {
  url <- paste0(gbif_base(), '/occurrence/search')
  tt <- gbif_GET2(url, list(q = search, spellCheck = "true", limit = 0),
                  TRUE, curlopts)
  if (!"suggestions" %in% names(tt$spellCheckResponse)) {
    tt$spellCheckResponse$correctlySpelled
  } else {
    tt$spellCheckResponse
  }
}

gbif_GET2 <- function(url, args, parse=FALSE, curlopts = list()) {
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  temp <- cli$get(query = args)
  temp$raise_for_status()
  if (temp$status_code == 204) stop("Status: 204 - not found", call. = FALSE)
  if (temp$status_code > 200) {
    mssg <- temp$parse("UTF-8")
    if (grepl("html", mssg)) {
      stop("500 - Server error", call. = FALSE)
    }
    if (length(mssg) == 0 || nchar(mssg) == 0) {
      mssg <- temp$status_http()$message
    }
    if (temp$status_code == 503) mssg <- temp$status_http()$message
    stop(mssg, call. = FALSE)
  }
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  jsonlite::fromJSON(temp$parse("UTF-8"), parse)
}
