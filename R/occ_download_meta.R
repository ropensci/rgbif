#' Retrieves the occurrence download metadata by its unique key.
#'
#' @export
#'
#' @param key A key generated from a request, like that from \code{occ_download}
#' @param ... Further args passed to \code{\link[httr]{GET}}
#'
#' @examples \dontrun{
#' occ_download_meta("0003970-140910143529206")
#' occ_download_meta("0000099-140929101555934")
#' }

occ_download_meta <- function(key, ...) {
  stopifnot(!is.null(key))
  url <- sprintf('http://api.gbif.org/v1/occurrence/download/%s', key)
  tmp <- GET(url, make_rgbif_ua(), ...)
  if (tmp$status_code > 203) stop(c_utf8(tmp), call. = FALSE)
  stopifnot(tmp$header$`content-type` == 'application/json')
  tt <- c_utf8(tmp)
  structure(jsonlite::fromJSON(tt, FALSE), class = "occ_download_meta")
}

#' @export
print.occ_download_meta <- function(x, ...){
  stopifnot(is(x, 'occ_download_meta'))
  cat("<<gbif download metadata>>", "\n", sep = "")
  cat("  Status: ", x$status, "\n", sep = "")
  cat("  Download key: ", x$key, "\n", sep = "")
  cat("  Created: ", x$created, "\n", sep = "")
  cat("  Modified: ", x$modified, "\n", sep = "")
  cat("  Download link: ", x$downloadLink, "\n", sep = "")
  cat("  Total records: ", x$totalRecords, "\n", sep = "")
  cat("  Request: ", gbif_make_list(x$request), "\n", sep = "")
}

gbif_make_list <- function(y){
  if (length(y) > 0) {
    y <- y$predicate
    if (!"predicates" %in% names(y)) {
      y <- list(predicates = list(y))
    }
    out <- list()
    for (i in seq_along(y$predicates)) {
      tmp <- y$predicates[[i]]
      out[[i]] <- sprintf("\n      - type: %s, key: %s, value: %s", tmp$type, tmp$key, tmp$value)
    }
    paste0(paste("\n    type: ", y$type), pc("\n    predicates: ", pc(out)), collapse = ", ")
  } else {
    "none"
  }
}

pc <- function(..., collapse = "") {
  paste0(..., collapse = collapse)
}
