#' Search datasets in GBIF.
#'
#' This function does not search occurrence data, only metadata on the datasets
#' that contain occurrence data.
#'
#' @export
#' @template otherlimstart
#' @template occ
#' @template dataset
#' @template dataset_facet
#' @param return What to return. One of meta, descriptions, data, facets,
#'    or all (Default).
#'
#' @references \url{http://www.gbif.org/developer/registry#datasetSearch}
#'
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
#' dataset_search(country="US")
#'
#' # Search by decade
#' dataset_search(decade=1980)
#'
#' # Faceting
#' ## just facets
#' dataset_search(facet="decade", facetMincount="10", limit=0)
#'
#' ## data and facets
#' dataset_search(facet="decade", facetMincount="10", limit=2)
#'
#' ## httr options
#' library('httr')
#' dataset_search(facet="decade", facetMincount="10", limit=2, config=verbose())
#' }

dataset_search <- function(query = NULL, country = NULL, type = NULL, keyword = NULL,
  owningOrg = NULL, publishingOrg = NULL, hostingOrg = NULL, publishingCountry = NULL,
  decade = NULL, facet=NULL, facetMincount=NULL, facetMultiselect=NULL, limit=100,
  start=NULL, pretty=FALSE, return="all", ...)
{
  if(!is.null(facetMincount) && inherits(facetMincount, "numeric"))
    stop("Make sure facetMincount is character")
  if(!is.null(facet)) {
    facetbyname <- facet
    names(facetbyname) <- rep('facet', length(facet))
  } else { facetbyname <- NULL }

  url <- paste0(gbif_base(), '/dataset/search')
  args <- as.list(rgbif_compact(c(q=query,type=type,keyword=keyword,owningOrg=owningOrg,
                       publishingOrg=publishingOrg,
                       hostingOrg=hostingOrg,publishingCountry=publishingCountry,
                       decade=decade,limit=limit,offset=start,facetbyname,
                       facetMincount=facetMincount,
                       facetMultiselect=facetMultiselect)))
  tt <- gbif_GET(url, args, FALSE, ...)

  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]

  # if pretty
  if(pretty){
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
      out <- do.call(rbind_fill, lapply(tt$results, parse_dataset))
    }

    # select output
    return <- match.arg(return, c("meta", "descriptions", "data", "facets", "all"))
    switch(return,
           meta = data.frame(meta),
           descriptions = descs,
           data = out,
           facets = facetsdat,
           all = list(meta=data.frame(meta), data=out, facets=facetsdat, descriptions=descs))
  }
}

parse_dataset <- function(x){
  tmp <- rgbif_compact(list(datasetTitle=x$title,
                      datasetKey=x$key,
                      type=x$type,
                      hostingOrganization=x$hostingOrganizationTitle,
                      hostingOrganizationKey=x$hostingOrganizationKey,
                      publishingOrganization=x$publishingOrganizationTitle,
                      publishingOrganizationKey=x$publishingOrganizationKey,
                      publishingCountry=x$publishingCountry))
  data.frame(tmp, stringsAsFactors=FALSE)
}

printdata <- function(x){
  cat(paste("datasetTitle:", x$title),
      paste("datasetKey:", x$key),
      paste("type:", x$type),
      paste("hostingOrganization:", x$hostingOrganizationTitle),
      paste("hostingOrganizationKey:", x$hostingOrganizationKey),
      paste("publishingOrganization:", x$publishingOrganizationTitle),
      paste("publishingOrganizationKey:", x$publishingOrganizationKey),
      paste("publishingCountry:", x$publishingCountry),
      paste("description:", x$description), "\n", sep="\n")
  invisible(TRUE)
}
