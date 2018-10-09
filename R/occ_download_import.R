#' Import a downloaded file from GBIF.
#'
#' @export
#'
#' @param x The output of a call to `occ_download_get`
#' @param key A key generated from a request, like that from
#' \code{occ_download}
#' @param path Path to unzip file to. Default: `"."` Writes to
#' folder matching zip file name
#' @param fill (logical) (default: `FALSE`). If `TRUE` then in case
#' the rows have unequal length, blank fields are implicitly filled.
#' passed on to `fill` parameter in [data.table::fread]. If you get
#' problems with this function crashing it could be due to
#' `data.table` failing, in which case try setting `fill=FALSE`
#' @param ... parameters passed on to [data.table::fread()]
#'
#' @return a tibble (data.frame)
#'
#' @details You can provide either x as input, or both key and path. We use
#' [data.table::fread()] internally to read data.
#' @note see [downloads] for an overview of GBIF downloads methods
#'
#' @examples \dontrun{
#' # First, kick off at least 1 download, then wait for the job to be complete
#' # Then use your download keys
#' res <- occ_download_get(key="0000066-140928181241064", overwrite=TRUE)
#' occ_download_import(res)
#'
#' occ_download_get(key="0000066-140928181241064", overwrite = TRUE) %>%
#'   occ_download_import
#'
#' # coerce a file path to the right class to feed to occ_download_import
#' # as.download("0000066-140928181241064.zip")
#' # as.download(key = "0000066-140928181241064")
#' # occ_download_import(as.download("0000066-140928181241064.zip"))
#'
#' # download a dump that has a CSV file
#' # res <- occ_download_get(key = "0001369-160509122628363", overwrite=TRUE)
#' # occ_download_import(res)
#' # occ_download_import(key = "0001369-160509122628363")
#' }

occ_download_import <- function(x=NULL, key=NULL, path=".", fill = TRUE, ...) {
  if (!is.null(x)) {
    stopifnot(inherits(x, "occ_download_get"))
    path <- x[[1]]
    key <- attr(x, "key")
  } else {
    stopifnot(!is.null(key), !is.null(path))
    path <- sprintf("%s/%s.zip", path, key)
  }
  if (!file.exists(path)) stop("file does not exist", call. = FALSE)
  tmpdir <- file.path(tempdir(), "gbifdownload", key)
  utils::unzip(path, exdir = tmpdir, overwrite = TRUE)
  xx <- list.files(tmpdir)
  if (any(grepl("occurrence.txt", xx))) {
    tpath <- "occurrence.txt"
  } else if (any(grepl("\\.csv", xx))) {
    tpath <- grep("\\.csv", xx, value = TRUE)
    if (length(tpath) > 1) stop("more than one .csv file found", call. = FALSE)
  }
  targetpath <- file.path(tmpdir, tpath)
  if (!file.exists(tmpdir)) stop("appropriate file not found", call. = FALSE)
  tibble::as_tibble(
    data.table::fread(targetpath, data.table = FALSE, fill = fill, ...)
  )
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
