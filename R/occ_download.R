#' Spin up a download request for GBIF occurrence data.
#'
#' @export
#'
#' @param ... One or more of query arguments to kick of a download job.
#' If you use this, don't use `body` parameter. All inputs must be
#' character strings. See Details.
#' @param body if you prefer to pass in the payload yourself, use this
#' parameter. if use this, don't pass anythig to the dots. accepts
#' either an R list, or JSON. JSON is likely easier, since the JSON
#' library \pkg{jsonlite} requires that you unbox strings that shouldn't
#' be auto-converted to arrays, which is a bit tedious for large queries.
#' optional
#' @param type (character) One of equals (=), and (&), or (|), lessThan (<),
#' lessThanOrEquals (<=), greaterThan (>), greaterThanOrEquals (>=), in,
#' within, not (!), like
#' @param format (character) The download format. One of DWCA (default),
#' SIMPLE_CSV, or SPECIES_LIST
#' @param user (character) User name within GBIF's website. Required. See
#' Details.
#' @param pwd (character) User password within GBIF's website. Required. See
#' Details.
#' @param email (character) Email address to recieve download notice done
#' email. Required. See Details.
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#'
#' @section geometry:
#' When using the geometry parameter, make sure that your well known text
#' (WKT) is formatted as GBIF expects it. They expect WKT to have a
#' counter-clockwise winding order. For example, the following is clockwise
#' `POLYGON((-19.5 34.1, -25.3 68.1, 35.9 68.1, 27.8 34.1, -19.5 34.1))`,
#' whereas they expect the other order:
#' `POLYGON((-19.5 34.1, 27.8 34.1, 35.9 68.1, -25.3 68.1, -19.5 34.1))`
#'
#' note that coordinate pairs are `longitude latitude`, longitude first, then
#' latitude
#'
#' you should not get any results if you supply WKT that has clockwise
#' winding order.
#'
#' also note that [occ_search()]/[occ_data()] behave differently with
#' respect to WKT in that you can supply counter-clockwise WKT to those
#' functions but they treat it as an exclusion, so get all data not
#' inside the WKT area.
#'
#' @section Methods:
#'
#' - `occ_download_prep`: prepares a download request, but DOES NOT execute it.
#' meant for use with [occ_download_queue()]
#' - `occ_download`: prepares a download request and DOES execute it
#'
#' @section Authentication:
#' For `user`, `pwd`, and `email` parameters, you can set them in one of
#' three ways:
#'
#' - Set them in your `.Rprofile` file with the names `gbif_user`,
#' `gbif_pwd`, and `gbif_email`
#' - Set them in your `.Renviron`/`.bash_profile` (or similar) file with the
#' names `GBIF_USER`, `GBIF_PWD`, and `GBIF_EMAIL`
#' - Simply pass strings to each of the parameters in the function
#' call
#'
#' We strongly recommend the second option - storing your details as
#' environment variables as it's the most widely used way to store secrets.
#'
#' See `?Startup` for help.
#'
#' @details Argument passed have to be passed as character (e.g.,
#' 'country = US'), with a space between key ('country'), operator ('='),
#' and value ('US'). See the `type` parameter for possible options for
#' the operator.  This character string is parsed internally.
#'
#' The value can be comma separated, in which case we'll turn that into a
#' predicate combined with the OR operator, for example,
#' `"taxonKey = 2480946,5229208"` will turn into
#'
#' ```
#' '{
#'    "type": "or",
#'    "predicates": [
#'      {
#'       "type": "equals",
#'       "key": "TAXON_KEY",
#'       "value": "2480946"
#'      },
#'      {
#'       "type": "equals",
#'       "key": "TAXON_KEY",
#'       "value": "5229208"
#'      }
#'    ]
#' }'
#' ```
#'
#' Acceptable arguments to `...` are:
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
#' @section Query length:
#' GBIF has a limit of 12,000 characters for a download query. This means
#' that you can have a pretty long query, but at some point it may lead to an
#' error on GBIF's side and you'll have to split your query into a few.
#'
#' @references See the API docs
#' <http://www.gbif.org/developer/occurrence#download> for more info,
#' and the predicates docs
#' <http://www.gbif.org/developer/occurrence#predicates>
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
#' # download format
#' # z <- occ_download('decimalLatitude >= 75', format = "SPECIES_LIST")
#'
#' # res <- occ_download('taxonKey = 7264332', 'hasCoordinate = TRUE')
#'
#' # pass output directly, or later, to occ_download_meta for more information
#' # occ_download('decimalLatitude > 75') %>% occ_download_meta
#'
#' # Multiple queries
#' # occ_download('decimalLatitude >= 65', 'decimalLatitude <= -65', type="or")
#' # gg <- occ_download('depth = 80', 'taxonKey = 2343454', type="or")
#'
#' # complex example with many predicates
#' # shows example of how to do date ranges for both year and month
#' # res <- occ_download(
#' #  "taxonKey = 2480946,5229208",
#' #  "basisOfRecord = HUMAN_OBSERVATION,OBSERVATION,MACHINE_OBSERVATION",
#' #  "country = US",
#' #  "hasCoordinate = true",
#' #  "hasGeospatialIssue = false",
#' #  "year >= 1999",
#' #  "year <= 2011",
#' #  "month >= 3",
#' #  "month <= 8"
#' # )
#'
#' # Using body parameter - pass in your own complete query
#' ## as JSON
#' query1 <- '{"creator":"sckott",
#'   "notification_address":["myrmecocystus@gmail.com"],
#'   "predicate":{"type":"and","predicates":[
#'     {"type":"equals","key":"TAXON_KEY","value":"7264332"},
#'     {"type":"equals","key":"HAS_COORDINATE","value":"TRUE"}]}
#'  }'
#' # res <- occ_download(body = query1, curlopts=list(verbose=TRUE))
#'
#' ## as a list
#' library(jsonlite)
#' query <- list(
#'   creator = unbox("sckott"),
#'   notification_address = "myrmecocystus@gmail.com",
#'   predicate = list(
#'     type = unbox("and"),
#'     predicates = list(
#'       list(type = unbox("equals"), key = unbox("TAXON_KEY"),
#'         value = unbox("7264332")),
#'       list(type = unbox("equals"), key = unbox("HAS_COORDINATE"),
#'         value = unbox("TRUE"))
#'     )
#'   )
#' )
#' # res <- occ_download(body = query, curlopts = list(verbose = TRUE))
#'
#' # Prepared query
#' occ_download_prep("basisOfRecord = LITERATURE")
#' occ_download_prep("basisOfRecord = LITERATURE", format = "SIMPLE_CSV")
#' occ_download_prep("basisOfRecord = LITERATURE", format = "SPECIES_LIST")
#' }
occ_download <- function(..., body = NULL, type = "and", format = "DWCA",
  user = NULL, pwd = NULL, email = NULL, curlopts = list()) {

  z <- occ_download_prep(..., body = body, type = type, format = format,
    user = user, pwd = pwd, email = email, curlopts = curlopts)
  out <- rg_POST(z$url, req = z$request, user = z$user, pwd = z$pwd, curlopts)
  structure(out, class = "occ_download", user = z$user, email = z$email,
    format = z$format)
}

download_formats <- c("DWCA", "SIMPLE_CSV", "SPECIES_LIST")

#' @export
#' @rdname occ_download
occ_download_prep <- function(..., body = NULL, type = "and", format = "DWCA",
  user = NULL, pwd = NULL, email = NULL, curlopts = list()) {

  url <- paste0(gbif_base(), '/occurrence/download/request')
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  email <- check_email(email)
  assert(format, "character")
  if (!format %in% download_formats) {
    stop("'format' must be one of: ", paste0(download_formats, collapse = ", "),
      call. = FALSE)
  }
  stopifnot(!is.null(user), !is.null(email))
  if (!is.null(body)) {
    req <- body
  } else {
    req <- parse_occd(user, email, type, format, ...)
  }
  structure(list(url = url, request = req, user = user, pwd = pwd,
    email = email, format = format, curlopts = curlopts),
  class = "occ_download_prep")
}

occ_download_exec <- function(x) {
  assert(x, "occ_download_prep")
  out <- rg_POST(x$url, req = x$req, user = x$user, pwd = x$pwd, x$curlopts)
  structure(out, class = "occ_download", user = x$user, email = x$email)
}

check_user <- function(x) {
  z <- if (is.null(x)) Sys.getenv("GBIF_USER", "") else x
  if (z == "") getOption("gbif_user", stop("supply a username")) else z
}

check_pwd <- function(x) {
  z <- if (is.null(x)) Sys.getenv("GBIF_PWD", "") else x
  if (z == "") getOption("gbif_pwd", stop("supply a password")) else z
}

check_email <- function(x) {
  z <- if (is.null(x)) Sys.getenv("GBIF_EMAIL", "") else x
  if (z == "") getOption("gbif_email", stop("supply an email address")) else z
}

check_inputs <- function(x) {
  if (is.character(x)) {
    # replace newlines
    x <- gsub("\n|\r|\\s+", "", x)
    # validate
    tmp <- jsonlite::validate(x)
    if (!tmp) stop(attr(tmp, "err"))
    x
  } else {
    jsonlite::toJSON(x)
  }
}

parse_occd <- function(user, email, type, format, ...) {
  args <- list(...)
  keyval <- lapply(args, parse_args, type1 = type)

  if (length(keyval) > 1 ||
    length(keyval) == 1 && "predicates" %in% names(keyval[[1]])
  ) {
    list(creator = unbox(user),
         notification_address = email,
         format = unbox(format),
         predicate = list(
           type = unbox(type),
           predicates = {
             lapply(keyval, function(z) {
               if (z$type == "within" && z$key == "GEOMETRY") {
                 z$key <- NULL
                 names(z)[2] <- "geometry"
                 z
               } else {
                 z
               }
             })
           }
         )
    )
  } else {
    if (type == "within" || "within" %in% sapply(keyval, "[[", "type")) {
      tmp <- list(creator = unbox(user),
                  notification_address = email,
                  format = unbox(format),
                  predicate = list(
                    type = keyval[[1]]$type,
                    value = keyval[[1]]$value
                  )
      )
      names(tmp$predicate)[2] <- tolower(keyval[[1]]$key)
      tmp
    } else if (type == "in") {
      list(
        creator = unbox(user),
        notification_address = email,
        format = unbox(format),
        predicate = keyval[[1]]
      )
    } else {
      list(creator = unbox(user),
           notification_address = email,
           format = unbox(format),
           predicate = list(
             type = keyval[[1]]$type,
             key = keyval[[1]]$key,
             value = keyval[[1]]$value
           )
      )
    }
  }
}

rg_POST <- function(url, req, user, pwd, curlopts) {
  cli <- crul::HttpClient$new(url = url, opts = c(
    curlopts, httpauth = 1, userpwd = paste0(user, ":", pwd)),
    headers = c(
      rgbif_ual, `Content-Type` = "application/json",
      Accept = "application/json"
    )
  )
  res <- cli$post(body = check_inputs(req))
  if (res$status_code > 203) stop(catch_err(res), call. = FALSE)
  res$raise_for_status()
  stopifnot(res$response_headers$`content-type` == 'application/json')
  res$parse("UTF-8")
}

catch_err <- function(x) {
  if (length(x$content) > 0) {
    x$parse("UTF-8")
  } else {
    sthp <- x$status_http()
    sprintf("%s - %s", sthp$status_code, sthp$message)
  }
}

process_keyval <- function(args, type) {
  out <- list()
  for (i in seq_along(args)) {
    out[[i]] <- list(type = unbox(type), key = unbox(names(args[i])),
                     value = unbox(args[[i]]))
  }
  out
}

#' @export
print.occ_download <- function(x, ...) {
  stopifnot(inherits(x, 'occ_download'))
  cat("<<gbif download>>", "\n", sep = "")
  cat("  Username: ", attr(x, "user"), "\n", sep = "")
  cat("  E-mail: ", attr(x, "email"), "\n", sep = "")
  cat("  Format: ", attr(x, "format"), "\n", sep = "")
  cat("  Download key: ", x, "\n", sep = "")
}

#' @export
print.occ_download_prep <- function(x, ...) {
  cat("<<gbif download - prepared>>", "\n", sep = "")
  cat("  Username: ", x$user, "\n", sep = "")
  cat("  E-mail: ", x$email, "\n", sep = "")
  cat("  Format: ", x$format, "\n", sep = "")
  cat("  Request: ", gbif_make_list(x$request), "\n", sep = "")
}

parse_args <- function(x, type1 = "and") {
  if (
    !all(vapply(x, is.character, logical(1))) ||
    length(x) > 1
  ) {
    stop("all inputs to `...` of occ_download must be character & length=1\n",
      "  see examples; as an alternative, see the `body` param",
      call. = FALSE)
  }
  key <- key_lkup[[ strextract(x, "[A-Za-z]+") ]]
  type <- operator_lkup[[ strtrim(strextract(x, paste0(operators_regex,
                                                       collapse = "|"))) ]]
  loc <- regexpr(paste0(operators_regex, collapse = "|"), x)
  value <- strtrim(
    substring(x, loc + attr(loc, "match.length"), nchar(x))
  )
  if (
    grepl(",", value) &&
    !grepl("polygon|multipolygon|linestring|multilinestring|point|mulitpoint",
           value, ignore.case = TRUE) &&
    type1 != "in"
  ) {
    value <- strsplit(value, ",")[[1]]
    out <- list(
      type = unbox("or"), predicates = lapply(value, function(z) {
        list(type = unbox("equals"), key = unbox(key), value = unbox(z))
      })
    )
    return(out)
  }
  if (type1 == "in") {
    list(type = unbox("in"), key = unbox(key), values = strsplit(value, ",")[[1]])
  } else {
    list(type = unbox(type), key = unbox(key), value = unbox(value))
  }
}

operators_regex <- c("=", "\\&", "<", "<=", ">", ">=", "\\!", "\\sin\\s",
                     "\\swithin\\s", "\\slike\\s", "\\|")

operator_lkup <- list(`=` = 'equals', `&` = 'and', `|` = 'or',
                      `<` = 'lessThan', `<=` = 'lessThanOrEquals',
                      `>` = 'greaterThan', `>=` = 'greaterThanOrEquals',
                      `!` = 'not', 'in' = 'in', 'within' = 'within',
                      'like' = 'like')

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
