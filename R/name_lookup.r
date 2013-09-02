#' Lookup names in all taxonomies.
#' 
#' See details for information about the sources.
#'
#' @template namelkup
#' @export
#' @examples \dontrun{
#' name_lookup(class='mammalia')
#' out <- name_lookup('Helianthus annuus', rank="species")
#' out$data[[1]][!names(out$data[[1]]) %in% c("descriptions","descriptionsSerialized")]
#' llply(out$data, function(x) x[!names(x) %in% c("descriptions","descriptionsSerialized")])
#' }
name_lookup <- function(query=NULL, canonical_name=NULL, class=NULL,
  description=NULL, family=NULL, genus=NULL, kingdom=NULL, order=NULL, 
  phylum=NULL, scientificName=NULL, species=NULL, rank=NULL, subgenus=NULL, 
  vernacularName=NULL, callopts=list())
{
  url = 'http://api.gbif.org/name_usage/search'
  args <- compact(list(q=query, rank=rank, canonical_name=canonical_name, 
                       description=description, family=family, genus=genus, 
                       kingdom=kingdom, order=order, phylum=phylum, class=class,
                       scientificName=scientificName, species=species, 
                       subgenus=subgenus, vernacularName=vernacularName))
  tt <- content(GET(url, query=args, callopts))
  meta <- tt[c('offset','limit','endOfRecords','count')]
  data <- tt$results
  list(meta=meta, data=data)
}
# http://api.gbif.org/name_usage/search?class=mammalia