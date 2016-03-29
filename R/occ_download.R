#' Spin up a download request for GBIF occurrence data.
#'
#' @importFrom jsonlite unbox
#' @export
#'
#' @param ... One or more of query arguments to kick of a download job. See Details.
#' @param type (charcter) One of equals (=), and (&), or (|), lessThan (<), lessThanOrEquals (<=),
#' greaterThan (>), greaterThanOrEquals (>=), in, within, not (!), like
#' @param user (character) User name within GBIF's website. Required. Set in your
#' \code{.Rprofile} file with the option \code{gbif_user}
#' @param pwd (character) User password within GBIF's website. Required. Set in your
#' \code{.Rprofile} file with the option \code{gbif_pwd}
#' @param email (character) Email address to recieve download notice done email. Required.
#' Set in your \code{.Rprofile} file with the option \code{gbif_email}
#' @param callopts Further named arguments passed on to \code{\link[httr]{POST}}
#'
#' @details Argument passed have to be passed as character (e.g., 'country = US'), with a space
#' between key ('country'), operator ('='), and value ('US'). See the \code{type} parameter for
#' possible options for the operator.  This character string is parsed internally.
#'
#' Acceptable arguments to \code{...} are:
#' \itemize{
#'  \item taxonKey = 'TAXON_KEY'
#'  \item scientificName = 'SCIENTIFIC_NAME'
#'  \item country = 'COUNTRY'
#'  \item publishingCountry = 'PUBLISHING_COUNTRY'
#'  \item hasCoordinate = 'HAS_COORDINATE'
#'  \item hasGeospatialIssue = 'HAS_GEOSPATIAL_ISSUE'
#'  \item typeStatus = 'TYPE_STATUS'
#'  \item recordNumber = 'RECORD_NUMBER'
#'  \item lastInterpreted = 'LAST_INTERPRETED'
#'  \item continent = 'CONTINENT'
#'  \item geometry = 'GEOMETRY'
#'  \item basisOfRecord = 'BASIS_OF_RECORD'
#'  \item datasetKey = 'DATASET_KEY'
#'  \item eventDate = 'EVENT_DATE'
#'  \item catalogNumber = 'CATALOG_NUMBER'
#'  \item year = 'YEAR'
#'  \item month = 'MONTH'
#'  \item decimalLatitude = 'DECIMAL_LATITUDE'
#'  \item decimalLongitude = 'DECIMAL_LONGITUDE'
#'  \item elevation = 'ELEVATION'
#'  \item depth = 'DEPTH'
#'  \item institutionCode = 'INSTITUTION_CODE'
#'  \item collectionCode = 'COLLECTION_CODE'
#'  \item issue = 'ISSUE'
#'  \item mediatype = 'MEDIA_TYPE'
#'  \item recordedBy = 'RECORDED_BY'
#' }
#'
#' @references See the API docs \url{http://www.gbif.org/developer/occurrence#download} for
#' more info, and the predicates docs \url{http://www.gbif.org/developer/occurrence#predicates}.
#'
#' @examples \dontrun{
#' # occ_download("basisOfRecord = LITERATURE")
#' # occ_download('taxonKey = 3119195')
#' # occ_download('decimalLatitude > 50')
#' # occ_download('elevation >= 9000')
#' # occ_download('decimalLatitude >= 65')
#' # occ_download("country = US")
#' # occ_download("institutionCode = TLMF")
#' # occ_download("catalogNumber = Bird.27847588")
#'
#' # res <- occ_download('taxonKey = 7264332', 'hasCoordinate = TRUE')
#'
#' # pass output directly, or later, to occ_download_meta for more information
#' # occ_download('decimalLatitude > 75') %>% occ_download_meta
#'
#' # Multiple queries
#' # occ_download('decimalLatitude >= 65', 'decimalLatitude <= -65', type="or")
#' # gg <- occ_download('depth = 80', 'taxonKey = 2343454', type="or")
#' }

occ_download <- function(...,
   type = "and", user = getOption("gbif_user"), pwd = getOption("gbif_pwd"),
   email = getOption("gbif_email"), callopts = list()) {

  url <- 'http://api.gbif.org/v1/occurrence/download/request'
  stopifnot(!is.null(user), !is.null(email))

  args <- list(...)
  keyval <- lapply(args, parse_args)

  req <- if (length(keyval) > 1) {
    list(creator = unbox(user),
         notification_address = email,
         predicate = list(
           type = unbox(type),
           predicates = keyval
         )
    )
  } else {
    if (type == "within" | "within" %in% sapply(keyval, "[[", "type")) {
      tmp <- list(creator = unbox(user),
           notification_address = email,
           predicate = list(
             type = keyval[[1]]$type,
             value = keyval[[1]]$value
           )
      )
      names(tmp$predicate)[2] <- tolower(keyval[[1]]$key)
      tmp
    } else {
      list(creator = unbox(user),
           notification_address = email,
           predicate = list(
             type = keyval[[1]]$type,
             key = keyval[[1]]$key,
             value = keyval[[1]]$value
           )
      )
    }
  }

  out <- rg_POST(url, req = req, user = user, pwd = pwd, callopts)
  structure(out, class = "occ_download", user = user, email = email)
}

rg_POST <- function(url, req, user, pwd, callopts) {
  tmp <- POST(url, config = c(
    content_type_json(),
    accept_json(),
    authenticate(user = user, password = pwd),
    callopts), body = jsonlite::toJSON(req),
    make_rgbif_ua())
  if (tmp$status_code > 203) stop(catch_err(tmp), call. = FALSE)
  stopifnot(tmp$header$`content-type` == 'application/json')
  c_utf8(tmp)
}

catch_err <- function(x) {
  if (httr::has_content(x)) {
    c_utf8(x)
  } else {
    httr::http_condition(x, "message")$message
  }
}

process_keyval <- function(args, type) {
  out <- list()
  for (i in seq_along(args)) {
    out[[i]] <- list(type = unbox(type), key = unbox(names(args[i])), value = unbox(args[[i]]))
  }
  out
}

#' @export
print.occ_download <- function(x, ...) {
  stopifnot(is(x, 'occ_download'))
  cat("<<gbif download>>", "\n", sep = "")
  cat("  Username: ", attr(x, "user"), "\n", sep = "")
  cat("  E-mail: ", attr(x, "email"), "\n", sep = "")
  cat("  Download key: ", x, "\n", sep = "")
}

parse_args <- function(x){
  tmp <- strsplit(x, "\\s")[[1]]
  type <- operator_lkup[[ tmp[2] ]]
  key <- key_lkup[[ tmp[1] ]]
  value <- paste0(tmp[3:length(tmp)], collapse = " ")
  list(type = unbox(type), key = unbox(key), value = unbox(value))
}

operator_lkup <- list(`=` = 'equals', `&` = 'and', `|` = 'or', `<` = 'lessThan',
    `<=` = 'lessThanOrEquals', `>` = 'greaterThan',
    `>=` = 'greaterThanOrEquals', `!` = 'not',
    'in' = 'in', 'within' = 'within', 'like' = 'like')

key_lkup <- list(taxonKey='TAXON_KEY', scientificName='SCIENTIFIC_NAME', country='COUNTRY',
     publishingCountry='PUBLISHING_COUNTRY', hasCoordinate='HAS_COORDINATE',
     hasGeospatialIssue='HAS_GEOSPATIAL_ISSUE', typeStatus='TYPE_STATUS',
     recordNumber='RECORD_NUMBER', lastInterpreted='LAST_INTERPRETED', continent='CONTINENT',
     geometry='GEOMETRY', basisOfRecord='BASIS_OF_RECORD', datasetKey='DATASET_KEY',
     eventDate='EVENT_DATE', catalogNumber='CATALOG_NUMBER', year='YEAR', month='MONTH',
     decimalLatitude='DECIMAL_LATITUDE', decimalLongitude='DECIMAL_LONGITUDE', elevation='ELEVATION',
     depth='DEPTH', institutionCode='INSTITUTION_CODE', collectionCode='COLLECTION_CODE',
     issue='ISSUE', mediatype='MEDIA_TYPE', recordedBy='RECORDED_BY')
