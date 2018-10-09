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
#' @references <http://www.gbif.org/developer/registry#datasetSearch>
#'
#' @examples \dontrun{
#' # Gets all datasets of type "OCCURRENCE".
#' dataset_search(type="OCCURRENCE", limit = 10)
#'
#' # Fulltext search for all datasets having the word "amsterdam" somewhere in
#' # its metadata (title, description, etc).
#' dataset_search(query="amsterdam", limit = 10)
#'
#' # Limited search
#' dataset_search(type="OCCURRENCE", limit=2)
#' dataset_search(type="OCCURRENCE", limit=2, start=10)
#'
#' # Return just descriptions
#' dataset_search(type="OCCURRENCE", return="descriptions", limit = 10)
#'
#' # Return metadata in a more human readable way (hard to manipulate though)
#' dataset_search(type="OCCURRENCE", pretty=TRUE, limit = 10)
#'
#' # Search by country code. Lookup isocodes first, and use US for United States
#' isocodes[agrep("UNITED", isocodes$gbif_name),]
#' dataset_search(country="US", limit = 10)
#'
#' # Search by decade
#' dataset_search(decade=1980, limit = 10)
#'
#' # Faceting
#' ## just facets
#' dataset_search(facet="decade", facetMincount="10", limit=0)
#'
#' ## data and facets
#' dataset_search(facet="decade", facetMincount="10", limit=2)
#'
#' # Some parameters accept many inputs, treated as OR
#' dataset_search(type = c("metadata", "checklist"))$data
#' dataset_search(keyword = c("fern", "algae"))$data
#' dataset_search(publishingOrg = c("e2e717bf-551a-4917-bdc9-4fa0f342c530",
#'   "90fd6680-349f-11d8-aa2d-b8a03c50a862"))$data
#' dataset_search(hostingOrg = c("c5f7ef70-e233-11d9-a4d6-b8a03c50a862",
#'   "c5e4331-7f2f-4a8d-aa56-81ece7014fc8"))$data
#' dataset_search(publishingCountry = c("DE", "NZ"))$data
#' dataset_search(decade = c(1910, 1930))$data
#'
#' ## curl options
#' dataset_search(facet="decade", facetMincount="10", limit=2,
#'   curlopts = list(verbose=TRUE))
#' }

dataset_search <- function(query = NULL, country = NULL, type = NULL,
  keyword = NULL, publishingOrg = NULL, hostingOrg = NULL,
  publishingCountry = NULL, decade = NULL, facet=NULL, facetMincount=NULL,
  facetMultiselect=NULL, limit=100, start=NULL, pretty=FALSE, return="all",
  curlopts = list()) {

  if (!is.null(facetMincount) && inherits(facetMincount, "numeric")) {
    stop("Make sure facetMincount is character", call. = FALSE)
  }
  if (!is.null(facet)) {
    facetbyname <- facet
    names(facetbyname) <- rep('facet', length(facet))
  } else {
    facetbyname <- NULL
  }

  type <- as_many_args(type)
  keyword <- as_many_args(keyword)
  publishingOrg <- as_many_args(publishingOrg)
  hostingOrg <- as_many_args(hostingOrg)
  publishingCountry <- as_many_args(publishingCountry)
  decade <- as_many_args(decade)

  url <- paste0(gbif_base(), '/dataset/search')
  args <- as.list(
    rgbif_compact(c(q=query, limit=limit, offset=start, facetbyname,
                    facetMincount=facetMincount,
                    facetMultiselect=facetMultiselect)))
  args <- c(args, type, keyword, publishingOrg, hostingOrg,
            publishingCountry, decade)
  tt <- gbif_GET(url, args, FALSE, curlopts)

  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]

  # if pretty
  if (pretty) {
    if (length(tt$results) == 1) {
      printdata(tt$results)
    } else {
      lapply(tt$results, printdata)[[1]]
    }
  } else {
    # facets
    facets <- tt$facets
    if (!length(facets) == 0) {
      facetsdat <- lapply(facets, function(x)
        do.call(rbind, lapply(x$counts, data.frame, stringsAsFactors = FALSE)))
      names(facetsdat) <- facet
    } else {
      facetsdat <- NULL
    }

    # descriptions
    descs <- lapply(tt$results, "[[", "description")
    names(descs) <- sapply(tt$results, "[[", "title")

    # data
    if (length(tt$results) == 0) {
      out <- NULL
    } else if (length(tt$results) == 1) {
      out <- parse_dataset(x = tt$results)
    } else {
      out <- tibble::as_data_frame(do.call(rbind_fill,
                                           lapply(tt$results, parse_dataset)))
    }

    # select output
    return <- match.arg(return, c("meta", "descriptions", "data",
                                  "facets", "all"))
    switch(return,
           meta = data.frame(meta),
           descriptions = descs,
           data = out,
           facets = facetsdat,
           all = list(meta = data.frame(meta), data = out,
                      facets = facetsdat, descriptions = descs))
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
  data.frame(tmp, stringsAsFactors = FALSE)
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
