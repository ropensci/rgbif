#' Search for names on checklistbank
#'
#' Constructs and sends a query to the Taxonomy API based on specified parameters.
#' 
#' @param q (string) General query term.
#' @param key (integer) The unique identifier for the resource.
#' @param id (string) Identifier of the taxonomic entity.
#' @param name (string) The name of the taxonomic entity to query.
#' @param scientificName (string) Scientific name of the species or taxonomic group.
#' @param authorship (string) Authorship of the scientific name.
#' @param code (string) Nomenclatural code (e.g. ICZN, ICBN).
#' @param rank (string) Taxonomic rank to filter by (e.g., species, genus).
#' @param status (string) Status of the taxon (e.g., valid, synonym).
#' @param verbose (boolean) If `TRUE`, returns additional information.
#' @param superkingdom (string) Taxonomic level above kingdom.
#' @param kingdom (string) The kingdom to filter by.
#' @param subkingdom (string) The subkingdom to filter by.
#' @param superphylum (string) Taxonomic level above phylum.
#' @param phylum (string) The phylum to filter by.
#' @param subphylum (string) The subphylum to filter by.
#' @param superclass (string) Taxonomic level above class.
#' @param class (string) The class to filter by.
#' @param subclass (string) The subclass to filter by.
#' @param superorder (string) Taxonomic level above order.
#' @param order (string) The order to filter by.
#' @param suborder (string) The suborder to filter by.
#' @param superfamily (string) Taxonomic level above family.
#' @param family (string) The family to filter by.
#' @param subfamily (string) The subfamily to filter by.
#' @param tribe (string) Taxonomic tribe to filter by.
#' @param subtribe (string) The subtribe to filter by.
#' @param genus (string) The genus to filter by.
#' @param subgenus (string) The subgenus to filter by.
#' @param section (string) The section to filter by within a genus.
#' @param species (string) The species to filter by.
#' @param user (string) GBIF user name for authentication.
#' @param pwd (string) GBIF password for authentication.
#' @param curlopts (list) List of named curl options passed on to HttpClient.
#' 
#' @return list
#' 
#' @examples \dontrun{
#' cb_name_usage("Calopteryx splendens")
#' }
#' @export

cb_name_usage <- function(
    q = NULL,
    key = "304862",
    id = NULL,
    name = NULL,
    scientificName = NULL,
    authorship = NULL,
    code = NULL,
    rank = NULL,
    status = NULL,
    verbose = NULL,
    superkingdom = NULL,
    kingdom = NULL,
    subkingdom = NULL,
    superphylum = NULL,
    phylum = NULL,
    subphylum = NULL,
    superclass = NULL,
    class = NULL,
    subclass = NULL,
    superorder = NULL,
    order = NULL,
    suborder = NULL,
    superfamily = NULL,
    family = NULL,
    subfamily = NULL,
    tribe = NULL,
    subtribe = NULL,
    genus = NULL,
    subgenus = NULL,
    section = NULL,
    species = NULL,
    user = NULL,
    pwd = NULL,
    curlopts = list()
) {
  # https://api.checklistbank.org/dataset/304862/match/nameusage?q=Telegonus%20favilla
  base_url = "https://api.checklistbank.org/dataset/"
  url = paste0(base_url, key, "/match/nameusage?")
  
  user <- check_user(user)
  pwd <- check_pwd(pwd)
  
  args <- rgbif_compact(
    list(
    q = q,
    id = id,
    name = name,
    scientificName = scientificName,
    authorship = authorship,
    code = code,
    rank = rank,
    status = status,
    verbose = verbose,
    superkingdom = superkingdom,
    kingdom = kingdom,
    subkingdom = subkingdom,
    superphylum = superphylum,
    phylum = phylum,
    subphylum = subphylum,
    superclass = superclass,
    class = class,
    subclass = subclass,
    superorder = superorder,
    order = order,
    suborder = suborder,
    superfamily = superfamily,
    family = family,
    subfamily = subfamily,
    tribe = tribe,
    subtribe = subtribe,
    genus = genus,
    subgenus = subgenus,
    section = section,
    species = species
    )
  )
  
  cli <- crul::HttpClient$new(
    url = url,
    auth = crul::auth(user = user, pwd = pwd),
    headers = rgbif_ual, 
    opts = curlopts
  )
  
  temp <- cli$get(query = args)
  tt <- jsonlite::fromJSON(temp$parse("UTF-8"), parse)
  classification <- bind_rows(lapply(tt$usage$classification,tibble::as_tibble))
  tt$usage$classification <- NULL
  usage <- tibble::as_tibble(tt$usage)
  
  issues <- tt$issues
  match <- tt$match 
  original <- tibble::as_tibble(tt$original)
  type <- tt$type
  
  out <- list(usage = usage, 
              classification = classification, 
              match = match, 
              original = original, 
              type = type,
              issues = issues)
  
  structure(out, class = "cb_name_usage")
}