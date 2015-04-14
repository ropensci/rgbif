#' @param taxonKey A taxon key from the GBIF backbone. All included and synonym taxa
#'    are included in the search, so a search for aves with taxononKey=212
#'    (i.e. /occurrence/search?taxonKey=212) will match all birds, no matter which
#'    species. You can pass many keys by passing occ_search in a call to an
#'    lapply-family function (see last example below).
#' @param scientificName A scientific name from the GBIF backbone. All included and synonym
#' 	  taxa are included in the search.
#' @param datasetKey The occurrence dataset key (a uuid)
#' @param catalogNumber An identifier of any form assigned by the source within a
#'    physical collection or digital dataset for the record which may not unique,
#'    but should be fairly unique in combination with the institution and collection code.
#' @param collectorName The person who recorded the occurrence.
#' @param collectionCode An identifier of any form assigned by the source to identify
#'    the physical collection or digital dataset uniquely within the text of an institution.
#' @param institutionCode An identifier of any form assigned by the source to identify
#'    the institution the record belongs to. Not guaranteed to be que.
#' @param country The 2-letter country code (as per ISO-3166-1) of the country in
#'    which the occurrence was recorded. See here
#'    \url{http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2}
#' @param basisOfRecord Basis of record, as defined in our BasisOfRecord enum here
#'    \url{http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/BasisOfRecord.html} 
#'    Acceptable values are:
#'    \itemize{
#'      \item FOSSIL_SPECIMEN An occurrence record describing a fossilized specimen.
#'      \item HUMAN_OBSERVATION An occurrence record describing an observation made by
#'      one or more people.
#'      \item LITERATURE An occurrence record based on literature alone.
#'      \item LIVING_SPECIMEN An occurrence record describing a living specimen, e.g.
#'      \item MACHINE_OBSERVATION An occurrence record describing an observation made
#'      by a machine.
#'      \item OBSERVATION An occurrence record describing an observation.
#'      \item PRESERVED_SPECIMEN An occurrence record describing a preserved specimen.
#'      \item UNKNOWN Unknown basis for the record.
#'    }
#' @param eventDate Occurrence date in ISO 8601 format: yyyy, yyyy-MM, yyyy-MM-dd, or
#'    MM-dd. Supports range queries, smaller,larger (e.g., '1990,1991', whereas '1991,1990' 
#'    wouldn't work)
#' @param year The 4 digit year. A year of 98 will be interpreted as AD 98. Supports range queries,
#'    smaller,larger (e.g., '1990,1991', whereas '1991,1990' wouldn't work)
#' @param month The month of the year, starting with 1 for January. Supports range queries, 
#'    smaller,larger (e.g., '1,2', whereas '2,1' wouldn't work)
#' @param search Query terms. The value for this parameter can be a simple word or a phrase.
#' @param decimalLatitude Latitude in decimals between -90 and 90 based on WGS 84.
#'    Supports range queries, smaller,larger (e.g., '25,30', whereas '30,25' wouldn't work)
#' @param decimalLongitude Longitude in decimals between -180 and 180 based on WGS 84.
#'    Supports range queries (e.g., '-0.4,-0.2', whereas '-0.2,-0.4' wouldn't work).
#' @param publishingCountry The 2-letter country code (as per ISO-3166-1) of the
#'    country in which the occurrence was recorded.
#' @param elevation Elevation in meters above sea level. Supports range queries, smaller,larger 
#'    (e.g., '5,30', whereas '30,5' wouldn't work)
#' @param depth Depth in meters relative to elevation. For example 10 meters below a
#'    lake surface with given elevation. Supports range queries, smaller,larger (e.g., '5,30', 
#'    whereas '30,5' wouldn't work)
#' @param geometry Searches for occurrences inside a polygon described in Well Known
#'    Text (WKT) format. A WKT shape written as either POINT, LINESTRING, LINEARRING
#'    or POLYGON. Example of a polygon: ((30.1 10.1, 20, 20 40, 40 40, 30.1 10.1))
#'     would be queried as \url{http://bit.ly/1BzNwDq}.
#' @param hasGeospatialIssue (logical) Includes/excludes occurrence records which contain spatial
#'    issues (as determined in our record interpretation), i.e. \code{hasGeospatialIssue=TRUE}
#'    returns only those records with spatial issues while \code{hasGeospatialIssue=FALSE} includes
#'    only records without spatial issues. The absence of this parameter returns any
#'    record with or without spatial issues.
#' @param issue (character) One or more of many possible issues with each occurrence record. See
#'    Details. Issues passed to this parameter filter results by the issue.
#' @param hasCoordinate (logical) Return only occurence records with lat/long data (TRUE) or
#'    all records (FALSE, default).
#' @param typeStatus Type status of the specimen. One of many options. See ?typestatus
#' @param recordNumber Number recorded by collector of the data, different from GBIF record
#'    number. See \url{http://rs.tdwg.org/dwc/terms/#recordNumber} for more info
#' @param lastInterpreted Date the record was last modified in GBIF, in ISO 8601 format:
#'    yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd.  Supports range queries, smaller,larger (e.g., 
#'    '1990,1991', whereas '1991,1990' wouldn't work)
#' @param continent Continent. One of africa, antarctica, asia, europe, north_america
#'    (North America includes the Caribbean and reachies down and includes Panama), oceania,
#'    or south_america
#' @param fields (character) Default ('all') returns all fields. 'minimal' returns just taxon name, 
#'    key, latitude, and longitute. Or specify each field you want returned by name, e.g.
#'    fields = c('name','latitude','elevation').
#' @param return One of data, hier, meta, or all. If data, a data.frame with the
#'    data. hier returns the classifications in a list for each record. meta
#'    returns the metadata for the entire call. all gives all data back in a list.
#' @param mediatype Media type. Default is NULL, so no filtering on mediatype. Options:
#'    NULL, 'MovingImage', 'Sound', and 'StillImage'.``
#' @return A data.frame or list
#' @details
#' Note that you can pass in a vector to one of taxonkey, datasetKey, and
#' catalogNumber parameters in a function call, but not a vector >1 of the three
#' parameters at the same time
#'
#' \bold{Hierarchies:} hierarchies are returned wih each occurrence object. There is no
#' option no to return them from the API. However, within the \code{occ_search}
#' function you can select whether to return just hierarchies, just data, all of
#' data and hiearchies and metadata, or just metadata. If all hierarchies are the
#' same we just return one for you.
#'
#' \bold{Data:} By default only three data fields are returned: name (the species name),
#' decimallatitude, and decimallongitude. Set parameter minimal=FALSE if you want more data.
#'
#' \bold{Nerds:} You can pass parameters not defined in this function into the call to
#' the GBIF API to control things about the call itself using \code{...}. See an example below 
#' that passes in the \code{verbose} function to get details on the http call.
#'
#' \bold{Scientific names vs. taxon keys:} In the previous GBIF API and the version of rgbif that
#' wrapped that API, you could search the equivalent of this function with a species name, which
#' was convenient. However, names are messy right. So it sorta makes sense to sort out the species
#' key numbers you want exactly, and then get your occurrence data with this function. GBIF has
#' added a parameter scientificName to allow searches by scientific names in this function - which
#' includes synonym taxa. \emph{Note:} that if you do use the scientificName parameter, we will
#' check internally that it's not a synonym of an accepted name, and if it is, we'll search on the
#' accepted name. If you want to force searching by a synonym do so by finding the GBIF identifier
#' first with any \code{name_*} functions, then pass that ID to the \code{taxonKey} parameter.
#'
#' \bold{WKT:} Examples of valid WKT objects:
#' \itemize{
#'  \item 'POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))'
#'  \item 'POINT(30.1 10.1)'
#'  \item 'LINESTRING(3 4,10 50,20 25)'
#'  \item 'LINEARRING' ???' - Not sure how to specify this. Anyone?
#' }
#'
#' \bold{Range queries:} A range query is as it sounds - you query on a range of values defined by
#' a lower and upper limit. Do a range query by specifying the lower and upper limit in a vector
#' like \code{depth='50,100'}. It would be more R like to specify the range in a vector like
#' \code{c(50,100)}, but that sort of syntax allows you to do many searches, one for each element in
#' the vector - thus range queries have to differ. The following parameters support range queries.
#' \itemize{
#'  \item decimalLatitude
#'  \item decimalLongitude
#'  \item depth
#'  \item elevation
#'  \item eventDate
#'  \item lastInterpreted
#'  \item month
#'  \item year
#' }
#'
#' \bold{Issue:} The options for the issue parameter (from
#' http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html):
#' \itemize{
#'  \item BASIS_OF_RECORD_INVALID The given basis of record is impossible to interpret or seriously
#'  different from the recommended vocabulary.
#'  \item CONTINENT_COUNTRY_MISMATCH The interpreted continent and country do not match up.
#'  \item CONTINENT_DERIVED_FROM_COORDINATES The interpreted continent is based on the coordinates,
#'  not the verbatim string information.
#'  \item CONTINENT_INVALID Uninterpretable continent values found.
#'  \item COORDINATE_INVALID Coordinate value given in some form but GBIF is unable to interpret it.
#'  \item COORDINATE_OUT_OF_RANGE Coordinate has invalid lat/lon values out of their decimal max
#'  range.
#'  \item COORDINATE_REPROJECTED The original coordinate was successfully reprojected from a
#'  different geodetic datum to WGS84.
#'  \item COORDINATE_REPROJECTION_FAILED The given decimal latitude and longitude could not be
#'  reprojected to WGS84 based on the provided datum.
#'  \item COORDINATE_REPROJECTION_SUSPICIOUS Indicates successful coordinate reprojection according
#'  to provided datum, but which results in a datum shift larger than 0.1 decimal degrees.
#'  \item COORDINATE_ROUNDED Original coordinate modified by rounding to 5 decimals.
#'  \item COUNTRY_COORDINATE_MISMATCH The interpreted occurrence coordinates fall outside of the
#'  indicated country.
#'  \item COUNTRY_DERIVED_FROM_COORDINATES The interpreted country is based on the coordinates, not
#'  the verbatim string information.
#'  \item COUNTRY_INVALID Uninterpretable country values found.
#'  \item COUNTRY_MISMATCH Interpreted country for dwc:country and dwc:countryCode contradict each
#'  other.
#'  \item DEPTH_MIN_MAX_SWAPPED Set if supplied min>max
#'  \item DEPTH_NON_NUMERIC Set if depth is a non numeric value
#'  \item DEPTH_NOT_METRIC Set if supplied depth is not given in the metric system, for example
#'  using feet instead of meters
#'  \item DEPTH_UNLIKELY Set if depth is larger than 11.000m or negative.
#'  \item ELEVATION_MIN_MAX_SWAPPED Set if supplied min > max elevation
#'  \item ELEVATION_NON_NUMERIC Set if elevation is a non numeric value
#'  \item ELEVATION_NOT_METRIC Set if supplied elevation is not given in the metric system, for
#'  example using feet instead of meters
#'  \item ELEVATION_UNLIKELY Set if elevation is above the troposphere (17km) or below 11km
#'  (Mariana Trench).
#'  \item GEODETIC_DATUM_ASSUMED_WGS84 Indicating that the interpreted coordinates assume they are
#'  based on WGS84 datum as the datum was either not indicated or interpretable.
#'  \item GEODETIC_DATUM_INVALID The geodetic datum given could not be interpreted.
#'  \item IDENTIFIED_DATE_INVALID The date given for dwc:dateIdentified is invalid and cant be
#'  interpreted at all.
#'  \item IDENTIFIED_DATE_UNLIKELY The date given for dwc:dateIdentified is in the future or before
#'  Linnean times (1700).
#'  \item MODIFIED_DATE_INVALID A (partial) invalid date is given for dc:modified, such as a non
#'  existing date, invalid zero month, etc.
#'  \item MODIFIED_DATE_UNLIKELY The date given for dc:modified is in the future or predates unix
#'  time (1970).
#'  \item MULTIMEDIA_DATE_INVALID An invalid date is given for dc:created of a multimedia object.
#'  \item MULTIMEDIA_URI_INVALID An invalid uri is given for a multimedia object.
#'  \item PRESUMED_NEGATED_LATITUDE Latitude appears to be negated, e.g. 32.3 instead of -32.3
#'  \item PRESUMED_NEGATED_LONGITUDE Longitude appears to be negated, e.g. 32.3 instead of -32.3
#'  \item PRESUMED_SWAPPED_COORDINATE Latitude and longitude appear to be swapped.
#'  \item RECORDED_DATE_INVALID A (partial) invalid date is given, such as a non existing date,
#'  invalid zero month, etc.
#'  \item RECORDED_DATE_MISMATCH The recording date specified as the eventDate string and the
#'  individual year, month, day are contradicting.
#'  \item RECORDED_DATE_UNLIKELY The recording date is highly unlikely, falling either into the
#'  future or represents a very old date before 1600 that predates modern taxonomy.
#'  \item REFERENCES_URI_INVALID An invalid uri is given for dc:references.
#'  \item TAXON_MATCH_FUZZY Matching to the taxonomic backbone can only be done using a fuzzy, non
#'  exact match.
#'  \item TAXON_MATCH_HIGHERRANK Matching to the taxonomic backbone can only be done on a higher
#'  rank and not the scientific name.
#'  \item TAXON_MATCH_NONE Matching to the taxonomic backbone cannot be done cause there was no
#'  match at all or several matches with too little information to keep them apart (homonyms).
#'  \item TYPE_STATUS_INVALID The given type status is impossible to interpret or seriously
#'  different from the recommended vocabulary.
#'  \item ZERO_COORDINATE Coordinate is the exact 0/0 coordinate, often indicating a bad null
#'  coordinate.
#' }
#' 
#' \bold{Counts:} There is a slight difference in the way records are counted here vs. 
#' results from \code{\link{occ_count}}. For equivalent outcomes, in this function 
#' use \code{hasCoordinate=TRUE}, and \code{hasGeospatialIssue=FALSE} to have the 
#' same outcome using \code{\link{occ_count}} with \code{isGeoreferenced=TRUE}.
#' 
#' @references \url{http://www.gbif.org/developer/occurrence#search}
