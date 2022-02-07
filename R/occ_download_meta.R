#' Retrieves the occurrence download metadata by its unique key.
#'
#' @export
#'
#' @param key A key generated from a request, like that from
#' \code{occ_download}
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#' @return an object of class `occ_download_meta`, a list with slots for
#' the download key, the DOI assigned to the download, license link,
#' the request details you sent in the `occ_download()` request,
#' and metadata about the size and date/time of the request
#' @family downloads
#' @examples \dontrun{
#' occ_download_meta(key="0003983-140910143529206")
#' occ_download_meta("0000066-140928181241064")
#' }

occ_download_meta <- function(key, curlopts = list()) {
  stopifnot(!is.null(key))
  
  if(!is_download_key(key)) stop("key should be a downloadkey or 
                                     an occ_download object.")
  #stopifnot(inherits(key, c("character", "occ_download")))
  url <- sprintf('%s/occurrence/download/%s', gbif_base(), key)
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  tmp <- cli$get()
  if (tmp$status_code > 203) stop(tmp$parse("UTF-8"), call. = FALSE)
  stopifnot(tmp$response_headers$`content-type` == 'application/json')
  tt <- tmp$parse("UTF-8")
  res <- jsonlite::fromJSON(tt, FALSE)
  structure(res, class = "occ_download_meta", format = res$request$format)
}

#' @export
print.occ_download_meta <- function(x, ...){
  stopifnot(inherits(x, 'occ_download_meta'))
  cat_n("<<gbif download metadata>>")
  cat_n("  Status: ", x$status)
  cat_n("  DOI: ", x$doi)
  cat_n("  Format: ", attr(x, 'format'))
  cat_n("  Download key: ", x$key)
  cat_n("  Created: ", x$created)
  cat_n("  Modified: ", x$modified)
  cat_n("  Download link: ", x$downloadLink)
  cat_n("  Total records: ", n_with_status(x$totalRecords, x$status))
}

n_with_status <- function(n, status) {
  # bail out if not numeric or integer
  if (!inherits(n, c("numeric", "integer"))) return(n)
  # return n if greater than zero
  if (n > 0) return(n)
  # if zero and still running return NA
  if (!tolower(status) %in% c('succeeded', 'killed', 'cancelled')) {
    return("<NA>")
  }
  # else return n
  return(n)
}

 sprintf_not_null <- function(z, ws_prefix = "\n          -") {
   sprintf("%s type: %s, parameter: %s", 
     ws_prefix, z$type, z$parameter)
}
sprintf_key_val <- function(x, ws_prefix = "\n          -") {
   sprintf("%s type: %s, key: %s, value: %s", 
     ws_prefix, x$type, x$key, x$value)
 }
 sprintf_not <- function(type, fmt) {
   z <- if (type == "isNotNull") {
     sprintf_not_null(fmt, "\n            -")
   } else {
     sprintf_key_val(fmt)
   }
   paste0("\n          - type: not", z)
 }
 

