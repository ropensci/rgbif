#'occurrencelist description
#'@import RCurl XML plyr
#'@param  sciname scientitic name of taxon (character, see example)
#'@param  taxonconceptKey unique key for taxon (numeric)
#'@param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#'@param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#'@param  resourcenetworkkey  <what param does>
#'@param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#'@param  minlatitude  return only records from locations with latitudes greater 
#'    than the supplied value (southern hemisphere with negative latitudes). (numeric)
#'@param  maxlatitude  return only records from locations with latitudes lower than 
#'    the supplied value (southern hemisphere with negative latitudes). (numeric)
#'@param  minlongitude  return only records from locations with longitudes greater 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#'@param  maxlongitude  return only records from locations with longitudes lower 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#'@param  minaltitude  return only records from altitudes greater than or equal to 
#'    the supplied value. (integer)
#'@param  maxaltitude  return only records from altitudes less than or equals to 
#'    the supplied value. (integer)
#'@param  mindepth  return only records from depth greater than or equal to the supplied 
#'    value. (numeric 2 decimal places)
#'@param  maxdepth  return only records from depth less than or equals to the supplied 
#'    value. (numeric 2 decimal places)
#'@param  cellid  identifier for a one degree cell (O - 64,799)
#'@param  centicellid  identifier for a 0.1 degree cell within a one degree cell 
#'@param  typesonly  if set to "true", return only records with a type status specified.
#'@param  georeferencedonly  This option is deprecated.
#'@param  coordinatestatus  if set to "true", return only records with coordinates. 
#'    If set to "false", return only records without coordinates.
#'@param  coordinateissues  if set to "true", return only records for which the portal 
#'    has detected possible issues in georeferencing. If set to "false", return only 
#'    records for which the portal has not detected any such issues.
#'@param  hostisocountrycode  return only records served by providers from the country 
#'    identified by the supplied 2-letter ISO code.
#'@param  originisocountrycode return only records of occurrences which occurred 
#'    within the country identified by the supplied 2-letter ISO code. 
#'@param  originregioncode  return only records of occurrences which occurred 
#'    within the region identified by the supplied 3-letter code.
#'@param  startdate  return only records occurring on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#'@param  enddate  return only records occurring on or before the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#'@param  startyear  return only records from during or after the supplied year.
#'@param  endyear  return only records from during or before the supplied year.
#'@param  year  return only records from during the supplied year.
#'@param  month  return only records from during the supplied month (expressed as 
#'    an integer in the range 1 to 12).
#'@param  day  return only records from during the supplied day of month 
#'    (expressed as an integer in the range 1 to 31).
#'@param modifiedsince  return only records which have been indexed or modified 
#'    in the GBIF data portal index on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28). 
#'@param  startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#'@param  maxresults  max number of results (integer) (1-10000)
#'@param  format  specifies the format in which the records are to be returned,
#     one of: brief, darwin or kml (character)
#'@param  icon  <what param does>
#'@param mode  specifies whether the response data should (as far as possible)  be the raw values originally retrieved from the data resource or processed (normalised) values used within the data portal (character)latlongdf: return a data.frame of lat/long's for all occurrences (logical)
#'@param  stylesheet sets the URL of the stylesheet to be associated with the
#     response document.
#'@param  latlongdf  Return results of function as data.frame
#'@param url the base GBIF API url for the function (should be left to default)
#'@param ... optional additional curl options (debugging tools mostly)
#'@param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'occurrencelist(sciname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100)
#'}
occurrencelist <- function(sciname = NA, taxonconceptKey = NA,
    dataproviderkey = NA, dataresourcekey = NA, resourcenetworkkey = NA,
    basisofrecordcode = NA, minlatitude = NA, maxlatitude = NA,
    minlongitude = NA, maxlongitude = NA, minaltitude = NA, maxaltitude = NA,
    mindepth = NA, maxdepth = NA, cellid = NA, centicellid = NA,
    typesonly = NA, georeferencedonly = NA, coordinatestatus = NA,
    coordinateissues = NA, hostisocountrycode = NA, originisocountrycode = NA,
    originregioncode = NA, startdate = NA, enddate = NA, startyear = NA,
    endyear = NA, year = NA, month = NA, day = NA, modifiedsince = NA,
    startindex = NA, maxresults = 10, format = NA, icon = NA,
    mode = NA, stylesheet = NA, latlongdf = FALSE, url = "http://data.gbif.org/ws/rest/occurrence/list?",
    ..., curl = getCurlHandle()) {
    if (!is.na(sciname)) {
        sciname2 <- paste("scientificname=", gsub(" ", "+", sciname),
            sep = "")
    } else {
        sciname2 <- NULL
    }
    if (!is.na(basisofrecordcode)) {
      basisofrecordcode2 <- paste("&basisofrecordcode=", basisofrecordcode, sep = "")
    } else {
      basisofrecordcode2 <- NULL
    }
    if (!is.na(coordinatestatus)) {
        coordinatestatus2 <- paste("&coordinatestatus=", coordinatestatus,
            sep = "")
    } else {
        coordinatestatus2 <- NULL
    }
    if (!is.na(minlatitude)) {
      minlatitude2 <- paste("&minlatitude=", minlatitude, sep = "")
    } else {
      minlatitude2 <- NULL
    }
    if (!is.na(maxlatitude)) {
      maxlatitude2 <- paste("&maxlatitude=", maxlatitude, sep = "")
    } else {
      maxlatitude2 <- NULL
    }
    if (!is.na(minlongitude)) {
      minlongitude2 <- paste("&minlongitude=", minlongitude, sep = "")
    } else {
      minlongitude2 <- NULL
    }
    if (!is.na(maxlongitude)) {
      maxlongitude2 <- paste("&maxlongitude=", maxlongitude, sep = "")
    } else {
      maxlongitude2 <- NULL
    }
    if (!is.na(minaltitude)) {
      minaltitude2 <- paste("&minaltitude=", minaltitude, sep = "")
    } else {
      minaltitude2 <- NULL
    }
    if (!is.na(maxaltitude)) {
      maxaltitude2 <- paste("&maxaltitude=", maxaltitude, sep = "")
    } else {
      maxaltitude2 <- NULL
    }
    if (!is.na(mindepth)) {
      mindepth2 <- paste("&mindepth=", mindepth, sep = "")
    } else {
      mindepth2 <- NULL
    }
    if (!is.na(maxdepth)) {
      maxdepth2 <- paste("&maxdepth=", maxdepth, sep = "")
    } else {
      maxdepth2 <- NULL
    }
    if (!is.na(maxresults)) {
        maxresults2 <- paste("&maxresults=", maxresults, sep = "")
    } else {
        maxresults2 <- NULL
    }
    args <- paste(sciname2, basisofrecordcode2, maxresults2, coordinatestatus2, 
                  minlatitude2, maxlatitude2, minlongitude2, maxlongitude2, 
                  minaltitude2, maxaltitude2, mindepth2, maxdepth2, sep = "")
    
    query <<- paste(url, args, sep = "")
    tt <- getURL(query, ..., curl = curl)
    out <- xmlTreeParse(tt)$doc$children$gbifResponse
    if (latlongdf == TRUE) {
        latlist <- xpathApply(out, "//to:decimalLatitude")
        longlist <- xpathApply(out, "//to:decimalLongitude")
        df <- data.frame(rep(sciname, length(latlist)), laply(latlist,
            function(x) as.numeric(xmlValue(x))), laply(longlist,
            function(x) as.numeric(xmlValue(x))))
        names(df) <- c("sciname", "latitude", "longitude")
        df
    } else {
        out
    }
}
# out <- occurrencelist(sciname = 'Aratinga holochlora rubritorquis', coordinatestatus = TRUE,
#     maxresults = 10, latlongdf = TRUE)
# out
