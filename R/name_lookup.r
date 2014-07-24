#' Lookup names in all taxonomies in GBIF.
#'
#' @template all
#' @template namelkup
#' @import httr plyr
#' @export
#' @examples \dontrun{
#' # Look up names like mammalia
#' name_lookup(query='mammalia')
#' 
#' # Get all data and parse it, removing descriptions which can be quite long
#' out <- name_lookup('Helianthus annuus', rank="species", verbose=TRUE)
#' library("plyr")
#' llply(out$data, function(x) x[!names(x) %in% c("descriptions","descriptionsSerialized")])
#' 
#' # Search for a genus, returning just data
#' name_lookup(query='Cnaemidophorus', rank="genus", return="data")
#' 
#' # Just metadata
#' name_lookup(query='Cnaemidophorus', rank="genus", return="meta")
#' 
#' # Just hierarchies
#' name_lookup(query='Cnaemidophorus', rank="genus", return="hierarchy")
#' 
#' # Just vernacular (common) names
#' name_lookup(query='Cnaemidophorus', rank="genus", return="names")
#' 
#' # Fuzzy searching
#' name_lookup(query='Cnaemidophor', rank="genus")
#' 
#' # Get more data from the API call
#' library("httr")
#' name_lookup(query='Cnaemidophorus', rank="genus", callopts=verbose())
#' 
#' # Limit records to certain number
#' name_lookup('Helianthus annuus', rank="species", limit=2)
#' 
#' # Using faceting
#' name_lookup(facet='status', limit=0, facetMincount='70000')
#' name_lookup(facet=c('status','highertaxon_key'), limit=0, facetMincount='700000')
#' 
#' name_lookup(facet='name_type', limit=0)
#' name_lookup(facet='habitat', limit=0)
#' name_lookup(facet='dataset_key')
#' name_lookup(facet='rank', limit=0)
#' name_lookup(facet='extinct', limit=0)
#' }

name_lookup <- function(query=NULL, rank=NULL, highertaxon_key=NULL, status=NULL, extinct=NULL, 
  habitat=NULL, name_type=NULL, dataset_key=NULL, nomenclatural_status=NULL,
  limit=20, facet=NULL, facetMincount=NULL, facetMultiselect=NULL, type=NULL, callopts=list(), 
  verbose=FALSE, return="all")
{
  if(!is.null(facetMincount) && inherits(facetMincount, "numeric"))
    stop("Make sure facetMincount is character")
  if(!is.null(facet)) {
    facetbyname <- facet
    names(facetbyname) <- rep('facet', length(facet))
  } else { facetbyname <- NULL }
  
  url = 'http://api.gbif.org/v1/species/search'
  args <- as.list(rgbif_compact(c(q=query, rank=rank, highertaxon_key=highertaxon_key, status=status, 
            extinct=extinct, habitat=habitat, name_type=name_type, dataset_key=dataset_key, 
            nomenclatural_status=nomenclatural_status, limit=limit, facetbyname, 
            facetMincount=facetMincount, 
            facetMultiselect=facetMultiselect, type=type)))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  assert_that(temp$headers$`content-type`=='application/json')
  res <- content(temp, as = 'text', encoding = "UTF-8")
  tt <- RJSONIO::fromJSON(res, simplifyWithNames = FALSE)
  
  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]

  # facets
  facets <- tt$facets
  if(!length(facets) == 0){
    facetsdat <- lapply(facets, function(x) do.call(rbind, lapply(x$counts, data.frame, stringsAsFactors=FALSE)))
    names(facetsdat) <- tolower(sapply(facets, "[[", "field"))
  } else { facetsdat <- NULL  }
  
  # actual data
  if(!verbose){
    data <- do.call(rbind.fill, lapply(tt$results, namelkupparser))
  } else
  {
    data <- tt$results
  }
  
  # hierarchies
  hierdat <- sapply(tt$results, function(x){
    tmp <- x[ names(x) %in% "higherClassificationMap" ]
    tmpdf <- data.frame(rankkey=names(tmp[[1]]), name=unlist(unname(tmp[[1]])), stringsAsFactors = FALSE)
    if(NROW(tmpdf) == 0) NULL else tmpdf
  })
  names(hierdat) <- vapply(tt$results, "[[", numeric(1), "key")
  
  # vernacular names
  vernames <- lapply(tt$results, function(x){
    rbind.fill(lapply(x$vernacularNames, data.frame))
  })
  names(vernames) <- vapply(tt$results, "[[", numeric(1), "key")

  # select output
  return <- match.arg(return, c('meta','data','facets','hierarchy','names','all'))
  switch(return, 
         meta = data.frame(meta, stringsAsFactors=FALSE),
         data = data,
         facets = facetsdat,
         hierarchy = compact_null(hierdat),
         names = compact_null(vernames),
         all = list(meta=data.frame(meta, stringsAsFactors=FALSE), data=data, facets=facetsdat, 
                    hierarchies=compact_null(hierdat), names=compact_null(vernames)))
}