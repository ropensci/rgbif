#' A quick and simple autocomplete service that returns up to 20 name usages by 
#' doing prefix matching against the scientific name. Results are ordered by relevance. 
#' 
#' @template all
#' @template occ
#' @import httr plyr
#' @param q Simple search parameter. The value for this parameter can be a simple 
#'    word or a phrase. Wildcards can be added to the simple word parameters only, 
#'    e.g. q=*puma*
#' @param rank The rank given as our rank enum.
#' @param name Filters by a case insensitive, canonical namestring, e.g. 'Puma concolor'
#' @param strict If TRUE it (fuzzy) matches only the given name, but never a 
#'    taxon in the upper classification
#' @param verbose If TRUE show alternative matches considered which had been rejected.
#' @return A data.frame with fields selected by fields arg.
#' @export
#' @examples \dontrun{
#' name_suggest(q='Puma concolor')
#' name_suggest(q='Puma')
#' name_suggest(q='Puma', limit=2)
#' name_suggest(q='Puma', fields=c('key','canonicalName'))
#' }
name_suggest <- function(q=NULL, rank=NULL, name=NULL, strict=NULL, verbose=FALSE, 
                         fields=NULL, start=NULL, limit=20, callopts=list())
{
  url = 'http://api.gbif.org/v0.9/species/suggest'
  args <- compact(list(q=q, rank=rank, name=name, strict=strict, verbose=verbose,
                       offset=start, limit=limit))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  
  if(verbose){ 
    #     alt <- do.call(rbind.fill, lapply(tt$alternatives, namelkupparser))
    #     dat <- data.frame(tt[!names(tt) %in% c("alternatives","note")])
    #     list(data=dat, alternatives=alt)
    if(is.null(fields)){
      toget <- c("key","scientificName","rank")
    } else { toget <- fields }
    matched <- sapply(toget, function(x) x %in% suggestfields())
    if(!any(matched))
      stop(sprintf("the fields %s are not valid", paste0(names(matched[matched == FALSE]),collapse=",")))
    out <- lapply(tt, function(x) x[names(x) %in% toget])
    do.call(rbind.fill, lapply(out,data.frame))
  } else
  {
    if(is.null(fields)){
      toget <- c("key","scientificName","rank")
    } else { toget <- fields }
    matched <- sapply(toget, function(x) x %in% suggestfields())
    if(!any(matched))
      stop(sprintf("the fields %s are not valid", paste0(names(matched[matched == FALSE]),collapse=",")))
    out <- lapply(tt, function(x) x[names(x) %in% toget])
    do.call(rbind.fill, lapply(out,data.frame))
  }
}

#' Fields available in gbif_suggest function
#' @export
#' @keywords internal
suggestfields <- function(){  
  c("key","datasetTitle","datasetKey","nubKey","parentKey","parent",
    "kingdom","phylum","clazz","order","family","genus","species",
    "kingdomKey","phylumKey","classKey","orderKey","familyKey","genusKey",
    "speciesKey","scientificName","canonicalName","authorship",
    "accordingTo","nameType","taxonomicStatus","rank","numDescendants",
    "numOccurrences","sourceId","nomenclaturalStatus","threatStatuses",
    "synonym")
}