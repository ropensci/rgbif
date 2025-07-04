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
  name_data = NULL,
  rank = NULL,
  kingdom = NULL,
  phylum = NULL,
  class = NULL,
  order = NULL,
  family = NULL,
  genus  = NULL,
  strict = FALSE,
  verbose = FALSE,
  curlopts = list()
) {
  name_data <- check_name_data(name_data)
  if(!is.null(c(rank,kingdom,phylum,class,order,family,genus))) 
    name_data <- default_value_handler(name_data=name_data,rank=rank,kingdom=kingdom,phylum=phylum,class=class,order=order,family=family,genus=genus) 
  data_list <- lapply(data.table::transpose(name_data),function(x) stats::setNames(as.list(x),colnames(name_data)))
  urls <- make_async_urls(data_list,verbose=verbose,strict=strict)
  matched_list <- gbif_async_get(urls)
  verbatim_list <- lapply(data_list,function(x) stats::setNames(x,paste0("verbatim_",names(x))))
  mvl <- mapply(function(x, y) c(x,y),verbatim_list,matched_list,SIMPLIFY = FALSE)
  matched_names <- bind_rows(mvl)
  if(verbose) {
    a <- lapply(mvl,function(x) x[["alternatives"]])
    alternatives <- process_alternatives(a,verbatim_list)
    matched_names <- bind_rows(list(matched_names,alternatives))
  }
  # post processing matched names
  matched_names$verbatim_index <- as.numeric(matched_names$verbatim_index)
  matched_names <- matched_names[order(matched_names$verbatim_index),]
  matched_names <- matched_names[!names(matched_names) %in% c("alternatives", "note")]
  col_idx <- grep("verbatim_", names(matched_names))
  ordering <- c((1:ncol(matched_names))[-col_idx],col_idx)
  matched_names <- unique(matched_names[, ordering])
  if(verbose) matched_names$is_alternative[is.na(matched_names$is_alternative)] <- FALSE
  return(matched_names)
}

bind_rows <- function(x) tibble::as_tibble(data.table::rbindlist(x,fill=TRUE))

process_alternatives <- function(a,vl) {
  is_empty <- sapply(a,is.null) 
  a <- a[!is_empty] # alternatives
  vl <- vl[!is_empty] # verbatim list
  dl <- lapply(a,function(x) lapply(`[`(x), function(xx) tibble::as_tibble(xx)))
  dl <- lapply(dl,function(x) bind_rows(`[`(x)))
  vl <- lapply(vl,function(x) tibble::as_tibble(x))
  n_times_list <- lapply(sapply(dl,nrow),function(x) rep(1,x))
  vl <- mapply(function(x,y) x[y,],vl,n_times_list,SIMPLIFY = FALSE) # repeat data
  alternatives <- bind_rows(mapply(function(x,y) cbind(x,y),dl,vl,SIMPLIFY = FALSE))
  alternatives$is_alternative <- TRUE
  alternatives
}

check_name_data = function(name_data) {
  
  if(is.null(name_data)) stop("You forgot to supply your checklist data.frame or vector to name_data.")
  if(is.vector(name_data)) {
    if(!is.character(name_data)) stop("name_data should be class character.")
    name_data <- data.frame(name=name_data)
    name_data$index <- 1:nrow(name_data) # add id for sorting 
    return(name_data) # exit early if vector
  } 
  if(ncol(name_data) == 1) {
    message("Assuming first column is 'name' column.")
    colnames(name_data) <- "name"
    if(!is.character(name_data$name)) stop("The name column should be class character.")
    name_data$index <- 1:nrow(name_data) # add id for sorting
    return(name_data) # exit early if only one column
  }
  
  # clean column names 
  original_colnames <- colnames(name_data) 
  colnames(name_data) <- tolower(colnames(name_data)) 
  colnames(name_data) <- gsub("_","",colnames(name_data))
  
  # check for aliases 
  name_aliases <- c("scientificname","sciname","names","species","speciesname","spname","taxonname")
  if((any(name_aliases %in% colnames(name_data))) & (!"name" %in% colnames(name_data))) {
    left_most_index <- which(colnames(name_data) %in% name_aliases)[1]
    left_most_name <- colnames(name_data)[left_most_index]
    message("No 'name' column found. Using leftmost '",original_colnames[left_most_index], "' as the 'name' column.\nIf you do not want to use '", original_colnames[left_most_index], "' column, re-name the column you want to use 'name'.")
    colnames(name_data) <- gsub(left_most_name,"name",colnames(name_data))
  } 
  # check columns are character
  char_args <- c("name","rank","kingdom","phylum","class","order","family","genus")
  if(!all(sapply(name_data[names(name_data) %in% char_args],is.character))) stop("All taxonomic columns should be character.")
  name_data <- name_data[colnames(name_data) %in% char_args] # only keep needed columns
  name_data$index <- 1:nrow(name_data) # add id for sorting 
  name_data
}

default_value_handler <- function(name_data=NULL,rank=NULL,kingdom=NULL,phylum=NULL,class=NULL,
                                  order=NULL,family=NULL,genus=NULL) {
  args <- rgbif_compact(list(rank=rank, kingdom=kingdom, phylum=phylum,
                             class=class, order=order, family=family, genus=genus))
  arg_names = names(args)
  sapply(args,function(x) stopifnot(is.character(x))) 
  if(any(arg_names %in% colnames(name_data))) message("Default values found, over-writing : ",paste0(arg_names[arg_names %in% colnames(name_data)],collapse=", "))
  # overwrite original names in name_data
  for(i in 1:length(args)) name_data[,arg_names[i]] <- args[i]
  return(name_data)
}

make_async_urls <- function(x,verbose=FALSE,strict=FALSE) {
  url_base <- paste0(gbif_base(), '/species/match')
  x <- lapply(x, function(x) x[!is.na(x)]) # remove potential missing values
  x <- lapply(x, function(sublist) {
    lapply(sublist, function(element) utils::URLencode(element, reserved = TRUE))
  })
  queries <- lapply(x,function(x) paste0(names(x),"=",x,collapse="&"))
  urls <- paste0(url_base,"?",queries)
  if(verbose) urls <- paste0(urls,"&verbose=true")
  if(strict) urls <- paste0(urls,"&strict=true")
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
