#' Lookup names in the GBIF backbone taxonomy.
#' 
#' @template all
#' @template occ
#' @import httr plyr
#' @param name Full scientific name potentially with authorship
#' @param rank The rank given as our rank enum.
#' @param kingdom If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone.
#' @param phylum If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone.
#' @param class If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone.
#' @param order If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone.
#' @param family If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone.
#' @param genus If provided default matching will also try to match against this 
#'    if no direct match is found for the name alone.
#' @param strict If TRUE it (fuzzy) matches only the given name, but never a 
#'    taxon in the upper classification
#' @param verbose If TRUE show alternative matches considered which had been rejected.
#' @return A list.
#' @export
#' @examples \dontrun{
#' name_backbone(name='Helianthus annuus', kingdom='plants')
#' name_backbone(name='Helianthus', rank='genus', kingdom='plants')
#' name_backbone(name='Helianthus annuus', kingdom='plants', verbose=TRUE)
#' }
name_backbone <- function(name, rank=NULL, kingdom=NULL, phylum=NULL, class=NULL, 
  order=NULL, family=NULL, genus=NULL, strict=FALSE, verbose=FALSE, 
  start=NULL, limit=20, callopts=list())
{
  url = 'http://api.gbif.org/v0.9/species/match'
  args <- compact(list(name=name, rank=rank, kingdom=kingdom, phylum=phylum, 
                       class=class, order=order, family=family, genus=genus, 
                       strict=strict, verbose=verbose, offset=start, limit=limit))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  
  if(verbose){ 
    alt <- do.call(rbind.fill, lapply(tt$alternatives, namelkupparser))
    dat <- data.frame(tt[!names(tt) %in% c("alternatives","note")])
    list(data=dat, alternatives=alt)
  } else
  {
    tt[!names(tt) %in% c("alternatives","note")]
  }
}