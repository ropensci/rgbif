#' Get a download from GBIF.
#'
#' @export
#'
#' @param key A key generated from a request, like that from \code{occ_download}
#' @param path Path to write zip file to. Default: \code{"."}, with a \code{.zip}
#' appended to the end.
#' @param overwrite Will only overwrite existing path if TRUE.
#' @param ... Further args passed to \code{\link[httr]{GET}}
#'
#' @details Downloads the zip file to a directory you specify on your machine.
#' \code{link[httr]{write_disk}} is used internally to write the zip file to disk.
#' This function only downloads the file. See \code{occ_download_import} to open a
#' downloaded file in your R session. The speed of this function is of course proportional
#' to the size of the file to download. For example, a 58 MB file on my machine
#' took about 26 seconds.
#'
#' @examples \dontrun{
#' occ_download_get("0000066-140928181241064", overwrite = TRUE)
#' occ_download_get("0003983-140910143529206", overwrite = TRUE)
#' }

occ_download_get <- function(key, path=".", overwrite=FALSE, ...) {
  meta <- occ_download_meta(key)
  size <- getsize(meta$size)
  message(sprintf('Download file size: %s MB', size))
  url <- sprintf('http://api.gbif.org/v1/occurrence/download/request/%s', key)
  path <- sprintf("%s/%s.zip", path, key)
  res <- GET(url, write_disk(path = path, overwrite = overwrite), make_rgbif_ua(), ...)
  if (res$status_code > 203) stop(c_utf8(res))
  stopifnot(res$header$`content-type` == "application/octet-stream; qs=0.5")
  options(gbifdownloadpath = path)
  message( sprintf("On disk at %s", res$request$writer[[1]]) )
  structure(path, class = "occ_download_get", size = size, key = key)
}

#' @export
print.occ_download_get <- function(x, ...) {
  stopifnot(is(x, 'occ_download_get'))
  cat("<<gbif downloaded get>>", "\n", sep = "")
  cat("  Path: ", x, "\n", sep = "")
  cat("  File size: ", sprintf("%s MB", attr(x, "size")), "\n", sep = "")
}
