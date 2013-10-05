#' Search datasets in GBIF.
#' 
#' This function does not search occurrence data, only metadata on the datasets 
#' that contain occurrence data.
#'
#' @template all
#' @import httr
#' @import plyr
#' @template occ
#' @param query Query term(s) for full text search.
#' @param type Type of dataset, options include OCCURRENCE, etc.
#' @param keyword Keyword to search by. Datasets can be tagged by keywords, which
#'    you can search on.
#' @param owningOrg Hosting organization. A uuid string. See \code{\link{organizations}}
#' @param networkOrigin Hosting organization. A uuid string. See \code{\link{organizations}}
#' @param hostingOrg Hosting organization. A uuid string. See \code{\link{organizations}}
#' @param decade Decade, e.g., 1980
#' @param country Limit search to a country using isocodes. See example.
#' @param pretty Print informative metadata using \code{\link{cat}}. Not easy to 
#'    manipulate output though.
#' @param description Return descriptions only (TRUE) or all data (FALSE, default)
#' @return A data.frame, list, or message printed to console (using pretty=TRUE).
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
#' 
#' # Search by country code. Lookup isocodes first, and use US for United States
#' isocodes[agrep("united", isocodes$name),]
#' dataset_search(country="US")
#' 
#' # Search by decade
#' dataset_search(decade=1980)
#' }
dataset_search <- function(query= NULL, type = NULL, keyword = NULL,
  owningOrg = NULL, networkOrigin = NULL, hostingOrg = NULL, decade = NULL, 
  country = NULL, limit=20, start=NULL, callopts=list(), pretty=FALSE, 
  description=FALSE)
{
  url <- 'http://api.gbif.org/v0.9/dataset/search'
  args <- compact(list(q=query,type=type,keyword=keyword,owningOrg=owningOrg,
                       networkOrigin=networkOrigin,hostingOrg=hostingOrg,
                       decade=decade,iso_country_code=country,limit=limit,
                       offset=start))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
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