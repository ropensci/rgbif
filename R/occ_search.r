#' Search for GBIF occurrences.
#' 
#' @import httr plyr
#' @template occsearch
#' @template occ
#' @template all
#' @examples \dontrun{
#' # Search by species name, using \code{\link{name_backbone}} first to get key
#' key <- name_backbone(name='Helianthus annuus', kingdom='plants')$speciesKey
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
#' occ_search(catalogNumber=c("49366","Bird.27847588"))
#' 
#' # Get all data, not just lat/long and name
#' occ_search(taxonKey=key, fields='all')
#' 
#' # Or get specific fields. Note that this isn't done on GBIF's side of things. This
#' # is done in R, but before you get the return object, so other fields are garbage
#' # collected
#' occ_search(taxonKey=key, fields=c('name','basisOfRecord','protocol'))
#' 
#' # Use paging parameters (limit and start) to page. Note the different results 
#' # for the two queries below.
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5,
#'    return="data")
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5,
#'    return="data")
#' 
#' # Many dataset keys
#' occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"))
#' 
#' # Occurrence data: lat/long data, and associated metadata with occurrences
#' ## If return='data' the output is a data.frame of all data together 
#' ## for easy manipulation
#' occ_search(taxonKey=key, return='data')
#' 
#' # Taxonomic hierarchy data
#' ## If return='meta' the output is a list of the hierarch for each record
#' occ_search(taxonKey=key, return='hier')
#' 
#' # Search by collector name
#' occ_search(collectorName="smith")
#' 
#' # Many collector names
#' occ_search(collectorName=c("smith","BJ Stacey"))
#' 
#' # Pass in curl options for extra fun
#' library(httr)
#' occ_search(taxonKey=key, limit=20, return='hier', callopts=verbose())
#' 
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_backbone(name=x, kingdom='plants')$speciesKey,
#'    USE.NAMES=FALSE)
#' occ_search(taxonKey=keys, limit=5, return='data')
#' 
#' # Search on latitidue and longitude
#' occ_search(taxonKey=key, latitude=40, longitude=-120)
#' 
#' # Search on a bounding box (in well known text format)
#' occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
#' key <- name_backbone(name='Aesculus hippocastanum', kingdom='plants')$speciesKey
#' occ_search(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
#' 
#' # Search on country
#' occ_search(country='US')
#'
#' # Get only occurrences with lat/long data (i.e. georeferenced)
#' occ_search(taxonKey=key, georeferenced=TRUE)
#' 
#' # Get only occurrences that were recorded as living specimens
#' occ_search(taxonKey=key, basisOfRecord="LIVING_SPECIMEN", georeferenced=TRUE)
#' 
#' # Get occurrences for a particular date
#' occ_search(taxonKey=key, date="2013")
#' occ_search(taxonKey=key, year="2013")
#' occ_search(taxonKey=key, month="6")
#'
#' # Get occurrences based on depth
#' key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, depth="5")
#' 
#' # Get occurrences based on altitude
#' key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, altitude=2000, georeferenced=TRUE)
#' 
#' # Get occurrences based on institutionCode
#' occ_search(institutionCode="TLMF")
#' occ_search(institutionCode=c("TLMF","ArtDatabanken"))
#' 
#' # Get occurrences based on collectionCode
#' occ_search(collectionCode="Floristic Databases MV - Higher Plants")
#' occ_search(collectionCode=c("Floristic Databases MV - Higher Plants","Artport"))
#' 
#' # Get only those occurrences with spatial issues
#' occ_search(taxonKey=key, spatialIssues=TRUE)
#' 
#' # Search using a query string
#' occ_search(search="kingfisher")
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
occ_search <- function(taxonKey=NULL, country=NULL, publishingCountry=NULL, georeferenced=NULL, 
  geometry=NULL, collectorName=NULL, basisOfRecord=NULL, datasetKey=NULL, date=NULL, 
  catalogNumber=NULL, year=NULL, month=NULL, latitude=NULL, longitude=NULL, 
  altitude=NULL, depth=NULL, institutionCode=NULL, collectionCode=NULL, 
  spatialIssues=NULL, search=NULL, callopts=list(), limit=20, start=NULL, 
  fields = 'minimal', return='all')
{
  url = 'http://api.gbif.org/v0.9/occurrence/search'
  getdata <- function(x=NULL, itervar=NULL)
  {
    if(!is.null(x))
      assign(itervar, x)
    
    args <- compact(list(taxonKey=taxonKey, country=country, publishingCountry=publishingCountry, 
       georeferenced=georeferenced, geometry=geometry, collectorName=collectorName, 
       basisOfRecord=basisOfRecord, datasetKey=datasetKey, date=date, catalogNumber=catalogNumber,
       year=year, month=month, latitude=latitude, longitude=longitude, 
       altitude=altitude, depth=depth, institutionCode=institutionCode, 
       collectionCode=collectionCode, spatialIssues=spatialIssues, q=search, 
       limit=as.integer(limit), offset=start))
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
        limit <- tt$count
#         sumreturned <- 999999999
      
      if(sumreturned < limit){
        args$limit <- limit-sumreturned
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
#         data <- gbifparser(input=data, minimal=minimal)
        data <- gbifparser(input=data, fields=fields)
        ldfast(lapply(data, "[[", "data"))
      }
    } else
    if(return=='hier'){
      if(identical(data, list())){
        paste("no data found, try a different search")
      } else
      {
#         data <- gbifparser(input=data, minimal=minimal)
        data <- gbifparser(input=data, fields=fields)
        unique(lapply(data, "[[", "hierarchy"))
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
#         data <- gbifparser(input=data, minimal=minimal)
        data <- gbifparser(input=data, fields=fields)
        dat2 <- ldfast(lapply(data, "[[", "data"))
        hier2 <- unique(lapply(data, "[[", "hierarchy"))
      }
      list(meta=meta, hierarchy=hier2, data=dat2)
    }
  }
  
  params <- list(taxonKey=taxonKey,datasetKey=datasetKey,catalogNumber=catalogNumber,
                 collectorName=collectorName,geometry=geometry,country=country,
                 search=search,institutionCode=institutionCode,collectionCode=collectionCode,
                 latitude=latitude,longitude=longitude)
  if(!any(sapply(params, length)>0))
    stop("at least one of the parmaters taxonKey, datasetKey, catalogNumber, collectorName, geometry, latitude, or longitude 
         must have a value")
  iter <- params[which(sapply(params, length)>1)]
  if(length(names(iter))>1)
    stop("You can have multiple values for only one of taxonKey, datasetKey, catalogNumber, collectorName,
         collectionCode, institutionCode")
  
  if(length(iter)==0){
    out <- getdata()
  } else
  {
    out <- lapply(iter[[1]], getdata, itervar = names(iter))
    names(out) <- iter[[1]]
  }
  
  out
}