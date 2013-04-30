#' Prints the minimal results of the call.
#' 
#' @param x input
#' @param ... more stuff
#' @export
#' @examples
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 4000)
#' minimal(out)
minimal <- function(x, ...) UseMethod("minimal")

#' @S3method minimal gbiflist
minimal.gbiflist <- function(x){
  if(!is.gbiflist(x))
    stop("Input is not of class gbiflist")  
  output <- data.frame(x)[,c("taxonName","decimalLatitude","decimalLongitude")]
  return( output )
}

#' Print summary of gbifdens class
#' @method print gbifdens
#' @S3method print gbifdens
#' @export
print.gbifdens <- function(x){
  if(!is.gbifdens(x))
    stop("Input is not of class gbifdens")  
  
  Stats = c("NumberCells","MinLatitude","MaxLatitude","MinLongitude","MaxLongitude","MinPerCell","MaxPercell")
  records <- nrow(x)
  minlat = min(x$minLatitude, na.rm=TRUE)
  maxlat = max(x$maxLatitude, na.rm=TRUE)
  minlong = min(x$minLongitude, na.rm=TRUE)
  maxlong = max(x$maxLongitude, na.rm=TRUE)
  minpercell = min(x$count)
  maxpercell = max(x$count)
  
  print(data.frame(Stats, numbers=c(records,minlat,maxlat,minlong,maxlong,minpercell,maxpercell)))
}

#' Print summary of gbiflist class
#' @method print gbiflist
#' @S3method print gbiflist
#' @export
print.gbiflist <- function(x){
  if(!is.gbiflist(x))
    stop("Input is not of class gbiflist")
  
  records <- nrow(x)
  names2 <- unique(x$taxonName)
  Stats = c("MinLatitude","MaxLatitude","MinLongitude","MaxLongitude")
  minlat = min(x$decimalLatitude, na.rm=TRUE)
  maxlat = max(x$decimalLatitude, na.rm=TRUE)
  minlong = min(x$decimalLongitude, na.rm=TRUE)
  maxlong = max(x$decimalLongitude, na.rm=TRUE)
  countries = unique(x$country)
  
  print(list(NumberFound = records, 
             TaxonNames = names2, 
             Coordinates = data.frame(Stats, numbers=c(minlat,maxlat,minlong,maxlong)), 
             Countries = countries))
}

#' Check if object is of class gbiflist
#' @param x input
#' @export
is.gbiflist <- function(x) inherits(x, "gbiflist")

#' Check if object is of class gbifdens
#' @param x input
#' @export
is.gbifdens <- function(x) inherits(x, "gbifdens")