#' Search datasets.
#' 
#' This function does not search occurrence data, only the datasets that may
#' contain occurrence data
#' 
#' @import httr
#' @importFrom plyr compact
#' @template occsearch
#' @param type 
#' @param keyword 
#' @param owningOrg
#' @param networkOrigin
#' @param hostingOrg
#' @param decade
#' @param country
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
#' 
#' # Limited search
#' dataset_search(type="OCCURRENCE", limit=2)
#' dataset_search(type="OCCURRENCE", limit=2, start=10)
#' 
#' # Return just descriptions
#' dataset_search(type="OCCURRENCE", description=TRUE)
#' 
#' # Return metadata in a more human readable way (hard to manipulate though)
#' dataset_search(type="OCCURRENCE", pretty=TRUE)
#' }
dataset_search <- function(query= NULL, type = NULL, keyword = NULL,
  owningOrg = NULL, networkOrigin = NULL, hostingOrg = NULL, decade = NULL, 
  country = NULL, limit=20, start=NULL, callopts=list(), pretty=FALSE, 
  description=FALSE)
{
  url <- 'http://api.gbif.org/dataset/search'
  args <- compact(list(q=query,type=type,keyword=keyword,owningOrg=owningOrg,
                       networkOrigin=networkOrigin,hostingOrg=hostingOrg,
                       decade=decade,country=country,limit=limit,offset=start))
  tt <- content(GET(url, query=args, callopts))
  meta <- tt[!names(tt) == 'results']
  tt$results[[1]]
  
  parse_dataset <- function(x){
    data.frame(title=x$title,hostingOrganization=x$hostingOrganizationTitle,
               owningOrganization=x$owningOrganizationTitle,
               type=x$type,publishingCountry=x$publishingCountry,key=x$key,
               hostingOrganizationKey=x$hostingOrganizationKey,
               owningOrganizationKey=x$owningOrganizationKey)
  }
  
  if(description){
    out <- lapply(tt$results, "[[", "description")
    names(out) <- sapply(tt$results, "[[", "title")
  } else
  {
    if(length(tt$results)==1){
      out <- parse_dataset(x=tt$results)
    } else
    {
      out <- do.call(rbind, lapply(tt$results, parse_dataset))
    }
  }
  
  if(pretty){
    printdata <- function(x){    
      cat(paste("title:", x$title),
          paste("hostingOrganization:", x$hostingOrganizationTitle),
          paste("owningOrganization:", x$owningOrganizationTitle),
          paste("type:", x$type),
          paste("publishingCountry:", x$publishingCountry),
          paste("hostingOrganizationKey:", x$hostingOrganizationKey),
          paste("owningOrganizationKey:", x$owningOrganizationKey), 
          paste("description:", x$description), "\n", sep="\n")
    }
    if(length(tt$results)==1){
      printdata(tt$results)
    } else
    {
      lapply(tt$results, printdata)[[1]]
    }
  } else
  {
    return( out )
  }
}