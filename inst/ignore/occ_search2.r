# occ <- function(gbifopts=list())
# {
#   do.call(occ_search, gbifopts)
# }
# 
# occ(gbifopts=list(taxonKey=1858636, limit=2))

# occ_search(taxonKey=1858636, limit=2)
#
occ_search <- function(taxonKey=NULL, georeferenced=NULL, boundingBox=NULL, 
  collectorName=NULL, basisOfRecord=NULL, datasetKey=NULL, date=NULL, catalogNumber=NULL,
  callopts=list(), limit=20, start=NULL, minimal=TRUE, return='all', pars=list())
{
  url = 'http://api.gbif.org/v0.9/occurrence/search'  
  getdata <- function(x=NULL, itervar=NULL){
    if(!is.null(x))
      assign(itervar, x)
    
    args <- compact(list(taxonKey=pars$taxonKey, georeferenced=pars$georeferenced, 
              boundingBox=pars$boundingBox, collectorName=pars$collectorName, 
              basisOfRecord=pars$basisOfRecord, datasetKey=pars$datasetKey, date=pars$date, 
              catalogNumber=pars$catalogNumber, limit=pars$limit, offset=pars$start))  
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
    data <- sapply(outout, "[[", "results")
    data <- gbifparser(data, minimal=minimal)
    
    if(return=='data'){
      ldfast(lapply(data, "[[", "data"))
    } else
      if(return=='hier'){
        unique(lapply(data, "[[", "hierarch"))
      } else
        if(return=='meta'){ 
          data.frame(meta) 
        } else
        {
          list(meta=meta, hierarchy=unique(lapply(data, "[[", "hierarch")), 
               data=ldfast(lapply(data, "[[", "data")))
        }
  }
  
  params <- list(taxonKey=pars$taxonKey,datasetKey=pars$datasetKey,
                 catalogNumber=pars$catalogNumber,collectorName=pars$collectorName)
  if(!any(sapply(params, length)>0))
    stop("at least one of the parmaters taxonKey, datasetKey, catalogNumber, collectorName must have a value")
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