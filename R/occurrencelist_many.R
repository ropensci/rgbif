#' occurrencelist_many is the same as occurrencelist, but takes in a vector of species names.
#'
#' @inheritParams occurrencelist
#' @examples \dontrun{
#' # Query for a many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100))
#' head(out)
#' gbifmap(out)
#' }
#' @export
occurrencelist_many <- function(scientificname = NULL, taxonconceptKey = NULL,
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
  
  parseresults <- function(x) {
    df <- gbifxmlToDataFrame(x, format=format)
    
    if(nrow(df[!is.na(df$decimalLatitude),])==0){
      return( df )
    } else
    {			
      commas_to_periods <- function(dataframe){
        dataframe$decimalLatitude <- gsub("\\,", ".", dataframe$decimalLatitude)
        dataframe$decimalLongitude <- gsub("\\,", ".", dataframe$decimalLongitude)
        return( dataframe )
      }
      
      df <- commas_to_periods(df)
      
      df_num <- df[!is.na(df$decimalLatitude),]
      df_nas <- df[is.na(df$decimalLatitude),]
      
      df_num$decimalLongitude <- as.numeric(df_num$decimalLongitude)
      df_num$decimalLatitude <- as.numeric(df_num$decimalLatitude)
      # 			df_num[, "decimalLongitude"] <- as.numeric(df_num[, "decimalLongitude"])
      # 			df_num[, "decimalLatitude"] <- as.numeric(df_num[, "decimalLatitude"])
      i <- df_num$decimalLongitude == 0 & df_num$decimalLatitude == 0
      if (removeZeros) {
        df_num <- df_num[!i, ]
      } else 
      {
        df_num[i, "decimalLatitude"] <- NA
        df_num[i, "decimalLongitude"] <- NA 
      }
      temp <- rbind(df_num, df_nas)
      return( colClasses(temp, c(rep("character",5),rep("numeric",7),rep("character",8))) )
      # 			return( temp )
    }
  }
  
  url = "http://data.gbif.org/ws/rest/occurrence/list"
  
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
        scientificname=sciname, taxonconceptKey=taxonkey,
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
      numreturned <- as.numeric(xpathSApply(outlist, "//gbif:summary/@totalReturned", namespaces="gbif"))
      ss <- tryCatch(xpathApply(outlist, "//gbif:nextRequestUrl", xmlValue)[[1]], error = function(e) e$message)	
      if(ss=="subscript out of bounds"){url <- NULL} else {
        url <- sub("&maxresults=[0-9]+", paste("&maxresults=",maxresults-sumreturned,sep=''), ss)
      }
      args <- NULL
      sumreturned <- sumreturned + numreturned
      if(is.null(url))
        maxresults <- sumreturned
      outout[[iter]] <- outlist
    }
    outt <- lapply(outout, parseresults)
    dd <- do.call(rbind, outt)
    
    if(fixnames == "matchorig"){
      dd[ dd$taxonName %in% sciname, ]
    } else
      if(fixnames == "changealltorig"){
        dd$taxonName <- sciname
        dd
      } else
        { dd } 
  }
  
  if(is.null(scientificname)){itervec <- taxonconceptKey} else {itervec <- scientificname}
  
  if(length(scientificname)==1 | length(taxonconceptKey)==1){
    out <- getdata(itervec)
  } else
  {
    out <- ldply(itervec, getdata)
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