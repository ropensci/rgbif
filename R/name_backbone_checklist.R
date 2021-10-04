#' Title
#'
#' @param name_data 
#' @param strict 
#' @param start 
#' @param limit 
#' @param curlopts 
#' @param verbose 
#'
#' @return
#' @export
#'
#' @examples
#' 
name_backbone_checklist <- function(
  name_data = NULL,
  strict=FALSE,
  start=NULL,
  limit=100, 
  curlopts = list(),
  verbose = FALSE
) {
  
  name_data <- check_name_data(name_data)
  print(name_data)
  data_list <- lapply(data.table::transpose(name_data),function(x) setNames(as.list(x),colnames(name_data)))
  
  # if(FALSE) {
  
  pb <- utils::txtProgressBar(min = 0, max = length(data_list), style = 3)
  matched_list = lapply(1:length(data_list), function(i) {
    x = data_list[[i]] # needed for progress bar 
    
    if(verbose) {
      out = rgbif::name_backbone_verbose(
        name=x$name,
        rank=x$rank,
        kingdom=x$kingdom,
        phylum=x$phylum,
        class=x$class,
        order=x$order,
        family=x$family,
        genus=x$genus,
        strict=strict,
        start=start, 
        limit=limit, 
        curlopts = curlopts
      ) } else {
        out = rgbif::name_backbone(
          name=x$name,
          rank=x$rank,
          kingdom=x$kingdom,
          phylum=x$phylum,
          class=x$class,
          order=x$order,
          family=x$family,
          genus=x$genus,
          strict=strict,
          start=start, 
          limit=limit, 
          curlopts = curlopts
        )
      }
    setTxtProgressBar(pb, i)
    out 
  }) 
  cat("\n")
  
  matched_names = data.table::rbindlist(matched_list,fill=TRUE)
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
  name_aliases = c("scientificname","sciname","names","species","speciesname","spname","canonicalname")
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
