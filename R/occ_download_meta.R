#' Retrieves the occurrence download metadata by its unique key.
#'
#' @export
#'
#' @param key A key generated from a request, like that from \code{occ_download}
#' @param ... Further args passed to \code{\link[httr]{GET}}
#'
#' @examples \donttest{
#' occ_download_meta(key="0003970-140910143529206")
#' occ_download_meta("0000099-140929101555934")
#' }

occ_download_meta <- function(key, ...)
{
  assert_that(!is.null(key))
  url <- sprintf('http://api.gbif.org/v1/occurrence/download/%s', key)
  tmp <- GET(url, ...)
  if(tmp$status_code > 203) stop(content(tmp, as = "text"))
  assert_that(tmp$header$`content-type` == 'application/json')
  tt <- content(tmp, as = "text")
  structure(jsonlite::fromJSON(tt), class="occ_download_meta")
}

#' @export
print.occ_download_meta <- function (x, ...){
  assert_that(is(x, 'occ_download_meta'))
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
  if(length(y) > 0){
    y <- y[[1]]
    out <- list()
    for(i in seq_along(y)){
      out[[i]] <- paste0(names(y)[i], " (", y[i], ")")
    }
    paste0(out, collapse = ", ")
  } else { "none" }
}

