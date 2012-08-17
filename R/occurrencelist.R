#' Occurrencelist searches for taxon concept records matching a range of filters.
#'
#' @import RCurl XML plyr
#' @param  sciname scientitic name of taxon (character, see example)
#' @param  taxonconceptKey unique key for taxon (numeric)
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param  institutioncode Return only records from a given institution code.
#' @param  collectioncode Return only records from a given collection code.
#' @param  catalognumber Return only records from a given catalog number.                 
#' @param  resourcenetworkkey  count only records which have been made available by 
#'    resources identified as belonging to the network identified by the supplied numeric key.
#' @param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#' @param  minlatitude  return only records from locations with latitudes greater 
#'    than the supplied value (southern hemisphere with negative latitudes). (numeric)
#' @param  maxlatitude  return only records from locations with latitudes lower than 
#'    the supplied value (southern hemisphere with negative latitudes). (numeric)
#' @param  minlongitude  return only records from locations with longitudes greater 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#' @param  maxlongitude  return only records from locations with longitudes lower 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#' @param  minaltitude  return only records from altitudes greater than or equal to 
#'    the supplied value. (integer)
#' @param  maxaltitude  return only records from altitudes less than or equals to 
#'    the supplied value. (integer)
#' @param  mindepth  return only records from depth greater than or equal to the supplied 
#'    value. (numeric 2 decimal places)
#' @param  maxdepth  return only records from depth less than or equals to the supplied 
#'    value. (numeric 2 decimal places)
#' @param  cellid  identifier for a one degree cell (O - 64,799)
#' @param  centicellid  identifier for a 0.1 degree cell within a one degree cell 
#' @param  typesonly  if set to "true", return only records with a type status specified.
#' @param  georeferencedonly  This option is deprecated.
#' @param  coordinatestatus  if set to "true", return only records with coordinates. 
#'    If set to "false", return only records without coordinates.
#' @param  coordinateissues  if set to "true", return only records for which the portal 
#'    has detected possible issues in georeferencing. If set to "false", return only 
#'    records for which the portal has not detected any such issues.
#' @param  hostisocountrycode  return only records served by providers from the country 
#'    identified by the supplied 2-letter ISO code.
#' @param  originisocountrycode return only records of occurrences which occurred 
#'    within the country identified by the supplied 2-letter ISO code. 
#' @param  originregioncode  return only records of occurrences which occurred 
#'    within the region identified by the supplied 3-letter code.
#' @param  startdate  return only records occurring on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#' @param  enddate  return only records occurring on or before the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#' @param  startyear  return only records from during or after the supplied year.
#' @param  endyear  return only records from during or before the supplied year.
#' @param  year  return only records from during the supplied year.
#' @param  month  return only records from during the supplied month (expressed as 
#'    an integer in the range 1 to 12).
#' @param  day  return only records from during the supplied day of month 
#'    (expressed as an integer in the range 1 to 31).
#' @param modifiedsince  return only records which have been indexed or modified 
#'    in the GBIF data portal index on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28). 
#' @param  startindex  return the subset of the matching records that starts at 
#'    the supplied (zero-based index). 
#' @param  maxresults  max number of results (integer) (1-10000)
#' @param  format  specifies the format in which the records are to be returned,
#     one of: brief or darwin (character) default is brief.
#' @param  icon  (only when format is set to kml) specified the URL for an icon
#'    to be used for the KML Placemarks.
#' @param mode Specifies whether the response data should (as far as possible)  
#'    be the raw values originally retrieved from the data resource or processed 
#'    (normalised) values used within the data portal (character)
#' @param stylesheet Sets the URL of the stylesheet to be associated with the
#     response document.
#' @param latlongdf Return a data.frame of lat/long's for all occurrences (logical)
#' @param removeZeros remove records with both Lat Long zero values (logical) 
#' @param writecsv If path to a file is given, a text file is written out and 
#' 		a success message is returned to the console (logical)
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#' the returned value in here (avoids unnecessary footprint)
#' @examples \dontrun{
#' occurrencelist(sciname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100)
#' occurrencelist(sciname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf=F)
#' occurrencelist(sciname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf=T, writecsv="~/myyyy.csv")
#' }
#' @export
occurrencelist <- function(sciname = NA, taxonconceptKey = NA,
  dataproviderkey = NA, dataresourcekey = NA, institutioncode = NA ,
  collectioncode = NA, catalognumber = NA, resourcenetworkkey = NA,
  basisofrecordcode = NA, minlatitude = NA, maxlatitude = NA,
  minlongitude = NA, maxlongitude = NA, minaltitude = NA, maxaltitude = NA,
  mindepth = NA, maxdepth = NA, cellid = NA, centicellid = NA,
  typesonly = NA, georeferencedonly = NA, coordinatestatus = NA,
  coordinateissues = NA, hostisocountrycode = NA, originisocountrycode = NA,
  originregioncode = NA, startdate = NA, enddate = NA, startyear = NA,
  endyear = NA, year = NA, month = NA, day = NA, modifiedsince = NA,
  startindex = NA, maxresults = 10, format = NA, icon = NA,
  mode = NA, stylesheet = NA, latlongdf = FALSE, removeZeros = FALSE, writecsv = NULL,
  url = "http://data.gbif.org/ws/rest/occurrence/list?", ..., curl = getCurlHandle()) 
{
  # Code based on the `gbifxmlToDataFrame` function from dismo package 
  # (http://cran.r-project.org/web/packages/dismo/index.html),
  # by Robert Hijmans, 2012-05-31, License: GPL v3
  gbifxmlToDataFrame <- function(s,format) {
    doc = xmlInternalTreeParse(s)
    nodes <- getNodeSet(doc, "//to:TaxonOccurrence")
    if (length(nodes) == 0) 
      return(data.frame())
    if(!is.na(format) & format=="darwin"){
      varNames <- c("country", "stateProvince", 
                    "county", "locality", "decimalLatitude", "decimalLongitude", 
                    "coordinateUncertaintyInMeters", "maximumElevationInMeters", 
                    "minimumElevationInMeters", "maximumDepthInMeters", 
                    "minimumDepthInMeters", "institutionCode", "collectionCode", 
                    "catalogNumber", "basisOfRecordString", "collector", 
                    "earliestDateCollected", "latestDateCollected", "gbifNotes")
    }else{
      varNames <- c("country", "decimalLatitude", "decimalLongitude", 
                    "catalogNumber", "earliestDateCollected", "latestDateCollected" )
    }
    dims <- c(length(nodes), length(varNames))
    ans <- as.data.frame(replicate(dims[2], rep(as.character(NA), 
                                                dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
    names(ans) <- varNames
    for (i in seq(length = dims[1])) {
      ans[i, ] <- xmlSApply(nodes[[i]], xmlValue)[varNames]
    }
    nodes <- getNodeSet(doc, "//to:Identification")
    varNames <- c("taxonName")
    dims = c(length(nodes), length(varNames))
    tax = as.data.frame(replicate(dims[2], rep(as.character(NA), 
                                               dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
    names(tax) = varNames
    for (i in seq(length = dims[1])) {
      tax[i, ] = xmlSApply(nodes[[i]], xmlValue)[varNames]
    }
    cbind(tax, ans)
  }
  #End gbifxmlToDataFrame -----
  
  if (!is.na(sciname)) {
    sciname2 <- paste("scientificname=", gsub(" ", "+", sciname), sep = "")
    noCount <- FALSE
  } else {
    sciname2 <- NULL
    noCount <- TRUE
  }
  if (!is.na(dataproviderkey)) {
    dataproviderkey2 <- paste("&dataproviderkey=", dataproviderkey, sep = "")
  } else {
    dataproviderkey2 <- NULL
  }
  if (!is.na(dataresourcekey)) {
    dataresourcekey2 <- paste("&dataresourcekey=", dataresourcekey, sep = "")
  } else {
    dataresourcekey2 <- NULL
  }
  if (!is.na(institutioncode)) {
    institutioncode2 <- paste("&institutioncode=", institutioncode, sep = "")
  } else {
    institutioncode2 <- NULL
  }
  if (!is.na(collectioncode)) {
    collectioncode2 <- paste("&collectioncode=", collectioncode, sep = "")
  } else {
    collectioncode2 <- NULL
  }
  if (!is.na(catalognumber)) {
    catalognumber2 <- paste("&catalognumber=", catalognumber, sep = "")
  } else {
    catalognumber2 <- NULL
  }
  if (!is.na(taxonconceptKey)) {
    taxonconceptKey2 <- paste("&taxonconceptKey=", taxonconceptKey, sep = "")
  } else {
    taxonconceptKey2 <- NULL
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
  if (!is.na(cellid)) {
    cellid2 <- paste("&cellid=", cellid, sep = "")
  } else {
    cellid2 <- NULL
  }
  if (!is.na(centicellid)) {
    centicellid2 <- paste("&centicellid=", centicellid, sep = "")
  } else {
    centicellid2 <- NULL
  }
  if (!is.na(typesonly)) {
    typesonly2 <- paste("&typesonly=", typesonly, sep = "")
  } else {
    typesonly2 <- NULL
  }
  if (!is.na(coordinateissues)) {
    coordinateissues2 <- paste("&coordinateissues=", coordinateissues, sep = "")
  } else {
    coordinateissues2 <- NULL
  }
  if (!is.na(hostisocountrycode)) {
    hostisocountrycode2 <- paste("&hostisocountrycode=", hostisocountrycode, sep = "")
  } else {
    hostisocountrycode2 <- NULL
  }
  if (!is.na(originisocountrycode)) {
    originisocountrycode2 <- paste("&originisocountrycode=", originisocountrycode, sep = "")
  } else {
    originisocountrycode2 <- NULL
  }
  if (!is.na(originregioncode)) {
    originregioncode2 <- paste("&originregioncode=", originregioncode, sep = "")
  } else {
    originregioncode2 <- NULL
  }
  if (!is.na(startdate)) {
    startdate2 <- paste("&startdate=", startdate, sep = "")
  } else {
    startdate2 <- NULL
  }
  if (!is.na(enddate)) {
    enddate2 <- paste("&enddate=", enddate, sep = "")
  } else {
    enddate2 <- NULL
  }
  if (!is.na(startyear)) {
    startyear2 <- paste("&startyear=", startyear, sep = "")
  } else {
    startyear2 <- NULL
  }
  if (!is.na(endyear)) {
    endyear2 <- paste("&endyear=", endyear, sep = "")
  } else {
    endyear2 <- NULL
  }
  if (!is.na(year)) {
    year2 <- paste("&year=", year, sep = "")
  } else {
    year2 <- NULL
  }
  if (!is.na(month)) {
    month2 <- paste("&month=", month, sep = "")
  } else {
    month2 <- NULL
  }
  if (!is.na(day)) {
    day2 <- paste("&day=", day, sep = "")
  } else {
    day2 <- NULL
  }
  if (!is.na(modifiedsince)) {
    modifiedsince2 <- paste("&modifiedsince=", modifiedsince, sep = "")
  } else {
    modifiedsince2 <- NULL
  }
  if (!is.na(startindex)) {
    startindex2 <- paste("&startindex=", startindex, sep = "")
  } else {
    startindex2 <- NULL
  }
  if (!is.na(format)) {
    format2 <- paste("&format=", format, sep = "")
  } else {
    format2 <- NULL
  }
  if (!is.na(icon)) {
    icon2 <- paste("&icon=", icon, sep = "")
  } else {
    icon2 <- NULL
  }
  if (!is.na(mode)) {
    mode2 <- paste("&mode=", mode, sep = "")
  } else {
    mode2 <- NULL
  }
  if (!is.na(stylesheet)) {
    stylesheet2 <- paste("&stylesheet=", stylesheet, sep = "")
  } else {
    stylesheet2 <- NULL
  }
  
  if (!is.na(maxresults)) {
    maxresults2 <- paste("&maxresults=", maxresults, sep = "")
  } else {
    maxresults2 <- NULL
  }
  args <- paste(sciname2, taxonconceptKey2, basisofrecordcode2, maxresults2, 
                dataproviderkey2, dataresourcekey2, institutioncode2,
                collectioncode2, catalognumber2, coordinatestatus2, 
                minlatitude2, maxlatitude2, minlongitude2, maxlongitude2, 
                minaltitude2, maxaltitude2, mindepth2, maxdepth2, cellid2,
                centicellid2, typesonly2, coordinateissues2, hostisocountrycode2,
                originisocountrycode2, originregioncode2, startdate2, enddate2,
                startyear2, endyear2, year2, month2, day2, modifiedsince2, 
                startindex2, format2, icon2, mode2, stylesheet2, sep = "")
#  if(!noCount){
    urlct = "http://data.gbif.org/ws/rest/occurrence/count?"
    queryct <- paste(urlct, args, sep = "")
    x <- try(readLines(queryct, warn = FALSE))
    if (class(x) == "try-error") {
        cat("Connection problem\n")
        n = 0
    } else {
    x <- x[grep("totalMatched", x)]
    n <- as.integer(unlist(strsplit(x, "\""))[2])
    }
    if (n == 0) {
      cat("No occurrences found\n")
      return(invisible(NULL))
    }
#  }
  query <- paste(url, args, sep = "")
  tt <- getURL(query, ..., curl = curl)
  
  out <- xmlTreeParse(tt)$doc$children$gbifResponse
  if (latlongdf == TRUE) {
    df <- gbifxmlToDataFrame (query,format)
    df[, "decimalLongitude"] <- as.numeric(df[, "decimalLongitude"])
    df[, "decimalLatitude"] <- as.numeric(df[, "decimalLatitude"])
    i <- df[, "decimalLongitude"] == 0 & df[, "decimalLatitude"] == 0
    i
    if (removeZeros) {
      df <- df[!i, ]
    }
    else {
      df[i, "decimalLatitude"] <- NA
      df[i, "decimalLongitude"] <- NA 
    }
    df
    	if(!is.null(writecsv)){
    		write.csv(df, file=writecsv)
    		message("Success! CSV file written")
    	}
  } else {
    out
  }
}