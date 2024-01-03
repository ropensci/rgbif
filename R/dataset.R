#' Search for more obscure dataset metadata. 
#'
#' @param country The 2-letter country code (as per ISO-3166-1) of the country 
#' publishing the dataset.
#' @param type The primary type of the dataset. 
#' Available values : OCCURRENCE, CHECKLIST, METADATA, SAMPLING_EVENT, 
#' MATERIAL_ENTITY.
#' @param identifierType An identifier type for the identifier parameter.
#' Available values : URL, LSID, HANDLER, DOI, UUID, FTP, URI, UNKNOWN, 
#' GBIF_PORTAL, GBIF_NODE, GBIF_PARTICIPANT, GRSCICOLL_ID, GRSCICOLL_URI,
#' IH_IRN, ROR, GRID, CITES, SYMBIOTA_UUID, WIKIDATA, NCBI_BIOCOLLECTION.
#' @param identifier An identifier of the type given by the identifierType 
#' parameter. 
#' @param machineTagNamespace Filters for entities with a machine tag in the 
#' specified namespace.
#' @param machineTagName Filters for entities with a machine tag with the 
#' specified name (use in combination with the machineTagNamespace parameter).
#' @param machineTagValue Filters for entities with a machine tag with the 
#' specified value (use in combination with the machineTagNamespace and machineTagName parameters).
#' @param modified The modified date of the dataset. Accepts ranges and a '' 
#' can be used as a wildcard, e.g.:modified=2023-04-01,
#' @param query Simple full text search parameter. The value for this parameter 
#' can be a simple word or a phrase. Wildcards are not supported.
#' @param limit Controls the number of results in the page. 
#' @param start Determines the start for the search results.
#' @param curlopts options passed on to [crul::HttpClient].
#'
#' @return A `list`. 
#' 
#' @details
#' This function allows you to search for some more obscure dataset metadata
#' that might not be possible with `dataset_search()`. 
#' 
#' 
#' @export
#'
#' @examples \dontrun {
#' 
#' 
#' 
#' }
dataset <- function(country = NULL, 
                    type = NULL, 
                    identifierType = NULL, 
                    identifier = NULL, 
                    machineTagNamespace = NULL,
                    machineTagName = NULL, 
                    machineTagValue = NULL,
                    modified = NULL, 
                    query = NULL, 
                    limit = NULL, 
                    start = NULL,
                    curlopts = list()) {
  
  assert(country, "character") 
  assert(type, "character")
  assert(identifierType, "character") 
  assert(machineTagNamespace, "character")
  assert(machineTagName, "character")
  assert(machineTagValue, "character")
  assert(modified, "character")
  assert(query, "character")           
  
  args <- as.list(
    rgbif_compact(c(q=query,
                    limit=limit,
                    offset=start
    )))
  
  args <- as.list(
    rgbif_compact(c(
    args,
    convmany(country),
    convmany(type), 
    convmany(identifierType),
    convmany(identifier), 
    convmany(machineTagNamespace),
    convmany(machineTagName),
    convmany(machineTagValue),
    convmany(modified)
    )))
  
  url <- paste0(gbif_base(), '/dataset/')
  tt <- gbif_GET(url, args, FALSE, curlopts)
  
  meta <- tt[c('offset','limit','endOfRecords','count')]
  
  if (length(tt$results) == 0) {
    out <- NULL
  } else {
    nest_if_needed <- function(x) ifelse(length(x) > 1, list(x), x)
    out <- lapply(tt$results,function(x) tibble::as_tibble(lapply(x, nest_if_needed))) 
    out <- bind_rows(out)
    }
  
  list(meta = data.frame(meta), data = out)
} 




