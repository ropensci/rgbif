#' Spin up a download request for GBIF occurrence data.
#'
#' @export
#'
#' @param ... For `occ_download()` and `occ_download_prep()`, one or more
#' objects of class `occ_predicate` or `occ_predicate_list`, created by
#' `pred*` functions (see [download_predicate_dsl]). If you use this, don't
#' use `body` parameter.
#' @param body if you prefer to pass in the payload yourself, use this
#' parameter. If you use this, don't pass anything to the dots. Accepts
#' either an R list, or JSON. JSON is likely easier, since the JSON
#' library \pkg{jsonlite} requires that you unbox strings that shouldn't
#' be auto-converted to arrays, which is a bit tedious for large queries.
#' optional
#' @param type (character) One of equals (=), and (&), or (|), lessThan (<),
#' lessThanOrEquals (<=), greaterThan (>), greaterThanOrEquals (>=), in,
#' within, not (!), like, isNotNull
#' @param format (character) The download format. One of 'DWCA' (default),
#' 'SIMPLE_CSV', or 'SPECIES_LIST'
#' @param user (character) User name within GBIF's website. Required. See
#' "Authentication" below
#' @param pwd (character) User password within GBIF's website. Required. See
#' "Authentication" below
#' @param email (character) Email address to receive download notice done
#' email. Required. See "Authentication" below
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
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
#' respect to WKT in that you can supply clockwise WKT to those
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
#' @section Query length:
#' GBIF has a limit of 12,000 characters for a download query. This means
#' that you can have a pretty long query, but at some point it may lead to an
#' error on GBIF's side and you'll have to split your query into a few.
#'
#' @references See the API docs
#' <https://www.gbif.org/developer/occurrence#download> for more info,
#' and the predicates docs
#' <https://www.gbif.org/developer/occurrence#predicates>
#'
#' @examples \dontrun{
#' # occ_download(pred("basisOfRecord", "LITERATURE"))
#' # occ_download(pred("taxonKey", 3119195), pred_gt("elevation", 5000))
#' # occ_download(pred_gt("decimalLatitude", 50))
#' # occ_download(pred_gte("elevation", 9000))
#' # occ_download(pred_gte('decimalLatitude", 65))
#' # occ_download(pred("country", "US"))
#' # occ_download(pred("institutionCode", "TLMF"))
#' # occ_download(pred("catalogNumber", 217880))
#' 
#' # download format
#' # z <- occ_download(pred_gte("decimalLatitude", 75),
#' #  format = "SPECIES_LIST")
#'
#' # res <- occ_download(pred("taxonKey", 7264332), pred("hasCoordinate", TRUE))
#'
#' # pass output directly, or later, to occ_download_meta for more information
#' # occ_download(pred_gt('decimalLatitude', 75)) %>% occ_download_meta
#'
#' # Multiple queries
#' # occ_download(pred_gte("decimalLatitude", 65),
#' #  pred_lte("decimalLatitude", -65), type="or")
#' # gg <- occ_download(pred("depth", 80), pred("taxonKey", 2343454),
#' #  type="or")
#' # x <- occ_download(pred_and(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
#' #  pred_gte("elevation", 5000)))
#'
#' # complex example with many predicates
#' # shows example of how to do date ranges for both year and month
#' # res <- occ_download(
#' #  pred_gt("elevation", 5000),
#' #  pred_in("basisOfRecord", c('HUMAN_OBSERVATION','OBSERVATION','MACHINE_OBSERVATION')),
#' #  pred("country", "US"),
#' #  pred("hasCoordinate", TRUE),
#' #  pred("hasGeospatialIssue", FALSE),
#' #  pred_gte("year", 1999),
#' #  pred_lte("year", 2011),
#' #  pred_gte("month", 3),
#' #  pred_lte("month", 8)
#' # )
#'
#' # Using body parameter - pass in your own complete query
#' ## as JSON
#' query1 <- '{"creator":"sckott",
#'   "notification_address":["stuff1@gmail.com"],
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
#'   notification_address = "stuff1@gmail.com",
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
#' occ_download_prep(pred("basisOfRecord", "LITERATURE"))
#' occ_download_prep(pred("basisOfRecord", "LITERATURE"), format = "SIMPLE_CSV")
#' occ_download_prep(pred("basisOfRecord", "LITERATURE"), format = "SPECIES_LIST")
#' occ_download_prep(pred_in("taxonKey", c(2977832, 2977901, 2977966, 2977835)))
#' occ_download_prep(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"))
#' 
#' ## a complicated example
#' occ_download_prep(
#'   pred_in("basisOfRecord", c("MACHINE_OBSERVATION", "HUMAN_OBSERVATION")),
#'   pred_in("taxonKey", c(2498343, 2481776, 2481890)),
#'   pred_in("country", c("GB", "IE")),
#'   pred_or(pred_lte("year", 1989), pred("year", 2000))
#' )
#' 
#' # x = occ_download(
#' #   pred_in("basisOfRecord", c("MACHINE_OBSERVATION", "HUMAN_OBSERVATION")),
#' #   pred_in("taxonKey", c(9206251, 3112648)),
#' #   pred_in("country", c("US", "MX")),
#' #   pred_and(pred_gte("year", 1989), pred_lte("year", 1991))
#' # )
#' # occ_download_meta(x)
#' # z <- occ_download_get(x)
#' # df <- occ_download_import(z)
#' # str(df)
#' # library(dplyr)
#' # unique(df$basisOfRecord)
#' # unique(df$taxonKey)
#' # unique(df$countryCode)
#' # sort(unique(df$year))
#' }
occ_download <- function(..., body = NULL, type = "and", format = "DWCA",
                         user = NULL, pwd = NULL, email = NULL, curlopts = list()) {
  
  z <- occ_download_prep(..., body = body, type = type, format = format,
                         user = user, pwd = pwd, email = email, curlopts = curlopts)
  out <- rg_POST(z$url, req = z$request, user = z$user, pwd = z$pwd, curlopts)
  md <- occ_download_meta(out) # get meta_data for printing
  citation <- gbif_citation(md)$download # get citation
  
  structure(out, 
            class = "occ_download", 
            user = z$user, 
            email = z$email,
            format = z$format,
            status = md$status,
            created = md$created,
            downloadLink = md$downloadLink,
            doi = md$doi,
            citation = citation
  )
}

download_formats <- c("DWCA", "SIMPLE_CSV", "SPECIES_LIST", "SIMPLE_PARQUET")

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
    req <- parse_predicates(user, email, type, format, ...)
  }
  structure(list(
    url = url,
    request = req,
    json_request = jsonlite::prettify(check_inputs(req),indent = 1),
    user = user,
    pwd = pwd,
    email = email,
    format = format,
    curlopts = curlopts),
    class = "occ_download_prep")
}

#' @export
print.occ_download <- function(x, ...) {
  stopifnot(inherits(x, 'occ_download'))
  cat_n("<<gbif download>>")
  cat_n("  Your download is being processed by GBIF:")
  cat_n("  https://www.gbif.org/occurrence/download/",x)
  cat_n("  Most downloads finish within 15 min.")
  cat_n("  Check status with")
  cat_n("  occ_download_wait('",x,"')")
  cat_n("  After it finishes, use")
  cat_n("  d <- occ_download_get('",x,"') %>%") 
  cat_n("    occ_download_import()")
  cat_n("  to retrieve your download.")
  cat_n("Download Info:")
  cat_n("  Username: ", attr(x, "user"))
  cat_n("  E-mail: ", attr(x, "email"))
  cat_n("  Format: ", attr(x, "format"))
  cat_n("  Download key: ", x)
  cat_n("  Created: ",attr(x, "created"))
  cat_n("Citation Info:  ")
  cat_n("  Please always cite the download DOI when using this data.")
  cat_n("  https://www.gbif.org/citation-guidelines")
  cat_n("  DOI: ", attr(x,"doi"))
  cat_n("  Citation:")
  cat_n("  ", attr(x,"citation"))
}
#' @export
print.occ_download_prep <- function(x, ...) {
  cat_n("<<gbif download - prepared>>")
  cat_n("  Username: ", x$user)
  cat_n("  E-mail: ", x$email)
  cat_n("  Format: ", x$format)
  if(nchar(x$json_request) < 1500) cat_n("  Request: \n", x$json_request)
  else cat_n("  Request: \n  OK. But too large to print. \n Use 'occ_download_prep()$json_request' to see JSON print out.")
}

# helpers -------------------------------------------
occ_download_exec <- function(x) {
  assert(x, "occ_download_prep")
  out <- rg_POST(x$url, req = x$req, user = x$user, pwd = x$pwd, x$curlopts)
  structure(out, class = "occ_download", user = x$user, email = x$email)
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
