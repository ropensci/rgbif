#' Get data.frame from occurrencelist, occurrencelist_many, or densitylist.
#' 
#' @param input Input object from a call to occurrencelist, occurrencelist_many, 
#'    or densitylist.
#' @param ... further arguments
#' @details A convienence function to get the raw data in a data.frame format from 
#'    occurrencelist, occurrencelist_many, and densitylist functions.
#' @export
#' @examples \dontrun{
#' # occurrencelist
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, 
#'    maxresults = 40)
#' gbifdata(out)
#' gbifdata(out, minimal=FALSE)
#' 
#' occurrencelist_many
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
#' gbifdata(out)
#' gbifdata(out, minimal=FALSE)
#' 
#' # densitylist (the minimal parameter doesn't apply with densitylist data)
#' out <- densitylist(originisocountrycode="US")
#' gbifdata(out)
#' }
gbifdata <- function(input, ...) UseMethod("gbifdata")

#' Gbiflist method
#' @param input Input object from a call to occurrencelist, occurrencelist_many, or densitylist.
#' @param minimal Only applies to occurrencelist data. If TRUE, returns only name, lat, 
#'    long fields; defaults to TRUE. 
#' @param ... further arguments
#' @method gbifdata gbiflist
#' @export
gbifdata.gbiflist <- function(input, minimal=TRUE, ...)
{  
  if(!is.gbiflist(input))
    stop("Input is not of class gbiflist")  
  
  input <- data.frame(input)
  input$decimalLatitude <- as.numeric(input$decimalLatitude)
  input$decimalLongitude <- as.numeric(input$decimalLongitude)
  
  input2 <- input[complete.cases(input$decimalLatitude, input$decimalLatitude), ]
  tomap <- input2[-(which(input2$decimalLatitude <=90 || input2$decimalLongitude <=180)), ]
  input2$taxonName <- as.factor(capwords(input2$taxonName, onlyfirst=TRUE))
  
  if(minimal)
    input2 <- input2[,c("taxonName","decimalLatitude","decimalLongitude")]
  return( input2 )
}

#' Gbifdens method
#' @param input Input object from a call to occurrencelist, occurrencelist_many, or densitylist.
#' @param ... further arguments
#' @method gbifdata gbifdens
#' @export
gbifdata.gbifdens <- function(input, ...)
{
  if(!is.gbifdens(input))
    stop("Input is not of class gbifdens")  
  
  return( data.frame(input) )
}

#' Print summary of gbifdens class
#' @param x an object of class gbifdens
#' @param ... further arguments passed to or from other methods.
#' @method print gbifdens
#' @export
print.gbifdens <- function(x, ...){
  if(!is.gbifdens(x))
    stop("Input is not of class gbifdens")  
  
  Stats = c("NumberCells","MinLatitude","MaxLatitude","MinLongitude",
    "MaxLongitude","MinPerCell","MaxPercell")
  records <- nrow(x)
  minlat = min(x$minLatitude, na.rm=TRUE)
  maxlat = max(x$maxLatitude, na.rm=TRUE)
  minlong = min(x$minLongitude, na.rm=TRUE)
  maxlong = max(x$maxLongitude, na.rm=TRUE)
  minpercell = min(x$count)
  maxpercell = max(x$count)
  
  print(data.frame(Stats, numbers=c(records,minlat,maxlat,minlong,
    maxlong,minpercell,maxpercell)))
}

#' Print summary of gbiflist class
#' @param x an object of class gbiflist
#' @param ... further arguments passed to or from other methods.
#' @method print gbiflist
#' @export
print.gbiflist <- function(x, ...){
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