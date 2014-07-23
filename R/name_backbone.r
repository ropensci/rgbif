#' Lookup names in the GBIF backbone taxonomy.
#' 
#' @template all
#' @template occ
#' @import httr plyr
#' @export
#' 
#' @param name (character) Full scientific name potentially with authorship (required)
#' @param rank (character) The rank given as our rank enum. (optional)
#' @param kingdom (character) If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone. (optional)
#' @param phylum (character) If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone. (optional)
#' @param class (character) If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone. (optional)
#' @param order (character) If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone. (optional)
#' @param family (character) If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone. (optional)
#' @param genus (character) If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone. (optional)
#' @param strict (logical) If TRUE it (fuzzy) matches only the given name, but never a 
#'    taxon in the upper classification (optional)
#' @param verbose (logical) If TRUE show alternative matches considered which had been rejected.
#' 
#' @return A list for a single taxon with many slots (with \code{verbose=FALSE} - default), or a 
#' list of length two, first element for the suggested taxon match, and a data.frame
#' with alternative name suggestions resulting from fuzzy matching (with \code{verbose=TRUE}).
#' @details If you don't get a match GBIF gives back a list of length 3 with slots synonym, 
#' confidence, and matchType='NONE'.
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
#' name_backbone(name='Helianthus annuus', kingdom='plants', verbose=TRUE, strict=TRUE)
#' 
#' # Non-existent name - returns list of lenght 3 stating no match
#' name_backbone(name='Aso')
#' }
#' 
#' @examples \donttest{
#' # Throws error because a name is required in the function call
#' name_backbone(kingdom='plants')
#' }

name_backbone <- function(name, rank=NULL, kingdom=NULL, phylum=NULL, class=NULL, 
  order=NULL, family=NULL, genus=NULL, strict=FALSE, verbose=FALSE, 
  start=NULL, limit=20, callopts=list())
{
  url = 'http://api.gbif.org/v1/species/match'
  args <- rgbif_compact(list(name=name, rank=rank, kingdom=kingdom, phylum=phylum, 
                       class=class, order=order, family=family, genus=genus, 
                       strict=strict, verbose=verbose, offset=start, limit=limit))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  assert_that(temp$headers$`content-type`=='application/json')
  res <- content(temp, as = 'text', encoding = "UTF-8")
  tt <- RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  
  if(verbose){ 
    alt <- do.call(rbind.fill, lapply(tt$alternatives, namelkupparser))
    dat <- data.frame(tt[!names(tt) %in% c("alternatives","note")], stringsAsFactors=FALSE)
    list(data=dat, alternatives=alt)
  } else
  {
    tt[!names(tt) %in% c("alternatives","note")]
  }
}