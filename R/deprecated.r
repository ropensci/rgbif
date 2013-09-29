#' The density web service provides access to records showing the density
#'    of occurrence records from the GBIF Network by one-degree cell.
#'
#' This is similar to the densitylist function. You can get the same data.frame
#'    of results as densitylist with this function, but you can also get a
#'    species list or data.frame of species and their counts for any degree cell.
#'
#' @import RCurl XML plyr
#' @param taxonconceptKey Unique key for taxon (numeric). Count only records
#'    which are for the taxon identified by the supplied numeric key, including
#'    any records provided under synonyms of the taxon concerned, and any
#'    records for child taxa (e.g. all genera and species within a family).
#'    May be repeted in single request.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available
#'    by resources identified as belonging to the network identified by the
#'    supplied numeric key.
#' @param originisocountrycode Return density records for occurrences which
#'    occurred within the country identified by the supplied 2-letter ISO code.
#' @param format Specifies the format in which the records are to be returned,
#'    one of: brief or kml (character)
#' @param spplist Get the species list for a 1 degree cell. One of "none",
#'    "random", "greatest", or "all". "none" returns the data.frame of count of
#'    specimens by 1 degree cells without species list. "random" returns a
#'    species list selected randomly from one of the cells. "greatest" returns
#'    a species list selected from the cell with the greatest number of specimens.
#'    "all" returns species lists from all cells in a list. Be aware that
#'    calling "all" could take quite a while, so plan accordingly.
#' @param listcount Return a species list ('splist') or a data.frame of the
#'    species and the count for each species ('counts').
#' @return A vector of scientific species names for one degree grid cells.
#' @examples \dontrun{
#' # Just return the data.frame of counts by cells.
#' density_spplist(originisocountrycode = "CO")
#'
#' # Get a species list by cell, choosing one at random
#' density_spplist(originisocountrycode = "CO", spplist = "random")
#' density_spplist(originisocountrycode = "CO", spplist = "r") # can abbr. spplist
#'
#' # Get a species list by cell, choosing the one with the greatest no. of records
#' density_spplist(originisocountrycode = "CO", spplist = "great")
#' 
#' # Instead of a list, get back a data.frame with species names and counts
#' density_spplist(originisocountrycode = "CO", spplist = "great", listcount='counts')
#' }
#' @export
density_spplist <- function(taxonconceptKey = NULL, dataproviderkey = NULL,
  dataresourcekey = NULL, resourcenetworkkey = NULL, originisocountrycode = NULL,
  format = NULL, spplist = c("none","random","greatest","all"), listcount = "list")
{
  .Deprecated(msg="This function is deprecated, and will be removed in a future version. There is no longer a similar function.")
  
  names_ = NULL
  
  url = "http://data.gbif.org/ws/rest/density/list"
  args <- compact(list(taxonconceptKey = taxonconceptKey,
    dataproviderkey = dataproviderkey, dataresourcekey = dataresourcekey,
    resourcenetworkkey = resourcenetworkkey,
    originisocountrycode = originisocountrycode, format = format))
  temp <- getForm(url, .params=args)
  tt <- xmlParse(temp)
  minLatitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:minLatitude"), xmlValue))
  maxLatitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:maxLatitude"), xmlValue))
  minLongitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:minLongitude"), xmlValue))
  maxLongitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:maxLongitude"), xmlValue))
  count <- as.numeric(sapply(getNodeSet(tt, "//gbif:count"), xmlValue))
  urls <- sapply(getNodeSet(tt, "//gbif:portalUrl"), xmlValue)
  df <- data.frame(minLatitude=minLatitude, maxLatitude=maxLatitude,
             minLongitude=minLongitude, maxLongitude=maxLongitude,
             count=count, urls=urls)
  spp <- match.arg(spplist, choices=c("none","random","greatest","all"),
                   several.ok=F)

  gett <- function(x, listcount) {
#     bbb<-xmlParse(content(GET(x),as="text"))
    bbb<-xmlParse(getURL(x))
    if(listcount == 'list'){
      sort(unique(sapply(getNodeSet(bbb, "//tn:nameComplete"), xmlValue)))
    } else
      if(listcount == 'counts'){
        temp <- data.frame(names_=sapply(getNodeSet(bbb, "//tn:nameComplete"),
                                         xmlValue))
        ddply(temp, .(names_), summarise, count = length(names_))
      } else
        stop("listcount must be one of 'list' or 'counts'")
  }

  if(spp == "none"){
    df
  } else
    if(spp == "random"){
      urlsp <- as.character(df[sample(1:nrow(df),1), "urls"])
      gett(urlsp, listcount)
    } else
      if(spp == "greatest"){
        urlsp <- df[order(df$count, decreasing=T), "urls"][[1]]
        gett(urlsp, listcount)
      } else
        if(spp == "all"){
          urlsp <- as.character(df[, "urls"])
          llply(urlsp, gett, listcount, .progress="text")
        } else
          stop("spplist must be one of 'none','random','greatest','all'")
}

#' The density web service provides access to records showing the density
#'   	of occurrence records from the GBIF Network by one-degree cell.
#'
#' @import RCurl XML plyr
#' @param taxonconceptKey Unique key for taxon (numeric). Count only records which are 
#'		for the taxon identified by the supplied numeric key, including any records provided 
#'		under synonyms of the taxon concerned, and any records for child taxa 
#'		(e.g. all genera and species within a family).  May be repeted in single request.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available by 
#'    resources identified as belonging to the network identified by the supplied numeric key.
#' @param originisocountrycode Return density records for occurrences which 
#' 		occurred within the country identified by the supplied 2-letter ISO code.
#' @param format Specifies the format in which the records are to be returned,
#' 		one of: brief or kml (character)
#' @return A data.frame with the columns
#' \itemize{
#'  \item{"minLatitude"}{Minimum latitude of the cell}
#'  \item{"maxLatitude"}{Maximum latitude of the cell}
#'  \item{"minLongitude"}{Minimum longitude of the cell}
#'  \item{"maxLongitude"}{Maximum longitude of the cell}
#'  \item{"count"}{Number of occurrences found}
#' }
#' @examples \dontrun{
#' head( out <- densitylist(originisocountrycode = "CA") )
#' }
#' @export
densitylist <- function(taxonconceptKey = NULL, dataproviderkey = NULL,
                        dataresourcekey = NULL, resourcenetworkkey = NULL, originisocountrycode = NULL,
                        format = NULL) 
{
  .Deprecated(msg="This function is deprecated, and will be removed in a future version. There is no longer a similar function.")
  
  url = "http://data.gbif.org/ws/rest/density/list"
  args <- compact(list(taxonconceptKey = taxonconceptKey, 
                       dataproviderkey = dataproviderkey, dataresourcekey = dataresourcekey, 
                       resourcenetworkkey = resourcenetworkkey, 
                       originisocountrycode = originisocountrycode, format = format))
  temp <- getForm(url, .params=args)
  tt <- xmlParse(temp)	
  cellid <- as.numeric(xpathSApply(tt, "//gbif:densityRecord", xmlAttrs))
  minLatitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:minLatitude"), xmlValue))
  maxLatitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:maxLatitude"), xmlValue))
  minLongitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:minLongitude"), xmlValue))
  maxLongitude <- as.numeric(sapply(getNodeSet(tt, "//gbif:maxLongitude"), xmlValue))
  count <- as.numeric(sapply(getNodeSet(tt, "//gbif:count"), xmlValue))
  out <- data.frame(cellid=cellid, minLatitude=minLatitude, maxLatitude=maxLatitude, 
                    minLongitude=minLongitude, maxLongitude=maxLongitude,
                    count=count)
  class(out) <- c("gbifdens","data.frame")
  return( out )
}

#' Counts taxon concept records matching a range of filters.
#' 
#' @import RCurl XML plyr
#' @param  scientificname count only records where the scientific name matches 
#'    that supplied, use an asterisk * for any name starting with preseding 
#'		string (character). does not make use of extra knowledge of possible synonyms 
#'		or of child taxa.  For these functions, use taxonconceptkey. May be repeted in 
#'		single request.
#' @param  taxonconceptKey unique key for taxon (numeric). Count only records which are 
#'		for the taxon identified by the supplied numeric key, including any records provided
#'		under synonyms of the taxon concerned, and any records for child taxa 
#'		(e.g. all genera and species within a family).  May be repeted in single request.
#' @param  dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See \link{providers}. (character)
#' @param  dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See \link{resources}. (character)
#' @param  institutioncode Return only records from a given institution code.
#' @param  collectioncode Return only records from a given collection code.
#' @param  catalognumber Return only records from a given catalog number.                 
#' @param  resourcenetworkkey  count only records which have been made available by 
#'		resources identified as belonging to the network identified by the supplied 
#'  	numeric key.
#' @param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#' @param  minlatitude  return only records from locations with latitudes greater 
#'    than the supplied value (southern hemisphere with negative latitudes). (numeric)
#' @param  maxlatitude  return only records from locations with latitudes lower than 
#'    the supplied value (southern hemisphere with negative latitudes). (numeric)
#' @param  minlongitude  return only records from locations with longitudes greater 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#' @param  maxlongitude  return only records from locations with longitudes lower 
#'    than the supplied value (western hemisphere with negative longitudes). (numeric)
#' @param  minaltitude  return only records from altitudes greater than or equal to 
#'    the supplied value. (integer)
#' @param  maxaltitude  return only records from altitudes less than or equals to 
#'    the supplied value. (integer)
#' @param  mindepth  return only records from depth greater than or equal to the supplied
#'    value. (numeric 2 decimal places)
#' @param  maxdepth  return only records from depth less than or equals to the supplied 
#'    value. (numeric 2 decimal places)
#' @param  cellid  identifier for a one degree cell (O - 64,799). 
#'		Using a cellid is more efficient than using a bounding box for the same cell.
#' @param  centicellid  identifier for a 0.1 degree cell within a one degree cell 
#' @param  typesonly  if set to "true", return only records with a type status specified.
#' @param  coordinatestatus  if set to "true", return only records with coordinates. 
#'    If set to "false", return only records without coordinates.
#' @param  coordinateissues  if set to "true", return only records for which the portal 
#'    has detected possible issues in georeferencing. If set to "false", return only 
#'    records for which the portal has not detected any such issues.
#' @param  hostisocountrycode  return only records served by providers from the country 
#'    identified by the supplied 2-letter ISO code.
#' @param  originisocountrycode return only records of occurrences which occurred 
#'    within the country identified by the supplied 2-letter ISO code. 
#' @param  originregioncode  return only records of occurrences which occurred 
#'    within the region identified by the supplied 3-letter code.
#' @param  startdate  return only records occurring on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#' @param  enddate  return only records occurring on or before the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28).
#' @param  startyear  return only records from during or after the supplied year.
#' @param  endyear  return only records from during or before the supplied year.
#' @param  year  return only records from during the supplied year.
#' @param  month  return only records from during the supplied month (expressed as 
#'    an integer in the range 1 to 12).
#' @param  day  return only records from during the supplied day of month 
#'    (expressed as an integer in the range 1 to 31).
#' @param modifiedsince  return only records which have been indexed or modified 
#'    in the GBIF data portal index on or after the supplied date 
#'    (format YYYY-MM-DD, e.g. 2006-11-28). 
#' @return A single numeric value - the number of records found in GBIF matching 
#'    the query.
#' @examples \dontrun{
#' occurrencecount(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE)
#' occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE, 
#'    year=2009)
#' occurrencecount(scientificname = 'Helianthus annuus', coordinatestatus = TRUE, 
#'    year=2005, maxlatitude=20)
#' }
#' @export
occurrencecount <- function(scientificname = NULL, taxonconceptKey = NULL,
                            dataproviderkey = NULL, dataresourcekey = NULL, institutioncode = NULL ,
                            collectioncode = NULL, catalognumber = NULL, resourcenetworkkey = NULL,
                            basisofrecordcode = NULL, minlatitude = NULL, maxlatitude = NULL,
                            minlongitude = NULL, maxlongitude = NULL, minaltitude = NULL, maxaltitude = NULL,
                            mindepth = NULL, maxdepth = NULL, cellid = NULL, centicellid = NULL,
                            typesonly = NULL, coordinatestatus = NULL,
                            coordinateissues = NULL, hostisocountrycode = NULL, originisocountrycode = NULL,
                            originregioncode = NULL, startdate = NULL, enddate = NULL, startyear = NULL,
                            endyear = NULL, year = NULL, month = NULL, day = NULL, modifiedsince = NULL) 
{  
  .Deprecated(new="occ_count", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_count")
  
  url = "http://data.gbif.org/ws/rest/occurrence/count"
  querystr <- compact(list(scientificname=scientificname,taxonconceptKey=taxonconceptKey,
                           dataproviderkey=dataproviderkey,dataresourcekey=dataresourcekey,
                           institutioncode=institutioncode,collectioncode=collectioncode,
                           catalognumber=catalognumber,resourcenetworkkey=resourcenetworkkey,	
                           basisofrecordcode=basisofrecordcode,minlatitude=minlatitude,
                           maxlatitude=maxlatitude,minlongitude=minlongitude,maxlongitude=maxlongitude,
                           minaltitude=minaltitude,maxaltitude=maxaltitude,mindepth=mindepth,
                           maxdepth=maxdepth,cellid=cellid,centicellid=centicellid,typesonly=typesonly,
                           coordinatestatus=coordinatestatus,coordinateissues=coordinateissues,
                           hostisocountrycode=hostisocountrycode,originisocountrycode=originisocountrycode,
                           originregioncode=originregioncode,startdate=startdate,enddate=enddate,
                           startyear=startyear,endyear=endyear,year=year,month=month,day=day,
                           modifiedsince=modifiedsince))
  
  temp <- getForm(url, .params=querystr)
  out <- xmlParse(temp)
  as.numeric(
    xmlGetAttr(
      getNodeSet(out, "//gbif:summary", namespaces="gbif")[[1]], "totalMatched"))
}

#' Returns summary counts of occurrence records by one-degree cell for a single
#'   	taxon, country, dataset, data publisher or data network.
#'
#' @export
occurrencedensity <- function()
{
  .Deprecated(new="densitylist", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?densitylist")
}


#' Get individual records for a given occurrence record.
#'
#' @import RCurl XML plyr
#' @param key numeric key uniquely identifying the occurrence record within the GBIF
#' @param format specifies the format in which the records are to be returned, one 
#'   	of: brief, darwin or kml (character)
#' @param mode specifies whether the response data should (as far as possible) be 
#' 		the raw values originally retrieved from the data resource or processed 
#' 		(normalised) values used within the data portal (character)
#' @details Currently, the function returns the record as a list, hopefully
#' 		in future will return a data.frame.
#' @examples \dontrun{
#' occurrenceget(key = 13749100)
#' }
#' @export
occurrenceget <- function(key = NULL, format = NULL, mode = NULL)
{
  .Deprecated(new="occ_get", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_get")
  
  url = "http://data.gbif.org/ws/rest/occurrence/get"
  args <- compact(list(key = key, format = format, mode = mode))
  temp <- getForm(url, .params=args)
  tt <- xmlParse(temp)
  xmlToList(tt)$data
}

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
#' out <- llply(splist, function(x) occurrencelist(x, coordinatestatus = TRUE, maxresults = 100), .parallel=T)
#' lapply(out, function(x) head(gbifdata(x)))
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
                           typesonly = NULL, coordinatestatus = NULL, coordinateissues = NULL, 
                           hostisocountrycode = NULL, originisocountrycode = NULL,originregioncode = NULL, 
                           startdate = NULL, enddate = NULL, startyear = NULL,endyear = NULL, year = NULL, 
                           month = NULL, day = NULL, modifiedsince = NULL, startindex = NULL, maxresults = 10, 
                           format = "brief", icon = NULL, mode = NULL, stylesheet = NULL, removeZeros = FALSE, 
                           writecsv = NULL, curl = getCurlHandle(), fixnames = "none") 
{	
  .Deprecated(new="occ_search", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_search")
  
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
    if(is.null(args)){ tt <- getURL(url, curl = curl) } else
    { tt <- getForm(url, .params = args, curl = curl) }
    outlist <- xmlParse(tt)
    numreturned <- as.numeric(xpathSApply(outlist, "//gbif:summary/@totalReturned", 
                                          namespaces="gbif"))
    ss <- tryCatch(xpathApply(outlist, "//gbif:nextRequestUrl", xmlValue)[[1]], 
                   error = function(e) e$message)	
    if(ss=="subscript out of bounds"){url <- NULL} else {
      url <- sub("&maxresults=[0-9]+", 
                 paste("&maxresults=",maxresults-numreturned,sep=''), ss)
      # 			         paste("&maxresults=",maxresults-sumreturned,sep=''), ss)
    }
    args <- NULL
    sumreturned <- sumreturned + numreturned
    # 		if(is.null(url))
    # 			maxresults <- sumreturned
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

#' Occurrencelist_all carries out an occurrencelist query for a single name and all its name variants according to GBIF's name matching.
#'
#' @param scientificname A scientific name. (character)
#' @param ... Further arguments passed on to occurrencelist_many
#' @examples \dontrun{
#' # Query for a single species
#' # compare the names returned by occurrencelist to occurrencelist_all
#' occurrencelist(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE,
#' maxresults = 40)
#' occurrencelist_all(scientificname = 'Aristolochia serpentaria', coordinatestatus = TRUE,
#' maxresults = 40)
#'
#' }
#' @export
occurrencelist_all <- function(scientificname, ...)
{  
  .Deprecated(new="occ_search", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_search")
  
  gbifkey <- taxonsearch(scientificname=scientificname)$gbifkey
  name_lkup <- taxonget(key = as.numeric(as.character(gbifkey)))
  sciname <- unique(as.character(subset(name_lkup, select='sciname',
                                        subset=rank == 'species' |
                                          rank == 'variety')[ , 1]))
  sciname <- paste(sciname, '*', sep='')
  out <- occurrencelist_many(scientificname = sciname, ...)
  return(out)
}

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
                                typesonly = NULL, coordinatestatus = NULL,
                                coordinateissues = NULL, hostisocountrycode = NULL, originisocountrycode = NULL,
                                originregioncode = NULL, startdate = NULL, enddate = NULL, startyear = NULL,
                                endyear = NULL, year = NULL, month = NULL, day = NULL, modifiedsince = NULL,
                                startindex = NULL, maxresults = 10, format = "brief", icon = NULL,
                                mode = NULL, stylesheet = NULL, removeZeros = FALSE, writecsv = NULL,
                                curl = getCurlHandle(), fixnames = "none", parallel = FALSE, cores=4) 
{    
  .Deprecated(new="occ_search", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_search")
  
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

#' Get data providers and their unique keys.
#'
#' Beware: It takes a while to retrieve the full list of providers - so
#' go get more coffee.
#'
#' @import RCurl XML plyr
#' @param name data provider name search string, by default searches all
#'   	data providers by defining name = ''
#' @param isocountrycode return only providers from the country identified by
#'  	the supplied 2-letter ISO code.
#' @param modifiedsince return only records which have been indexed or modified
#'    on or after the supplied date (format YYYY-MM-DD, e.g. 2006-11-28)
#' @param  startindex  return the subset of the matching records that starts at
#'    the supplied (zero-based index).
#' @param maxresults max number of results to return
#' @examples \dontrun{
#' # Test the function for a few providers
#' providers(maxresults=10)
#'
#' # By data provider name
#' providers('University of Texas-Austin')
#' }
#' @examples \dontest{
#' # All data providers
#' providers()
#' }
#' @export
providers <- function(name = "", isocountrycode = NULL, modifiedsince = NULL,
                      startindex = NULL, maxresults = NULL)
{
  .Deprecated(new="networks", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?networks, ?organizations, and ?datasets")
  
  url = "http://data.gbif.org/ws/rest/provider/list"
  args <- compact(list(name = name, isocountrycode=isocountrycode, 
                       modifiedsince=modifiedsince,startindex=startindex,
                       maxresults=maxresults))
  
  temp <- getForm(url, .params=args)
  tt <- xmlParse(temp)
  names_ <- xpathSApply(tt, "//gbif:dataProvider/gbif:name",
                        xmlValue)
  dataproviderkey <- xpathSApply(tt, "//gbif:dataProvider", xmlAttrs)[1,]
  data.frame(names_, dataproviderkey)
}

#' Get data resources and their unique keys.
#'
#' Beware: It takes a while to retrieve the full list of resources - so
#' go get more coffee.
#'
#' @import RCurl XML plyr
#' @param name data provider name search string, by default searches all
#'   	data resources by defining name = ''
#' @param  providerkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See \link{providers}(). (character)
#' @param  basisofrecordcode  return only records with the specified basis of record.
#'    Supported values are: "specimen, observation, living, germplasm, fossil, unknown".
#'    (character)
#' @param modifiedsince return only records which have been indexed or modified
#'    on or after the supplied date (format YYYY-MM-DD, e.g. 2006-11-28)
#' @param  startindex  return the subset of the matching records that starts at
#'    the supplied (zero-based index).
#' @param maxresults max number of results to return
#' @examples \dontrun{
#' # Test the function for a few resources
#' resources(maxresults=30)
#'
#' # By name
#' resources('Flora')
#' }
#' @examples \dontest{
#' # All data providers
#' resources()
#' }
#' @export
resources <- function(name = "", providerkey = NULL, basisofrecordcode = NULL,
                      modifiedsince = NULL,  startindex = NULL, maxresults = NULL)
{
  .Deprecated(new="networks", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?networks, ?organizations, and ?datasets")
  
  url = "http://data.gbif.org/ws/rest/resource/list"
  args <- compact(list(name = name, providerkey = providerkey,
                       basisofrecordcode = basisofrecordcode,
                       modifiedsince = modifiedsince, startindex = startindex,
                       maxresults = maxresults))
  
  temp <- getForm(url, .params=args)
  tt <- xmlParse(temp)
  names_ <- xpathSApply(tt, "//gbif:dataResource/gbif:name",
                        xmlValue)
  resourcekey <- xpathSApply(tt, "//gbif:dataResource", xmlAttrs)[2,]
  data.frame(names_, resourcekey)
}


#' Search by taxon to retrieve number of records in GBIF.
#'
#' @import httr XML plyr
#' @param scientificname Scientitic name of taxon (character, see example)
#' @param rank Rank of taxon, see taxrank() (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource. See resources(). (character)
#' @examples \dontrun{
#' taxoncount(scientificname = 'Puma concolor')
#' taxoncount(scientificname = 'Helianthus annuus')
#' }
#' \donttest{
#' taxoncount(rank = 'family')
#' }
#' @export
taxoncount <- function(scientificname = NULL, rank = NULL, dataresourcekey = NULL)
{
  .Deprecated(new="occ_count", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_count")
  
  url <- "http://data.gbif.org/ws/rest/taxon/count"
  args <- compact(list(scientificname = scientificname, rank = rank,
                       dataresourcekey = dataresourcekey))
  tt <- content(GET(url, query=args))
  as.numeric(xmlGetAttr(getNodeSet(tt, "//gbif:summary", 
                                   namespaces="gbif")[[1]], "totalMatched"))
}

#' Get taxonomic information on a specific taxon or taxa in GBIF by their taxon
#'   	concept keys.
#'
#' @import httr XML plyr
#' @param key A single key, or many keys in a vector, for a taxon.
#' @return A single data.frame of taxonomic information if  single data.frame is
#' 		supplied, or a list of data.frame's if a list of keys is supplied.
#' @examples \dontrun{
#' keys <- taxonsearch(scientificname = 'Puma concolor')
#' taxonget(keys$gbifkey)
#'
#' # Just for one key
#' taxonget(51780668) # taxonconceptkey for Puma concolor
#' }
#' @export
taxonget <- function(key = NULL)
{
  .Deprecated(new="name_usage", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?name_usage")
  
  url = "http://data.gbif.org/ws/rest/taxon/get"
  doit <- function(x) {
    args <- compact(list(key = x))
    tt <- content(GET(url, query=args))
    taxonconceptkeys <- sapply(getNodeSet(tt, "//tc:TaxonConcept[@gbifKey]"), 
                               xmlGetAttr, "gbifKey")
    sciname <- sapply(getNodeSet(tt, "//tn:nameComplete"), xmlValue)
    rank <- sapply(getNodeSet(tt, "//tn:rankString"), xmlValue)
    data.frame(sciname, taxonconceptkeys, rank)
  }
  out <- lapply(key, doit)
  if(length(out)==1){out[[1]]} else{out}
}


#' Search for taxa in GBIF.
#'
#' Search for a taxon using scientific name. Optionally, include taxonomic
#'   	rank in the search. Returns list of TaxonConcept key values.
#'
#' @import httr XML plyr
#' @param scientificname  scientific name of taxon (character, see example)
#' @param rank  rank of taxon, see taxrank() (character)
#' @param maxresults  return at most the specified number of records. The
#'   	default (and maximum supported) is 1000 records.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available by
#'    resources identified as belonging to the network identified by the 
#'    supplied numeric key.
#' @param hostisocountrycode  return only records served by providers from the country
#'    identified by the supplied 2-letter ISO code.
#' @param startindex  return the subset of the matching records that starts at
#'    the supplied (zero-based index).
#' @param accepted_status Status in the GIBF portal
#' @description 
#' When searching for taxa, keep in mind that unless you want taxon identifiers 
#' for a specific data source, leave dataproviderkey as the default of 1, which 
#' is the GBIF backbone taxonomy. Also, always specify the taxonomic rank you 
#' are searching for - GBIF says the search is more efficient if rank is given.
#' @return A data.frame.
#' @examples \dontrun{
#' # Do specify the taxonomic rank the you are searching for, rank of species here
#' taxonsearch(scientificname = 'Puma concolor', rank="species")
#' 
#' # Fabaceae (rank of genus)
#' taxonsearch(scientificname = 'Abies', rank="genus")
#' 
#' # Fabaceae (rank of family)
#' taxonsearch(scientificname = 'Fabaceae', rank="family")
#' }
#' @export
taxonsearch <- function(scientificname = NULL, rank = NULL, maxresults = 10,
                        dataproviderkey = 1, dataresourcekey = NULL, resourcenetworkkey = NULL,
                        hostisocountrycode = NULL, startindex = NULL, accepted_status = FALSE)
{
  .Deprecated(new="occ_search", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?occ_search")
  
  url = "http://data.gbif.org/ws/rest/taxon/list"
  args <- compact(list(
    scientificname = scientificname, dataproviderkey = dataproviderkey,
    dataresourcekey = dataresourcekey,  resourcenetworkkey = resourcenetworkkey,
    hostisocountrycode = hostisocountrycode, rank=rank, maxresults=maxresults,
    startindex=startindex))
  tt <- content(GET(url, query=args))
  nodes <- getNodeSet(tt, "//tc:TaxonConcept")
  
  if (length(nodes) < 1)
    stop("No results found")
  
  gbifkey <- sapply(nodes, function(x) xmlGetAttr(x, "gbifKey"))
  status <- sapply(nodes, function(x) xmlGetAttr(x, "status"))
  name <- xpathSApply(tt, "//tn:nameComplete", xmlValue)
  rank <- xpathSApply(tt, "//tn:rankString", xmlValue)
  sci <- xpathSApply(tt, "//tn:scientific", xmlValue)
  accordingto <- xpathSApply(tt, "//tc:accordingToString", xmlValue)
  primary <- xpathSApply(tt, "//tc:primary", xmlValue)
  
  out <- data.frame(gbifkey=gbifkey,status=status,name=name,rank=rank,sci=sci,
                    source=accordingto,primary=primary,stringsAsFactors=FALSE)
  
  if(accepted_status)
    as.numeric(as.character(out[out$status %in% "accepted",]))
  else
    out
}

#' Make a simple map to visualize GBIF data density data
#' 
#' @template map
#' @examples \dontrun{
#' # Tile map, using output from densitylist, Canada
#' out2 <- densitylist(originisocountrycode = "CA") # data for Canada
#' gbifmap_dens(out2) # on world map
#' gbifmap_dens(out2, region="Canada") # on Canada map
#' 
#' # Tile map, using gbifdensity, a specific data provider key
#' # 191 for 'University of Texas at El Paso'
#' out2 <- densitylist(dataproviderkey = 191) # data for the US
#' gbifmap_dens(out2) # on world map
#' 
#' # Modify the plotting region
#' out <- densitylist(originisocountrycode="US")
#' gbifmap_dens(out, mapdatabase="usa")
#' }
#' @export
gbifmap_dens <- function(input = NULL, mapdatabase = "world", region = ".", 
                         geom = geom_point, jitter = NULL, customize = NULL)
{
  .Deprecated(new="gbifmap", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?gbifmap")
  
  long = NULL
  lat = NULL
  group = NULL
  
  if(!is.gbifdens(input))
    stop("Input is not of class gbifdens")
  
  input <- data.frame(input)
  middf <- data.frame(
    lat = input$minLatitude+0.5,
    long = input$minLongitude+0.5,
    count = input$count
  )
  mapp <- map_data(map=mapdatabase, region=region)
  message(paste("Rendering map...plotting ", nrow(input), " tiles", sep=""))
  ggplot(mapp, aes(long, lat)) + # make the plot
    geom_raster(data=middf, aes(long, lat, fill=log10(count), width=1, height=1)) +
    scale_fill_gradient2(low = "white", mid="blue", high = "black") +
    geom_polygon(aes(group=group), fill="white", alpha=0, color="gray80", size=0.8) +
    labs(x="", y="") +
    theme_bw(base_size=14) + 
    theme(legend.position = "bottom", legend.key = element_blank()) +
    blanktheme() +
    customize
}

#' Make a simple map to visualize GBIF point data.
#' 
#' @template map
#' @examples \dontrun{
#' # Point map, using output from occurrencelist, example 1
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius',
#'    coordinatestatus = TRUE, maxresults = 100)
#' gbifmap_list(input = out) # make a map using vertmap
#' 
#' # Point map, using output from occurrencelist, example 2, a species with more data
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, 
#'    maxresults = 100)
#' gbifmap_list(input = out) # make a map
#' gbifmap_list(input = out, region = 'USA') # make a map, just using the US map
#' 
#' # Point map, using output from occurrencelist, many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
#' gbifmap_list(out)
#' 
#' # Point map, using output from occurrencelist, many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Ceyx fallax', 
#'    'Picoides lignarius', 'Campephilus leucopogon')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100)
#' gbifmap_list(out)
#' 
#' # Get occurrences or density by area, using min/max lat/long coordinates
#' # Setting scientificname="*" so we just get any species
#' out <- occurrencelist(scientificname="*", minlatitude=30, maxlatitude=35,
#'    minlongitude=-100, maxlongitude=-95, coordinatestatus = TRUE, maxresults = 500)
#' 
#' # Using `geom_point`
#' gbifmap_list(out, "state", "texas", geom_point)
#' 
#' # Using geom_jitter to move the points apart from one another
#' gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 0.3, 
#'    height = 0.3))
#' 
#' # And move points a lot
#' gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 1, height = 1))
#' 
#' # Customize the plot by passing options to `ggplot()`
#' mycustom <- function(){
#'    list(geom_point(size=9)
#'        )}
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', 
#'    coordinatestatus = TRUE, maxresults = 100)
#' gbifmap_list(out, customize = mycustom())
#' }
#' @export
gbifmap_list <- function(input = NULL, mapdatabase = "world", region = ".", 
                         geom = geom_point, jitter = NULL, customize = NULL)
{
  .Deprecated(new="gbifmap", package="rgbif", msg="This function is deprecated, and will be removed in a future version. See ?gbifmap")
  
  long = NULL
  lat = NULL
  group = NULL
  decimalLongitude = NULL
  decimalLatitude = NULL
  taxonName = NULL
  
  if(!is.gbiflist(input))
    stop("Input is not of class gbiflist")
  
  input <- data.frame(input)
  input$decimalLatitude <- as.numeric(input$decimalLatitude)
  input$decimalLongitude <- as.numeric(input$decimalLongitude)
  
  tomap <- input[complete.cases(input$decimalLatitude, input$decimalLatitude), ]
  tomap <- input[-(which(tomap$decimalLatitude <=90 || tomap$decimalLongitude <=180)), ]
  tomap$taxonName <- as.factor(capwords(tomap$taxonName, onlyfirst=TRUE))
  
  if(length(unique(tomap$taxonName))==1){ theme2 <- theme(legend.position="none") } else 
  { theme2 <- NULL }
  
  world <- map_data(map=mapdatabase, region=region) # get world map data
  message(paste("Rendering map...plotting ", nrow(tomap), " points", sep=""))
  
  ggplot(world, aes(long, lat)) + # make the plot
    geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
    geom(data=tomap, aes(decimalLongitude, decimalLatitude, colour=taxonName), 
         alpha=0.4, size=3, position=jitter) +
    scale_color_brewer("", type="qual", palette=6) +
    labs(x="", y="") +
    theme_bw(base_size=14) +
    theme(legend.position = "bottom", legend.key = element_blank()) +
    guides(col = guide_legend(nrow=2)) +
    blanktheme() +
    theme2 + 
    customize
}