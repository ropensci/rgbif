#' Search for catalog numbers, collection codes, collector names, and institution 
#' codes.
#' 
#' @import httr plyr
#' @template all
#' @param type Type of data, one of catalog_number, collection_code, collector_name, 
#' institution_code. Unique partial strings work too, like 'cat' for catalog_number
#' @param q Search term
#' @param limit Number of results, default=5
#' @param callopts Args passed on to \code{httr::GET}
#' @param pretty Pretty as true (Default) uses cat to print data, FALSE gives 
#' character strings.
#' @examples \dontrun{
#' # catalog number
#' occ_metadata(type = "catalog_number", q=122)
#' 
#' # collection code
#' occ_metadata(type = "collection_code", q=12)
#' 
#' # collector name
#' occ_metadata(type = "collector_name", q='juan')
#' 
#' # institution code
#' occ_metadata(type = "institution_code", q='GB')
#' 
#' # data as character strings
#' occ_metadata(type = "catalog_number", q=122, pretty=FALSE)
#' 
#' # Change number of results returned
#' occ_metadata(type = "catalog_number", q=122, limit=10)
#' 
#' # Partial unique type strings work too
#' occ_metadata(type = "cat", q=122)
#' }
#' @export
occ_metadata <- function(type = "catalog_number", q=NULL, limit=5, 
                         callopts=list(), pretty=TRUE)
{
  type <- match.arg(type, choices=c("catalog_number","collection_code",
                                    "collector_name","institution_code"))
  url <- sprintf('http://api.gbif.org/v0.9/occurrence/search/%s', type)
  args <- compact(list(q = q, limit = limit))
  tt <- GET(url, query=args, callopts)
  stop_for_status(tt)
  if(pretty){
    cat(content(tt), sep="\n")
  } else
  { content(tt) }
}