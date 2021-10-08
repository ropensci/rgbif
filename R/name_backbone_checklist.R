#' Lookup names in the GBIF backbone taxonomy in a checklist.
#'
#' @template otherlimstart
#' @template occ
#' @export
#'
#' @param name_data (data.frame or vector) see details.
#' @param strict (logical) If `TRUE` it (fuzzy) matches only the given name,
#' but never a taxon in the upper classification (optional)
#' @param verbose (logical) should the matching return non-exact matches
#' @param progress_bar (logical) show or hide progress bar 
#' 
#' @return
#' A \code{data.frame} of matched names.
#' 
#' @details
#' This function is a wrapper for  \code{name_backbone()}, which will work with 
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
#' "verbatim_phylum"...
#'
#' The following aliases for the 'name' column will work (any case or with '_'
#' work) :
#' - "scientificName", "ScientificName", "scientific_name" ... 
#' - "sci_name", "sciname", "SCI_NAME" ...
#' - "names", "NAMES" ...
#' - "species", "SPECIES" ... 
#' - "species_name", "speciesname" ... 
#' - "sp_name", "SP_NAME", "spname" ...
#'   
#' If more than one aliases is present and no column is named 'name', then the
#' left-most column with an acceptable aliased name above is used.  
#'
#' This function can also be used with a character vector of names. In that case 
#' no column names are needed of course. 
#' 
#' This function is very similar to the GBIF species-lookup tool. 
#' \href{https://www.gbif.org/tools/species-lookup}{https://www.gbif.org/tools/species-lookup}
#' 
#' If you have 1000s of names to match, it can take some minutes to get back all
#' of the matches. Also you will usually get better matches if you include the 
#' author details. 
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
#' name_backbone_checklist(name_data,verbose=TRUE) # return non-accepted names too 
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
#' 
#' }
#' 
name_backbone_checklist <- function(
  name_data = NULL,
  strict = FALSE,
  verbose = FALSE,
  progress_bar = TRUE,
  start=NULL,
  limit=100, 
  curlopts = list()
  
) {
  
  name_data <- check_name_data(name_data)
  data_list <- lapply(data.table::transpose(name_data),
                      function(x) stats::setNames(as.list(x),colnames(name_data)))
  
  if(progress_bar){
    message("matching names in progress...")
    pb <- utils::txtProgressBar(min = 0, max = length(data_list), style = 3)
  } 
  matched_list <- lapply(1:length(data_list), function(i) {
    x <- data_list[[i]] # needed for progress bar 
    
      out <- rgbif::name_backbone(
        name=x$name,
        rank=x$rank,
        kingdom=x$kingdom,
        phylum=x$phylum,
        class=x$class,
        order=x$order,
        family=x$family,
        genus=x$genus,
        strict=strict,
        verbose=verbose,
        start=start,
        limit=limit, 
        curlopts = curlopts) 
      
    if(progress_bar) utils::setTxtProgressBar(pb, i)
    out 
  }) 
  matched_names <- tibble::as_tibble(data.table::rbindlist(matched_list,fill=TRUE))
  
  # make sure "verbatim_" end up at the end of the data.frame
  col_idx <- grep("verbatim_", names(matched_names))
  ordering <- c((1:ncol(matched_names))[-col_idx],col_idx)
  matched_names <- matched_names[, ordering]
  matched_names
}

check_name_data = function(name_data) {
  
  if(is.null(name_data)) stop("You forgot to supply your checklist data.frame or vector to name_data.")
  if(is.vector(name_data)) {
    if(!is.character(name_data)) stop("name_data should be class character.")
    name_data <- data.frame(name=name_data)
    return(name_data) # exit early if vector
  } 
  if(ncol(name_data) == 1) {
    message("Assuming first column is 'name' column.")
    colnames(name_data) <- "name"
    if(!is.character(name_data$name)) stop("The name column should be class character.")
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
  name_data
}
