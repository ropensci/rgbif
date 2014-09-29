#' Import a downloaded file from GBIF.
#' 
#' @importFrom data.table fread
#' @export
#'
#' @param x The output of a call to \code{occ_download_get}
#' @param key A key generated from a request, like that from \code{occ_download}
#' @param path Path to write file to. Default: "~/" your home directory, with a \code{.zip} 
#' appended to the end.
#' 
#' @details You can provide either x as input, or both key and path.
#'
#' @examples \donttest{
#' res <- occ_download_get(key="0000066-140928181241064")
#' occ_download_import(x=res)
#' 
#' occ_download_get(key="0000066-140928181241064") %>% occ_download_import
#' }

occ_download_import <- function(x=NULL, key=NULL, path="~/")
{
  if(!is.null(x)){
    assert_that(is(x, "occ_download_get"))
    path <- x[[1]]
    key <- attr(x, "key")
  } else {
    assert_that(!is.null(key), !is.null(path))
    path <- sprintf("%s/%s.zip", path, key)    
  }
  tmpdir <- file.path(tempdir(), key)
  unzip(path, exdir = tmpdir, overwrite = TRUE)
  dat <- data.frame(fread(file.path(tmpdir, "occurrence.txt")))
  structure(dat, class=c("gbif_download","data.frame"))
}

#' @export
print.gbif_download <- function (x, ..., n = 10)
{
  trunc_mat(x, n = n)
}
