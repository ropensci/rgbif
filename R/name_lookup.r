#' Lookup names in all taxonomies in GBIF.
#'
#' @template all
#' @import httr
#' @import plyr
#' @template namelkup
#' @return A list of length two. The first element is metadata. The second is 
#' either a data.frame (verbose=FALSE, default) or a list (verbose=TRUE)
#' @description
#' This service uses fuzzy lookup so that you can put in partial names and 
#' you should get back those things that match. See examples below.
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
#' # Fuzzy searching
#' name_lookup(query='Cnaemidophor', rank="genus")
#' 
#' # Get more data from the API call
#' name_lookup(query='Cnaemidophorus', rank="genus", callopts=verbose())
#' 
#' # Limit records to certain number
#' name_lookup('Helianthus annuus', rank="species", limit=2)
#' }
name_lookup <- function(query=NULL, canonical_name=NULL, class=NULL,
  description=NULL, family=NULL, genus=NULL, kingdom=NULL, order=NULL, 
  phylum=NULL, scientificName=NULL, species=NULL, rank=NULL, subgenus=NULL, 
  vernacularName=NULL, limit=20, callopts=list(), 
  verbose=FALSE, return="all")
{
  url = 'http://api.gbif.org/v0.9/species/search'
  args <- compact(list(q=query, rank=rank, canonical_name=canonical_name, 
                       description=description, family=family, genus=genus, 
                       kingdom=kingdom, order=order, phylum=phylum, class=class,
                       scientificName=scientificName, species=species, 
                       subgenus=subgenus, vernacularName=vernacularName, 
                       limit=limit))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  meta <- tt[c('offset','limit','endOfRecords','count')]
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