#' Lookup names in all taxonomies.
#' 
#' See details for information about the sources. Paging is supported
#' 
#' @template occsearch
#' @examples \dontrun{
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='coord')
#' 
#' key <- gbif_lookup(name='Helianthus annuus', kingdom='plants')$speciesKey
#' occ_search(taxonKey=key, limit=2)
#' occ_search(taxonKey=key, limit=20)
#' occ_search(taxonKey=key, limit=20, return='meta')
#' occ_search(taxonKey=key, limit=20, return='hier')
#' 
#' occ_search(catalogNumber='PlantAndMushroom.6845144', minimal=FALSE)
#' }
occ_search <- function(taxonKey=NULL, boundingBox=NULL, collectorName=NULL, 
                       basisOfRecord=NULL, datasetKey=NULL, date=NULL, 
                       catalogNumber=NULL, callopts=list(), limit=20, start=NULL,
                       minimal=TRUE, return='all')
{
  url = 'http://api.gbif.org/occurrence/search'
  args <- compact(list(taxonKey=taxonKey, boundingBox=boundingBox, 
                       collectorName=collectorName, 
                       basisOfRecord=basisOfRecord, datasetKey=datasetKey, 
                       date=date, catalogNumber=catalogNumber, limit=limit, 
                       offset=start))
  tt <- content(GET(url, query=args, callopts))
  meta <- tt[c('offset','limit','endOfRecords','count')]
  data <- tt$results
  data <- gbifparser(data, minimal=minimal)
  if(return=='data'){
    ldfast(lapply(data, "[[", "data"))
  } else
    if(return=='hier'){
      lapply(data, "[[", "hierarch")
    } else
      if(return=='meta'){ data.frame(meta) } else
      {
        list(meta=meta, data=data)
      }
}
# http://api.gbif.org/occurrence/search?datasetKey=7b5d6a48-f762-11e1-a439-00145eb45e9a