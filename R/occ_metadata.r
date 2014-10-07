#' Search for catalog numbers, collection codes, collector names, and institution 
#' codes.
#' 
#' @import httr plyr assertthat
#' @export
#' 
#' @param type Type of data, one of catalog_number, collection_code, collector_name, 
#' institution_code. Unique partial strings work too, like 'cat' for catalog_number
#' @param q Search term
#' @param limit Number of results, default=5
#' @param callopts Args passed on to \code{httr::GET}
#' @param pretty Pretty as true (Default) uses cat to print data, FALSE gives 
#' character strings.
#' 
#' @references \url{http://www.gbif.org/developer/occurrence#search}
#' 
#' @examples \dontrun{
#' # catalog number
#' occ_metadata(type = "catalogNumber", q=122)
#' 
#' # collection code
#' occ_metadata(type = "collectionCode", q=12)
#' 
#' # institution code
#' occ_metadata(type = "institutionCode", q='GB')
#' 
#' # data as character strings
#' occ_metadata(type = "catalogNumber", q=122, pretty=FALSE)
#' 
#' # Change number of results returned
#' occ_metadata(type = "catalogNumber", q=122, limit=10)
#' 
#' # Partial unique type strings work too
#' occ_metadata(type = "cat", q=122)
#' }
#' 
#' @examples \donttest{
#' # collector name - collector_name endpoint down on 2014-04-23
#' occ_metadata(type = "collector_name", q='jane')
#' }

occ_metadata <- function(type = "catalogNumber", q=NULL, limit=5, callopts=list(), pretty=TRUE)
{
  type <- match.arg(type, c("catalogNumber","collectionCode","collectorName","institutionCode"))
  url <- sprintf('%s/occurrence/search/%s', gbif_base(), type)
  args <- rgbif_compact(list(q = q, limit = limit))
  out <- gbif_GET(url, args, callopts, TRUE)
  
  if(pretty)
    cat(out, sep="\n")
  else
    out
}
