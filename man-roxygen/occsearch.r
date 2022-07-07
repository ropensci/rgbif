#' @param taxonKey (numeric) A taxon key from the GBIF backbone. All included and synonym taxa
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
#' @param recordedBy The person who recorded the occurrence.
#' @param recordedByID (character) Identifier (e.g. ORCID) for the person who
#' recorded the occurrence
#' @param identifiedByID (character) Identifier (e.g. ORCID) for the person who
#' provided the taxonomic identification of the occurrence.
#' @param collectionCode An identifier of any form assigned by the source to identify
#'    the physical collection or digital dataset uniquely within the text of an institution.
#' @param institutionCode An identifier of any form assigned by the source to identify
#'    the institution the record belongs to. Not guaranteed to be que.
#' @param country The 2-letter country code (as per ISO-3166-1) of the country in
#'    which the occurrence was recorded. See here
#'    https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
#' @param basisOfRecord (character) Basis of record. he specific nature of the 
#' data record.
#'    
#'    \itemize{
#'      \item "FOSSIL_SPECIMEN" An occurrence record describing a fossilized specimen.
#'      \item "HUMAN_OBSERVATION" An occurrence record describing an observation made by
#'      one or more people.
#'      \item "MATERIAL_CITATION" A reference to or citation of one, a part of, or 
#'      multiple specimens in scholarly publications.
#'      \item "MATERIAL_SAMPLE" An occurrence record based on samples taken from 
#'      other specimens or the environment.
#'      \item "LIVING_SPECIMEN" An occurrence record describing a living specimen, e.g.
#'      \item "MACHINE_OBSERVATION" An occurrence record describing an observation made
#'      by a machine.
#'      \item "OBSERVATION" An occurrence record describing an observation.
#'      \item "PRESERVED_SPECIMEN" An occurrence record describing a preserved specimen.
#'      \item "OCCURRENCE" An existence of an Organism 
#'      at a particular place at a particular time.
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
#'    POLYGON, or MULTIPOLYGON. Example of a polygon: POLYGON((30.1 10.1, 20, 20 40, 40 40, 30.1 10.1))
#'    would be queried as http://bit.ly/1BzNwDq See also the section **WKT** below.
#' @param geom_big (character) One of "axe", "bbox", or "asis" (default). See Details.
#' @param geom_size (integer) An integer indicating size of the cell. Default: 40. See Details.
#' @param geom_n (integer) An integer indicating number of cells in each dimension. Default: 10.
#' See Details.
#' @param hasGeospatialIssue (logical) Includes/excludes occurrence records which contain spatial
#'    issues (as determined in our record interpretation), i.e. \code{hasGeospatialIssue=TRUE}
#'    returns only those records with spatial issues while \code{hasGeospatialIssue=FALSE} includes
#'    only records without spatial issues. The absence of this parameter returns any
#'    record with or without spatial issues.
#' @param issue (character) One or more of many possible issues with each occurrence record. See
#'    Details. Issues passed to this parameter filter results by the issue.
#' @param hasCoordinate (logical) Return only occurence records with lat/long data (\code{TRUE}) or
#'    all records (\code{FALSE}, default).
#' @param typeStatus Type status of the specimen. One of many options. See \code{?typestatus}
#' @param recordNumber Number recorded by collector of the data, different from GBIF record
#'    number. See http://rs.tdwg.org/dwc/terms/#recordNumber for more info
#' @param lastInterpreted Date the record was last modified in GBIF, in ISO 8601 format:
#'    yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd.  Supports range queries, smaller,larger (e.g.,
#'    '1990,1991', whereas '1991,1990' wouldn't work)
#' @param continent Continent. One of africa, antarctica, asia, europe, north_america
#'    (North America includes the Caribbean and reachies down and includes Panama), oceania,
#'    or south_america
#' @param mediaType Media type. Default is NULL, so no filtering on mediatype. Options:
#'    NULL, 'MovingImage', 'Sound', and 'StillImage'.
#' @param repatriated (character) Searches for records whose publishing country
#' is different to the country where the record was recorded in.
#' @param kingdomKey (numeric) Kingdom classification key.
#' @param phylumKey (numeric) Phylum classification key.
#' @param classKey (numeric) Class classification key.
#' @param orderKey (numeric) Order classification key.
#' @param familyKey (numeric) Family classification key.
#' @param genusKey (numeric) Genus classification key.
#' @param speciesKey (numeric) Species classification key.
#' @param subgenusKey (numeric) Subgenus classification key.
#' @param establishmentMeans (character) provides information about whether an
#'  organism or organisms have been introduced to a given place and time through 
#'  the direct or indirect activity of modern humans.
#' 
#' Some acceptable values for establishmentMeans:
#' 
#' \itemize{
#'  \item "Introduced"
#'  \item "Native"
#'  \item "NativeReintroduced"
#'  \item "Vagrant"
#'  \item "Uncertain"
#'  \item "IntroducedAssistedColonisation"
#'  }
#' @param degreeOfEstablishment (character) Provides information about degree to 
#' which an Organism survives, reproduces, and expands its range at the given 
#' place and time.
#' 
#' Some acceptable values for degreeOfEstablishment:
#' 
#' "Naturalized" "Colonising" "Managed" "WidespreadInvasive" "Spreading" 
#' "Captive" "Established" "Released" "Reproducing" "Native" "Failing" "Casual" 
#' "Invasive" "Cultivated" "Unestablished".
#' 
#' @param protocol (character) Protocol or mechanism used to provide the
#' occurrence record. 
#'
#' \itemize{
#'  \item "BIOCASE" A BioCASe protocl compliant service.
#'  \item "DIGIR" A DiGIR service endpoint.
#'  \item "DIGIR_MANIS" A DiGIR service slightly modified for the MANIS
#'  network.
#'  \item "DWC_ARCHIVE" A Darwin Core Archive as defined by the Darwin Core
#'  Text Guidelines.
#'  \item "EML" A single EML metadata document in any EML version.
#'  \item "FEED" Syndication feeds like RSS or ATOM of various flavors.
#'  \item "OAI_PMH" The Open Archives Initiative Protocol for Metadata
#'  Harvesting.
#'  \item "OTHER" Any other service not covered by this enum so far.
#'  \item "TAPIR" A TAPIR service.
#'  \item "TCS_RDF" Taxon Concept data given as RDF based on the TDWG ontology.
#'  \item "TCS_XML" A Taxon Concept Schema document.
#'  \item "WFS" An OGC Web Feature Service.
#'  \item "WMS" An OGC Web Map Service.
#' }
#' 
#' @param license (character) The type license applied to the dataset or record.
#' 
#'  \itemize{
#'  \item "CC0_1_0"
#'  \item "CC_BY_4_0"
#'  \item "CC_BY_NC_4_0"
#'  }
#' 
#' @param organismId (numeric) An identifier for the Organism instance (as
#' opposed to a particular digital record of the Organism). May be a globally
#' unique identifier or an identifier specific to the data set.
#' @param publishingOrg (character) The publishing organization key (a UUID).
#' @param stateProvince (character) The name of the next smaller administrative
#' region than country (state, province, canton, department, region, etc.) in
#' which the Location occurs.
#' @param waterBody (character) The name of the water body in which the
#' locations occur
#' @param locality (character) The specific description of the place.
#' @param occurrenceStatus (character)  Default is "PRESENT". Specify whether 
#' search should return "PRESENT" or "ABSENT" data.
#' @param gadmGid (character) The gadm id of the area occurrences are desired 
#' from. https://gadm.org/.
#' @param coordinateUncertaintyInMeters A number or range between 0-1,000,000 which 
#' specifies the desired coordinate uncertainty. A coordinateUncertaintyInMeters=1000 
#' will be interpreted all records with exactly 1000m. Supports range queries, 
#' smaller,larger (e.g., '1000,10000', whereas '10000,1000' wouldn't work).
#' @param verbatimScientificName (character) Scientific name as provided by the 
#' source.
#' @param eventId (character) identifier(s) for a sampling event.
#' @param identifiedBy (character)  names of people, groups, or organizations.
#' @param networkKey (character) The occurrence network key (a uuid) 
#' who assigned the Taxon to the subject.
#' @param occurrenceId (character) occurrence id from source. 
#' @param organismQuantity A number or range which 
#' specifies the desired organism quantity. An organismQuantity=5 
#' will be interpreted all records with exactly 5. Supports range queries, 
#' smaller,larger (e.g., '5,20', whereas '20,5' wouldn't work). 
#' @param organismQuantityType (character) The type of quantification system 
#' used for the quantity of organisms. For example, "individuals" or "biomass".
#' @param relativeOrganismQuantity (numeric) A relativeOrganismQuantity=0.1 will
#' be interpreted all records with exactly 0.1 The relative measurement of the 
#' quantity of the organism (a number between 0-1). Supports range queries,  
#' "smaller,larger" (e.g., '0.1,0.5', whereas '0.5,0.1' wouldn't work).
#' @param iucnRedListCategory (character) The IUCN threat status category. 
#' 
#' \itemize{
#'  \item "NE" (Not Evaluated) 
#'  \item "DD" (Data Deficient)
#'  \item "LC" (Least Concern)
#'  \item "NT" (Near Threatened)
#'  \item "VU" (Vulnerable)
#'  \item "EN" (Endangered)
#'  \item "CR" (Critically Endangered) 
#'  \item "EX" (Extinct)
#'  \item "EW" (Extinct in the Wild)
#'  }
#' @param lifeStage (character) the life stage of the occurrence. 
#' @param isInCluster (logical) identify potentially related records on GBIF.
#' 
#' some acceptable values: 
#' 
#' "Nymph" "Adult" "Embryo" 
#' "Vegetative" "Tadpole"
#' "Calyptopsis" "Juvenile" 
#' "Pupa" "Cyst" 
#' "Polyp" "Caterpillar" 
#' "Zoea" "Flowering" 
#' "Egg" "Veliger" "Fruiting" "Nestling" 
#' "Fledgling" "Larva" 
#' "Nauplius" "Medusa" "Furcilia" "Neonate" "Unknown" 
#' "Metanauplius" "Megalopa" 
#' "Mature" "Deutonymph" 
#' "Eft" "Zygote" 
#' "Seedling" "Chick" 
#' "Imago" "Gametophyte" 
#' "Hatchling" "Fetus" 
#' "Immature" "Subadult" 
#' "Cyprid".
#' @param skip_validate (logical) whether to skip `wellknown::validate_wkt`
#' call or not. passed down to [check_wkt()]. Default: `TRUE`
#'
#'
#' @section Multiple values passed to a parameter:
#' There are some parameters you can pass multiple values to in a vector,
#' each value of which produces a different request (MDR: multiple different
#' requests). Some parameters allow multiple values to be passed in the same
#' request (MSR: multiple same request) in a semicolon separated string
#' (e.g., 'a;b'); if given we'll do a single request with that parameter
#' repeated for each value given (e.g., `foo=a&foo=b` if the parameter
#' is `foo`). Some parameters allow both MDR and MSR.
#' 
#' The following list shows which parameters support MDR and MSR.
#' 
#' \itemize{
#' \item basisOfRecord: MDR, MSR
#' \item classKey: MDR, MSR
#' \item country: MDR, MSR
#' \item familyKey: MDR, MSR
#' \item genusKey: MDR, MSR
#' \item identifiedByID: MDR, MSR
#' \item kingdomKey: MDR, MSR
#' \item license: MDR, MSR
#' \item locality: MDR, MSR
#' \item catalogNumber: MDR, MSR
#' \item collectionCode: MDR, MSR
#' \item continent: MDR, MSR
#' \item datasetKey: MDR, MSR
#' \item establishmentMeans: MDR, MSR
#' \item geometry: MDR, MSR
#' \item institutionCode: MDR, MSR
#' \item mediaType: MDR, MSR
#' \item orderKey: MDR, MSR
#' \item organismId: MDR, MSR
#' \item phylumKey: MDR, MSR
#' \item protocol: MDR, MSR
#' \item publishingCountry: MDR, MSR
#' \item publishingOrg: MDR, MSR
#' \item recordedBy: MDR, MSR
#' \item recordedByID: MDR, MSR
#' \item recordNumber: MDR, MSR
#' \item scientificName: MDR, MSR
#' \item stateProvince: MDR, MSR
#' \item subgenusKey: MDR, MSR
#' \item taxonKey: MDR, MSR
#' \item typeStatus: MDR, MSR
#' \item waterBody: MDR, MSR
#' \item depth: MDR
#' \item limit: MDR
#' \item q: MDR
#' \item year: MDR
#' \item repatriated: MDR
#' \item lastInterpreted: MDR
#' \item decimalLatitude: MDR
#' \item decimalLongitude: MDR
#' }
#'
#' Note that you can not pass a vector > length 1 to more than 1 of the above
#' MDR parameters at the same time.
#'
#'
#' @section Range queries:
#' A range query is as it sounds - you query on a range of values defined by
#' a lower and upper limit. Do a range query by specifying the lower and upper
#' limit in a string like \code{depth='50,100'}. It would be more R like to
#' specify the range in a vector like \code{c(50,100)}, but that sort of syntax
#' allows you to do many searches, one for each element in the vector -
#' thus range queries have to differ. The following parameters support
#' range queries.
#' 
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
#' See also above section: semicolon and comma separated strings lead to
#' different outcomes for some parameters.
#' 
#' @section Hierarchies:
#' Hierarchies are returned wih each occurrence object. There is no
#' option no to return them from the API. However, within the \code{occ_search}
#' function you can select whether to return just hierarchies, just data, all
#' of data and hiearchies and metadata, or just metadata. If all hierarchies
#' are the same we just return one for you.
#'
#' @section curl debugging:
#' You can pass parameters not defined in this function into the call to
#' the GBIF API to control things about the call itself using \code{curlopts}.
#' See an example below that passes in the \code{verbose} function to get
#' details on the http call.
#'
#' @section Scientific names vs. taxon keys:
#' In the previous GBIF API and the version of rgbif that
#' wrapped that API, you could search the equivalent of this function with a
#' species name, which was convenient. However, names are messy right. So it
#' sorta makes sense to sort out the species key numbers you want exactly,
#' and then get your occurrence data with this function. GBIF has added a
#' parameter scientificName to allow searches by scientific names in this
#' function - which includes synonym taxa. *Note:* that if you do use the
#' scientificName parameter, we will check internally that it's not a
#' synonym of an accepted name, and if it is, we'll search on the
#' accepted name. If you want to force searching by a synonym do so by
#' finding the GBIF identifier first with any \code{name_*} functions,
#' then pass that ID to the \code{taxonKey} parameter.
#'
#' @section WKT:
#' Examples of valid WKT objects:
#' \itemize{
#'  \item 'POLYGON((-19.5 34.1, 27.8 34.1, 35.9 68.1, -25.3 68.1, -19.5 34.1))'
#'  \item 'MULTIPOLYGON(((-123 38,-116 38,-116 43,-123 43,-123 38)),((-97 41,-93 41,-93 45,-97 45,-97 41)))'
#'  \item 'POINT(-120 40)'
#'  \item 'LINESTRING(3 4,10 50,20 25)'
#'  \item 'LINEARRING' ???' - Not sure how to specify this. Anyone?
#' }
#'
#' Note that GBIF expects counter-clockwise winding order for WKT. You can
#' supply clockwise WKT, but GBIF treats it as an exclusion, so you get all
#' data not inside the WKT area. [occ_download()] behaves differently
#' in that you should simply get no data back at all with clockwise WKT.
#'
#' @section Long WKT:
#' Options for handling long WKT strings:
#' Note that long WKT strings are specially handled when using \code{\link{occ_search}} or
#' \code{\link{occ_data}}. Here are the three options for long WKT strings (> 1500 characters),
#' set one of these three via the parameter \code{geom_big}:
#' \itemize{
#'  \item asis - the default setting. This means we don't do anything internally. That is,
#'  we just pass on your WKT string just as we've done before in this package.
#'  \item axe - this option uses the \pkg{sf} package to chop up your WKT string in
#'  to many polygons, which then leads to a separate data request for each polygon piece,
#'  then we combine all dat back together to give to you. Note that if your WKT string
#'  is not of type polygon, we drop back to \code{asis}as there's no way to chop up
#'  linestrings, etc. This option will in most cases be slower than the other two options.
#'  However, this polygon splitting approach won't have the problem of
#'  the disconnect between how many records you want and what you actually get back as
#'  with the bbox option.
#'
#'  This method uses \code{sf::st_make_grid} and \code{sf::st_intersection}, which has 
#'  two parameters \code{cellsize} and \code{n}. You can tweak those parameters here by
#'  tweaking \code{geom_size} and \code{geom_n}. \code{geom_size} seems to be more useful in
#'  toggling the number of WKT strings you get back.
#'
#'  See \code{\link{wkt_parse}} to manually break make WKT bounding box from a larger WKT
#'  string, or break a larger WKT string into many smaller ones.
#'
#'  \item bbox - this option checks whether your WKT string is longer than 1500 characters,
#'  and if it is we create a bounding box from the WKT, do the GBIF search with that
#'  bounding box, then prune the resulting data to only those occurrences in your original
#'  WKT string. There is a big caveat however. Because we create a bounding box from the WKT,
#'  and the \code{limit} parameter determines some subset of records to get, then when we
#'  prune the resulting data to the WKT, the number of records you get could be less than
#'  what you set with your \code{limit} parameter. However, you could set the limit to be
#'  high enough so that you get all records back found in that bounding box, then you'll
#'  get all the records available within the WKT.
#' }
#'
#' @section issue parameter:
#' The options for the issue parameter (from
#' https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html):
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
#' @section Counts:
#' There is a slight difference in the way records are counted here vs.
#' results from \code{\link{occ_count}}. For equivalent outcomes, in this
#' function use \code{hasCoordinate=TRUE}, and \code{hasGeospatialIssue=FALSE}
#' to have the same outcome using \code{\link{occ_count}} with
#' \code{isGeoreferenced=TRUE}
#'
#' @references https://www.gbif.org/developer/occurrence#search
