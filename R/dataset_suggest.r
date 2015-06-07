#' Suggest datasets in GBIF.
#'
#' Search that returns up to 20 matching datasets. Results are ordered by relevance.
#'
#' @export
#' @template otherlimstart
#' @template occ
#' @template dataset
#'
#' @param subtype NOT YET IMPLEMENTED. Will allow filtering of datasets by their
#'    dataset subtypes, DC or EML.
#' @param continent Not yet implemented, but will eventually allow filtering datasets
#'    by their continent(s) as given in our Continent enum.
#' @param description Return descriptions only (TRUE) or all data (FALSE, default)
#'
#' @references \url{http://www.gbif.org/developer/registry#datasetSearch}
#'
#' @examples \dontrun{
#' # Suggest datasets of type "OCCURRENCE".
#' dataset_suggest(query="Amazon", type="OCCURRENCE")
#'
#' # Suggest datasets tagged with keyword "france".
#' dataset_suggest(keyword="france")
#'
#' # Suggest datasets owned by the organization with key
#' # "07f617d0-c688-11d8-bf62-b8a03c50a862" (UK NBN).
#' head(dataset_suggest(owningOrg="07f617d0-c688-11d8-bf62-b8a03c50a862"))
#'
#' # Fulltext search for all datasets having the word "amsterdam" somewhere in
#' # its metadata (title, description, etc).
#' head(dataset_suggest(query="amsterdam"))
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
#' head(dataset_suggest(country="US"))
#'
#' # Search by decade
#' head(dataset_suggest(decade=1980))
#'
#' # httr options
#' library('httr')
#' dataset_suggest(type="OCCURRENCE", limit=2, config=verbose())
#' }

dataset_suggest <- function(query = NULL, country = NULL, type = NULL, subtype = NULL,
  keyword = NULL, owningOrg = NULL, publishingOrg = NULL, hostingOrg = NULL,
  publishingCountry = NULL, decade = NULL, continent = NULL, limit=100, start=NULL,
  pretty=FALSE, description=FALSE, ...)
{
  url <- paste0(gbif_base(), '/dataset/suggest')
  args <- rgbif_compact(list(q=query,type=type,keyword=keyword,owningOrg=owningOrg,
                       publishingOrg=publishingOrg,
                       hostingOrg=hostingOrg,publishingCountry=publishingCountry,
                       decade=decade,limit=limit,offset=start))
  tt <- gbif_GET(url, args, FALSE, ...)

  if(description){
    out <- sapply(tt, "[[", "description")
    names(out) <- sapply(tt, "[[", "title")
    out <- rgbif_compact(out)
  } else
  {
    if(length(tt)==1){
      out <- parse_suggest(x=tt$results)
    } else
    {
      out <- do.call(rbind_fill, lapply(tt, parse_suggest))
    }
  }

  if(pretty){
    if(length(tt)==1){
      invisible(print_suggest(tt))
    } else
    {
      invisible(lapply(tt, print_suggest)[[1]])
    }
  } else
  {
    return( out )
  }
}

parse_suggest <- function(x){
  tmp <- rgbif_compact(list(
    key=x$key,
    type=x$type,
    title=x$title
  ))
  data.frame(tmp, stringsAsFactors=FALSE)
}

print_suggest <- function(x){
  cat(
    paste("datasetKey:", x$key),
    paste("type:", x$type),
    paste("datasetTitle:", x$title),
    paste("description:", x$description),
    "\n", sep="\n")
}
