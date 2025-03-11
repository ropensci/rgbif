#' Title
#'
#' @param q 
#' @param key 
#' @param id 
#' @param name 
#' @param scientificName 
#' @param authorship 
#' @param code 
#' @param rank 
#' @param status 
#' @param verbose 
#' @param superkingdom 
#' @param kingdom 
#' @param subkingdom 
#' @param superphylum 
#' @param phylum 
#' @param subphylum 
#' @param superclass 
#' @param class 
#' @param subclass 
#' @param superorder 
#' @param order 
#' @param suborder 
#' @param superfamily 
#' @param family 
#' @param subfamily 
#' @param tribe 
#' @param subtribe 
#' @param genus 
#' @param subgenus 
#' @param section 
#' @param species 
#' @param user 
#' @param pwd 
#' @param curlopts 
#'
#' @return
#' @export
#'
#' @examples
cb_name_usage = function(
    q = NULL,
    key = "308374",
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
  url <- paste0(base_url, key, "/match/nameusage?")
  print(url)
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
    url = utils::URLencode(url),
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



