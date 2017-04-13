#' Get a download from GBIF.
#'
#' @export
#'
#' @param key A key generated from a request, like that from `occ_download`
#' @param path Path to write zip file to. Default: `"."`, with a
#' `.zip` appended to the end.
#' @param overwrite Will only overwrite existing path if TRUE.
#' @template occ
#'
#' @details Downloads the zip file to a directory you specify on your machine.
#' [crul::HttpClient()] is used internally to write the zip file to
#' disk. See [crul::writing-options]. This function only downloads the file.
#' See `occ_download_import` to open a downloaded file in your R session.
#' The speed of this function is of course proportional to the size of the
#' file to download. For example, a 58 MB file on my machine took about
#' 26 seconds.
#'
#' @examples \dontrun{
#' occ_download_get("0000066-140928181241064")
#' occ_download_get("0003983-140910143529206", overwrite = TRUE)
#' }

occ_download_get <- function(key, path=".", overwrite=FALSE, curlopts=list()) {
  meta <- occ_download_meta(key)
  size <- getsize(meta$size)
  message(sprintf('Download file size: %s MB', size))
  url <- sprintf('%s/occurrence/download/request/%s', gbif_base(), key)
  path <- sprintf("%s/%s.zip", path, key)
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  if (file.exists(path)) {
    if (!overwrite) stop("file exists & overwrite is FALSE")
  }
  res <- cli$get(disk = path)
  if (res$status_code > 203) stop(res$parse("UTF-8"))
  stopifnot(res$response_headers$`content-type` ==
              "application/octet-stream; qs=0.5")
  options(gbifdownloadpath = path)
  message( sprintf("On disk at %s", res$content) )
  structure(path, class = "occ_download_get",
            size = size, key = key, format = attr(meta, "format"))
}

#' @export
print.occ_download_get <- function(x, ...) {
  stopifnot(inherits(x, 'occ_download_get'))
  cat("<<gbif downloaded get>>", "\n", sep = "")
  cat("  Path: ", x, "\n", sep = "")
  cat("  File size: ", sprintf("%s MB", attr(x, "size")), "\n", sep = "")
}
