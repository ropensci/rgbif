#' Search GRSciColl collections
#'
#' @param query Simple full text search parameter. The value for this parameter 
#' can be a simple word or a phrase. Wildcards are not supported.
#' @param name Name of a GrSciColl institution or collection.
#' @param fuzzyName It searches by name fuzzily so the parameter doesn't have 
#' to be the exact name.
#' @param preservationType Preservation type of a GrSciColl collection. Accepts 
#' multiple values.
#' @param contentType Content type of a GrSciColl collection. See here for 
#' accepted values : 
#' https://techdocs.gbif.org/en/openapi/v1/registry#/Collections/listCollections
#' @param numberSpecimens Number of specimens. It supports ranges and a `*` can 
#' be used as a wildcard.
#' @param accessionStatus Accession status of a GrSciColl collection. Accepted 
#' values : INSTITUTIONAL, PROJECT
#' @param personalCollection Flag for personal GRSciColl collections.
#' @param sourceId sourceId of MasterSourceMetadata.
#' @param source Source attribute of MasterSourceMetadata. Accepted values : 
#' DATASET, ORGANIZATION, IH_IRN
#' @param code Code of a GrSciColl institution or collection.
#' @param alternativeCode Alternative code of a GrSciColl institution or 
#' collection.
#' @param contact Filters collections and institutions whose contacts contain 
#' the person key specified.
#' @param institutionKey Keys of institutions to filter by.
#' @param country Filters by country given as a ISO 639-1 (2 letter) country 
#' code.
#' @param city Filters by the city of the address. It searches in both the 
#' physical and the mailing address.
#' @param gbifRegion Filters by a gbif region
#' Available values : AFRICA, ASIA, EUROPE, NORTH_AMERICA, OCEANIA, 
#' LATIN_AMERICA, ANTARCTICA.
#' @param machineTagNamespace Filters for entities with a machine tag in the 
#' specified namespace.
#' @param machineTagName Filters for entities with a machine tag with the 
#' specified name (use in combination with the machineTagNamespace parameter).
#' @param machineTagValue Filters for entities with a machine tag with the 
#' specified value (use in combination with the machineTagNamespace and 
#' machineTagName parameters).
#' @param identifier An identifier of the type given by the identifierType 
#' parameter, for example a DOI or UUID.
#' @param identifierType An identifier type for the identifier parameter. 
#' Available values : URL, LSID, HANDLER, DOI, UUID, FTP, URI, UNKNOWN, 
#' GBIF_PORTAL, GBIF_NODE, GBIF_PARTICIPANT, GRSCICOLL_ID, GRSCICOLL_URI, 
#' IH_IRN, ROR, GRID, CITES, SYMBIOTA_UUID, WIKIDATA, NCBI_BIOCOLLECTION, 
#' ISIL, CLB_DATASET_KEY.
#' @param active Active status of a GrSciColl institution or collection.
#' @param displayOnNHCPortal Flag to show this record in the NHC portal.
#' @param alternativeCode Alternative code of a GrSciColl institution or 
#' collection.
#' @param masterSourceType The master source type of a GRSciColl institution. 
#' or collection. Available values : GRSCICOLL, GBIF_REGISTRY, IH.
#' @param replacedBy Key of the entity that replaced another entity.
#' @param sortBy Field to sort the results by. It only supports the fields 
#' contained in the enum. Available values : NUMBER_SPECIMENS.
#' @param sortOrder Sort order to use with the sortBy parameter. 
#' Available values : ASC, DESC.
#' @param offset Determines the offset for the search results.
#' @param limit Controls the number of results in the page. Default 20. 
#' @param format (character) Format of the export. Default is "TSV". 
#' Only used for [collection_export].
#' @param curlopts curlopts options passed on to [crul::HttpClient]. 
#' 
#' @details Will return GRSciColl collections data. [collection_export] will 
#' return all of the results in a single `tibble`, while [collection_search] will 
#' return a sample of results. 
#' 
#' @return a `list`
#' @export
#'  
#' @references 
#' https://scientific-collections.gbif.org/connected-systems#grscicoll-data-coming-from-other-sources  
#' @examples \dontrun{
#'   collection_search(query="insect",limit=2)
#'   collection_search(name="Insects;Entomology", limit=2)
#'   collection_search(numberSpecimens = "0,100", limit=1)
#'   collection_search(institutionKey = "6a6ac6c5-1b8a-48db-91a2-f8661274ff80"
#'   , limit = 1)
#'   collection_search(query = "insect", country = "US;GB", limit=1)
#' } 
collection_search <- function(
    query = NULL,
    name = NULL,
    fuzzyName = NULL,
    preservationType = NULL,
    contentType = NULL,
    numberSpecimens = NULL,
    accessionStatus = NULL,
    personalCollection = NULL,
    sourceId = NULL,
    source = NULL,
    code = NULL,
    alternativeCode = NULL,
    contact = NULL,
    institutionKey = NULL,
    country = NULL,
    city = NULL,
    gbifRegion = NULL,
    machineTagNamespace = NULL,
    machineTagName = NULL,
    machineTagValue = NULL,
    identifier = NULL,
    identifierType = NULL,
    active = NULL,
    displayOnNHCPortal = NULL,
    masterSourceType = NULL,
    replacedBy = NULL,
    sortBy = NULL,
    sortOrder = NULL,
    offset = NULL,
    limit = NULL,
    format = NULL,
    curlopts = list(http_version=2)  
  ) {
  
  assert(query,"character")
  assert(name,"character")
  assert(fuzzyName,"character")
  assert(preservationType,"character")
  assert(contentType, "character")
  assert(accessionStatus,"character")
  assert(personalCollection,"logical")
  assert(source,"character")
  assert(code,"character")
  assert(alternativeCode,"character")
  assert(contact,"character")
  assert(institutionKey,"character")
  assert(country,"character")
  assert(city,"character")
  assert(gbifRegion,"character")
  assert(machineTagNamespace,"character")
  assert(machineTagName,"character")
  assert(identifierType,"character")
  assert(active,"logical")
  assert(displayOnNHCPortal,"logical")
  assert(alternativeCode,"character")
  assert(masterSourceType,"character")
  assert(replacedBy,"character")
  assert(sortBy,"character")
  assert(limit,"numeric")
  assert(offset,"numeric")
  
  # check for valid values 
  if(!is.null(sortBy)) {
    match.arg(sortBy, c("NUMBER_SPECIMENS"))
  }
  if(!is.null(sortOrder)) {
    match.arg(sortOrder, c("ASC", "DESC"))
  }

  args <- as.list(
    rgbif_compact(c(
      q = query,
      numberSpecimens = numberSpecimens,
      accessionStatus = accessionStatus,
      active = active,
      displayOnNHCPortal = displayOnNHCPortal,
      replacedBy = replacedBy,
      sortBy = sortBy,
      sortOrder = sortOrder,
      offset = offset,
      limit = limit
    )))
  
  args <- rgbif_compact(c(
      args,
      convmany(name),
      convmany(fuzzyName),
      convmany(preservationType),
      convmany(contentType),
      convmany(personalCollection),
      convmany(sourceId),
      convmany(source),
      convmany(code),
      convmany(alternativeCode),
      convmany(contact),
      convmany(institutionKey),
      convmany(country),
      convmany(city),
      convmany(gbifRegion),
      convmany(machineTagNamespace),
      convmany(machineTagName),
      convmany(machineTagValue),
      convmany(identifier),
      convmany(identifierType),
      convmany(masterSourceType)
    ))
  
  url <- paste0(gbif_base(), '/grscicoll/collection')
  tt <- gbif_GET(url, args, TRUE, curlopts)
  
  meta <- tt[c('offset','limit','endOfRecords','count')]
  data <- tibble::as_tibble(tt$results)
  
  list(meta = as.data.frame(meta), data = data)
}

#' @export
#' @rdname collection_search
collection_export <- function(
    query = NULL,
    name = NULL,
    fuzzyName = NULL,
    preservationType = NULL,
    contentType = NULL,
    numberSpecimens = NULL,
    accessionStatus = NULL,
    personalCollection = NULL,
    sourceId = NULL,
    source = NULL,
    code = NULL,
    alternativeCode = NULL,
    contact = NULL,
    institutionKey = NULL,
    country = NULL,
    city = NULL,
    gbifRegion = NULL,
    machineTagNamespace = NULL,
    machineTagName = NULL,
    machineTagValue = NULL,
    identifier = NULL,
    identifierType = NULL,
    active = NULL,
    displayOnNHCPortal = NULL,
    masterSourceType = NULL,
    replacedBy = NULL,
    sortBy = NULL,
    sortOrder = NULL,
    offset = NULL,
    limit = NULL,
    format = "TSV",
    curlopts = list()  
) {
  
  # https://api.gbif.org/v1/grscicoll/collection/export?format=TSV&displayOnNHCPortal=true
  assert(query,"character")
  assert(name,"character")
  assert(fuzzyName,"character")
  assert(preservationType,"character")
  assert(contentType, "character")
  assert(accessionStatus,"character")
  assert(personalCollection,"logical")
  assert(source,"character")
  assert(code,"character")
  assert(alternativeCode,"character")
  assert(contact,"character")
  assert(institutionKey,"character")
  assert(country,"character")
  assert(city,"character")
  assert(gbifRegion,"character")
  assert(machineTagNamespace,"character")
  assert(machineTagName,"character")
  assert(identifierType,"character")
  assert(active,"logical")
  assert(displayOnNHCPortal,"logical")
  assert(alternativeCode,"character")
  assert(masterSourceType,"character")
  assert(replacedBy,"character")
  assert(sortBy,"character")
  assert(limit,"numeric")
  assert(offset,"numeric")
  
  if(format != "TSV") {
    warning("Only 'TSV' format is supported for collection_export")
  }
  if(!is.null(limit) | !is.null(offset)) {
    warning("Limit and offset are ignored for collection_export. The full export
            is returned.")
  }
    
  args <- as.list(
    rgbif_compact(c(
      q = query,
      numberSpecimens = numberSpecimens,
      accessionStatus = accessionStatus,
      active = active,
      displayOnNHCPortal = displayOnNHCPortal,
      replacedBy = replacedBy,
      sortBy = sortBy,
      sortOrder = sortOrder,
      offset = offset,
      limit = limit,
      format = format
    )))
  
  args <- rgbif_compact(c(
    args,
    convmany(name),
    convmany(fuzzyName),
    convmany(preservationType),
    convmany(contentType),
    convmany(personalCollection),
    convmany(sourceId),
    convmany(source),
    convmany(code),
    convmany(alternativeCode),
    convmany(contact),
    convmany(institutionKey),
    convmany(country),
    convmany(city),
    convmany(gbifRegion),
    convmany(machineTagNamespace),
    convmany(machineTagName),
    convmany(machineTagValue),
    convmany(identifier),
    convmany(identifierType),
    convmany(masterSourceType)
  ))
  
  url_query <- paste0(names(args),"=",args,collapse="&")
  url_query <- utils::URLencode(url_query) 
  url <- paste0(gbif_base(),"/grscicoll/collection/export?",url_query)
  temp_file <- tempfile()
  utils::download.file(url,destfile=temp_file,quiet=TRUE)
  out <- tibble::as_tibble(data.table::fread(temp_file, showProgress=FALSE))
  colnames(out) <- to_camel(colnames(out))
  out 
}

