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
#' - `pred_not`: not
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
#' The following two functions accept multiple individual predicates,
#' separating them by either "and" or "or":
#' - `pred_and`: and
#' - `pred_or`: or
#'
#' The following function is special in that it accepts a single key
#' but many values; stating that you want to search for all the values:
#' - `pred_in`: in
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
#' parameter; see below for examples):
#'
#' - taxonKey (TAXON_KEY)
#' - scientificName (SCIENTIFIC_NAME)
#' - country (COUNTRY)
#' - publishingCountry (PUBLISHING_COUNTRY)
#' - hasCoordinate (HAS_COORDINATE)
#' - hasGeospatialIssue (HAS_GEOSPATIAL_ISSUE)
#' - typeStatus (TYPE_STATUS)
#' - recordNumber (RECORD_NUMBER)
#' - lastInterpreted (LAST_INTERPRETED)
#' - continent (CONTINENT)
#' - geometry (GEOMETRY)
#' - basisOfRecord (BASIS_OF_RECORD)
#' - datasetKey (DATASET_KEY)
#' - eventDate (EVENT_DATE)
#' - catalogNumber (CATALOG_NUMBER)
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
#' pred_not("catalogNumber", "cat1")
#' pred_like("catalogNumber", "PAPS5-560%")
#' pred_notnull("issue")
#' pred("basisOfRecord", "LITERATURE")
#' pred("hasCoordinate", TRUE)
#' pred("hasGeospatialIssue", FALSE)
#' pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))")
#' pred_or(pred("taxonKey", 2977832), pred("taxonKey", 2977901),
#'   pred("taxonKey", 2977966))
#' pred_in("taxonKey", c(2977832, 2977901, 2977966, 2977835))

#' @rdname download_predicates
#' @export
pred <- function(key, value) pred_factory("=")(key, value)
#' @rdname download_predicates
#' @export
pred_gt <- function(key, value) pred_factory(">")(key, value)
#' @rdname download_predicates
#' @export
pred_gte <- function(key, value) pred_factory(">=")(key, value)
#' @rdname download_predicates
#' @export
pred_lt <- function(key, value) pred_factory("<")(key, value)
#' @rdname download_predicates
#' @export
pred_lte <- function(key, value) pred_factory("<=")(key, value)
#' @rdname download_predicates
#' @export
pred_not <- function(key, value) pred_factory("not")(key, value)
#' @rdname download_predicates
#' @export
pred_like <- function(key, value) pred_factory("like")(key, value)
#' @rdname download_predicates
#' @export
pred_within <- function(value) pred_factory("within")(key = "geometry", value)
#' @rdname download_predicates
#' @export
pred_notnull <- function(key) pred_factory("isNotNull")(key, "foo")
#' @rdname download_predicates
#' @export
pred_or <- function(..., .list = list()) preds_factory("or")(.list, ...)
#' @rdname download_predicates
#' @export
pred_and <- function(..., .list = list()) preds_factory("and")(.list, ...)
#' @rdname download_predicates
#' @export
pred_in <- function(key, value) pred_multi_factory("in")(key, value)

#' @export
print.occ_predicate <- function(x, ...) {
  cat("<<gbif download - predicate>>", sep = "\n")
  cat("  ", pred_cat(x), "\n", sep = "")
}
#' @export
print.occ_predicate_list <- function(x, ...) {
  cat("<<gbif download - predicate list>>", sep = "\n")
  cat(paste0("  type: ", attr(x, "type")), sep = "\n")
  for (i in x) cat("  ", pred_cat(i), "\n", sep = "")
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
    if (!all(vapply(pp, class, "") == "occ_predicate"))
      stop("1 or more inputs is not of class 'occ_predicate'; see docs")
    structure(pp, class = "occ_predicate_list", type = unbox(type))
  }
}

operators_regex <- c("=", "\\&", "and", "<", "<=", ">", ">=", "not", "in",
                     "within", "like", "\\|", "or", "isNotNull")
operator_lkup <- list(`=` = 'equals', `&` = 'and', 'and' = 'and',
                      `<` = 'lessThan', `<=` = 'lessThanOrEquals',
                      `>` = 'greaterThan', `>=` = 'greaterThanOrEquals',
                      `not` = 'not', 'in' = 'in', 'within' = 'within',
                      'like' = 'like', `|` = 'or', "or" = "or",
                      "isNotNull" = "isNotNull")
key_lkup <- list(taxonKey='TAXON_KEY', scientificName='SCIENTIFIC_NAME',
    country='COUNTRY', publishingCountry='PUBLISHING_COUNTRY',
    hasCoordinate='HAS_COORDINATE', hasGeospatialIssue='HAS_GEOSPATIAL_ISSUE',
    typeStatus='TYPE_STATUS', recordNumber='RECORD_NUMBER',
    lastInterpreted='LAST_INTERPRETED', continent='CONTINENT',
    geometry='GEOMETRY',
    basisOfRecord='BASIS_OF_RECORD', datasetKey='DATASET_KEY',
    eventDate='EVENT_DATE', catalogNumber='CATALOG_NUMBER', year='YEAR',
    month='MONTH', decimalLatitude='DECIMAL_LATITUDE',
    decimalLongitude='DECIMAL_LONGITUDE', elevation='ELEVATION', depth='DEPTH',
    institutionCode='INSTITUTION_CODE', collectionCode='COLLECTION_CODE',
    issue='ISSUE', mediatype='MEDIA_TYPE', recordedBy='RECORDED_BY')

parse_pred <- function(key, value, type = "and") {
  assert(key, "character")
  assert(type, "character")

  key <- key_lkup[[key]]
  if (is.null(key))
    stop("'key' not in acceptable set of keys; see ?occ_download",
      call.=FALSE)

  if (!any(operators_regex %in% type))
    stop("'type' not in acceptable set of types; see param def. 'type'",
      call.=FALSE)
  type <- operator_lkup[ operators_regex %in% type ][[1]]

  if (
    (is.character(value) &&
      all(grepl("polygon|multipolygon|linestring|multilinestring|point|mulitpoint",
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
  } else {
    list(type = unbox(type), key = unbox(key), value = unbox(as_c(value)))
  }
}
pred_cat <- function(x) {
  if ("predicates" %in% names(x)) {
    cat("type: or", sep = "\n")
    for (i in seq_along(x$predicates)) {
      z <- x$predicates[[i]]
      cat(sprintf("  > type: %s, key: %s, value(s): %s",
        z$type, z$key, z$value), sep = "\n")
    }
  } else if ("parameter" %in% names(x)) {
    sprintf("> type: %s, parameter: %s", x$type, x$parameter)
  } else {
    sprintf(
      "> type: %s, key: %s, value(s): %s",
      x$type,
      if ("geometry" %in% names(x)) "geometry" else x$key,
      if ("geometry" %in% names(x)) {
        x$geometry
      } else {
        zz <- x$value %||% x$values
        if (!is.null(zz)) paste(zz, collapse = ",") else zz
      }
    )
  }
}
parse_predicates <- function(user, email, type, format, ...) {
  tmp <- list(...)
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
          lst$predicates <- lapply(w, unclass)
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
