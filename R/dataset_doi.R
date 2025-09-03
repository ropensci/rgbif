#' Get a GBIF dataset from a doi
#'
#' @param doi the doi of the dataset you wish to lookup. 
#' @param limit Controls the number of results in the page.
#' @param start Determines the offset for the search results.
#' @param curlopts options passed on to [crul::HttpClient]. 
#' 
#' @details This function allows for dataset lookup using a doi. Be aware that 
#' some doi have more than one dataset associated with them. 
#' 
#' @return A `list`. 
#' @export
#'
#' @examples \dontrun{
#' dataset_doi('10.15468/igasai')
#' }
dataset_doi <- function(doi = NULL, 
                        limit = 20, 
                        start = NULL, 
                        curlopts = list(http_version = 2)) {
  assert(doi,"character")
  is_doi <- grepl("^(10\\.\\d{4,9}/[-._;()/:A-Z0-9]+)$", doi, perl = TRUE, 
                  ignore.case = TRUE)
  if(!is_doi) warning("The doi you supplied might not be valid.")
  url <- paste0(gbif_base(), '/dataset/doi/',doi)
  args <- rgbif_compact(list(limit = as.integer(limit),
                             offset = start))
  res <- gbif_GET(url, args, TRUE, curlopts)
  structure(list(meta = get_meta(res), data = parse_results(res,NULL)))
}
