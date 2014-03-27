#' Search datasets in GBIF.
#' 
#' This function does not search occurrence data, only metadata on the datasets 
#' that contain occurrence data.
#'
#' @import httr plyr
#' @template all
#' @template occ
#' @template dataset
#' @template dataset_facet
#' @param return What to return. One of meta, descriptions, data, facets, 
#'    or all (Default).
#' @export
#' @examples \dontrun{
#' # Gets all datasets of type "OCCURRENCE".
#' dataset_search(type="OCCURRENCE")
#' 
#' # Gets all datasets tagged with keyword "france".
#' dataset_search(keyword="france")
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
#' dataset_search(type="OCCURRENCE", return="descriptions")
#' 
#' # Return metadata in a more human readable way (hard to manipulate though)
#' dataset_search(type="OCCURRENCE", pretty=TRUE)
#' 
#' # Search by country code. Lookup isocodes first, and use US for United States
#' isocodes[agrep("UNITED", isocodes$gbif_name),]
#' dataset_search(country="UNITED_STATES")
#' 
#' # Search by decade
#' dataset_search(decade=1980)
#' 
#' # Faceting
#' ## just facets
#' dataset_search(facet="decade", facet_only=TRUE, facet_mincount="10")
#' 
#' ## data and facets
#' dataset_search(facet="decade", facet_mincount="10")
#' }
dataset_search <- function(query= NULL, country = NULL, type = NULL, keyword = NULL,
  owning_org = NULL, hosting_org = NULL, publishing_country = NULL, decade = NULL, 
  facet=NULL, facet_only=NULL, facet_mincount=NULL, facet_multiselect=NULL, limit=20, 
  start=NULL, callopts=list(), pretty=FALSE, return="all")
{
  if(!is.null(facet_mincount) && inherits(facet_mincount, "numeric"))
    stop("Make sure facet_mincount is character")
  if(!is.null(facet)) {
    facetbyname <- facet
    names(facetbyname) <- rep('facet', length(facet))
  } else { facetbyname <- NULL }
  
  url <- 'http://api.gbif.org/v0.9/dataset/search'
  args <- as.list(compact(c(q=query,type=type,keyword=keyword,owning_org=owning_org,
                       hosting_org=hosting_org,publishing_country=publishing_country,
                       decade=decade,limit=limit,offset=start,facetbyname, 
                       facet_only=facet_only, facet_mincount=facet_mincount, 
                       facet_multiselect=facet_multiselect)))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  assert_that(temp$headers$`content-type`=='application/json')
  res <- content(temp, as = 'text', encoding = "UTF-8")
  tt <- RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  
  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]
  
  parse_dataset <- function(x){
    tmp <- compact(list(title=x$title,
               hostingOrganization=x$hostingOrganizationTitle,
               owningOrganization=x$owningOrganizationTitle,
               type=x$type,
               publishingCountry=x$publishingCountry,
               key=x$key,
               hostingOrganizationKey=x$hostingOrganizationKey,
               owningOrganizationKey=x$owningOrganizationKey))
    data.frame(tmp, stringsAsFactors=FALSE)
  }
  
  # if pretty
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
    # facets
    facets <- tt$facets
    if(!length(facets) == 0){
      facetsdat <- lapply(facets, function(x) do.call(rbind, lapply(x$counts, data.frame, stringsAsFactors=FALSE)))
      names(facetsdat) <- facet
    } else { facetsdat <- NULL  }
    
    # descriptions
    descs <- lapply(tt$results, "[[", "description")
    names(descs) <- sapply(tt$results, "[[", "title")
    
    # data
    if(length(tt$results)==0){
      out <- "no results"
    } else if(length(tt$results)==1){
      out <- parse_dataset(x=tt$results)
    } else
    {
      out <- do.call(rbind.fill, lapply(tt$results, parse_dataset))
    }
    
    # select output
    switch(return, 
           meta = data.frame(meta),
           descriptions = descs,
           data = out,
           facets = facetsdat,
           all = list(meta=data.frame(meta), data=out, facets=facetsdat, descriptions=descs))
  }
}