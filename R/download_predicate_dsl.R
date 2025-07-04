#' Download predicate DSL (domain specific language)
#'
#' @name download_predicate_dsl
#' @param key (character) the key for the predicate. See "Keys" below
#' @param value (various) the value for the predicate
#' @param ...,.list For `pred_or()` or `pred_and()`, one or more objects of
#' class `occ_predicate`, created by any `pred*` function
#' @section predicate methods and their equivalent types:
#'
#' `pred*` functions are named for the 'type' of operation they do, following
#' the terminology used by GBIF, see
#' https://www.gbif.org/developer/occurrence#predicates
#'
#' Function names are given, with the equivalent GBIF type value (e.g.,
#' `pred_gt` and `greaterThan`)
#'
#' The following functions take one key and one value:
#' - `pred`: equals
#' - `pred_lt`: lessThan
#' - `pred_lte`: lessThanOrEquals
#' - `pred_gt`: greaterThan
#' - `pred_gte`: greaterThanOrEquals
#' - `pred_like`: like
#'
#' The following function is only for geospatial queries, and only
#' accepts a WKT string:
#' - `pred_within`: within
#'
#' The following function is only for stating the you don't want
#' a key to be null, so only accepts one key:
#' - `pred_notnull`: isNotNull
#'
#' The following function is only for stating that you want a key to be null.
#' - `pred_isnull` : isNull
#' 
#' The following two functions accept multiple individual predicates,
#' separating them by either "and" or "or":
#' - `pred_and`: and
#' - `pred_or`: or
#' 
#' The not predicate accepts one predicate; that is, this negates whatever
#' predicate is passed in, e.g., not the taxonKey of 12345:
#' - `pred_not`: not
#'
#' The following function is special in that it accepts a single key
#' but many values; stating that you want to search for all the values:
#' - `pred_in`: in
#'
#' The following function will apply commonly used **defaults**. 
#' - `pred_default`
#'   
#' Using `pred_default()` is equivalent to running: 
#'
#'```
#'   pred_and(
#'    pred("HAS_GEOSPATIAL_ISSUE",FALSE),
#'    pred("HAS_COORDINATE",TRUE),
#'    pred("OCCURRENCE_STATUS","PRESENT"),
#'    pred_not(pred_in("BASIS_OF_RECORD",
#'     c("FOSSIL_SPECIMEN","LIVING_SPECIMEN")))
#'   )
#'```
#' 
#' @section What happens internally:
#' Internally, the input to `pred*` functions turns into JSON to be sent to
#' GBIF. For example ...
#' 
#' `pred_in("taxonKey", c(2480946, 5229208))` gives:
#'
#' ```
#' {
#'    "type": "in",
#'    "key": "TAXON_KEY",
#'    "values": ["2480946", "5229208"]
#'  }
#' ```
#' 
#' `pred_gt("elevation", 5000)` gives:
#' 
#' ```
#' {
#'    "type": "greaterThan",
#'    "key": "ELEVATION",
#'    "value": "5000"
#' }
#' ```
#' 
#' `pred_or(pred("taxonKey", 2977832), pred("taxonKey", 2977901))` gives:
#' 
#' ```
#' {
#'   "type": "or",
#'   "predicates": [
#'      {
#'        "type": "equals",
#'        "key": "TAXON_KEY",
#'        "value": "2977832"
#'      },
#'      {
#'        "type": "equals",
#'        "key": "TAXON_KEY",
#'        "value": "2977901"
#'      }
#'   ]
#' }
#' ```
#'
#' @section Keys:
#'
#' Acceptable arguments to the `key` parameter are (with the version of
#' the key in parens that must be sent if you pass the query via the `body`
#' parameter; see below for examples). You can also use the 'ALL_CAPS' version
#' of a key if you prefer. Open an issue in the GitHub
#' repository for this package if you know of a key that should
#' be supported that is not yet.
#'
#' - taxonKey (TAXON_KEY)
#' - acceptedTaxonKey (ACCEPTED_TAXON_KEY)
#' - kingdomKey (KINGDOM_KEY)
#' - phylumKey (PHYLUM_KEY)
#' - classKey (CLASS_KEY)
#' - orderKey (ORDER_KEY)
#' - familyKey (FAMILY_KEY)
#' - genusKey (GENUS_KEY)
#' - subgenusKey (SUBGENUS_KEY)
#' - speciesKey (SPECIES_KEY)
#' - scientificName (SCIENTIFIC_NAME)
#' - country (COUNTRY)
#' - publishingCountry (PUBLISHING_COUNTRY)
#' - hasCoordinate (HAS_COORDINATE)
#' - hasGeospatialIssue (HAS_GEOSPATIAL_ISSUE)
#' - typeStatus (TYPE_STATUS)
#' - recordNumber (RECORD_NUMBER)
#' - lastInterpreted (LAST_INTERPRETED)
#' - modified (MODIFIED)
#' - continent (CONTINENT)
#' - geometry (GEOMETRY)
#' - basisOfRecord (BASIS_OF_RECORD)
#' - datasetKey (DATASET_KEY)
#' - datasetID/datasetId (DATASET_ID)
#' - eventDate (EVENT_DATE)
#' - catalogNumber (CATALOG_NUMBER)
#' - otherCatalogNumbers (OTHER_CATALOG_NUMBERS)
#' - year (YEAR)
#' - month (MONTH)
#' - decimalLatitude (DECIMAL_LATITUDE)
#' - decimalLongitude (DECIMAL_LONGITUDE)
#' - elevation (ELEVATION)
#' - depth (DEPTH)
#' - institutionCode (INSTITUTION_CODE)
#' - collectionCode (COLLECTION_CODE)
#' - issue (ISSUE)
#' - mediatype (MEDIA_TYPE)
#' - recordedBy (RECORDED_BY)
#' - recordedById/recordedByID (RECORDED_BY_ID)
#' - establishmentMeans (ESTABLISHMENT_MEANS)
#' - coordinateUncertaintyInMeters (COORDINATE_UNCERTAINTY_IN_METERS)
#' - gadm (GADM_GID) (for the Database of Global Administrative Areas)
#' - level0Gid (GADM_LEVEL_0_GID)
#' - level1Gid (GADM_LEVEL_1_GID)
#' - level2Gid (GADM_LEVEL_2_GID)
#' - level3Gid (GADM_LEVEL_3_GID)
#' - stateProvince (STATE_PROVINCE)
#' - occurrenceStatus (OCCURRENCE_STATUS)
#' - publishingOrg (PUBLISHING_ORG)
#' - occurrenceId/occurrenceID (OCCURRENCE_ID)
#' - eventId/eventID (EVENT_ID)
#' - parentEventId/parentEventID (PARENT_EVENT_ID)
#' - identifiedBy (IDENTIFIED_BY)
#' - identifiedById/identifiedByID (IDENTIFIED_BY_ID)
#' - license (LICENSE)
#' - locality(LOCALITY)
#' - pathway (PATHWAY)
#' - preparations (PREPARATIONS)
#' - networkKey (NETWORK_KEY)
#' - organismId/organismID (ORGANISM_ID)
#' - organismQuantity (ORGANISM_QUANTITY)
#' - organismQuantityType (ORGANISM_QUANTITY_TYPE)
#' - protocol (PROTOCOL)
#' - relativeOrganismQuantity (RELATIVE_ORGANISM_QUANTITY)
#' - repatriated (REPATRIATED)
#' - sampleSizeUnit (SAMPLE_SIZE_UNIT)
#' - sampleSizeValue (SAMPLE_SIZE_VALUE)
#' - samplingProtocol (SAMPLING_PROTOCOL)
#' - verbatimScientificName (VERBATIM_SCIENTIFIC_NAME)
#' - taxonID/taxonId (TAXON_ID)
#' - taxonomicStatus (TAXONOMIC_STATUS)
#' - waterBody (WATER_BODY)
#' - iucnRedListCategory (IUCN_RED_LIST_CATEGORY)
#' - degreeOfEstablishment (DEGREE_OF_ESTABLISHMENT)
#' - isInCluster (IS_IN_CLUSTER)
#' - lifeStage (LIFE_STAGE)
#' - distanceFromCentroidInMeters (DISTANCE_FROM_CENTROID_IN_METERS)
#' - gbifId (GBIF_ID)
#' - institutionKey (INSTITUTION_KEY)
#' 
#' @references Download predicates docs:
#' <https://www.gbif.org/developer/occurrence#predicates>
#' @family downloads
#' @examples
#' pred("taxonKey", 3119195)
#' pred_gt("elevation", 5000)
#' pred_gte("elevation", 5000)
#' pred_lt("elevation", 1000)
#' pred_lte("elevation", 1000)
#' pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))")
#' pred_and(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
#'   pred_gte("elevation", 5000))
#' pred_or(pred_lte("year", 1989), pred("year", 2000))
#' pred_and(pred_lte("year", 1989), pred("year", 2000))
#' pred_in("taxonKey", c(2977832, 2977901, 2977966, 2977835))
#' pred_in("basisOfRecord", c("MACHINE_OBSERVATION", "HUMAN_OBSERVATION"))
#' pred_not(pred("taxonKey", 729))
#' pred_like("catalogNumber", "PAPS5-560%")
#' pred_notnull("issue")
#' pred("basisOfRecord", "LITERATURE")
#' pred("hasCoordinate", TRUE)
#' pred("stateProvince", "California")
#' pred("hasGeospatialIssue", FALSE)
#' pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))")
#' pred_or(pred("taxonKey", 2977832), pred("taxonKey", 2977901),
#'   pred("taxonKey", 2977966))
#' pred_in("taxonKey", c(2977832, 2977901, 2977966, 2977835))

#' @rdname download_predicate_dsl
#' @export
pred <- function(key, value) pred_factory("=")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_gt <- function(key, value) pred_factory(">")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_gte <- function(key, value) pred_factory(">=")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_lt <- function(key, value) pred_factory("<")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_lte <- function(key, value) pred_factory("<=")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_not <- function(...) {
  pp <- list(...)
  if (length(pp) == 0 || length(pp) > 1) 
    stop("Supply one predicate to `not`, no more, no less",
      call. = FALSE)
  if (!all(vapply(pp, class, "") == "occ_predicate"))
    stop("1 or more inputs is not of class 'occ_predicate'; see docs")
  structure(pp, class = "occ_predicate_list", type = unbox("not"))
}
#' @rdname download_predicate_dsl
#' @export
pred_like <- function(key, value) pred_factory("like")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_within <- function(value) pred_factory("within")(key = "geometry", value)
#' @rdname download_predicate_dsl
#' @export
pred_isnull <- function(key) pred_factory("isNull")(key, "foo")
#' @rdname download_predicate_dsl
#' @export
pred_notnull <- function(key) pred_factory("isNotNull")(key, "foo")
#' @rdname download_predicate_dsl
#' @export
pred_or <- function(..., .list = list()) preds_factory("or")(.list, ...)
#' @rdname download_predicate_dsl
#' @export
pred_and <- function(..., .list = list()) preds_factory("and")(.list, ...)
#' @rdname download_predicate_dsl
#' @export
pred_in <- function(key, value) pred_multi_factory("in")(key, value)
#' @rdname download_predicate_dsl
#' @export
pred_default <- function() {
  pred_and(
  pred("HAS_GEOSPATIAL_ISSUE",FALSE),
  pred("HAS_COORDINATE",TRUE),
  pred("OCCURRENCE_STATUS","PRESENT"), 
  pred_not(pred_in("BASIS_OF_RECORD",c("FOSSIL_SPECIMEN","LIVING_SPECIMEN")))
  )
}

#' @export
print.occ_predicate <- function(x, ...) {
  cat("<<gbif download - predicate>>", sep = "\n")
  cat("  ", pred_cat(x), "\n", sep = "")
}
#' @export
print.occ_predicate_list <- function(x, ...) {
  cat("<<gbif download - predicate list>>", sep = "\n")
  cat(paste0("  type: ", attr(x, "type")), sep = "\n")
  for (i in x) {
   if (attr(i, "type") %||% "" == "not") {
     cat("  > type: not", "\n", sep = "")
     cat("    ", pred_cat(i[[1]]), "\n", sep = "")
    } else {
     cat("  ", pred_cat(i), "\n", sep = "")
    }
  }
}


# helpers
pred_factory <- function(type) {
  function(key, value) {
    if (!length(key) == 1) stop("'key' must be length 1", call. = FALSE)
    if (!length(value) == 1) stop("'value' must be length 1", call. = FALSE)
    z <- parse_pred(key, value, type)
    structure(z, class = "occ_predicate")
  }
}
pred_multi_factory <- function(type) {
  function(key, value) {
    if (!length(key) == 1) stop("'key' must be length 1", call. = FALSE)
    if (!type %in% c("or", "in"))
      stop("'type' must be one of: or, in", call. = FALSE)
    z <- parse_pred(key, value, type)
    structure(z, class = "occ_predicate")
  }
}
preds_factory <- function(type) {
  function(.list = list(), ...) {
    pp <- list(...)
    if (length(pp) == 0) pp <- NULL
    pp <- c(pp, .list)
    if (!type %in% c("or", "in", "and"))
      stop("'type' must be one of: or, in", call. = FALSE)
    if (length(pp) == 0) stop("nothing passed`", call. = FALSE)
    if (!length(pp) > 1) {
      stop("must pass more than 1 predicate to pred_or/pred_and")
    }
    if (!all(vapply(pp, class, "") %in% c("occ_predicate", "occ_predicate_list")))
      stop("1 or more inputs is not of class 'occ_predicate'; see docs")
    structure(pp, class = "occ_predicate_list", type = unbox(type))
  }
}

operators_regex <- c("=", "\\&", "and", "<", "<=", ">", ">=", "not", "in",
                     "within", "like", "\\|", "or", "isNotNull","isNull")
operator_lkup <- list(`=` = 'equals', `&` = 'and', 'and' = 'and',
                      `<` = 'lessThan', `<=` = 'lessThanOrEquals',
                      `>` = 'greaterThan', `>=` = 'greaterThanOrEquals',
                      `not` = 'not', 'in' = 'in', 'within' = 'within',
                      'like' = 'like', `|` = 'or', "or" = "or",
                      "isNotNull" = "isNotNull","isNull" = "isNull")
key_lkup <- list(
  taxonKey='TAXON_KEY',
  TAXON_KEY='TAXON_KEY',
  acceptedTaxonKey='ACCEPTED_TAXON_KEY',
  ACCEPTED_TAXON_KEY='ACCEPTED_TAXON_KEY',
  kingdomKey='KINGDOM_KEY',
  KINGDOM_KEY='KINGDOM_KEY',
  phylumKey='PHYLUM_KEY',
  PHYLUM_KEY='PHYLUM_KEY',
  classKey='CLASS_KEY',
  CLASS_KEY='CLASS_KEY',
  orderKey='ORDER_KEY',
  ORDER_KEY='ORDER_KEY',
  familyKey='FAMILY_KEY',
  FAMILY_KEY='FAMILY_KEY',
  genusKey='GENUS_KEY',
  GENUS_KEY='GENUS_KEY',
  subgenusKey='SUBGENUS_KEY',
  SUBGENUS_KEY='SUBGENUS_KEY',
  speciesKey='SPECIES_KEY',
  SPECIES_KEY='SPECIES_KEY',
  scientificName='SCIENTIFIC_NAME',
  SCIENTIFIC_NAME='SCIENTIFIC_NAME',
  country='COUNTRY',
  COUNTRY='COUNTRY',
  publishingCountry='PUBLISHING_COUNTRY',
  PUBLISHING_COUNTRY='PUBLISHING_COUNTRY',
  hasCoordinate='HAS_COORDINATE', 
  HAS_COORDINATE='HAS_COORDINATE', 
  hasGeospatialIssue='HAS_GEOSPATIAL_ISSUE',
  HAS_GEOSPATIAL_ISSUE='HAS_GEOSPATIAL_ISSUE',
  typeStatus='TYPE_STATUS', 
  TYPE_STATUS='TYPE_STATUS', 
  recordNumber='RECORD_NUMBER',
  RECORD_NUMBER='RECORD_NUMBER',
  lastInterpreted='LAST_INTERPRETED', 
  LAST_INTERPRETED='LAST_INTERPRETED', 
  continent='CONTINENT',
  CONTINENT='CONTINENT',
  geometry='GEOMETRY',
  GEOMETRY='GEOMETRY',
  basisOfRecord='BASIS_OF_RECORD', 
  BASIS_OF_RECORD='BASIS_OF_RECORD', 
  datasetKey='DATASET_KEY',
  DATASET_KEY='DATASET_KEY',
  datasetID='DATASET_ID',
  datasetId='DATASET_ID',
  DATASET_ID='DATASET_ID',
  eventDate='EVENT_DATE', 
  EVENT_DATE='EVENT_DATE', 
  catalogNumber='CATALOG_NUMBER', 
  CATALOG_NUMBER='CATALOG_NUMBER', 
  otherCatalogNumbers='OTHER_CATALOG_NUMBERS',
  OTHER_CATALOG_NUMBERS='OTHER_CATALOG_NUMBERS',
  year='YEAR',
  YEAR='YEAR',
  month='MONTH', 
  MONTH='MONTH', 
  decimalLatitude='DECIMAL_LATITUDE',
  DECIMAL_LATITUDE='DECIMAL_LATITUDE',
  decimalLongitude='DECIMAL_LONGITUDE', 
  DECIMAL_LONGITUDE='DECIMAL_LONGITUDE', 
  elevation='ELEVATION', 
  ELEVATION='ELEVATION', 
  depth='DEPTH',
  DEPTH='DEPTH',
  institutionCode='INSTITUTION_CODE', 
  INSTITUTION_CODE='INSTITUTION_CODE', 
  collectionCode='COLLECTION_CODE',
  COLLECTION_CODE='COLLECTION_CODE',
  issue='ISSUE', 
  ISSUE='ISSUE', 
  mediatype='MEDIA_TYPE', 
  MEDIA_TYPE='MEDIA_TYPE', 
  recordedBy='RECORDED_BY',
  RECORDED_BY='RECORDED_BY',
  recordedById="RECORDED_BY_ID",
  recordedByID="RECORDED_BY_ID",
  RECORDED_BY_ID="RECORDED_BY_ID",
  establishmentMeans='ESTABLISHMENT_MEANS',
  ESTABLISHMENT_MEANS='ESTABLISHMENT_MEANS',
  coordinateUncertaintyInMeters='COORDINATE_UNCERTAINTY_IN_METERS',
  COORDINATE_UNCERTAINTY_IN_METERS='COORDINATE_UNCERTAINTY_IN_METERS',
  gadm='GADM_GID', 
  GADM_GID='GADM_GID', 
  level0Gid='GADM_LEVEL_0_GID',
  GADM_LEVEL_0_GID='GADM_LEVEL_0_GID',
  level1Gid='GADM_LEVEL_1_GID',
  GADM_LEVEL_1_GID='GADM_LEVEL_1_GID',
  level2Gid='GADM_LEVEL_2_GID',
  GADM_LEVEL_2_GID='GADM_LEVEL_2_GID',
  level3Gid='GADM_LEVEL_3_GID',
  GADM_LEVEL_3_GID='GADM_LEVEL_3_GID',
  stateProvince='STATE_PROVINCE',
  STATE_PROVINCE='STATE_PROVINCE',
  occurrenceStatus='OCCURRENCE_STATUS',
  OCCURRENCE_STATUS='OCCURRENCE_STATUS',
  publishingOrg='PUBLISHING_ORG',
  PUBLISHING_ORG='PUBLISHING_ORG',
  occurrenceID = 'OCCURRENCE_ID',
  occurrenceId = 'OCCURRENCE_ID',
  OCCURRENCE_ID = 'OCCURRENCE_ID',
  eventID="EVENT_ID",
  eventId="EVENT_ID",
  EVENT_ID="EVENT_ID",
  parentEventID='PARENT_EVENT_ID',
  parentEventId='PARENT_EVENT_ID',
  PARENT_EVENT_ID='PARENT_EVENT_ID',
  identifiedBy="IDENTIFIED_BY",
  IDENTIFIED_BY="IDENTIFIED_BY",
  identifiedById="IDENTIFIED_BY_ID",
  identifiedByID="IDENTIFIED_BY_ID",
  IDENTIFIED_BY_ID="IDENTIFIED_BY_ID",
  license="LICENSE",
  LICENSE="LICENSE",
  locality="LOCALITY",
  LOCALITY="LOCALITY",
  networkKey="NETWORK_KEY",
  NETWORK_KEY="NETWORK_KEY",
  organismId="ORGANISM_ID",
  organismID="ORGANISM_ID",
  ORGANISM_ID="ORGANISM_ID",
  organismQuantity="ORGANISM_QUANTITY",
  ORGANISM_QUANTITY="ORGANISM_QUANTITY",
  organismQuantityType="ORGANISM_QUANTITY_TYPE",
  ORGANISM_QUANTITY_TYPE="ORGANISM_QUANTITY_TYPE",
  protocol="PROTOCOL",
  PROTOCOL="PROTOCOL",
  relativeOrganismQuantity="RELATIVE_ORGANISM_QUANTITY",
  RELATIVE_ORGANISM_QUANTITY="RELATIVE_ORGANISM_QUANTITY",
  repatriated="REPATRIATED",
  REPATRIATED="REPATRIATED",
  modified='MODIFIED',
  MODIFIED='MODIFIED',
  sampleSizeUnit="SAMPLE_SIZE_UNIT",
  SAMPLE_SIZE_UNIT="SAMPLE_SIZE_UNIT",
  sampleSizeValue="SAMPLE_SIZE_VALUE",
  SAMPLE_SIZE_VALUE="SAMPLE_SIZE_VALUE",
  samplingProtocol="SAMPLING_PROTOCOL",
  SAMPLING_PROTOCOL="SAMPLING_PROTOCOL",
  verbatimScientificName="VERBATIM_SCIENTIFIC_NAME",
  VERBATIM_SCIENTIFIC_NAME="VERBATIM_SCIENTIFIC_NAME",
  taxonId="TAXON_ID",
  taxonID="TAXON_ID",
  TAXON_ID="TAXON_ID",
  taxonomicStatus='TAXONOMIC_STATUS',
  TAXONOMIC_STATUS='TAXONOMIC_STATUS',
  waterBody="WATER_BODY",
  WATER_BODY="WATER_BODY",
  pathway='PATHWAY',
  PATHWAY='PATHWAY',
  preparations='PREPARATIONS',
  PREPARATIONS='PREPARATIONS',
  iucnRedListCategory="IUCN_RED_LIST_CATEGORY",
  IUCN_RED_LIST_CATEGORY="IUCN_RED_LIST_CATEGORY",
  degreeOfEstablishment="DEGREE_OF_ESTABLISHMENT",
  DEGREE_OF_ESTABLISHMENT="DEGREE_OF_ESTABLISHMENT",
  isInCluster="IS_IN_CLUSTER",
  IS_IN_CLUSTER="IS_IN_CLUSTER",
  lifeStage="LIFE_STAGE",
  LIFE_STAGE="LIFE_STAGE",
  distanceFromCentroidInMeters="DISTANCE_FROM_CENTROID_IN_METERS",
  DISTANCE_FROM_CENTROID_IN_METERS="DISTANCE_FROM_CENTROID_IN_METERS",
  datasetName = "DATASET_NAME", # rgbif/issues/589
  GBIF_ID = "GBIF_ID",
  gbifId = "GBIF_ID",
  institutionKey = "INSTITUTION_KEY",
  INSTITUTION_KEY = "INSTITUTION_KEY"
  )

parse_pred <- function(key, value, type = "and") {
  assert(key, "character")
  assert(type, "character")

  ogkey <- key
  key <- key_lkup[[key]]
  if (is.null(key))
    stop(
      sprintf("'%s' not in acceptable set of keys; see ?download_predicate_dsl",
        ogkey), call.=FALSE)

  if (!any(operators_regex %in% type))
    stop("'type' not in acceptable set of types; see param def. 'type'",
      call.=FALSE)
  type <- operator_lkup[ operators_regex %in% type ][[1]]
  if (
    (is.character(value) &&
      all(grepl("polygon|multipolygon|linestring|multilinestring|point|multipoint",
        value, ignore.case = TRUE))) ||
    type == "within"
  ) {
    list(type = unbox("within"), geometry = unbox(as_c(value)))
  } else if (type == "in") {
    list(type = unbox("in"), key = unbox(key), values = as_c(value))
  } else if (type == "or") {
    list(type = unbox("or"), predicates = lapply(value, function(w)
      list(type = unbox("equals"), key = unbox(key), value = as_c(w))))
  } else if (type == "isNotNull") {
    list(type = unbox(type), parameter = unbox(key))
  } else if (type == "isNull") {
    list(type = unbox(type), parameter = unbox(key))
  } else {
    list(type = unbox(type), key = unbox(key), value = unbox(as_c(value)))
  }
}
pred_cat <- function(x) {
  # if (is.null(names(x))) pred_cat(x[[1]])
  if ("predicates" %in% names(x)) {
    cat("type: or", sep = "\n")
    for (i in seq_along(x$predicates)) {
      z <- x$predicates[[i]]
      cat(sprintf_key_val(z, "  >"), sep = "\n")
    }
  } else if ("parameter" %in% names(x)) {
    sprintf_not_null(x, ">")
  } else {
    gg <- if ("geometry" %in% names(x)) {
      x$geometry
    } else {
      zz <- x$value %||% x$values
      if (!is.null(zz)) paste(zz, collapse = ",") else zz
    }
    sprintf_key_val(
      list(
        type = x$type,
        key = if ("geometry" %in% names(x)) "geometry" else x$key,
        value = sub_str(gg, 60)
      ),
      ">"
    )

  }
}
sub_str <- function(str, max = 100) {
  if (!nzchar(str)) return(str)
  if (nchar(str) < max) return(str)
  paste0(substring(str, 1, max), " ... ", sprintf("(N chars: %s)", nchar(str)))
}
parse_predicates <- function(user, email, type, format, ...) {
  tmp <- list(...)
  if(length(tmp) == 0) { 
    stop("You are requesting a full download. Please use a predicate to filter the data. For example, pred_default().")
  }  
clzzs <- vapply(tmp,
    function(z) inherits(z, c("occ_predicate", "occ_predicate_list")),
    logical(1)
  )
  if (!all(clzzs))
    stop("all inputs must be class occ_predicate/occ_predicate_list; ?occ_download",
      call. = FALSE)
  payload <- list(
    creator = unbox(user),
    notification_address = email,
    format = unbox(format),
    predicate = list()
  )
  if (any(vapply(tmp, function(w) "predicates" %in% names(w), logical(1)))) {
    payload$predicate <- list(unclass(tmp[[1]]))
  } else {
    payload$predicate <- list(
      type = unbox(type),
      predicates = lapply(tmp, function(w) {
        if (inherits(w, "occ_predicate")) {
          unclass(w)
        } else {
          lst <- list(type = attr(w, "type"))
          if (attr(w, "type") == "not") lst$predicate <- unclass(w[[1]])
          if (!attr(w, "type") == "not") lst$predicates <- lapply(w, function(m) {
            if (!is.null(attr(m, "type"))) {
              if (attr(m, "type") == "not") {
                list(type = unbox("not"), predicate = unclass(m[[1]]))
              } else {
                unclass(m)
              }
            } else {
              unclass(m)
            }
          })
          lst
        }
      })
    )
    if (length(payload$predicate$predicates) == 1) {
      payload$predicate <- payload$predicate$predicates[[1]]
    }
  }
  return(payload)
}
as_c <- function(x) {
  z <- if (inherits(x, "logical")) tolower(x) else x
  return(as.character(z))
}
