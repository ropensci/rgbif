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
#' @param verbose (logical) If `TRUE` show alternative matches considered which
#' had been rejected.
#'
#' @return A data.frame for a single taxon with many columns (default,
#'   `verbose=FALSE`) or a list of length two, first data.frame for the
#'   suggested taxon match, and a data.frame with alternative name suggestions
#'   resulting from fuzzy matching (with `verbose=TRUE`).
#'
#' @details
#' If you don't get a match, GBIF gives back a data.frame with columns `synonym`
#' , `confidence`, and `matchType='NONE'`.
#'
#' @references <http://www.gbif.org/developer/species#searching>
#'
#' @examples \dontrun{
#' name_backbone(name='Helianthus annuus', kingdom='plants')
#' name_backbone(name='Helianthus', rank='genus', kingdom='plants')
#' name_backbone(name='Poa', rank='genus', family='Poaceae')
#'
#' # Verbose - gives back alternatives
#' name_backbone(name='Helianthus annuus', kingdom='plants', verbose=TRUE)
#'
#' # Strictness
#' name_backbone(name='Poa', kingdom='plants', verbose=TRUE, strict=FALSE)
#' name_backbone(name='Helianthus annuus', kingdom='plants', verbose=TRUE,
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

  url <- paste0(gbif_base(), '/species/match')
  args <- rgbif_compact(
    list(name=name, rank=rank, kingdom=kingdom, phylum=phylum,
         class=class, order=order, family=family, genus=genus,
         strict=strict, verbose=verbose, offset=start, limit=limit))
  tt <- gbif_GET(url, args, FALSE, curlopts)
  if (verbose) {
    alt <- tibble::as_tibble(data.table::setDF(
      data.table::rbindlist(
        lapply(tt$alternatives, function(x)
          lapply(x, function(x) if (length(x) == 0) NA else x)),
        use.names = TRUE, fill = TRUE)))
    dat <- tibble::as_tibble(
      data.frame(tt[!names(tt) %in% c("alternatives", "note")],
                 stringsAsFactors = FALSE))
    out <- list(data = dat,
                alternatives = alt)
    class(out) <- "gbif"
  } else {
    out <- tibble::as_tibble(tt[!names(tt) %in% c("alternatives", "note")])
    class(out) <- c('tbl_df', 'tbl', 'data.frame', 'gbif')
  }
  # no multiple parameters possible in name_backbone
  attr(out, 'type') <- "single"
  structure(out, args = args, note = tt$note)
}
