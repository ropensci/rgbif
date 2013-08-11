#' Lookup names in all taxonomies.
#' 
#' See details for information about the sources.
#'
#' @template namelkup
#' @export
#' @examples \dontrun{
#' name_lookup(class='mammalia')
#' }
name_lookup <- function(canonical_name=NULL, class=NULL, description=NULL, 
                        family=NULL, genus=NULL, kingdom=NULL, order=NULL, 
                        phylum=NULL, scientificName=NULL, species=NULL, 
                        subgenus=NULL, vernacularName=NULL, callopts=list())
{
  url = 'http://api.gbif.org/name_usage/search'
  args <- compact(list(name=name, canonical_name=canonical_name, class=class, 
                       description=description, family=family, genus=genus, 
                       kingdom=kingdom, order=order, phylum=phylum, 
                       scientificName=scientificName, species=species, 
                       subgenus=subgenus, vernacularName=vernacularName))
  tt <- content(GET(url, query=args, callopts))
  meta <- tt[c('offset','limit','endOfRecords','count')]
  data <- tt$results
  list(meta=meta, data=data)
}
# http://api.gbif.org/name_usage/search?class=mammalia