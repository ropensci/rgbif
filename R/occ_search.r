#' Search for GBIF occurrences.
#' 
#' @template all
#' @import httr
#' @import plyr
#' @template occsearch
#' @template occ
#' @param georeferenced Return only occurence records with lat/long data (TRUE) or
#' all records (FALSE, default).
#' @examples \dontrun{
#' # Search by species name, using \code{gbif_lookup} first to get key
#' key <- gbif_lookup(name='Helianthus annuus', kingdom='plants')$speciesKey
#' occ_search(taxonKey=key, limit=2)
#' 
#' # Return 20 results, this is the default by the way
#' occ_search(taxonKey=key, limit=20)
#' 
#' # Return just metadata for the search
#' occ_search(taxonKey=key, return='meta')
#' 
#' # Search by dataset key
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')
#' 
#' # Search by catalog number
#' occ_search(catalogNumber="49366")
#' 
#' # Get all data, not just lat/long and name
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', minimal=FALSE)
#' 
#' # Use paging parameters (limit and start) to page. Note the different results 
#' # for the two queries below.
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5,return="data")
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5,return="data")
#' 
#' # Many dataset keys
#' occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7","7b5d6a48-f762-11e1-a439-00145eb45e9a"))
#' 
#' # Occurrence data: lat/long data, and associated metadata with occurrences
#' ## If return='data' the output is a data.frame of all data together 
#' ## for easy manipulation
#' occ_search(taxonKey=key, return='data')
#' 
#' # Taxonomic hierarchy data
#' ## If return='meta' the output is a list of the hierarch for each record
#' occ_search(taxonKey=key, limit=20, return='hier')
#' 
#' # Search by collector name
#' occ_search(collectorName="smith")
#' 
#' # Many collector names
#' occ_search(collectorName=c("smith","BJ Stacey"))
#' 
#' # Pass in curl options for extra fun
#' occ_search(taxonKey=key, limit=20, return='hier', callopts=verbose())
#' 
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) gbif_lookup(name=x, kingdom='plants')$speciesKey, USE.NAMES=FALSE)
#' occ_search(taxonKey=keys, limit=5, return='data')
#' }
#' \donttest{
#' # If you try multiple values for two different parameters you are wacked on the hand
#' occ_search(taxonKey=c(2482598,2492010), collectorName=c("smith","BJ Stacey"))
#' 
#' # Get a lot of data, here 1500 records for Helianthus annuus
#' out <- occ_search(taxonKey=key, limit=1500, return="data")
#' nrow(out)
#' }
#' @export
occ_search <- function(taxonKey=NULL, country=NULL, georeferenced=NULL, boundingBox=NULL, 
  collectorName=NULL, basisOfRecord=NULL, datasetKey=NULL, date=NULL, catalogNumber=NULL,
  callopts=list(), limit=20, start=NULL, minimal=TRUE, return='all', ...)
{
  url = 'http://api.gbif.org/v0.9/occurrence/search'  
  getdata <- function(x=NULL, itervar=NULL){
    if(!is.null(x))
      assign(itervar, x)
    
    args <- compact(list(taxonKey=taxonKey, country=country, georeferenced=georeferenced, 
                         boundingBox=boundingBox, collectorName=collectorName, 
                         basisOfRecord=basisOfRecord, datasetKey=datasetKey, date=date, 
                         catalogNumber=catalogNumber, limit=limit, offset=start))  
    iter <- 0
    sumreturned <- 0
    outout <- list()
    while(sumreturned < limit){
      iter <- iter + 1
      temp <- GET(url, query=args, callopts)
      stop_for_status(temp)
      tt <- content(temp)
      numreturned <- length(tt$results)
      sumreturned <- sumreturned + numreturned
      
      if(tt$count < limit)
        sumreturned <- 999999
      
      if(sumreturned < limit){
        args$limit <- limit-numreturned
        args$offset <- sumreturned
      }
      outout[[iter]] <- tt
    }
    
    meta <- outout[[length(outout)]][c('offset','limit','endOfRecords','count')]
#     data <- sapply(outout, "[[", "results")
#     data <- do.call(c, data)
    data <- do.call(c, lapply(outout, "[[", "results"))
#     data <- gbifparser(input=data, minimal=minimal)
    
    if(return=='data'){
      if(identical(data, list())){
        paste("no data found, try a different search")
      } else
      {
        data <- gbifparser(input=data, minimal=minimal)        
        ldfast(lapply(data, "[[", "data"))
      }
    } else
    if(return=='hier'){
      if(identical(data, list())){
        paste("no data found, try a different search")
      } else
      {
        data <- gbifparser(input=data, minimal=minimal)
        unique(lapply(data, "[[", "hierarch"))
      }
    } else
    if(return=='meta'){ 
      data.frame(meta) 
    } else
    {
      if(identical(data, list())){
        dat2 <- paste("no data found, try a different search")
        hier2 <- paste("no data found, try a different search")
      } else
      {
        data <- gbifparser(input=data, minimal=minimal)
        dat2 <- ldfast(lapply(data, "[[", "data"))
        hier2 <- unique(lapply(data, "[[", "hierarch"))
      }
      list(meta=meta, hierarchy=hier2, data=dat2)
    }
  }
  
  params <- list(taxonKey=taxonKey,datasetKey=datasetKey,
                 catalogNumber=catalogNumber,collectorName=collectorName)
  if(!any(sapply(params, length)>0))
    stop("at least one of the parmaters taxonKey, datasetKey, catalogNumber, collectorName
         must have a value")
  iter <- params[which(sapply(params, length)>1)]
  if(length(names(iter))>1)
    stop("You can have multiple values for only one of taxonKey, datasetKey, catalogNumber, or collectorName")
  
  if(length(iter)==0){
    out <- getdata()
  } else
  {
    out <- lapply(iter[[1]], getdata, itervar = names(iter))
    names(out) <- iter[[1]]
  }
  
  out
}