#' @param  scientificname scientitic name of taxon (character, see example)
#' @param  taxonconceptkey unique key for taxon (numeric)
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See \link{providers}. (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See \link{resources}. (character)
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
#' @param  maxresults  max number of results (integer) (1-10000); defaults to 10
#' @param  format  specifies the format in which the records are to be returned,
#     one of: brief or darwin (character) default is brief.
#' @param  icon  (only when format is set to kml) specified the URL for an icon
#'    to be used for the KML Placemarks.
#' @param mode Specifies whether the response data should (as far as possible)  
#'    be the raw values originally retrieved from the data resource or processed 
#'    (normalised) values used within the data portal (character)
#' @param stylesheet Sets the URL of the stylesheet to be associated with the
#     response document.
#' @param removeZeros remove records with both Lat Long zero values (logical) 
#' @param writecsv If path to a file is given, a text file is written out and 
#' 		a success message is returned to the console (logical)
#' @param curl If using in a loop, call getCurlHandle() first and pass
#' 		the returned value in here (avoids unnecessary footprint)
#' @param fixnames One of "match","change","none", just keep those 
#' 		records that match original search term, change all names to the original 
#' 		search term (beware using this option), or do nothing, respectively. Default is
#'   	"none".