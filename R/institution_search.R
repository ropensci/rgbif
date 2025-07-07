#' Search GRSciColl institutions
#'
#' @param query (character) Simple full text search parameter. The value for 
#' this parameter can be a simple word or a phrase. Wildcards are not supported
#' @param type (character) Type of a GrSciColl institution 
#' Available values : BIOMEDICAL_RESEARCH_INSTITUTE, BOTANICAL_GARDEN, 
#' HERBARIUM, LIVING_ORGANISM_COLLECTION, MEDICAL_RESEARCH_INSTITUTE, MUSEUM, 
#' MUSEUM_HERBARIUM_PRIVATE_NON_PROFIT, OTHER_INSTITUTIONAL_TYPE, 
#' OTHER_TYPE_RESEARCH_INSTITUTION_BIOREPOSITORY, UNIVERSITY_COLLEGE, 
#' ZOO_AQUARIUM
#' @param institutionalGovernance (character) Instutional governance of a 
#' GrSciColl institution Available values : ACADEMIC_FEDERAL, 
#' ACADEMIC_FOR_PROFIT, ACADEMIC_LOCAL, ACADEMIC_NON_PROFIT, ACADEMIC_STATE, 
#' FEDERAL, FOR_PROFIT, LOCAL, NON_PROFIT, OTHER, STATE.
#' @param disciplines (character) Discipline of a GrSciColl institution. 
#' Check available values : 
#' https://techdocs.gbif.org/en/openapi/v1/registry#/Institutions/listInstitutions
#' @param name (character) Name of a GrSciColl institution or collection
#' @param fuzzyName (character) It searches by name fuzzily so the parameter 
#' doesn't have to be the exact name.
#' @param numberSpecimens (character) Number of specimens. It supports ranges 
#' and a `*` can be used as a wildcard.
#' @param occurrenceCount (character) Count of occurrences linked. It supports 
#' ranges and a `*` can be used as a wildcard.
#' @param typeSpecimenCount (character) Count of type specimens linked. It 
#' supports ranges and a `*` can be used as a wildcard.
#' @param sourceId (character) sourceId of MasterSourceMetadata
#' @param source (character) Source attribute of MasterSourceMetadata
#' Available values : DATASET, ORGANIZATION, IH_IRN
#' @param code (character) Code of a GrSciColl institution or collection.
#' @param alternativeCode (character) Alternative code of a GrSciColl institution.
#' @param contact (character) Filters collections and institutions whose 
#' contacts contain the person key specified.
#' @param institutionKey (character) Keys of institutions to filter by.
#' @param country (character) Filters by country given as a ISO 639-1 (2 letter) 
#' country code.
#' @param city (character) Filters by the city of the address. It searches in both the 
#' physical and the mailing address.
#' @param gbifRegion (character) Filters by a gbif region. Available values : AFRICA, ASIA, 
#' EUROPE, NORTH_AMERICA, OCEANIA, LATIN_AMERICA, ANTARCTICA.
#' @param machineTagNamespace (character) Filters for entities with a machine 
#' tag in the specified namespace.
#' @param machineTagName (character) Filters for entities with a machine tag 
#' with the specified name (use in combination with the machineTagNamespace 
#' parameter).
#' @param machineTagValue (character) Filters for entities with a machine tag 
#' with the specified value (use in combination with the machineTagNamespace and 
#' machineTagName parameters).
#' @param identifier (character) An identifier of the type given by the 
#' `identifierType` parameter, for example a DOI or UUID.
#' @param identifierType (character) An identifier type for the 
#' identifier parameter. 
#' Available values : URL, LSID, HANDLER, DOI, UUID, FTP, URI, UNKNOWN, 
#' GBIF_PORTAL, GBIF_NODE, GBIF_PARTICIPANT, GRSCICOLL_ID, GRSCICOLL_URI, 
#' IH_IRN, ROR, GRID, CITES, SYMBIOTA_UUID, WIKIDATA, NCBI_BIOCOLLECTION, ISIL, 
#' CLB_DATASET_KEY.
#' @param active (logical) Active status of a GrSciColl institution or collection.
#' @param displayOnNHCPortal (logical) Flag to show this record in the NHC 
#' portal.
#' @param masterSourceType (character) The master source type of a GRSciColl 
#' institution or collection. Available values : GRSCICOLL, GBIF_REGISTRY, IH.
#' @param replacedBy (character) Key of the entity that replaced another entity.
#' @param sortBy (character) Field to sort the results by. It only supports the 
#' fields contained in the enum. Available values : NUMBER_SPECIMENS.
#' @param sortOrder (character) Sort order to use with the sortBy parameter. 
#' Available values : ASC, DESC.
#' @param offset (numeric) Determines the offset for the search results. 
#' @param limit (numeric) Controls the number of results in the page. 
#' Default 20.
#' @param curlopts (list) curlopts options passed on to [crul::HttpClient].
#'
#' @return A `list`
#' @export
#'
#' @examples \dontrun{
#' institution_search(query="Kansas",limit=1)
#' institution_search(numberSpecimens = "1000,*",limit=2)
#' institution_search(source = "IH_IRN") 
#' institution_search(country = "US;GB")
#' institution_search(typeSpecimenCount = "10,100")
#' 
#' }
institution_search <- function(
    query = NULL,
    type = NULL,
    institutionalGovernance = NULL,
    disciplines = NULL,
    name = NULL,
    fuzzyName = NULL,
    numberSpecimens = NULL,
    occurrenceCount = NULL,
    typeSpecimenCount = NULL,
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
    curlopts = list()  
    ) {
    assert(query, "character")
    assert(type, "character")
    assert(institutionalGovernance, "character")
    assert(disciplines, "character")
    assert(name, "character")
    assert(fuzzyName, "character")
    assert(source, "character")
    assert(sourceId, "character")
    assert(code, "character")
    assert(alternativeCode, "character")
    assert(contact, "character")
    assert(institutionKey, "character")
    assert(country, "character")
    assert(city, "character")
    assert(gbifRegion, "character")
    assert(machineTagNamespace, "character")
    assert(machineTagName, "character")
    assert(identifierType, "character")
    assert(active, "logical")
    assert(displayOnNHCPortal, "logical")
    assert(masterSourceType, "character")
    assert(replacedBy, "character")
    assert(sortBy, "character")
    assert(sortOrder, "character")
    assert(offset, "numeric")
    assert(limit, "numeric")
    
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
        occurrenceCount = occurrenceCount,
        typeSpecimenCount = typeSpecimenCount,
        active = active,
        displayOnNHCPortal = displayOnNHCPortal,
        replacedBy = replacedBy,
        sortBy = sortBy,
        sortOrder = sortOrder,
        offset = offset,
        limit = limit
      )))
    
    args <- rgbif_compact(
      c(
        args,
        convmany(type),
        convmany(institutionalGovernance),
        convmany(disciplines),
        convmany(name),
        convmany(fuzzyName),
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
        convmany(identifierType)
      ))
    
    url <- paste0(gbif_base(), "/grscicoll/institution")
    tt <- gbif_GET(url, args, TRUE, curlopts)
    
    meta <- tt[c('offset','limit','endOfRecords','count')]
    data <- tibble::as_tibble(tt$results)
    
    list(meta = as.data.frame(meta), data = data)
}