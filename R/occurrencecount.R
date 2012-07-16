#'occurrencecount count taxon concept records matching a range of filters
#'@import RCurl XML plyr
#' @param  sciname count only records where the scientific name matches 
#'  	that supplied, use an asterisk * for any name starting with preseding 
#'		string (character). does not make use of extra knowledge of possible synonyms 
#'		or of child taxa.  For these functions, use taxonconceptkey. May be repeted in single request.
#' @param  taxonconceptKey unique key for taxon (numeric). Count only records which are 
#'		for the taxon identified by the supplied numeric key, including any records provided 
#'		under synonyms of the taxon concerned, and any records for child taxa 
#'		(e.g. all genera and species within a family).  May be repeted in single request.
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param  institutioncode Return only records from a given institution code.
#' @param  collectioncode Return only records from a given collection code.
#' @param  catalognumber Return only records from a given catalog number.                 
#' @param  resourcenetworkkey  count only records which have been made available by 
#'		resources identified as belonging to the network identified by the supplied numeric key.
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
#' @param  cellid  identifier for a one degree cell (O - 64,799). 
#'		Using a cellid is more efficient than using a bounding box for the same cell.
#' @param  centicellid  identifier for a 0.1 degree cell within a one degree cell 
#' @param  typesonly  if set to "true", return only records with a type status specified.
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
#' @param url the base GBIF API url for the function (should be left to default)
#' @param ... optional additional curl options (debugging tools mostly)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#'		the returned value in here (avoids unnecessary footprint)
#'@export
#'@examples \dontrun{
#'occurrencecount(sciname = 'Accipiter erythronemius', coordinatestatus = TRUE)
#'}
occurrencecount <- function(sciname = NA, taxonconceptKey = NA,
                            dataproviderkey = NA, dataresourcekey = NA, institutioncode =NA ,
                            collectioncode = NA, catalognumber = NA, resourcenetworkkey = NA,
                            basisofrecordcode = NA, minlatitude = NA, maxlatitude = NA,
                            minlongitude = NA, maxlongitude = NA, minaltitude = NA, maxaltitude = NA,
                            mindepth = NA, maxdepth = NA, cellid = NA, centicellid = NA,
                            typesonly = NA, coordinatestatus = NA,
                            coordinateissues = NA, hostisocountrycode = NA, originisocountrycode = NA,
                            originregioncode = NA, startdate = NA, enddate = NA, startyear = NA,
                            endyear = NA, year = NA, month = NA, day = NA, modifiedsince = NA,
                            url = "http://data.gbif.org/ws/rest/occurrence/count?",
                            ..., curl = getCurlHandle()) {
  
  if (!is.na(sciname)) {
    sciname2 <- paste("scientificname=", gsub(" ", "+", sciname), sep = "")
    noCount <- FALSE
  } else {
    sciname2 <- NULL
    noCount <- TRUE
  }
  if (!is.na(taxonconceptKey)) {
    taxonconceptKey2 <- paste("&taxonconceptKey=", taxonconceptKey, sep = "")
  } else {
    taxonconceptKey2 <- NULL
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
  if (!is.na(resourcenetworkkey)) {
    resourcenetworkkey2 <- paste("&resourcenetworkkey=", resourcenetworkkey, sep = "")
  } else {
    resourcenetworkkey2 <- NULL
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
  
  args <- paste(sciname2, taxonconceptKey2, basisofrecordcode2, coordinatestatus2, 
                dataproviderkey2, dataresourcekey2, institutioncode2,
                collectioncode2, catalognumber2, resourcenetworkkey2,
                minlatitude2, maxlatitude2, minlongitude2, maxlongitude2, 
                minaltitude2, maxaltitude2, mindepth2, maxdepth2, cellid2,
                centicellid2, typesonly2, coordinateissues2, hostisocountrycode2,
                originisocountrycode2, originregioncode2, startdate2, enddate2,
                startyear2, endyear2, year2, month2, day2, modifiedsince2, 
                sep = "")
  
  
  queryct <- paste(url, args, sep = "")
  x <- try(readLines(queryct, warn = FALSE))
  x <- x[grep("totalMatched", x)]
  out <- as.integer(unlist(strsplit(x, "\""))[2])
  
}
# out <- occurrencecount(sciname = 'Aratinga holochlora rubritorquis', coordinatestatus = TRUE)
# out
