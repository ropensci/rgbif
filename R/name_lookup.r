#' Lookup names in all taxonomies in GBIF.
#'
#' @template all
#' @import httr
#' @import plyr
#' @template namelkup
#' @export
#' @examples \dontrun{
#' # Look up names like mammalia
#' name_lookup(class='mammalia')
#' 
#' # Get all data and parse it, removing descriptions which can be quite long
#' out <- name_lookup('Helianthus annuus', rank="species", verbose=TRUE)
#' library(plyr)
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
#' library(httr)
#' name_lookup(query='Cnaemidophorus', rank="genus", callopts=verbose())
#' 
#' # Limit records to certain number
#' name_lookup('Helianthus annuus', rank="species", limit=2)
#' 
#' # Using faceting
#' name_lookup(facet='status', facet_only=TRUE, facet_mincount='7000000')
#' name_lookup(facet=c('status','highertaxon_key'), facet_only=TRUE, facet_mincount='700000')
#' }
name_lookup <- function(query=NULL, canonical_name=NULL, class=NULL,
  description=NULL, family=NULL, genus=NULL, kingdom=NULL, order=NULL, 
  phylum=NULL, scientificName=NULL, species=NULL, rank=NULL, subgenus=NULL, 
  vernacularName=NULL, limit=20, facet=NULL, facet_only=NULL, facet_mincount=NULL, 
  facet_multiselect=NULL, callopts=list(), verbose=FALSE, return="all")
{
  if(!is.null(facet_mincount) && inherits(facet_mincount, "numeric"))
    stop("Make sure facet_mincount is character")
  if(!is.null(facet)) {
    facetbyname <- facet
    names(facetbyname) <- rep('facet', length(facet))
  } else { facetbyname <- NULL }
  
  url = 'http://api.gbif.org/v0.9/species/search'
  args <- as.list(compact(c(q=query, rank=rank, canonical_name=canonical_name, 
                       description=description, family=family, genus=genus, 
                       kingdom=kingdom, order=order, phylum=phylum, class=class,
                       scientificName=scientificName, species=species, 
                       subgenus=subgenus, vernacularName=vernacularName, 
                       limit=limit, facetbyname, facet_only=facet_only, 
                       facet_mincount=facet_mincount, facet_multiselect=facet_multiselect)))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  tt <- content(temp)
  
  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]

  # facets
  facets <- tt$facets
  if(!length(facets) == 0){
  facetsdat <- lapply(facets, function(x) do.call(rbind, lapply(x$counts, data.frame, stringsAsFactors=FALSE)))
  names(facetsdat) <- facet
  } else { facetsdat <- NULL  }

  # actual data
  if(!verbose){
    data <- do.call(rbind.fill, lapply(tt$results, namelkupparser))
  } else
  {
    data <- tt$results
  }

  # select output
  switch(return, 
         meta = data.frame(meta),
         data = data,
         facets = facetsdat,
         all = list(meta=data.frame(meta), data=data, facets=facetsdat))
}