#' occurrencelist_many is the same as occurrencelist, but takes in a vector 
#' of species names.
#'
#' @template oclist
#' @param parallel Do calls in parallel or not. (default is FALSE)
#' @param cores Number of cores to use in parallel call option (only used 
#'    if parallel=TRUE)
#' @examples \dontrun{
#' # Query for a many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100)
#' gbifdata(out)
#' gbifmap_list(out)
#' }
#' @export
occurrencelist_many <- function(scientificname = NULL, taxonconceptkey = NULL,
    dataproviderkey = NULL, dataresourcekey = NULL, institutioncode = NULL,
    collectioncode = NULL, catalognumber = NULL, resourcenetworkkey = NULL,
    basisofrecordcode = NULL, minlatitude = NULL, maxlatitude = NULL,
    minlongitude = NULL, maxlongitude = NULL, minaltitude = NULL, maxaltitude = NULL,
    mindepth = NULL, maxdepth = NULL, cellid = NULL, centicellid = NULL,
    typesonly = NULL, georeferencedonly = NULL, coordinatestatus = NULL,
    coordinateissues = NULL, hostisocountrycode = NULL, originisocountrycode = NULL,
    originregioncode = NULL, startdate = NULL, enddate = NULL, startyear = NULL,
    endyear = NULL, year = NULL, month = NULL, day = NULL, modifiedsince = NULL,
    startindex = NULL, maxresults = 10, format = "brief", icon = NULL,
    mode = NULL, stylesheet = NULL, removeZeros = FALSE, writecsv = NULL,
    curl = getCurlHandle(), fixnames = "none", parallel = FALSE, cores=4) 
{	  
  url = "http://data.gbif.org/ws/rest/occurrence/list"
  registerDoMC = NULL
  
  getdata <- function(x){
    
    if(is.null(scientificname)){
      taxonkey <- x
      sciname <- NULL
    } else {
      sciname <- x
      taxonkey <- NULL
    }
    
    args <- compact(
      list(
        scientificname=sciname, taxonconceptkey=taxonkey,
        dataresourcekey=dataresourcekey, institutioncode=institutioncode,
        collectioncode=collectioncode, catalognumber=catalognumber,
        resourcenetworkkey=resourcenetworkkey, dataproviderkey=dataproviderkey,
        basisofrecordcode=basisofrecordcode, coordinatestatus=coordinatestatus, 
        minlatitude=minlatitude, maxlatitude=maxlatitude, minlongitude=minlongitude, 
        maxlongitude=maxlongitude, minaltitude=minaltitude, maxaltitude=maxaltitude, 
        mindepth=mindepth, maxdepth=maxdepth, cellid=cellid, centicellid=centicellid,
        typesonly=typesonly, coordinateissues=coordinateissues,
        hostisocountrycode=hostisocountrycode, originisocountrycode=originisocountrycode,
        originregioncode=originregioncode, startdate=startdate, enddate=enddate,
        startyear=startyear, endyear=endyear, year=year, month=month, day=day,
        modifiedsince=modifiedsince, startindex=startindex, format=format,
        icon=icon, mode=mode, stylesheet=stylesheet, maxresults=as.integer(maxresults)
      ))
    
    if(maxresults < 1000)
      args$maxresults <- maxresults
    
    iter <- 0
    sumreturned <- 0
    outout <- list()
    while(sumreturned < maxresults){
      iter <- iter + 1
      if(is.null(args)){ tt <- getURL(url) } else
      { tt <- getForm(url, .params = args, curl = curl) }
      outlist <- xmlParse(tt)
      numreturned <- as.numeric(xpathSApply(outlist, "//gbif:summary/@totalReturned", 
                                            namespaces="gbif"))
      ss <- tryCatch(xpathApply(outlist, "//gbif:nextRequestUrl", xmlValue)[[1]], 
                     error = function(e) e$message)	
      if(ss=="subscript out of bounds"){url <- NULL} else {
        url <- sub("&maxresults=[0-9]+", 
                   paste("&maxresults=",maxresults-sumreturned,sep=''), ss)
      }
      args <- NULL
      sumreturned <- sumreturned + numreturned
      if(is.null(url))
        maxresults <- sumreturned
      outout[[iter]] <- outlist
    }
    outt <- lapply(outout, parseresults, format=format, removeZeros=removeZeros)
    dd <- do.call(rbind, outt)
    
    if(fixnames == "match"){
      dd[ dd$taxonName %in% sciname, ]
    } else
      if(fixnames == "change"){
        dd$taxonName <- sciname
        dd
      } else
        { dd } 
  }
  
  if(is.null(scientificname)){itervec <- taxonconceptkey} else 
  {itervec <- scientificname}
  
  if(length(scientificname)==1 | length(taxonconceptkey)==1){
    out <- getdata(itervec)
  } else
  {
    if(parallel){
      registerDoMC(cores=cores)
      out <- ldply(itervec, getdata, .parallel=TRUE)
    } else
    {
      out <- ldply(itervec, getdata)
    }
  }
  
  if(!is.null(writecsv)){
    write.csv(out, file=writecsv, row.names=F)
    message("Success! CSV file written")
  } else
  { 
    class(out) <- c("gbiflist","data.frame")
    return( out )
  }
}