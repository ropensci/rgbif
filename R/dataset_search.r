#' Search datasets.
#' 
#' This function does not search occurrence data, only the datasets that may
#' contain occurrence data
#' 
#' @import httr
#' @importFrom plyr compact
#' @param query
#' @param type 
#' @param keyword 
#' @param owningOrg
#' @param networkOrigin
#' @param hostingOrg
#' @param decade
#' @param country
#' @param callopts Further args passed on to GET.
#' @export
#' @examples \dontrun{
#' # Gets all datasets of type "OCCURRENCE".
#' dataset_search(type="OCCURRENCE")
#' 
#' # Gets all datasets tagged with keyword "france".
#' dataset_search(keyword="france")
#' 
#' # Gets all datasets owned by the organization with key 
#' # "07f617d0-c688-11d8-bf62-b8a03c50a862" (UK NBN).
#' dataset_search(owningOrg="07f617d0-c688-11d8-bf62-b8a03c50a862")
#' 
#' # Fulltext search for all datasets having the word "amsterdam" somewhere in 
#' # its metadata (title, description, etc).
#' dataset_search(query="amsterdam")
#' }
dataset_search <- function(query= NULL, type = NULL, keyword = NULL, 
  owningOrg = NULL, networkOrigin = NULL, hostingOrg = NULL, decade = NULL, 
  country = NULL, callopts=list())
{
  url <- 'http://api.gbif.org/dataset/search'
  args <- compact(list(q=query,type=type,keyword=keyword,owningOrg=owningOrg,
                       networkOrigin=networkOrigin,hostingOrg=hostingOrg,
                       decade=decade,country=country))
  tt <- content(GET(url, query=args, callopts))
  tt
}