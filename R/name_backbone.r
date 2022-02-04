#' Lookup names in the GBIF backbone taxonomy.
#'
#' @template otherlimstart
#' @template occ
#' @export
#'
#' @param name (character) Full scientific name potentially with authorship
#' (required)
#' @param rank (character) The rank given as our rank enum. (optional)
#' @param kingdom (character) If provided default matching will also try to
#' match against this if no direct match is found for the name alone.
#' (optional)
#' @param phylum (character) If provided default matching will also try to
#' match against this if no direct match is found for the name alone.
#' (optional)
#' @param class (character) If provided default matching will also try to
#' match against this if no direct match is found for the name alone.
#' (optional)
#' @param order (character) If provided default matching will also try to
#' match against this if no direct match is found for the name alone.
#' (optional)
#' @param family (character) If provided default matching will also try to
#' match against this if no direct match is found for the name alone.
#' (optional)
#' @param genus (character) If provided default matching will also try to
#' match against this if no direct match is found for the name alone.
#' (optional)
#' @param strict (logical) If `TRUE` it (fuzzy) matches only the given name,
#' but never a taxon in the upper classification (optional)
#' @param verbose (logical) should the function give back more (less reliable) 
#' results. See function `name_backbone_verbose()`
#'
#' @return For `name_backbone`, a data.frame for a single taxon with many
#' columns. For `name_backbone_verbose`, a larger number of results in a 
#' data.frame the results of resulting from fuzzy matching. 
#' You will also get back your input name, rank, kingdom, phylum ect. as 
#' columns input_name, input_rank, input_kingdom ect. so you can check the 
#' results. 
#'
#' @details
#' If you don't get a match, GBIF gives back a data.frame with columns
#' `synonym`, `confidence`, and `matchType='NONE'`.
#'
#' @references <https://www.gbif.org/developer/species#searching>
#'
#' @examples \dontrun{
#' name_backbone(name='Helianthus annuus', kingdom='plants')
#' name_backbone(name='Helianthus', rank='genus', kingdom='plants')
#' name_backbone(name='Poa', rank='genus', family='Poaceae')
#'
#' # Verbose - gives back alternatives
#' ## Strictness
#' name_backbone_verbose(name='Poa', kingdom='plants',
#'   strict=FALSE)
#' name_backbone_verbose(name='Helianthus annuus', kingdom='plants',
#'   strict=TRUE)
#'
#' # Non-existent name - returns list of lenght 3 stating no match
#' name_backbone(name='Aso')
#' name_backbone(name='Oenante')
#'
#' # Pass on curl options
#' name_backbone(name='Oenante', curlopts = list(verbose=TRUE))
#' }
name_backbone <- function(name, rank=NULL, kingdom=NULL, phylum=NULL,
  class=NULL, order=NULL, family=NULL, genus=NULL, strict=FALSE, verbose=FALSE,
  start=NULL, limit=100, curlopts = list()) {

  # pchk(verbose, "name_backbone")
  url <- paste0(gbif_base(), '/species/match')
  args <- rgbif_compact(
    list(name=name, rank=rank, kingdom=kingdom, phylum=phylum,
         class=class, order=order, family=family, genus=genus,
         strict=as_log(strict), verbose = verbose, offset=start, limit=limit))
  tt <- gbif_GET(url, args, FALSE, curlopts)
    input_args_clean <- args[!names(args) %in% c("strict","verbose","start","limit","curlopts")]
    input_args_clean <- stats::setNames(input_args_clean,paste0("verbatim_",names(input_args_clean)))
    tt <- c(tt,input_args_clean)
  if(verbose) {
    alternatives <- tt[["alternatives"]]
    alternatives <- lapply(alternatives,function(x) c(x,input_args_clean))
    alternatives <- bind_rows(lapply(alternatives,tibble::as_tibble))
    accepted <- tibble::as_tibble(tt)
    out <- bind_rows(list(accepted,alternatives))
    out <- out[!colnames(out) %in% c("alternatives", "note")]
  } else {
    out <- tibble::as_tibble(tt[!names(tt) %in% c("alternatives", "note")])
  }
  col_idx <- grep("verbatim_", names(out))
  ordering <- c((1:ncol(out))[-col_idx],col_idx)
  out <- unique(out[, ordering])
  structure(out, args = args, note = tt$note, type = "single")
}
  

#' @export
#' @rdname name_backbone
name_backbone_verbose <- function(name, rank=NULL, kingdom=NULL, phylum=NULL,
                                  class=NULL, order=NULL, family=NULL, genus=NULL, strict=FALSE,
                                  start=NULL, limit=100, curlopts = list()) {
  
  url <- paste0(gbif_base(), '/species/match')
  args <- rgbif_compact(
    list(name=name, rank=rank, kingdom=kingdom, phylum=phylum,
         class=class, order=order, family=family, genus=genus,
         strict=as_log(strict), verbose=TRUE, offset=start, limit=limit))
  tt <- gbif_GET(url, args, FALSE, curlopts)
  alt <- tibble::as_tibble(data.table::setDF(
    data.table::rbindlist(
      lapply(tt$alternatives, function(x)
        lapply(x, function(x) if (length(x) == 0) NA else x)),
      use.names = TRUE, fill = TRUE)))
  dat <- tibble::as_tibble(
    data.frame(tt[!names(tt) %in% c("alternatives", "note")],
               stringsAsFactors = FALSE))
  out <- list(data = dat, alternatives = alt)
  structure(out, args = args, note = tt$note, type = "single")
}


