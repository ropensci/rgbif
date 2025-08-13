#' Lookup names in the GBIF backbone taxonomy in a checklist.
#'
#' @template occ
#' @export
#'
#' @param name_data (data.frame or vector) see details.
#' @param rank (character) default value (optional).
#' @param kingdom (character) default value (optional).
#' @param phylum (character) default value (optional).
#' @param class (character) default value (optional).
#' @param order (character) default value (optional).
#' @param family (character) default value (optional).
#' @param genus (character) default value (optional).
#' @param verbose (logical) If true it shows alternative matches which were 
#' considered but then rejected.
#' @param strict (logical) strict=TRUE will not attempt to fuzzy match or 
#' return higherrankmatches.
#' 
#' @return
#' A \code{data.frame} of matched names.
#' 
#' @details
#' This function is an alternative for  \code{name_backbone()}, which will work with 
#' a list of names (a vector or a data.frame). The data.frame should have the 
#' following column names, but \strong{only the 'name' column is required}. If only 
#' one column is present, then that column is assumed to be the 'name' column.
#' 
#' - \strong{name} : (required)
#' - \strong{rank} : (optional)
#' - \strong{kingdom} : (optional)
#' - \strong{phylum} : (optional)
#' - \strong{class} : (optional)
#' - \strong{order} : (optional)
#' - \strong{family} : (optional)
#' - \strong{genus} : (optional)
#'
#' The input columns will be returned as "verbatim_name","verbatim_rank",
#' "verbatim_phylum" ect. A column of "verbatim_index" will also be returned
#' giving the index of the input. 
#'
#' The following aliases for the 'name' column will work (any case or with '_'
#' will work) :
#' - "scientificName", "ScientificName", "scientific_name" ... 
#' - "sci_name", "sciname", "SCI_NAME" ...
#' - "names", "NAMES" ...
#' - "species", "SPECIES" ... 
#' - "species_name", "speciesname" ... 
#' - "sp_name", "SP_NAME", "spname" ...
#' - "taxon_name", "taxonname", "TAXON NAME" ...   
#' 
#' If more than one aliases is present and no column is named 'name', then the
#' left-most column with an acceptable aliased name above is used.  
#' 
#' If \code{verbose=TRUE}, a column called \code{is_alternative} will be returned, 
#' which species if a name was originally a first choice or not. 
#' \code{is_alternative=TRUE} means the name was not is not considered to be
#' the best match by GBIF.  
#' 
#' Default values for rank, kingdom, phylum, class, order, family, and genus can
#' can be supplied. If a default value is supplied, the values for these fields 
#' are ignored in name_data, and the default value is used instead. This is most 
#' useful if you have a list of names and you know they are all plants, insects,
#' birds, ect. You can also input multiple values, if they are the same length as 
#' list of names you are trying to match. 
#' 
#' This function can also be used with a character vector of names. In that case 
#' no column names are needed of course. 
#' 
#' This function is very similar to the GBIF species-lookup tool. 
#' \href{https://www.gbif.org/tools/species-lookup}{https://www.gbif.org/tools/species-lookup}.
#' 
#' If you have 1000s of names to match, it can take some minutes to get back all
#' of the matches. I have tested it with 60K names. Scientific names with author details
#'  usually get better matches. 
#'  
#' See also article \href{https://docs.ropensci.org/rgbif/articles/taxonomic_names.html}{Working With Taxonomic Names}.
#' 
#' @examples \dontrun{
#' 
#' library(rgbif)
#'
#' name_data <- data.frame(
#'  scientificName = c(
#'    "Cirsium arvense (L.) Scop.", # a plant
#'    "Calopteryx splendens (Harris, 1780)", # an insect
#'    "Puma concolor (Linnaeus, 1771)", # a big cat
#'    "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
#'    "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
#'    "Fake species (John Waller 2021)", # a fake species
#'    "Calopteryx" # Just a Genus   
#'  ), description = c(
#'    "a plant",
#'    "an insect",
#'    "a big cat",
#'    "newly discovered insect",
#'    "a mis-spelled big cat",
#'    "a fake species",
#'    "just a GENUS"
#'  ), 
#'  kingdom = c(
#'    "Plantae",
#'    "Animalia",
#'    "Animalia",
#'    "Animalia",
#'    "Animalia",
#'    "Johnlia",
#'    "Animalia"
#'  ))
#'
#' name_backbone_checklist(name_data)
#'
#' # return more than 1 result per name
#' name_backbone_checklist(name_data,verbose=TRUE) 
#'
#' # works with just vectors too 
#' name_list <- c(
#' "Cirsium arvense (L.) Scop.", 
#' "Calopteryx splendens (Harris, 1780)", 
#' "Puma concolor (Linnaeus, 1771)", 
#' "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", 
#' "Puma concuolor", 
#' "Fake species (John Waller 2021)", 
#' "Calopteryx")
#'
#' name_backbone_checklist(name_list)
#' name_backbone_checklist(name_list,verbose=TRUE)
#' name_backbone_checklist(name_list,strict=TRUE) 
#' 
#' # default values
#' name_backbone_checklist(c("Aloe arborecens Mill.",
#' "Cirsium arvense (L.) Scop."),kingdom="Plantae")
#' name_backbone_checklist(c("Aloe arborecens Mill.",
#' "Calopteryx splendens (Harris, 1780)"),kingdom=c("Plantae","Animalia"))
#' 
#' }
#'
name_backbone_checklist <- function(
    name_data,
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
    verbose = NULL,
    checklistKey = NULL,
    start = NULL,
    limit = NULL, 
    curlopts = list(http_version=2)
) {
  name_data <- check_name_data(name_data)
  default_args <- rgbif_compact(
    list(
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
      verbose = verbose,
      checklistKey = checklistKey
    )
  )
  
  if(length(default_args) > 0) {
    name_data <- default_value_handler(name_data = name_data, 
                                       default_args = default_args)
  }
  data_list <- lapply(data.table::transpose(name_data),
                      function(x) stats::setNames(as.list(x),colnames(name_data)))
  urls <- make_async_urls(data_list)
  tt <- gbif_async_get(urls)
  out <- mapply(function(x, y) {
    if(!isTRUE(as.logical(y$verbose))) {
      out <- process_name_backbone_output(x,y)
      out$is_alternative <- rep(FALSE,nrow(out))
    } else {
      alternatives <- bind_rows(
      lapply(x$diagnostics$alternatives, function(xx)
        process_name_backbone_output(xx,y))
      )
      alternatives$is_alternative <- rep(TRUE,nrow(alternatives))
      x$diagnostics$alternatives <- NULL
      accepted <- process_name_backbone_output(x,y)
      accepted$is_alternative <- rep(FALSE,nrow(accepted))
      out <- bind_rows(list(accepted,alternatives))
    }
    out
  }, tt,data_list,SIMPLIFY = FALSE)
  return(bind_rows(out))
}

bind_rows <- function(x) tibble::as_tibble(data.table::rbindlist(x,fill=TRUE))

check_name_data = function(name_data) {
  if(is.null(name_data)) {
    stop("You forgot to supply your checklist data.frame or vector to name_data.")
  }
  if(is.vector(name_data)) {
    if(!is.character(name_data)) stop("name_data should be class character.")
    name_data <- data.frame(scientificName=name_data)
    # name_data$index <- 1:nrow(name_data) # add id for sorting 
    return(name_data) # exit early if vector
  } 
  if(ncol(name_data) == 1) {
    if(!"scientificName" %in% colnames(name_data)) {
      message("Assuming first column is 'scientificName' column.")
      colnames(name_data) <- "scientificName"
    } 
    if(!is.character(name_data$scientificName)) stop("The scientificName column should be class character.")
    # name_data$index <- 1:nrow(name_data) # add id for sorting
    return(name_data) # exit early if only one column
  }
  
  # clean column names 
  original_colnames <- colnames(name_data) 
  colnames(name_data) <- tolower(colnames(name_data))
  colnames(name_data) <- gsub("_","",colnames(name_data))
  
  # check for aliases 
  name_aliases <- c("name","scientificname","sciname","names","species","speciesname","spname","taxonname")
  if((any(name_aliases %in% colnames(name_data))) & (!"scientificName" %in% colnames(name_data))) {
    left_most_index <- which(colnames(name_data) %in% name_aliases)[1]
    left_most_name <- colnames(name_data)[left_most_index]
    message("No 'scientificName' column found. Using leftmost '",original_colnames[left_most_index], "' as the 'scientificName' column.\nIf you do not want to use '", original_colnames[left_most_index], "' column, re-name the column you want to use 'scientificName'.")
    colnames(name_data) <- gsub(left_most_name,"scientificName",colnames(name_data))
  } 
  # check columns are character
  char_args <- c("scientificName","taxonRank","kingdom","phylum","class","order","family","genus")
  if(!all(sapply(name_data[names(name_data) %in% char_args],is.character))) stop("All taxonomic columns should be character.")
  name_data <- name_data[colnames(name_data) %in% char_args] # only keep needed columns
  # name_data$index <- 1:nrow(name_data) # add id for sorting
  name_data
}

default_value_handler <- function(name_data=NULL, default_args=NULL) {
  arg_names = names(default_args)
  if(any(arg_names %in% colnames(name_data))) message("Default values found, over-writing : ",paste0(arg_names[arg_names %in% colnames(name_data)],collapse=", "))
  # overwrite original names in name_data
  for(i in 1:length(default_args)) name_data[,arg_names[i]] <- default_args[i]
  return(name_data)
}

make_async_urls <- function(x,verbose=FALSE,strict=FALSE) {
  url_base <-   url <- paste0('https://api.gbif.org/v2', '/species/match')
  x <- lapply(x, function(x) x[!is.na(x)]) # remove potential missing values
  x <- lapply(x, function(sublist) {
    lapply(sublist, function(element) utils::URLencode(element, reserved = TRUE))
  })
  queries <- lapply(x,function(x) paste0(names(x),"=",x,collapse="&"))
  urls <- paste0(url_base,"?",queries)
  urls <- sapply(urls,function(x) gsub("\\[|\\]","",x)) # remove any square brackets
  urls
}

gbif_async_get <- function(urls, parse=FALSE, curlopts = list()) {
  cc <- crul::Async$new(urls = urls,headers = rgbif_ual, opts = curlopts)
  res <- process_async_get(cc$get(),parse=parse)
  return(res)
}

process_async_get <- function(res,parse=FALSE) {
  status_codes <- sapply(res, function(z) z$status_code)
  if(any(status_codes == 204)) stop("Status: 204 - not found", call. = FALSE)
  if(any(status_codes > 200)) {
    if(any(status_codes == 500)) stop("500 - Server error", call. = FALSE)
    if(any(status_codes == 503)) stop("503 - Service Unavailable", call. = FALSE)
  }
  # check content type
  content_types <- sapply(res, function(z) z$response_headers$`content-type`)
  stopifnot(any(content_types == 'application/json'))
  
  json_list <- lapply(res, function(z) jsonlite::fromJSON(z$parse("UTF-8"), parse)) 
  return(json_list)
}
