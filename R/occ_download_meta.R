#' Retrieves the occurrence download metadata by its unique key.
#'
#' @export
#'
#' @param key A key generated from a request, like that from
#' \code{occ_download}
#' @template occ
#' @note see [downloads] for an overview of GBIF downloads methods
#'
#' @examples \dontrun{
#' occ_download_meta(key="0003983-140910143529206")
#' occ_download_meta("0000066-140928181241064")
#' }

occ_download_meta <- function(key, curlopts = list()) {
  stopifnot(!is.null(key))
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
  cat("<<gbif download metadata>>", "\n", sep = "")
  cat("  Status: ", x$status, "\n", sep = "")
  cat("  Format: ", attr(x, 'format'), "\n", sep = "")
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
    otype <- y$type
    if (!"predicates" %in% names(y)) {
      y <- list(predicates = list(y))
    }
    out <- list()
    for (i in seq_along(y$predicates)) {
      tmp <- y$predicates[[i]]

      if ("predicates" %in% names(tmp)) {
        stt <- lapply(tmp$predicates, function(x) {
          sprintf("\n          - type: %s, key: %s, value: %s",
                  x$type, x$key, x$value)
        })
        out[[i]] <- paste0(paste("\n      > type: ", tmp$type),
                           pc("\n        predicates: ", pc(stt)),
                           collapse = ", ")
      } else {
        out[[i]] <- sprintf(
          "\n      > type: %s, key: %s, value(s): %s",
          tmp$type,
          if ("geometry" %in% names(tmp)) "geometry" else tmp$key,
          if ("geometry" %in% names(tmp)) {
            tmp$geometry 
          } else {
            zz <- tmp$value %||% tmp$values
            if (!is.null(zz)) paste(zz, collapse = ",") else zz
          }
        )
      }
    }

    paste0(paste("\n    type: ", otype), pc("\n    predicates: ", pc(out)),
           collapse = ", ")
  } else {
    "none"
  }
}

pc <- function(..., collapse = "") {
  paste0(..., collapse = collapse)
}
