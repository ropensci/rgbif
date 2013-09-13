#' Lookup names in all taxonomies.
#' 
#' See details for information about the sources.
#'
#' @template all
#' @importFrom httr GET content
#' @importFrom plyr compact rbind.fill
#' @template namelkup
#' @return A list of length two. The first element is metadata. The second is 
#' either a data.frame (verbose=FALSE, default) or a list (verbose=TRUE)
#' @export
#' @examples \dontrun{
#' # Look up names like mammalia
#' name_lookup(class='mammalia')
#' 
#' # Look up sunflowers
#' out <- name_lookup('Helianthus annuus', rank="species")
#' 
#' # Get all data and parse it, removing descriptions which can be quite long
#' out <- name_lookup('Helianthus annuus', rank="species", verbose=TRUE)
#' llply(out$data, function(x) x[!names(x) %in% c("descriptions","descriptionsSerialized")])
#' 
#' # Search for a genus, returning just data
#' name_lookup(query='Cnaemidophorus', rank="genus", return="data")
#' 
#' # Just metadata
#' name_lookup(query='Cnaemidophorus', rank="genus", return="meta")
#' 
#' # Just metadata
#' name_lookup(query='Cnaemidophorus', rank="genus")
#' 
#' # Get more data from the API call
#' name_lookup(query='Cnaemidophorus', rank="genus", callopts=verbose())
#' }
name_lookup <- function(query=NULL, canonical_name=NULL, class=NULL,
  description=NULL, family=NULL, genus=NULL, kingdom=NULL, order=NULL, 
  phylum=NULL, scientificName=NULL, species=NULL, rank=NULL, subgenus=NULL, 
  vernacularName=NULL, callopts=list(), verbose=FALSE, return="all")
{
  namelkupparser <- function(x){
    data.frame(
      compact(
        x[c('key','nubKey','parentKey','parent','kingdom','phylum',"clazz","order","family",
            "genus","kingdomKey","phylumKey","classKey","orderKey","familyKey","genusKey",
            "canonicalName","authorship","nameType","rank","numOccurrences")]))
  }
  url = 'http://api.gbif.org/name_usage/search'
  args <- compact(list(q=query, rank=rank, canonical_name=canonical_name, 
                       description=description, family=family, genus=genus, 
                       kingdom=kingdom, order=order, phylum=phylum, class=class,
                       scientificName=scientificName, species=species, 
                       subgenus=subgenus, vernacularName=vernacularName))
  tt <- content(GET(url, query=args, callopts))
  meta <- tt[c('offset','limit','endOfRecords','count')]
  if(!verbose){
    data <- do.call(rbind.fill, lapply(tt$results, namelkupparser))
  } else
  {
    data <- tt$results
  }
  
  if(!verbose){
    data <- do.call(rbind.fill, lapply(tt$results, namelkupparser))
  } else
  {
    data <- tt$results
  }
  
  if(return=='meta'){ 
    data.frame(meta)
  } else
  if(return=='data'){
    data
  } else
  {
    list(meta=data.frame(meta), data=data)
  }
}