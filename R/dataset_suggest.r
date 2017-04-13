#' Suggest datasets in GBIF.
#'
#' @export
#' @template otherlimstart
#' @template occ
#' @template dataset
#'
#' @param subtype NOT YET IMPLEMENTED. Will allow filtering of datasets by
#' their dataset subtypes, DC or EML.
#' @param continent Not yet implemented, but will eventually allow filtering
#' datasets by their continent(s) as given in our Continent enum.
#' @param description Return descriptions only (TRUE) or all data (FALSE,
#' default)
#'
#' @references <http://www.gbif.org/developer/registry#datasetSearch>
#'
#' @examples \dontrun{
#' # Suggest datasets of type "OCCURRENCE".
#' dataset_suggest(query="Amazon", type="OCCURRENCE")
#'
#' # Suggest datasets tagged with keyword "france".
#' dataset_suggest(keyword="france")
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
#' dataset_suggest(type="OCCURRENCE", limit = 5, description=TRUE)
#'
#' # Return metadata in a more human readable way (hard to manipulate though)
#' dataset_suggest(type="OCCURRENCE", limit = 5, pretty=TRUE)
#'
#' # Search by country code. Lookup isocodes first, and use US for United States
#' isocodes[agrep("UNITED", isocodes$gbif_name),]
#' dataset_suggest(country="US", limit = 25)
#'
#' # Search by decade
#' dataset_suggest(decade=1980, limit = 30)
#'
#' # Some parameters accept many inputs, treated as OR
#' dataset_suggest(type = c("metadata", "checklist"))
#' dataset_suggest(keyword = c("fern", "algae"))
#' dataset_suggest(publishingOrg = c("e2e717bf-551a-4917-bdc9-4fa0f342c530",
#'   "90fd6680-349f-11d8-aa2d-b8a03c50a862"))
#' dataset_suggest(hostingOrg = c("c5f7ef70-e233-11d9-a4d6-b8a03c50a862",
#'   "c5e4331-7f2f-4a8d-aa56-81ece7014fc8"))
#' dataset_suggest(publishingCountry = c("DE", "NZ"))
#' dataset_suggest(decade = c(1910, 1930))
#'
#' # curl options
#' dataset_suggest(type="OCCURRENCE", limit = 2, curlopts = list(verbose=TRUE))
#' }

dataset_suggest <- function(query = NULL, country = NULL, type = NULL,
  subtype = NULL, keyword = NULL, owningOrg = NULL, publishingOrg = NULL,
  hostingOrg = NULL, publishingCountry = NULL, decade = NULL, continent = NULL,
  limit=100, start=NULL, pretty=FALSE, description=FALSE, curlopts = list()) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("owningOrg") %in% calls
  if (any(calls_vec)) {
    stop("Parameters gone: owningOrg", call. = FALSE)
  }

  type <- as_many_args(type)
  keyword <- as_many_args(keyword)
  publishingOrg <- as_many_args(publishingOrg)
  hostingOrg <- as_many_args(hostingOrg)
  publishingCountry <- as_many_args(publishingCountry)
  decade <- as_many_args(decade)

  url <- paste0(gbif_base(), '/dataset/suggest')
  args <- rgbif_compact(list(q = query, limit = limit, offset = start))
  args <- c(args, type, keyword, publishingOrg, hostingOrg,
            publishingCountry, decade)
  tt <- gbif_GET(url, args, FALSE, curlopts)

  if (description) {
    out <- lapply(tt, "[[", "description")
    names(out) <- lapply(tt, "[[", "title")
    out <- rgbif_compact(out)
  } else {
    if (length(tt) == 1) {
      out <- parse_suggest(x = tt$results)
    } else {
      out <- tibble::as_data_frame(do.call(rbind_fill,
                                           lapply(tt, parse_suggest)))
    }
  }

  if (pretty) {
    if (length(tt) == 1) {
      invisible(print_suggest(tt))
    } else {
      invisible(lapply(tt, print_suggest)[[1]])
    }
  } else {
    return( out )
  }
}

parse_suggest <- function(x){
  tmp <- rgbif_compact(list(
    key = x$key,
    type = x$type,
    title = x$title
  ))
  tibble::as_data_frame(tmp)
}

print_suggest <- function(x){
  cat(
    paste("datasetKey:", x$key),
    paste("type:", x$type),
    paste("datasetTitle:", x$title),
    paste("description:", x$description),
    "\n", sep = "\n")
}
