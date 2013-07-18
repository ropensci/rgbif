#' Occurrencelist searches for taxon concept records matching a range of filters.
#'
#' @template oclist
#' @examples \dontrun{
#' # Query for a single species
#' occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, 
#'    maxresults = 40)
#' occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, 
#'    maxresults = 5)
#' 
#' # Query for many species, in this case using parallel fuctionality with plyr::llply
#' # Also, see \code{\link{occurrencelist_many}} as an alternative way to search for 
#' # many species, which is better for going straight to a map with the output data.
#' library(doMC)
#' registerDoMC(cores=4)
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- llply(splist, function(x) occurrencelist(x, coordinatestatus = TRUE, 
#'    maxresults = 100), .parallel=T)
#' lapply(out, head)
#'
#' # Write the output to csv file
#' occurrencelist(scientificname = 'Erebia gorge*', 
#'    coordinatestatus = TRUE, maxresults = 200, writecsv="~/adsdf.csv")
#' }
#' @export
occurrencelist <- function(scientificname = NULL, taxonconceptkey = NULL,
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
		curl = getCurlHandle(), fixnames = "none") 
{	
	url = "http://data.gbif.org/ws/rest/occurrence/list"
	
	args <- compact(
		list(
			scientificname=scientificname, dataproviderkey=dataproviderkey,
			dataresourcekey=dataresourcekey, institutioncode=institutioncode,
			collectioncode=collectioncode, catalognumber=catalognumber,
			resourcenetworkkey=resourcenetworkkey, taxonconceptkey=taxonconceptkey,
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
		dd <- dd[ dd$taxonName %in% scientificname, ]
	} else
		if(fixnames == "change"){
			dd$taxonName <- scientificname
	} else
		{ NULL } 
	
	if(!is.null(writecsv)){
		write.csv(dd, file=writecsv, row.names=F)
		message("Success! CSV file written")
	} else
		{ 
      class(dd) <- c("gbiflist","data.frame")
      return( dd )
		}
}