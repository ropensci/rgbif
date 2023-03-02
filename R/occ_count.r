#' Get number of occurrence records.
#' @export
#' 
#' @param ... parameters passed to `occ_search()`.
#' @param curlopts (list) curl options. 
#'
#' @details
#' `occ_count()` is a short convenience wrapper for 
#' `occ_search(limit=0,occurrenceStatus=NULL)$meta$count`. 
#' 
#' The current version of `occ_count()` uses a different GBIF API endpoint than 
#' than previous versions. This change greatly improves the usability of 
#' `occ_count()`. Legacy parameters `georeferenced`, `type`, `date`, `to`, 
#' `from` are no longer supported and not guaranteed to work correctly. See  
#' `occ_counts_country`, `occ_counts_pub_country()`, `occ_counts_year()`, 
#' `occ_counts_year`, and  `occ_counts_basis_of_record()` for replacements of 
#' counts available via the `type` parameter. 
#'  
#'  Certain `occ_search()` parameters, such as `facet`, will be ignored since
#'  they do not make sense in the context of a total count. Multiple values of
#'  the type `c("a","b")` will give an error, but `"a;b"` will work. 
#'  
#' @return
#' The occurrence count of the `occ_search()` query. 
#'
#' @examples \dontrun{
#' # total occurrences mediated by GBIF
#' occ_count() # should be > 2 billion! 
#' 
#' # number of plant occurrences
#' occ_count(kingdomKey=name_backbone("Plantea")$usageKey) 
#' occ_count(scientificName = 'Ursus americanus')
#' 
#' 
#' occ_count(country="DK") # found in Denmark 
#' occ_count(country="DK;US") # found in Denmark and United States
#' occ_count(publishingCountry="US") # published by the United States
#' # number of repatriated eBird records in India
#' occ_count(repatriated = TRUE,country="IN") 
#'  
#' occ_count(taxonKey=212) # number of bird occurrences
#' # between years 1800-1900
#' occ_count(basisOfRecord="PRESERVED_SPECIMEN", year="1800,1900") 
#' occ_count(recordedBy="John Waller") # recorded by John Waller
#' occ_count(decimalLatitude=0, decimalLongitude=0) # exactly on 0,0
#' 
#' # close to a known iso2 centroid
#' occ_count(distanceFromCentroidInMeters="0,2000") 
#' # close to a known iso2 centroid in Sweden
#' occ_count(distanceFromCentroidInMeters="0,2000",country="SE") 
#' 
#' occ_count(hasCoordinate=TRUE) # with coordinates
#' occ_count(protocol = "DIGIR") # published using DIGIR format
#' occ_count(mediaType = 'StillImage') # with images
#'
#' # number of occurrences iucn status "critically endangered"
#' occ_count(iucnRedListCategory="CR") 
#' occ_count(verbatimScientificName="Calopteryx splendens;Calopteryx virgo")
#' occ_count(
#' geometry="POLYGON((24.70938 48.9221,24.71056 48.92175,24.71107
#'  48.92296,24.71002 48.92318,24.70938 48.9221))")
#' 
#' }
occ_count <- function(..., curlopts = list()) {

  x <- list(...)
  arg_names <- names(x)

  # check for multiple values 
  if(any(!sapply(x,length) == 1)) stop("Multiple values of the form c('a','b') are not supported. Use 'a;b' instead.")
  
  # handle legacy parameters 
  if("georeferenced" %in% arg_names) {
    .Deprecated(msg="arg 'georeferenced' is deprecated since rgbif 3.7.6, use 'hasCoordinate' and 'hasGeospatialIssue' instead.")
    if(x$georeferenced) {
      x$hasCoordinate <- TRUE
      x$hasGeospatialIssue <- FALSE
    } 
    if(is.null(x$georeferenced)) {
      x$hasCoordinate <- NULL
      x$hasGeospatialIssue <- NULL
    } else {
      x$hasCoordinate <- FALSE
      x$hasGeospatialIssue <- FALSE
    }
  }
  if("date" %in% arg_names) {
    .Deprecated(msg="arg 'date' is deprecated since rgbif 3.7.6")
    x$eventDate = x$date
  }
  if(any(c("to","from") %in% arg_names)) {
    .Deprecated(msg="args 'to' and 'from' are deprecated since rgbif 3.7.6, use 'year' instead.")
    x$year <- paste(x$from,x$to,sep=",")
  }
  if("type" %in% arg_names) {
    .Deprecated(msg="arg 'type' is deprecated since rgbif 3.7.6, use 'occ_counts_*' functions instead.")
  }
  
 count <- occ_search(
             taxonKey = x$taxonKey,
             scientificName = x$scientificName,
             country = x$country,
             publishingCountry = x$publishingCountry, 
             hasCoordinate = x$hasCoordinate, 
             typeStatus = x$typeStatus,
             recordNumber = x$recordNumber,
             lastInterpreted = x$lastInterpreted,
             continent = x$continent,
             geometry = x$geometry,
             geom_big="asis",
             geom_size=40,
             geom_n=10,
             recordedBy = x$recordedBy,
             recordedByID = x$recordedByID,
             identifiedByID = x$identifiedByID,
             basisOfRecord = x$basisOfRecord,
             datasetKey = x$datasetKey,
             eventDate = x$eventDate,
             catalogNumber = x$catalogNumber,
             year = x$year,
             month = x$month,
             decimalLatitude = x$decimalLatitude,
             decimalLongitude = x$decimalLongitude,
             elevation = x$elevation,
             depth = x$depth,
             institutionCode = x$institutionCode,
             collectionCode = x$collectionCode,
             hasGeospatialIssue = x$hasGeospatialIssue,
             issue = x$issue,
             search = x$search,
             mediaType = x$mediaType,
             subgenusKey = x$subgenusKey,
             repatriated = x$repatriated,
             phylumKey = x$phylumKey,
             kingdomKey = x$kingdomKey,
             classKey = x$classKey,
             orderKey = x$orderKey,
             familyKey = x$familyKey,
             genusKey = x$genusKey,
             speciesKey = x$speciesKey,
             establishmentMeans = x$establishmentMeans,
             degreeOfEstablishment = x$degreeOfEstablishment,
             protocol = x$protocol,
             license = x$license,
             organismId = x$organismId,
             publishingOrg = x$publishingOrg,
             stateProvince = x$stateProvince,
             waterBody = x$waterBody,
             locality = x$locality,
             occurrenceStatus = x$occurrenceStatus,
             gadmGid = x$gadmGid,
             coordinateUncertaintyInMeters = x$coordinateUncertaintyInMeters,
             verbatimScientificName = x$verbatimScientificName,
             eventId = x$identifiedBy,
             identifiedBy = x$identifiedBy,
             networkKey = x$networkKey,
             verbatimTaxonId = x$verbatimTaxonId,
             occurrenceId = x$occurrenceId,
             organismQuantity = x$organismQuantity,
             organismQuantityType = x$organismQuantityType,
             relativeOrganismQuantity = x$relativeOrganismQuantity,
             iucnRedListCategory = x$iucnRedListCategory,
             lifeStage = x$lifeStage,
             isInCluster = x$isInCluster,
             distanceFromCentroidInMeters = x$distanceFromCentroidInMeters,
             limit=0,
             start=0,
             fields = 'all',
             return=NULL,
             facet = NULL,
             facetMincount = NULL,
             facetMultiselect = NULL,
             skip_validate = TRUE,
             curlopts = curlopts)$meta$count
    
  as.numeric(count)
}


