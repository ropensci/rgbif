#' Get number of occurrence records.
#' @export
#' 
#' @param ... parameters passed to `occ_search()`.
#' @param occurrenceStatus (character) Default is "PRESENT". Specify whether 
#' search should return "PRESENT" or "ABSENT" data.
#' @param curlopts (list) curl options. 
#'
#' @details
#' `occ_count()` is a short convenience wrapper for 
#' `occ_search(limit=0)$meta$count`. 
#' 
#' The current version (since rgbif 3.7.6) of `occ_count()` uses a different 
#' GBIF API endpoint than than previous versions. This change greatly improves 
#' the usability of `occ_count()`. Legacy parameters `georeferenced`, `type`, 
#' `date`, `to`, `from` are no longer supported and not guaranteed to work 
#' correctly. See `occ_counts_country`, `occ_counts_pub_country()`, 
#' `occ_counts_year()`, `occ_counts_year`, and  `occ_counts_basis_of_record()` 
#' for replacements of counts available via the `type` parameter. 
#'  
#' Multiple values of the type `c("a","b")` will give an error, 
#' but `"a;b"` will work. 
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
occ_count <- function(...,occurrenceStatus="PRESENT", curlopts = list()) {

  args <- list(...)
  args <- rgbif_compact(c(args,occurrenceStatus=occurrenceStatus))
  arg_names <- names(args)
  
  # check for multiple values 
  if(any(!sapply(args,length) == 1)) stop("Multiple values of the form c('a','b') are not supported. Use 'a;b' instead.")
  
  # handle legacy parameters 
  if("georeferenced" %in% arg_names) {
    .Deprecated(msg="arg 'georeferenced' is deprecated since rgbif 3.7.6, use 'hasCoordinate' and 'hasGeospatialIssue' instead.")
    if(args$georeferenced) {
      args$hasCoordinate <- TRUE
      args$hasGeospatialIssue <- FALSE
    } 
    if(is.null(args$georeferenced)) {
      args$hasCoordinate <- NULL
      args$hasGeospatialIssue <- NULL
    } else {
      args$hasCoordinate <- FALSE
      args$hasGeospatialIssue <- FALSE
    }
  }
  if("date" %in% arg_names) {
    .Deprecated(msg="arg 'date' is deprecated since rgbif 3.7.6")
    args$eventDate <- args$date
  }
  if(any(c("to","from") %in% arg_names)) {
    .Deprecated(msg="args 'to' and 'from' are deprecated since rgbif 3.7.6, use 'year' instead.")
    args$year <- paste(args$from,args$to,sep=",")
  }
  if("type" %in% arg_names) {
    .Deprecated(msg="arg 'type' is deprecated since rgbif 3.7.6, use 'occ_counts_*' functions instead.")
  }
  
  res <- occ_search(
             taxonKey = args$taxonKey,
             scientificName = args$scientificName,
             country = args$country,
             publishingCountry = args$publishingCountry, 
             hasCoordinate = args$hasCoordinate, 
             typeStatus = args$typeStatus,
             recordNumber = args$recordNumber,
             lastInterpreted = args$lastInterpreted,
             continent = args$continent,
             geometry = args$geometry,
             geom_big="asis",
             geom_size=40,
             geom_n=10,
             recordedBy = args$recordedBy,
             recordedByID = args$recordedByID,
             identifiedByID = args$identifiedByID,
             basisOfRecord = args$basisOfRecord,
             datasetKey = args$datasetKey,
             eventDate = args$eventDate,
             catalogNumber = args$catalogNumber,
             year = args$year,
             month = args$month,
             decimalLatitude = args$decimalLatitude,
             decimalLongitude = args$decimalLongitude,
             elevation = args$elevation,
             depth = args$depth,
             institutionCode = args$institutionCode,
             collectionCode = args$collectionCode,
             hasGeospatialIssue = args$hasGeospatialIssue,
             issue = args$issue,
             search = args$search,
             mediaType = args$mediaType,
             subgenusKey = args$subgenusKey,
             repatriated = args$repatriated,
             phylumKey = args$phylumKey,
             kingdomKey = args$kingdomKey,
             classKey = args$classKey,
             orderKey = args$orderKey,
             familyKey = args$familyKey,
             genusKey = args$genusKey,
             speciesKey = args$speciesKey,
             establishmentMeans = args$establishmentMeans,
             degreeOfEstablishment = args$degreeOfEstablishment,
             protocol = args$protocol,
             license = args$license,
             organismId = args$organismId,
             publishingOrg = args$publishingOrg,
             stateProvince = args$stateProvince,
             waterBody = args$waterBody,
             locality = args$locality,
             occurrenceStatus = args$occurrenceStatus,
             gadmGid = args$gadmGid,
             coordinateUncertaintyInMeters = args$coordinateUncertaintyInMeters,
             verbatimScientificName = args$verbatimScientificName,
             eventId = args$identifiedBy,
             identifiedBy = args$identifiedBy,
             networkKey = args$networkKey,
             verbatimTaxonId = args$verbatimTaxonId,
             occurrenceId = args$occurrenceId,
             organismQuantity = args$organismQuantity,
             organismQuantityType = args$organismQuantityType,
             relativeOrganismQuantity = args$relativeOrganismQuantity,
             iucnRedListCategory = args$iucnRedListCategory,
             lifeStage = args$lifeStage,
             isInCluster = args$isInCluster,
             distanceFromCentroidInMeters = args$distanceFromCentroidInMeters,
             limit=0,
             start=0,
             fields = 'all',
             return=NULL,
             facet = args$facet,
             facetMincount = args$facetMincount,
             facetMultiselect = args$facetMultiselect,
             skip_validate = TRUE,
             curlopts = curlopts, 
             facetLimit = args$facetLimit)
 
 if("facet" %in% arg_names) {
   count <- stats::setNames(res$facet[[1]],c(args$facet,"count"))
 } else {
   count <- as.numeric(res$meta$count)
 }
 count
}


