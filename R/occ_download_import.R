#' Import a downloaded file from GBIF.
#'
#' @export
#'
#' @param x The output of a call to \code{occ_download_get}
#' @param key A key generated from a request, like that from \code{occ_download}
#' @param path Path to unzip file to. Default: \code{"."} Writes to folder matching
#' zip file name
#'
#' @details You can provide either x as input, or both key and path. We use
#' \code{\link[data.table]{fread}} internally to read data.
#'
#' @examples \dontrun{
#' # First, kick off at least 1 download, then wait for the job to be complete
#' # Then use your download keys
#' res <- occ_download_get(key="0000066-140928181241064", overwrite=TRUE)
#' occ_download_import(x=res)
#'
#' occ_download_get(key="0000066-140928181241064", overwrite = TRUE) %>% occ_download_import
#'
#' # coerce a file path to the right class to feed to occ_download_import
#' as.download("0000066-140928181241064.zip")
#' as.download(key = "0000066-140928181241064")
#' occ_download_import(as.download("0000066-140928181241064.zip"))
#' }

occ_download_import <- function(x=NULL, key=NULL, path=".") {
  if (!is.null(x)) {
    stopifnot(is(x, "occ_download_get"))
    path <- x[[1]]
    key <- attr(x, "key")
  } else {
    stopifnot(!is.null(key), !is.null(path))
    path <- sprintf("%s/%s.zip", path, key)
  }
  tmpdir <- file.path(tempdir(), key)
  unzip(path, exdir = tmpdir, overwrite = TRUE)
  dat <- fread(file.path(tmpdir, "occurrence.txt"), data.table = FALSE)
  structure(dat, class = c("gbif_download", "data.frame"))
}

#' @export
print.gbif_download <- function(x, ..., n = 10) {
  trunc_mat(x, n = n)
}

#' @export
#' @rdname occ_download_import
as.download <- function(path = ".", key = NULL) {
  UseMethod("as.download")
}

#' @export
#' @rdname occ_download_import
as.download.character <- function(path = ".", key = NULL) {
  stopifnot(!is.null(path))
  if (!is.null(key)) path <- sprintf("%s/%s.zip", path, key)
  if (!file.exists(path)) stop("File does not exist", call. = FALSE)
  size <- getsize(file.info(path)$size)
  structure(path, class = "occ_download_get",
            size = size, key = ifelse(is.null(key), "unknown", key))
}

#' @export
#' @rdname occ_download_import
as.download.download <- function(path = ".", key = NULL) as.download(path, key)
