#' List datasets that are deleted or have no endpoint. 
#' 
#' 
#' @param limit Controls the number of results in the page. 
#' @param start Determines the start for the search results.
#' @param curlopts options passed on to [crul::HttpClient].
#'
#' @return A `list`.
#'
#' @details
#' Get a list of deleted datasets or datasets with no endpoint. You get the full
#' and no parameters aside from `limit` and `start` are accepted. 
#' 
#'
#' @examples \dontrun{
#' dataset_noendpoint(limit=3)
#' }

#' @name dataset_list_funs
#' @export
dataset_duplicate <- function(limit=20,start=NULL,curlopts=list()) {
  dataset_list_get_(endpoint="duplicate/",limit=limit,start=start,
                    curlopts=curlopts,meta=TRUE) 
}

#' @name dataset_list_funs
#' @export
dataset_noendpoint <- function(limit=20,start=NULL,curlopts=list()) {
  dataset_list_get_(endpoint="withNoEndpoint/",limit=limit,start=start,
                    curlopts=curlopts,meta=TRUE) 
}
    
dataset_list_get_ <- function(endpoint,limit=NULL,start=NULL,curlopts,meta) {
  url <- paste0(gbif_base(),"/dataset/",endpoint)
  if(!is.null(limit)) {
    args <- rgbif_compact(c(limit=limit,offset=start))
    tt <- gbif_GET(url, args, TRUE, curlopts)
  } else {
    tt <- gbif_GET(url, args = NULL, TRUE, curlopts)
  }
  if(meta) {
    meta <- tt[c('offset','limit','endOfRecords','count')]
    if (length(tt$results) == 0) {
      out <- NULL
    } else {
      out <- tibble::as_tibble(tt$results)  
    }
    list(meta = data.frame(meta), data = out) 
  } else {
    tibble::as_tibble(tt)
  }
}
