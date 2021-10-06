#' Lookup names in the GBIF backbone taxonomy in a checklist.
#'
#' @param name_data (data.frame or vector) see details.
#' @param strict (logical) If `TRUE` it (fuzzy) matches only the given name,
#' but never a taxon in the upper classification (optional)
#' @param verbose (logical) should the matching return non
#' @param fuzzy (logical) should the matching return non-exact matches
#'
#' @return
#' A \code{data.frame} of matched names.
#' 
#' @details
#' This function is a wrapper for  \code{name_backbone()}, which will work with 
#' a list of names (a vectors or a data.frame). The data.frame should have the 
#' following column names. \strong{Only the 'name' column is required}. If only 
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
#' - "scientificName" 
#' - "sci_name" 
#' - "names" 
#' - "species" 
#' - "species_name" 
#' - "sp_name" 
#'   
#' If more than one aliases is present and no column is named 'name', then the
#' leftmost column with an alias name is used.  
#'
#' This function can also be used with a character vector of names. In that case 
#' no column names are needed of course. 
#' 
#' 
#' 
#' 
#' @export
#'
#' @examples \dontrun{
#' 
#' }
#' 
name_backbone_checklist <- function(
  name_data = NULL,
  strict = FALSE,
  verbose = FALSE,
  start=NULL,
  limit=100, 
  curlopts = list()
  
) {
  
  name_data <- check_name_data(name_data)
  data_list <- lapply(data.table::transpose(name_data),
                      function(x) setNames(as.list(x),colnames(name_data)))
  
  message("matching names in progress...")
  pb <- utils::txtProgressBar(min = 0, max = length(data_list), style = 3)
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
      
    setTxtProgressBar(pb, i)
    out 
  }) 
  cat("\n")

  matched_names <- tibble::as_tibble(data.table::rbindlist(matched_list,fill=TRUE))
  
  # make sure "verbatim_" end up at the end of the data.frame
  col_idx <- grep("verbatim_", names(matched_names))
  ordering <- c((1:ncol(matched_names))[-col_idx],col_idx)
  matched_names <- matched_names[, ordering]
  matched_names
}

check_name_data = function(name_data) {
  
  if(is.null(name_data)) stop("You forgot to supply your checklist data.frame or vector to name_data")
  if(is.vector(name_data)) {
    name_data <- data.frame(name=name_data)
    return(name_data) # exit early if vector
  } 
  
  # clean column names 
  original_colnames <- colnames(name_data) 
  colnames(name_data) <- tolower(colnames(name_data)) 
  colnames(name_data) <- gsub("_","",colnames(name_data))
  
  # check for aliases 
  name_aliases = c("scientificname","sciname","names","species","speciesname","spname")
  if((any(name_aliases %in% colnames(name_data))) & (!"name" %in% colnames(name_data))) {
    left_most_index <- which(colnames(name_data) %in% name_aliases)[1]
    left_most_name <- colnames(name_data)[left_most_index]
    message("No 'name' column found. Using leftmost '",original_colnames[left_most_index], "' as the 'name' column.\nIf you do not want to use '", original_colnames[left_most_index], "' column, re-name the column you want to use 'name'.")
    colnames(name_data) <- gsub(left_most_name,"name",colnames(name_data))
  } 
  if(ncol(name_data) == 1) {
    message("Assuming first column is 'name' column.")
    colnames(name_data) <- "name"
    }
  name_data
}
