#' Describes the fields available in GBIF downloads
#'
#' @param x a character string (default: "dwca"). Accepted values: 
#' "simpleCsv", "simpleAvro", "simpleParquet","speciesList".
#' 
#' @details
#' The function returns a list with the fields available in GBIF downloads. It 
#' is considered experimental by GBIF, so the output might change in the future. 
#' 
#' @return a list. 
#' @export
#'
#' @examples \dontrun{
#' occ_download_describe("dwca")$verbatimFields
#' occ_download_describe("dwca")$verbatimExtensions
#' occ_download_describe("simpleCsv")$fields
#' }
occ_download_describe <- function(x="dwca") {
  acc_args <- c("dwca","simpleCsv","simpleAvro","simpleParquet","speciesList","sql")
  stopifnot(x %in% acc_args)
  url <- paste0(gbif_base(),"/occurrence/download/describe/",x)
  out <- gbif_GET(url,args=NULL,parse=TRUE)

  if(x == "dwca") {
  out <- list(
    multimediaFields = out$multimedia$fields,
    verbatimFields = out$verbatim$fields,
    interpretedFields = out$interpreted$fields,
    verbatimExtensions = out$verbatimExtensions
  )
  } else {
    out <- list(fields = out$fields)
  }
  structure(out,
    class = "occ_download_describe",
    x = x
    )
}

#' @export
print.occ_download_describe <- function(x, ...) {
  stopifnot(inherits(x, 'occ_download_describe'))
  cat_n("<<download fields description>>")
  cat_n("A list with elements:")
  for(n in names(x)) cat_n("   ",n)
}

