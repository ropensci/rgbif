#' Match names to GBIF backbone and other checklists.
#'
#' @param name (character) Full scientific name potentially with authorship
#' (required)
#' @param rank (character) Filter by taxonomic rank. See API reference for 
#' available values. 
#' @param usageKey (character) The usage key to look up. When provided, all 
#' other fields are ignored.
#' @param kingdom (character) Kingdom to match. 
#' @param phylum (character) Phylum to match.
#' @param class (character) Class to match.
#' @param order (character) Order to match.
#' @param superfamily (character) Superfamily to match.
#' @param family (character) Family to match.
#' @param subfamily (character) Subfamily to match.
#' @param tribe (character) Tribe to match.
#' @param subtribe (character) Subtribe to match.
#' @param genus (character) Genus to match.
#' @param subgenus (character) Subgenus to match.
#' @param species (character) Species to match.
#' @param taxonID (character) The taxon ID to look up. Matches to a taxonID 
#' will take precedence over scientificName values supplied. A comparison of 
#' the matched scientific and taxonID is performed tocheck for inconsistencies.
#' @param taxonConceptID (character) The taxonConceptID to match. Matches to a 
#' taxonConceptID will take precedence over scientificName values supplied. A 
#' comparison of the matched scientific and taxonConceptID is performed to 
#' check for inconsistencies.
#' @param scientificNameID (character) Matches to a scientificNameID will take 
#' precedence over scientificName values supplied. A comparison of the matched 
#' scientific and scientificNameID is performed to check for inconsistencies.
#' @param scientificNameAuthorship (character) The scientific name authorship 
#' to match against.  
#' @param genericName (character) Generic part of the name to match when given 
#' as atomised parts instead of the full name parameter. 
#' @param specificEpithet (character) Specific epithet to match. 
#' @param infraspecificEpithet (character) Infraspecific epithet to match.
#' @param verbatimTaxonRank (character) Filters by free text taxon rank.
#' @param exclude (character) An array of usage keys to exclude from the match.
#' @param strict (logical) If set to true, fuzzy matches only the given name, 
#' but never a taxon in the upper classification.
#' @param verbose (logical) If set to true, it shows alternative matches which 
#' were considered but then rejected.
#' @param checklistKey (character) The key of a checklist to use. The default is
#' the GBIF Backbone taxanomy. 
#' @param start (integer) Currently ignored.  
#' @param limit (integer) Currently ignored. 
#' @param curlopts A list of curl options passed on to [httr::GET()].
#'
#'
#' @details
#' If you don't get a match, GBIF gives back a data.frame with columns
#' `synonym`, `confidence`, and `matchType='NONE'`.
#' 
#' `name_backbone_verbose()` is a legacy wrapper function that returns 
#' returns alternatives in a separate `tibble`.
#' 
#' @returns A single row `tibble` of the best matched name. If `verbose=TRUE`, a
#' longer `tibble` with all potential alternatives is returned. 
#' 
#' @export
#' 
#' @references 
#' \url{https://techdocs.gbif.org/en/openapi/v1/species#/Searching%20names/matchNames}
#'   
#' @examples \dontrun{
#' name_backbone("Calopteryx splendens") 
#' name_backbone("Calopteryx splendens", kingdom = "Animalia")
#' name_backbone("Calopteryx splendens", kingdom = "Animalia", verbose = TRUE)
#' name_backbone_verbose("Calopteryx splendens", kingdom = "Animalia")
#' name_backbone("Calopteryx splendens", kingdom = "Plantae")
#'
#' }
name_backbone <- function(
    name = NULL,
    rank = NULL,
    kingdom = NULL,
    phylum = NULL,
    class = NULL,
    order = NULL,
    superfamily = NULL,
    family = NULL,
    subfamily = NULL,
    tribe = NULL,
    subtribe = NULL,
    genus = NULL,
    subgenus = NULL,
    species = NULL,
    usageKey = NULL,
    taxonID = NULL,
    taxonConceptID = NULL,
    scientificNameID = NULL,
    scientificNameAuthorship = NULL,
    genericName = NULL,
    specificEpithet = NULL,
    infraspecificEpithet = NULL,
    verbatimTaxonRank = NULL,
    exclude = NULL,
    strict = NULL,
    verbose = FALSE,
    checklistKey = NULL,
    start = NULL,
    limit = NULL, 
    curlopts = list(http_version=2)
) {
  url <- paste0('https://api.gbif.org/v2', '/species/match')
  args <- rgbif_compact(
    list(
      scientificName = name,
      scientificNameAuthorship = scientificNameAuthorship,
      genericName = genericName,
      specificEpithet = specificEpithet,
      infraspecificEpithet = infraspecificEpithet,
      taxonRank = rank,
      verbatimTaxonRank = verbatimTaxonRank,
      kingdom = kingdom,
      phylum = phylum,
      class = class,
      order = order,
      superfamily = superfamily,
      family = family,
      subfamily = subfamily,
      tribe = tribe,
      subtribe = subtribe,
      genus = genus,
      subgenus = subgenus,
      species = species,
      usageKey = usageKey,
      taxonID = taxonID,
      taxonConceptID = taxonConceptID,
      scientificNameID = scientificNameID,
      exclude = exclude,
      strict = strict,
      verbose = verbose,
      checklistKey = checklistKey,
      start = start,
      limit = limit
    )
  )
  tt <- gbif_GET(url, args, FALSE, curlopts)
  if(!verbose) {
    out <- process_name_backbone_output(tt,args)
  } else {
    alternatives <- bind_rows(lapply(tt$diagnostics$alternatives, function(x)
      process_name_backbone_output(x,args))
    )
    tt$diagnostics$alternatives <- NULL
    accepted <- process_name_backbone_output(tt,args)
    out <- bind_rows(list(accepted,alternatives))
  }
  structure(out, args = args, note = tt$diagnostics$note, type = "single")
}

#' @export
#' @rdname name_backbone
name_backbone_verbose <- function(name = NULL,
                                  rank = NULL,
                                  kingdom = NULL,
                                  phylum = NULL,
                                  class = NULL,
                                  order = NULL,
                                  superfamily = NULL,
                                  family = NULL,
                                  subfamily = NULL,
                                  tribe = NULL,
                                  subtribe = NULL,
                                  genus = NULL,
                                  subgenus = NULL,
                                  species = NULL,
                                  usageKey = NULL,
                                  taxonID = NULL,
                                  taxonConceptID = NULL,
                                  scientificNameID = NULL,
                                  scientificNameAuthorship = NULL,
                                  genericName = NULL,
                                  specificEpithet = NULL,
                                  infraspecificEpithet = NULL,
                                  verbatimTaxonRank = NULL,
                                  exclude = NULL,
                                  strict = NULL,
                                  checklistKey = NULL,
                                  start = NULL,
                                  limit = NULL, 
                                  curlopts = list(http_version=2)
                                  ) {
  url <- paste0('https://api.gbif.org/v2', '/species/match')
  args <- rgbif_compact(
    list(
      scientificName = name,
      scientificNameAuthorship = scientificNameAuthorship,
      genericName = genericName,
      specificEpithet = specificEpithet,
      infraspecificEpithet = infraspecificEpithet,
      taxonRank = rank,
      verbatimTaxonRank = verbatimTaxonRank,
      kingdom = kingdom,
      phylum = phylum,
      class = class,
      order = order,
      superfamily = superfamily,
      family = family,
      subfamily = subfamily,
      tribe = tribe,
      subtribe = subtribe,
      genus = genus,
      subgenus = subgenus,
      species = species,
      usageKey = usageKey,
      taxonID = taxonID,
      taxonConceptID = taxonConceptID,
      scientificNameID = scientificNameID,
      genericName = genericName,
      exclude = exclude,
      strict = strict,
      verbose = TRUE,
      checklistKey = checklistKey,
      start = start,
      limit = limit
    )
  )
  tt <- gbif_GET(url, args, FALSE, curlopts)
  alt <- bind_rows(lapply(tt$diagnostics$alternatives, function(x)
    process_name_backbone_output(x, args))
    )
  tt$diagnostics$alternatives <- NULL
  dat <- process_name_backbone_output(tt, args)
  out <- list(data = dat, alternatives = alt)
  structure(out, args = args, note = tt$diagnostics$note, type = "single")
}

process_name_backbone_output <- function(tt, args) {
  usage <- if (!is.null(tt$usage)) {
    u <- tibble::as_tibble(tt$usage)
    colnames(u)[colnames(u) == "key"] <- "usageKey"
    colnames(u)[colnames(u) == "name"] <- "scientificName"
    u
  } else { 
    NULL
  }
  diagnostics <- if (!is.null(tt$diagnostics)) {
    tt$diagnostics["timings"] <- NULL
    tt$diagnostics["issues"] <- NULL
    d <- tibble::as_tibble(tt$diagnostics)
    d
  } else {
    NULL
  }
  classification <- if (!is.null(tt$classification)) {
    c <- bind_rows(lapply(tt$classification, tibble::as_tibble))
    if(any(duplicated(c$rank))) {
      c$rank <- make.unique(c$rank)
    }
    nv <- stats::setNames(c$name, tolower(c$rank))
    kv <- stats::setNames(c$key,  paste0(tolower(c$rank), "Key"))
    
    c <- tibble::as_tibble(as.list(c(nv, kv)))
    c
  } else {
    NULL
  }
  synonym <- if (!is.null(tt$synonym)) {
    tibble::as_tibble(tt$synonym)
  } else {
    NULL
  }
  acceptedUsage <- if (!is.null(tt$acceptedUsage)) {
    a <- tibble::as_tibble(tt$acceptedUsage)[c("key","name")]
    colnames(a)[colnames(a) == "key"] <- "acceptedUsageKey"
    colnames(a)[colnames(a) == "name"] <- "acceptedScientificName"
    a
  } else {
    NULL
  }
  verbatim <- if (!is.null(args)) {
  input_args_clean <- args[!names(args) %in% 
                             c("strict","verbose","start","limit","curlopts")]
  v <- stats::setNames(input_args_clean,
                                    paste0("verbatim_",names(input_args_clean)))
  names(v)[names(v) == "verbatim_taxonRank"] <- "verbatim_rank"
  names(v)[names(v) == "verbatim_scientificName"] <- "verbatim_name"
  tibble::as_tibble(v)
  } else {
    NULL
  }
  out <- do.call("cbind", rgbif_compact(list(usage,
                                             acceptedUsage, 
                                             diagnostics, 
                                             classification,
                                             synonym,
                                             verbatim)))
  tibble::as_tibble(out)
}
