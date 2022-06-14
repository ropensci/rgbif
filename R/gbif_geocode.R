
#' Geocode lat-lon point(s) with GBIF's set of geo-polygons (experimental)
#'
#' @param latitude  a vector of numeric latitude values between -90 and 90.
#' @param longitude a vector of numeric longitude values between -180 and 180.
#'
#' @return
#' A data.frame of results from the GBIF gecoding service. 
#' 
#' - \strong{latitude} : The input latitude
#' - \strong{longitude} : The input longitude
#' - \strong{index} : The original input rownumber
#' - \strong{id} : The polygon id from which the geocode comes from
#' - \strong{type} : One of the following : "Political" (county codes), 
#' "IHO" (marine regions), "SeaVox" (marine regions), "WGSRPD" (tdwg regions), 
#' "EEZ", (in national waters) or "GADM0","GADM1","GADM2","GADM2"(http://gadm.org/)
#' - \strong{title} : The name of the source polygon
#' - \strong{distance} : distance to the polygon boarder
#' 
#' 
#' This function uses the GBIF geocoder API which is not guaranteed to be 
#' stable and is undocumented. As such, this may return different data over 
#' time, may be rate-limited or may stop working if GBIF change the service. 
#' Use this function with caution. 
#'  
#' 
#' @references
#' 
#' 
#' 
#' @export
#'
#' @examples \dontrun{
#' # one pair 
#' gbif_geocode(0,0)
#' # or multiple pairs of points
#' gbif_geocode(c(0,50),c(0,20))
#' 
#' }
#' 
#' @references 
#' http://gadm.org/
#' http://marineregions.org/
#' http://www.tdwg.org/standards/
#' <http://api.gbif.org/v1/geocode/reverse?lat=0&lng=0>
#' 
#' 
#' 
gbif_geocode <- function(latitude = NULL, longitude = NULL) {
  
  # check input 
  if(!is.numeric(latitude)) latitude <- as.numeric(as.character(latitude))
  if(!is.numeric(longitude)) longitude <- as.numeric(as.character(longitude))
  if(!is.numeric(longitude)) stop("longitude should be numeric")
  if(!is.numeric(latitude)) stop("latiude should be numeric")
  if(!any(latitude <= 90 & latitude >= -90)) stop("latitude should be between -90 and 90")
  if(!any(longitude <= 180 & longitude >= -180)) stop("longitude should be between -180 and 180")

  df_original <- tibble::tibble(latitude,longitude)
  df_original$index <- 1:nrow(df_original)
  df_original$lat_lon <- paste0(latitude,"_",longitude)
  df_coord <- stats::na.omit(df_original)
  df_coord <- df_coord[!duplicated(df_coord$lat_lon),]
  if(nrow(df_coord) == 0) stop("longitude and latitude should be numeric")
  url_base <- paste0(gbif_base(), '/geocode/reverse')
  urls <- paste0(url_base,"?lat=",df_coord$latitude,"&","lng=",df_coord$longitude)
  
  res <- gbif_async_get(urls) # do the api call
  
  make_df <- function(z) bind_rows(lapply(z,function(x)
    tibble::as_tibble(t(unlist(x,recursive = FALSE)))))
  #post process result
  res <- lapply(res,function(z) make_df(z))
  res <- mapply(function(x, y) transform(x, lat_lon=y),res,df_coord$lat_lon,SIMPLIFY = FALSE)
  res <- bind_rows(res)
  res <- merge(df_original,res,id="lat_lon",all.x=TRUE)
  res <- res[order(res$index),]
  res <- res[, !(names(res) %in% c("lat_lon"))]
  res
}


