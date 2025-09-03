#' Search for installations 
#'
#' @param query A search query string. 
#' @param type Choose from : IPT_INSTALLATION, DGIR INSTALLATION, TAPIR_INSTALLATION,
#' BIOCASE_INSTALLATION, HTTP_INSTALLATION, SYMBIOTA_INSTALLATION, 
#' EARTHCAPE_INSTALLATION, MDT_INSTALLATION. Only accepts one value.
#' @param identifierType Choose from : URL, LSID, HANDLER, DOI, UUID, FTP, URI, 
#' UNKNOWN, GBIF_PORTAL, GBIF_NODE, GBIF_PARTICIPANT, GRSCICOLL_ID, 
#' GRSCICOLL_URI, IH_IRN, ROR, GRID, CITES, SYMBIOTA_UUID, WIKIDATA, 
#' NCBI_BIOCOLLECTION, ISIL, CLB_DATASET_KEY. 
#' @param identifier An identifier of the type given by the identifierType 
#' parameter, for example a DOI or UUID.
#' @param machineTagNamespace Filters for entities with a machine tag in the 
#' specified namespace.
#' @param machineTagName Filters for entities with a machine tag with the 
#' specified name (use in combination with the machineTagNamespace parameter).
#' @param machineTagValue Filters for entities with a machine tag with the 
#' specified value (use in combination with the machineTagNamespace and 
#' machineTagName parameters).
#' @param modified The modified date of the dataset. Accepts ranges and 
#' a `*` can be used as a wildcard, e.g. modified=2023-04-01,`*`
#' @param limit The maximum number of results to return. Defaults to 20.
#' @param offset The offset of the first result to return. 
#' @param curlopts A list of curl options to pass to the request.
#'
#' @return A `list`
#' 
#' @export
#'
#' @examples \dontrun{
#' installation_search() 
#' installation_search(query="Estonia")
#' installation_search(type="IPT_INSTALLATION") 
#' installation_search(modified="2023-04-01,*")
#' 
#' }


installation_search <- function(
    query = NULL,
    type = NULL,
    identifierType = NULL,
    identifier = NULL,
    machineTagNamespace = NULL,
    machineTagName = NULL,
    machineTagValue = NULL,
    modified = NULL,
    limit = 20,
    offset = NULL,
    curlopts = list()
  ) {
  
  assert(query,"character")
  assert(identifierType, "character")
  assert(identifier, "character")
  assert(machineTagNamespace, "character")
  assert(machineTagName, "character")
  assert(machineTagValue, "character")
  assert(modified, "character")
  
  type_choices <- c("IPT_INSTALLATION", "DGIR INSTALLATION",
                    "TAPIR_INSTALLATION", "BIOCASE_INSTALLATION",
                    "HTTP_INSTALLATION", "SYMBIOTA_INSTALLATION",
                    "EARTHCAPE_INSTALLATION", "MDT_INSTALLATION")
  if(is.null(type)) { type = NULL } else { type = match.arg(type, type_choices) }
  indentifierType_choices <- c("URL", "LSID", "HANDLER", "DOI", "UUID",
                               "FTP", "URI", "UNKNOWN", "GBIF_PORTAL",
                               "GBIF_NODE", "GBIF_PARTICIPANT", "GRSCICOLL_ID",
                               "GRSCICOLL_URI", "IH_IRN", "ROR", "GRID",
                               "CITES", "SYMBIOTA_UUID", "WIKIDATA",
                               "NCBI_BIOCOLLECTION", "ISIL", "CLB_DATASET_KEY")
  
  
  if(is.null(identifierType)) { identifierType = NULL } else { 
    identifierType = match.arg(identifierType, indentifierType_choices) 
  }
  
  if (xor(is.null(identifierType), is.null(identifier))) {
    stop("Both 'identifierType' and 'identifier' must be provided 
         together or both be NULL.")
  }
  
  args <- rgbif_compact(list(
    q = query,
    type = type,
    identifierType = identifierType,
    identifier = identifier,
    machineTagNamespace = machineTagNamespace,
    machineTagName = machineTagName,
    machineTagValue = machineTagValue,
    modified = modified,
    limit = limit,
    offset = offset
  ))
  
  url <- paste0(gbif_base(), "/installation")
  tt <- gbif_GET(url, args, TRUE, curlopts)
  
  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]
  
  # data
  out <- tibble::as_tibble(tt$results)
  list(meta = data.frame(meta), data = out)
}