#' Get elevation for lat/long points from a data.frame or list of points.
#' 
#' @import httr data.table plyr assertthat
#' @importFrom stringr str_trim
#' @param input A data.frame of lat/long data.
#' @param latitude A vector of latitude's. Must be the same length as the longitude 
#' vector.
#' @param longitude A vector of longitude's. Must be the same length as the latitude 
#' vector.
#' @param latlong A vector of lat/long pairs. See examples.
#' @param callopts Options passed on to httr::GET, like curl options for debugging.
#' @return A new column in the supplied data.frame or a vector with elevation of 
#' each location in meters. 
#' @references Uses the Google Elevation API at the following link
#' \url{https://developers.google.com/maps/documentation/elevation/}
#' @export
#' @examples \dontrun{
#' key <- name_suggest('Puma concolor')$key[1]
#' dat <- occ_search(taxonKey=key, return='data', limit=300, hasCoordinate=TRUE)
#' elevation(dat)
#' 
#' # Pass in a vector of lat's and a vector of long's
#' elevation(latitude=dat$latitude, longitude=dat$longitude)
#' 
#' # Pass in lat/long pairs in a single vector
#' pairs <- list(c(31.8496,-110.576060), c(29.15503,-103.59828))
#' elevation(latlong=pairs)
#' }

elevation <- function(input=NULL, latitude=NULL, longitude=NULL, latlong=NULL, 
                      callopts=list())
{
  url <- 'http://maps.googleapis.com/maps/api/elevation/json'
  foo <- function(x) gsub("\\s+", "", str_trim(paste(x['latitude'], x['longitude'], sep=","), "both"))
 
  getdata <- function(x)
  {
    locations <- apply(x, 1, foo)
    if(length(locations) > 1){
      if(length(locations) > 50){
        locations <- split(locations, ceiling(seq_along(locations)/50))
        locations <- lapply(locations, function(x) paste(x, collapse="|"))
      } else
      {
        locations <- list(paste(locations, collapse="|"))
      }
    }
    
    outout <- list()
    for(i in seq_along(locations)){  
      args <- compact(list(locations=locations[[i]], sensor='false'))
      tt <- GET(url, query=args, callopts)
      stop_for_status(tt)
      assert_that(tt$headers$`content-type`=='application/json; charset=UTF-8')
      res <- content(tt, as = 'text', encoding = "UTF-8")
      out <- RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
      
      df <- data.frame(elevation=sapply(out$results, '[[', 'elevation'), stringsAsFactors=FALSE)
      outout[[i]] <- df
    }
    datdf <- data.frame(rbindlist(outout), stringsAsFactors=FALSE)
    return( cbind(x, datdf) )
  }
  
  if(is(input, "data.frame")){
    getdata(input)
  } else if(is.null(latlong))
  {
    if(!is.null(input)) stop("If you use latitude and longitude, input must be left as default")
    assert_that(length(latitude)==length(longitude))
    dat <- data.frame(latitude=latitude, longitude=longitude, stringsAsFactors=FALSE)
    getdata(dat)
  } else
  {
    dat <- data.frame(rbindlist(
      lapply(latlong, function(x) data.frame(t(x)))
    ), stringsAsFactors=FALSE)
    names(dat) <- c("latitude","longitude")
    getdata(dat)
  }
}