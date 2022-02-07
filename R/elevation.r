#' Get elevation for lat/long points from a data.frame or list of points.
#'
#' Uses the GeoNames web service
#'
#' @export
#' @param input A data.frame of lat/long data. There must be columns
#' decimalLatitude and decimalLongitude.
#' @param latitude A vector of latitude's. Must be the same length as the
#' longitude vector.
#' @param longitude A vector of longitude's. Must be the same length as
#' the latitude vector.
#' @param latlong A vector of lat/long pairs. See examples.
#' @param elevation_model (character) one of srtm3 (default), srtm1, astergdem,
#' or gtopo30. See "Elevation models" below for more
#' @param username (character) Required. An GeoNames user name. See Details.
#' @param ... curl options passed on to [crul::verb-GET]
#' see `curl::curl_options()` for curl options
#' @param key,curlopts defunct. see docs
#'
#' @return A new column named `elevation_geonames` in the supplied data.frame
#' or a vector with elevation of each location in meters. Note that data from
#' GBIF can already have a column named `elevation`, thus the column we
#' add is named differently.
#' @references GeoNames http://www.geonames.org/export/web-services.html
#' @section GeoNames user name:
#' To get a GeoNames user name, register for an account at
#' http://www.geonames.org/login - then you can enable your account for the
#' GeoNames webservice on your account page 
#' (http://www.geonames.org/manageaccount). Once you are enabled to use
#' the webservice, you can pass in your username to the `username`
#' parameter. Better yet, store your username in your `.Renviron` file, or
#' similar (e.g., .zshrc or .bash_profile files) and read it in via
#' `Sys.getenv()` as in the examples below. By default we do
#' `Sys.getenv("GEONAMES_USER")` for the `username` parameter.
#' @section Elevation models:
#'
#' - srtm3:
#'     - sample area: ca 90m x 90m
#'     - result: a single number giving the elevation in meters according to
#'       srtm3, ocean areas have been masked as "no data" and have been assigned
#'       a value of -32768
#' - srtm1:
#'     - sample area: ca 30m x 30m
#'     - result: a single number giving the elevation in meters according to
#'       srtm1, ocean areas have been masked as "no data" and have been assigned
#'       a value of -32768
#' - astergdem (Aster Global Digital Elevation Model V2 2011):
#'     - sample area: ca 30m x 30m, between 83N and 65S latitude
#'     - result: a single number giving the elevation in meters according to 
#'       aster gdem, ocean areas have been masked as "no data" and have been
#'       assigned a value of -32768
#' - gtopo30: 
#'     - sample area: ca 1km x 1km
#'     - result: a single number giving the elevation in meters according to
#'       gtopo30, ocean areas have been masked as "no data" and have been
#'       assigned a value of -9999
#'
#' @examples \dontrun{
#' user <- Sys.getenv("GEONAMES_USER")
#'
#' occ_key <- name_suggest('Puma concolor')$key[1]
#' dat <- occ_search(taxonKey = occ_key, limit = 300, hasCoordinate = TRUE)
#' head( elevation(dat$data, username = user) )
#'
#' # Pass in a vector of lat's and a vector of long's
#' elevation(latitude = dat$data$decimalLatitude[1:10],
#'   longitude = dat$data$decimalLongitude[1:10],
#'   username = user, verbose = TRUE)
#'
#' # Pass in lat/long pairs in a single vector
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs, username = user)
#'
#' # Pass on curl options
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs, username = user, verbose = TRUE)
#'
#' # different elevation models
#' lats <- dat$data$decimalLatitude[1:5]
#' lons <- dat$data$decimalLongitude[1:5]
#' elevation(latitude = lats, longitude = lons, elevation_model = "srtm3")
#' elevation(latitude = lats, longitude = lons, elevation_model = "srtm1")
#' elevation(latitude = lats, longitude = lons, elevation_model = "astergdem")
#' elevation(latitude = lats, longitude = lons, elevation_model = "gtopo30")
#' }
elevation <- function(input = NULL, latitude = NULL, longitude = NULL,
  latlong = NULL, elevation_model = "srtm3",
  username = Sys.getenv("GEONAMES_USER"), key, curlopts,
  ...) {

  if (!missing(key))
    stop("'key' param defunct; use username and see docs")
  if (!missing(curlopts))
    stop("'curlopts' param defunct; pass on curl options to ...")
  all_input <- rgbif_compact(list(input, latitude, longitude, latlong))
  if (!length(all_input) > 0) {
    stop("one of input, lat & long, or latlong must be given",
      call. = FALSE)
  }
  if (!elevation_model %in% el_models)
    stop("elevation_model not in allowed set; see docs")

  elev_ <- function(x, username, ...) {
    check_latlon(x)
    locs <- list(x)
    if (elevation_model == "gtopo30") {
      locs <- split(x, seq_along(x$latitude) / 1)
    }
    if (NROW(x) > 20 && elevation_model != "gtopo30") {
      locs <- split(x, ceiling(seq_along(x$latitude) / 20))
    }
    outout <- list()
    for (i in seq_along(locs)) {
      out <- geonames_conn(elevation_model, locs[[i]]$latitude,
        locs[[i]]$longitude, username, ...)
      df <- data.frame(elevation_geonames = out, stringsAsFactors = FALSE)
      outout[[i]] <- cbind(locs[[i]], df)
    }
    setdfrbind(outout)
  }

  if (!is.null(input)) {
    if (!inherits(input, "data.frame"))
      stop("input must be a data.frame", call. = FALSE)
    stopifnot(all(c("decimalLatitude", "decimalLongitude") %in% names(input)))
    names(input)[names(input) %in% "decimalLatitude"] <- "latitude"
    names(input)[names(input) %in% "decimalLongitude"] <- "longitude"
    elev_(input, username, ...)
  } else if (is.null(latlong)) {
    if (!is.null(input)) {
      stop("If you use latitude and longitude, input must be left as default")
    }
    stopifnot(length(latitude) == length(longitude))
    dat <- data.frame(latitude = latitude, longitude = longitude,
                      stringsAsFactors = FALSE)
    elev_(dat, username, ...)
  } else {
    dat <- setdfrbind(lapply(latlong, function(x) data.frame(t(x))))
    names(dat) <- c("latitude", "longitude")
    elev_(dat, username, ...)
  }
}

check_latlon <- function(x) {
  # types
  assert(x$latitude, c("numeric", "integer"))
  assert(x$longitude, c("numeric", "integer"))

  # missing values
  not_complete <- x[!stats::complete.cases(x$latitude, x$longitude), ]
  if (NROW(not_complete) > 0) {
    stop("Input data has some missing values\n       No lat/long pairs can have missing data",
         call. = FALSE)
  }

  # not possible
  not_possible <- x[!abs(x$latitude) <= 90 | !abs(x$longitude) <= 180, ]
  if (NROW(not_possible) > 0) {
    stop("Input data has some impossible values\n       latitude must be between 90 and -90\n       longitude between 180 and -180",
         call. = FALSE)
  }

  # warn about points at 0/0, these are very likely wrong
  zero_zero <- x[ x$latitude == 0 & x$longitude == 0, ]
  if (NROW(zero_zero) > 0) {
    warning("Input data has some points at 0,0\n       These are likely wrong, check them",
         call. = FALSE)
  }
}

geonames_conn <- function(elevation_model, latitude, longitude,
  username = Sys.getenv("GEONAMES_USER"), ...) {

  if (elevation_model != "gtopo30") {
    if (length(latitude) > 1) latitude <- paste0(latitude, collapse = ",")
    if (length(longitude) > 1) longitude <- paste0(longitude, collapse = ",")
  }
  cli <- crul::HttpClient$new(
    url = "http://api.geonames.org",
    headers = list(
      `User-Agent` = rgbif_ua(), `X-USER-AGENT` = rgbif_ua()
    ),
    opts = list(...)
  )
  if (elevation_model == "gtopo30") {
    args <- list(lat = latitude, lng = longitude, username = username)
  } else {
    args <- list(lats = latitude, lngs = longitude, username = username)
  }
  tt <- cli$get(elevation_model, query = args)
  geonames_errs(tt)
  res <- tt$parse("UTF-8")
  as.numeric(strsplit(res, "\n")[[1]])
}

geonames_errs <- function(z) {
  z$raise_for_status()
  stopifnot(z$response_headers$`content-type` == "text/html;charset=UTF-8")
  txt <- z$parse("UTF-8")
  if (grepl("ERR", txt)) {
    stop(sub("ERR:?[0-9]{1,2}:?", "", txt), call. = FALSE)
  }
}

el_models <- c("srtm3", "srtm1", "astergdem", "gtopo30")
