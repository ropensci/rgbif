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
#' @param username (character) Required. An GeoNames user name. See Details.
#' @param ... curl options passed on to [crul::verb-GET]
#' see [curl::curl_options()] for curl options
#'
#' @return A new column named elevation in the supplied data.frame or a vector
#' with elevation of each location in meters.
#' @references GeoNames http://www.geonames.org/export/web-services.html
#' @details To get a GeoNames user name, register for an account at
#' http://www.geonames.org/login - then you can enable your account for the
#' GeoNames webservice on your account page. Once you are enabled to use
#' the webservice, you can pass in your username to the `username`
#' parameter. Better yet, store your username in your `.Renviron` file, or
#' similar (e.g., .zshrc or .bash_profile files) and read it in via 
#' `Sys.getenv()` as in the examples below. By default we do 
#' `Sys.getenv("GEONAMES_USER")` for the `username` parameter.
#' @examples \dontrun{
#' user <- Sys.getenv("GEONAMES_USER")
#' 
#' occ_key <- name_suggest('Puma concolor')$key[1]
#' dat <- occ_search(taxonKey = occ_key, return = 'data', limit = 300,
#'   hasCoordinate = TRUE)
#' head( elevation(dat, username = user) )
#'
#' # Pass in a vector of lat's and a vector of long's
#' elevation(latitude = dat$decimalLatitude[1:10],
#'   longitude = dat$decimalLongitude[1:10],
#'   username = user)
#'
#' # Pass in lat/long pairs in a single vector
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs, username = user)
#'
#' # Pass on curl options
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs, username = user, verbose = TRUE)
#' }
elevation <- function(input = NULL, latitude = NULL, longitude = NULL,
  latlong = NULL, username = Sys.getenv("GEONAMES_USER"), ...) {

  all_input <- rgbif_compact(list(input, latitude, longitude, latlong))
  if (!length(all_input) > 0) {
    stop("one of input, lat & long, or latlong must be given",
      call. = FALSE)
  }

  getdata <- function(x) {
    check_latlon(x)
    locs <- list(x)
    if (NROW(x) > 20) {
      locs <- split(x, ceiling(seq_along(x$latitude) / 20))
    }
    outout <- list()
    for (i in seq_along(locs)) {
      out <- geonames_srtm3(locs[[i]]$latitude, locs[[i]]$longitude,
        username, ...)
      df <- data.frame(elevation = out, stringsAsFactors = FALSE)
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
    getdata(input)
  } else if (is.null(latlong)) {
    if (!is.null(input)) {
      stop("If you use latitude and longitude, input must be left as default")
    }
    stopifnot(length(latitude) == length(longitude))
    dat <- data.frame(latitude = latitude, longitude = longitude,
                      stringsAsFactors = FALSE)
    getdata(dat)
  } else {
    dat <- setdfrbind(lapply(latlong, function(x) data.frame(t(x))))
    names(dat) <- c("latitude", "longitude")
    getdata(dat)
  }
}

check_latlon <- function(x) {
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

geonames_srtm3 <- function(latitude, longitude,
  username = Sys.getenv("GEONAMES_USER"), ...) {

  assert(latitude, c("numeric", "integer"))
  assert(longitude, c("numeric", "integer"))
  if (length(latitude) > 1) latitude <- paste0(latitude, collapse = ",")
  if (length(longitude) > 1) longitude <- paste0(longitude, collapse = ",")
  cli <- crul::HttpClient$new(
    url = "http://api.geonames.org",
    headers = list(
      `User-Agent` = rgbif_ua(), `X-USER-AGENT` = rgbif_ua()
    ),
    opts = list(...)
  )
  args <- list(lats = latitude, lngs = longitude, username = username)
  tt <- cli$get("srtm3", query = args)
  tt$raise_for_status()
  stopifnot(tt$headers$`content-type` == "text/html;charset=UTF-8")
  res <- tt$parse("UTF-8")
  as.numeric(strsplit(res, "\n")[[1]])
}
