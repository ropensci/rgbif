#' Get elevation for lat/long points from a data.frame or list of points.
#'
#' @importFrom data.table rbindlist
#' @export
#'
#' @param input A data.frame of lat/long data. There must be columns decimalLatitude and
#' decimalLongitude.
#' @param latitude A vector of latitude's. Must be the same length as the longitude
#' vector.
#' @param longitude A vector of longitude's. Must be the same length as the latitude
#' vector.
#' @param latlong A vector of lat/long pairs. See examples.
#' @param key (character) Required. An API key. See Details.
#' @param ... Further named parameters, such as \code{query}, \code{path}, etc, passed on to
#' \code{\link[httr]{modify_url}} within \code{\link[httr]{GET}} call. Unnamed parameters will be
#' combined with \code{\link[httr]{config}}.
#'
#' @return A new column named elevation in the supplied data.frame or a vector with elevation of
#' each location in meters.
#' @references Uses the Google Elevation API at the following link
#' \url{https://developers.google.com/maps/documentation/elevation/}
#' @details To get an API key, see instructions at
#' \url{https://developers.google.com/maps/documentation/elevation/#api_key}. It should be an
#' easy process. Once you have the key pass it in to the \code{key} parameter. You can store
#' the key in your \code{.Rprofile} file and read it in via \code{getOption} as in the
#' examples below.
#' @examples \dontrun{
#' apikey <- getOption("g_elevation_api")
#' key <- name_suggest('Puma concolor')$key[1]
#' dat <- occ_search(taxonKey=key, return='data', limit=300, hasCoordinate=TRUE)
#' head( elevation(dat, key = apikey) )
#'
#' # Pass in a vector of lat's and a vector of long's
#' elevation(latitude=dat$decimalLatitude, longitude=dat$decimalLongitude, key = apikey)
#'
#' # Pass in lat/long pairs in a single vector
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs, key = apikey)
#'
#' # Pass on options to httr
#' library('httr')
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs, config=verbose(), key = apikey)
#' }

elevation <- function(input=NULL, latitude=NULL, longitude=NULL, latlong=NULL, key, ...) {

  url <- 'https://maps.googleapis.com/maps/api/elevation/json'
  foo <- function(x) gsub("\\s+", "", strtrim(paste(x['latitude'], x['longitude'], sep=",")))

  getdata <- function(x) {
    locations <- apply(x, 1, foo)
    if(length(locations) > 1) {
      if(length(locations) > 50) {
        locations <- split(locations, ceiling(seq_along(locations)/50))
        locations <- lapply(locations, function(x) paste(x, collapse="|"))
      } else {
        locations <- list(paste(locations, collapse="|"))
      }
    }

    outout <- list()
    for(i in seq_along(locations)){
      args <- rgbif_compact(list(locations=locations[[i]], sensor='false', key=key))
      tt <- GET(url, query=args, ...)
      stop_for_status(tt)
      stopifnot(tt$headers$`content-type`=='application/json; charset=UTF-8')
      res <- content(tt, as = 'text', encoding = "UTF-8")
      out <- jsonlite::fromJSON(res, FALSE)

      df <- data.frame(elevation=sapply(out$results, '[[', 'elevation'), stringsAsFactors=FALSE)
      outout[[i]] <- df
    }
    datdf <- data.frame(rbindlist(outout), stringsAsFactors=FALSE)
    return( cbind(x, datdf) )
  }

  if(is(input, "data.frame")){
    stopifnot(all(c('decimalLatitude','decimalLongitude') %in% names(input)))
    names(input)[names(input) %in% 'decimalLatitude'] <- "latitude"
    names(input)[names(input) %in% 'decimalLongitude'] <- "longitude"
    getdata(input)
  } else if(is.null(latlong)) {
    if(!is.null(input)) stop("If you use latitude and longitude, input must be left as default")
    stopifnot(length(latitude)==length(longitude))
    dat <- data.frame(latitude=latitude, longitude=longitude, stringsAsFactors=FALSE)
    getdata(dat)
  } else {
    dat <- data.frame(rbindlist(
      lapply(latlong, function(x) data.frame(t(x)))
    ), stringsAsFactors=FALSE)
    names(dat) <- c("latitude","longitude")
    getdata(dat)
  }
}
