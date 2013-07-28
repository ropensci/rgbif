#' @param  scientificname scientitic name of taxon. See details. (character)
#' @param  taxonconceptkey unique key for taxon. See details (numeric)
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
#' @param mode One of processed or raw. Specifies whether the response data 
#'    should (as far as possible) be the raw values originally retrieved from 
#'    the data resource or processed (normalised) values used within the data 
#'    portal (character)
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
#' @details
#' Including many possible values for a particular parameter: The following 
#' parameters may have many values passed to them (e.g., like parameter=c('a','b')):
#' scientificname, taxonconceptkey, dataproviderkey, dataresourcekey, 
#' resourcenetworkkey, basisofrecordcode, cellid, centicellid, hostisocountrycode, 
#' originisocountrycode, originregioncode, year, month, and day.
#' 
#' More on scientificname: Returns only records where the scientific name matches 
#' that supplied - this is based on the scientific name found in the original 
#' record from the data provider and does not make use of extra knowledge of 
#' possible synonyms or of child taxa.  For these functions, use taxonconceptkey. 
#' Including an asterisk '*' in the search string causes the service to return 
#' records for any name starting with the string preceding the asterisk. There 
#' must be at least three characters preceding the asterisk. The scientificname 
#' parameter may be repeated within a single request - the results will include 
#' records matching any of the supplied scientific names.
#' 
#' More on taxonconceptkey: Returns only records which are for the taxon identified
#' by the supplied numeric key, including any records provided under synonyms of 
#' the taxon concerned, and any records for child taxa (e.g. all genera and 
#' species within a family).  Values for taxonconceptkey can be found through the 
#' taxon web service (see http://data.gbif.org/ws/rest/taxon).  Note that the 
#' service will always search using the corresponding concept in the synthetic 
#' generated "PORTAL" taxonomy (even if the taxonconceptkey is for a concept from
#' a specific resource.  Use dataresourcekey to limit the search to a single data 
#' resource.  The most efficient and thorough way to search will be to limit 
#' searches to taxa belonging to the following ranks: kingdom, phylum, class, 
#' order, family, genus, species, any infraspecific rank. Each record returned 
#' from this action (and from the get action) also includes a taxonKey attribute 
#' which can be used in the taxonconceptkey parameter on subsequent invocations 
#' of the list and count actions. The taxonconceptkey parameter may be repeated 
#' within a single request - the results will include records for any of the 
#' specified taxa.
#' 
#' See the GBIF API docs for more details on each parameter:
#' http://data.gbif.org/ws/rest/occurrence