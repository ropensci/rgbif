#' Suggest datasets in GBIF.
#' 
#' Search that returns up to 20 matching datasets. Results are ordered by relevance.
#' 
#' @template all
#' @import httr plyr
#' @template occ
#' @param query Query term(s) for full text search.  The value for this parameter 
#'    can be a simple word or a phrase. Wildcards can be added to the simple word 
#'    parameters only, e.g. q=*puma*
#' @param country NOT YET IMPLEMENTED. Filters by country as given in \code{\link{isocodes$gbif_name}}, 
#'    e.g. country=CANADA.
#' @param type Type of dataset, options include OCCURRENCE, METADATA, and CHECKLIST.
#' @param subtype NOT YET IMPLEMENTED. Will allow filtering of datasets by their 
#'    dataset subtypes, DC or EML.
#' @param keyword Keyword to search by. Datasets can be tagged by keywords, which
#'    you can search on. The search is done on the merged collection of tags, the 
#'    dataset keywordCollections and temporalCoverages.
#' @param owning_org Owning organization. A uuid string. See \code{\link{organizations}}
#' @param hosting_org Hosting organization. A uuid string. See \code{\link{organizations}}
#' @param publishing_country Publishing country. See options at \code{\link{isocodes$gbif_name}}
#' @param decade Decade, e.g., 1980. Filters datasets by their temporal coverage 
#'    broken down to decades. Decades are given as a full year, e.g. 1880, 1960, 2000, 
#'    etc, and will return datasets wholly contained in the decade as well as those 
#'    that cover the entire decade or more. Facet by decade to get the break down, 
#'    e.g. /search?facet=DECADE&facet_only=true (see example below)
#' @param continent A continent. NOT YET IMPLEMENTED.
#' @param pretty Print informative metadata using \code{\link{cat}}. Not easy to 
#'    manipulate output though - just for viewing in console.
#' @param description Return descriptions only (TRUE) or all data without 
#'    the description (FALSE, default)
#' @return A data.frame, list, or message printed to console (using pretty=TRUE).
#' @export
#' @examples \dontrun{
#' # Suggest datasets of type "OCCURRENCE".
#' dataset_suggest(query="Amazon", type="OCCURRENCE")
#' 
#' # Suggest datasets tagged with keyword "france".
#' dataset_suggest(keyword="france")
#' 
#' # Suggest datasets owned by the organization with key 
#' # "07f617d0-c688-11d8-bf62-b8a03c50a862" (UK NBN).
#' dataset_suggest(owning_org="07f617d0-c688-11d8-bf62-b8a03c50a862")
#' 
#' # Fulltext search for all datasets having the word "amsterdam" somewhere in 
#' # its metadata (title, description, etc).
#' dataset_suggest(query="amsterdam")
#' 
#' # Limited search
#' dataset_suggest(type="OCCURRENCE", limit=2)
#' dataset_suggest(type="OCCURRENCE", limit=2, start=10)
#' 
#' # Return just descriptions
#' dataset_suggest(type="OCCURRENCE", description=TRUE)
#' 
#' # Return metadata in a more human readable way (hard to manipulate though)
#' dataset_suggest(type="OCCURRENCE", pretty=TRUE)
#' 
#' # Search by country code. Lookup isocodes first, and use US for United States
#' isocodes[agrep("UNITED", isocodes$gbif_name),]
#' dataset_suggest(country="UNITED_STATES")
#' 
#' # Search by decade
#' dataset_suggest(decade=1980)
#' }
dataset_suggest <- function(query = NULL, country = NULL, type = NULL, subtype = NULL, 
  keyword = NULL, owning_org = NULL, hosting_org = NULL, publishing_country = NULL, 
  decade = NULL, continent = NULL, limit=20, start=NULL, callopts=list(), 
  pretty=FALSE, description=FALSE)
{
  url <- 'http://api.gbif.org/v0.9/dataset/suggest'
  args <- compact(list(q=query,type=type,keyword=keyword,owning_org=owning_org,
                       hosting_org=hosting_org,publishing_country=publishing_country,
                       decade=decade,limit=limit,offset=start))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  
  parse_dataset <- function(x){
    tmp <- compact(list(
      key=x$key,
      type=x$type,
      title=x$title,
      hostingOrganization=x$hostingOrganizationTitle,
      hostingOrganizationKey=x$hostingOrganizationKey,
      owningOrganization=x$owningOrganizationTitle,
      owningOrganizationKey=x$owningOrganizationKey,
      publishingCountry=x$publishingCountry
    ))
    data.frame(tmp)
  }
  
  if(description){
    out <- lapply(tt, "[[", "description")
    names(out) <- sapply(tt, "[[", "title")
  } else
  {
    if(length(tt)==1){
      out <- parse_dataset(x=tt$results)
    } else
    {
      out <- do.call(rbind.fill, lapply(tt, parse_dataset))
    }
  }
  
  if(pretty){
    printdata <- function(x){    
      cat(
        paste("type:", x$key),
        paste("type:", x$type),
        paste("title:", x$title),
        paste("hostingOrganization:", x$hostingOrganizationTitle),
        paste("hostingOrganizationKey:", x$hostingOrganizationKey),
        paste("owningOrganization:", x$owningOrganizationTitle),
        paste("owningOrganizationKey:", x$owningOrganizationKey), 
        paste("publishingCountry:", x$publishingCountry),
        paste("description:", x$description
        ), "\n", sep="\n")
    }
    if(length(tt)==1){
      invisible(printdata(tt))
    } else
    {
      invisible(lapply(tt, printdata)[[1]])
    }
  } else
  {
    return( out )
  }
}