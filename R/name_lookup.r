#' Lookup names in all taxonomies in GBIF.
#'
#' @template namelkup
#' @export
#' @references \url{http://www.gbif.org/developer/species#searching}
#' @examples \dontrun{
#' # Look up names like mammalia
#' name_lookup(query='mammalia')
#'
#' # Paging
#' name_lookup(query='mammalia', limit=1)
#' name_lookup(query='mammalia', limit=1, start=2)
#'
#' # large requests, use start parameter
#' first <- name_lookup(query='mammalia', limit=1000)
#' second <- name_lookup(query='mammalia', limit=1000, start=1000)
#' tail(first$data)
#' head(second$data)
#' first$meta
#' second$meta
#'
#' # Get all data and parse it, removing descriptions which can be quite long
#' out <- name_lookup('Helianthus annuus', rank="species", verbose=TRUE)
#' lapply(out$data, function(x) x[!names(x) %in% c("descriptions","descriptionsSerialized")])
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
#' # Limit records to certain number
#' name_lookup('Helianthus annuus', rank="species", limit=2)
#'
#' # Query by habitat
#' name_lookup(habitat = "terrestrial", limit=2)
#' name_lookup(habitat = "marine", limit=2)
#' name_lookup(habitat = "freshwater", limit=2)
#'
#' # Using faceting
#' name_lookup(facet='status', limit=0, facetMincount='70000')
#' name_lookup(facet=c('status','higherTaxonKey'), limit=0, facetMincount='700000')
#'
#' name_lookup(facet='nameType', limit=0)
#' name_lookup(facet='habitat', limit=0)
#' name_lookup(facet='datasetKey', limit=0)
#' name_lookup(facet='rank', limit=0)
#' name_lookup(facet='isExtinct', limit=0)
#'
#' name_lookup(isExtinct=TRUE, limit=0)
#'
#' # text highlighting
#' ## turn on highlighting
#' res <- name_lookup(query='canada', hl=TRUE, limit=5)
#' res$data
#' name_lookup(query='canada', hl=TRUE, limit=45, return='data')
#' ## and you can pass the output to gbif_names() function
#' res <- name_lookup(query='canada', hl=TRUE, limit=5)
#' gbif_names(res)
#'
#' # Lookup by datasetKey
#' name_lookup(datasetKey='3f8a1297-3259-4700-91fc-acc4170b27ce')
#'
#' # Pass on httr options
#' library('httr')
#' name_lookup(query='Cnaemidophorus', rank="genus", config=verbose())
#' }

name_lookup <- function(query=NULL, rank=NULL, higherTaxonKey=NULL, status=NULL, isExtinct=NULL,
  habitat=NULL, nameType=NULL, datasetKey=NULL, nomenclaturalStatus=NULL,
  limit=100, start=NULL, facet=NULL, facetMincount=NULL, facetMultiselect=NULL, type=NULL, hl=NULL,
  verbose=FALSE, return="all", ...) {

  if (!is.null(facetMincount) && inherits(facetMincount, "numeric"))
    stop("Make sure facetMincount is character")
  if (!is.null(facet)) {
    facetbyname <- facet
    names(facetbyname) <- rep('facet', length(facet))
  } else {
    facetbyname <- NULL
  }

  url <- paste0(gbif_base(), '/species/search')
  args <- rgbif_compact(list(q=query, rank=rank, higherTaxonKey=higherTaxonKey, status=status,
            isExtinct=as_log(isExtinct), habitat=habitat, nameType=nameType, datasetKey=datasetKey,
            nomenclaturalStatus=nomenclaturalStatus, limit=limit, offset=start,
            facetMincount=facetMincount,
            facetMultiselect=as_log(facetMultiselect), hl=as_log(hl), type=type))
  args <- c(args, facetbyname)
  tt <- gbif_GET(url, args, FALSE, ...)

  # metadata
  meta <- tt[c('offset', 'limit', 'endOfRecords', 'count')]

  # facets
  facets <- tt$facets
  if (!length(facets) == 0) {
    facetsdat <- lapply(facets, function(x) do.call(rbind, lapply(x$counts, data.frame, stringsAsFactors = FALSE)))
    names(facetsdat) <- tolower(sapply(facets, "[[", "field"))
  } else {
    facetsdat <- NULL
  }

  # actual data
  if (!verbose) {
    data <- data.table::setDF(
      data.table::rbindlist(
        lapply(tt$results, namelkupcleaner),
        use.names = TRUE, fill = TRUE))
    if (limit > 0) data <- movecols(data, c('key', 'scientificName'))
  } else {
    data <- tt$results
  }

  # hierarchies
  hierdat <- lapply(tt$results, function(x){
    tmp <- x[ names(x) %in% "higherClassificationMap" ]
    tmpdf <- data.frame(rankkey = names(rgbif_compact(tmp[[1]])),
                        name = unlist(unname(rgbif_compact(tmp[[1]]))),
                        stringsAsFactors = FALSE)
    if (NROW(tmpdf) == 0) NULL else tmpdf
  })
  names(hierdat) <- vapply(tt$results, "[[", numeric(1), "key")

  # vernacular names
  vernames <- lapply(tt$results, function(x){
    rbind_fill(lapply(x$vernacularNames, data.frame))
  })
  names(vernames) <- vapply(tt$results, "[[", numeric(1), "key")

  # select output
  return <- match.arg(return, c('meta', 'data', 'facets', 'hierarchy', 'names', 'all'))
  switch(return,
         meta = data.frame(meta, stringsAsFactors = FALSE),
         data = data,
         facets = facetsdat,
         hierarchy = compact_null(hierdat),
         names = compact_null(vernames),
         all = list(meta = data.frame(meta, stringsAsFactors = FALSE), data = data, facets = facetsdat,
                    hierarchies = compact_null(hierdat), names = compact_null(vernames)))
}
