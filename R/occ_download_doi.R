#' Get download meta data from a doi 
#'
#' @param doi (character) the doi of the download you want to get metadata for.
#'
#' @return a list. 
#' 
#' @export
#'
#' @examples \dontrun{
#' occ_download_doi("10.15468/dl.zdfkkf")
#' 
#' occ_download_doi("10.15468/dl.zdfkkf")$key %>%
#' occ_download_get() %>%
#' occ_download_import() 
#' 
#' }
#' 
occ_download_doi <- function(doi = NULL) {
  # https://api.gbif.org/v1/occurrence/download/10.15468/dl.zdfkkf
  assert(doi,"character")
  is_doi <- grepl("^(10\\.\\d{4,9}/[-._;()/:A-Z0-9]+)$", doi, perl = TRUE, 
                  ignore.case = TRUE)
  if(!is_doi) warning("The doi you supplied might not be valid.")
  
  url <- paste0("https://api.gbif.org/v1/occurrence/download/",doi)

  out <- gbif_GET(url,args=NULL,parse=TRUE)
  
  structure(out,class = "occ_download_doi")
}

#' @export
print.occ_download_doi <- function(x, ...){
  stopifnot(inherits(x, 'occ_download_doi'))
  cat_n("<<gbif download metadata from DOI>>")
  cat_n("  Status: ", x$status)
  cat_n("  DOI: ", x$doi)
  cat_n("  Format: ", attr(x, 'format'))
  cat_n("  Download key: ", x$key)
  cat_n("  Created: ", x$created)
  cat_n("  Modified: ", x$modified)
  cat_n("  Download link: ", x$downloadLink)
  cat_n("  Total records: ", n_with_status(x$totalRecords, x$status))
}

