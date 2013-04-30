system.time(shit <- occurrenceshit(scientificname = 'Helianthus annuus', maxresults = 4000))
system.time(shit <- occurrencelist(scientificname = 'Helianthus annuus', maxresults = 4000))

system.time(shit <- occurrenceshit(taxonconceptKey=6, maxresults = 12000))
system.time(poop <- occurrencelist(taxonconceptKey=6, maxresults = 12000))

occurrenceshit <- function(scientificname = NULL, taxonconceptKey = NULL,
  dataproviderkey = NULL, dataresourcekey = NULL, institutioncode = NULL,
  collectioncode = NULL, catalognumber = NULL, resourcenetworkkey = NULL,
  basisofrecordcode = NULL, minlatitude = NULL, maxlatitude = NULL,
  minlongitude = NULL, maxlongitude = NULL, minaltitude = NULL, maxaltitude = NULL,
  mindepth = NULL, maxdepth = NULL, cellid = NULL, centicellid = NULL,
  typesonly = NULL, georeferencedonly = NULL, coordinatestatus = NULL,
  coordinateissues = NULL, hostisocountrycode = NULL, originisocountrycode = NULL,
  originregioncode = NULL, startdate = NULL, enddate = NULL, startyear = NULL,
  endyear = NULL, year = NULL, month = NULL, day = NULL, modifiedsince = NULL,
  startindex = NULL, maxresults = 10, format = NULL, icon = NULL,
  mode = NULL, stylesheet = NULL, removeZeros = FALSE, writecsv = NULL,
  curl = getCurlHandle(), fixnames = "none") 
{	
  
  parseresults <- function(x) {
    df <- gbifxmlToDataFrame(x, format=NA)
    
    if(nrow(na.omit(df))==0){
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
      
      df_num[, "decimalLongitude"] <- as.numeric(df_num[, "decimalLongitude"])
      df_num[, "decimalLatitude"] <- as.numeric(df_num[, "decimalLatitude"])
      i <- df_num[, "decimalLongitude"] == 0 & df_num[, "decimalLatitude"] == 0
      if (removeZeros) {
        df_num <- df_num[!i, ]
      } else 
      {
        df_num[i, "decimalLatitude"] <- NA
        df_num[i, "decimalLongitude"] <- NA 
      }
      temp <- rbind(df_num, df_nas)
      return( colClasses(temp, c("character","character","numeric","numeric","character","character","character")) )
    }
  }
  
  url = "http://data.gbif.org/ws/rest/occurrence/list"
  
  args <- compact(
    list(
      scientificname=scientificname, dataproviderkey=dataproviderkey,
      dataresourcekey=dataresourcekey, institutioncode=institutioncode,
      collectioncode=collectioncode, catalognumber=catalognumber,
      resourcenetworkkey=resourcenetworkkey, taxonconceptKey=taxonconceptKey,
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
  
#   if(maxresults < 1000)
#     args$maxresults <- maxresults
  
  if(!maxresults > 1000){
    tt <- getForm(url, .params = args, curl = curl)
    outlist <- xmlParse(tt)
    dd <- parseresults(outlist)
  } else
  {
    if(is.null(taxonconceptKey))
      counted <- occurrencecount(scientificname=scientificname)
    else
      counted <- occurrencecount(taxonconceptKey=taxonconceptKey)
    if(counted < maxresults){ maxto <- counted } else { maxto <- maxresults }
    
    startindex <- seq(0,maxto,1000)
    maxresults_ <- 1000
    
    registerDoMC(cores=4)
    
#     stime <- system.time({
    outout <- foreach(i=1:length(startindex)) %dopar% {
      args$maxresults <- maxresults_
      args <- c(args, startindex=startindex[[i]])
      tt <- getForm(url, .params = args, curl = curl)
      outlist <- xmlParse(tt)
      parseresults(outlist)
    }
#     })
    dd <- do.call(rbind, outout)
#     
#     outypoo <- list()
#     regtime <- system.time({
#       for(i in seq_along(startindex)){
#         args$maxresults <- maxresults_
#         args <- c(args, startindex=startindex[[i]])
#         tt <- getForm(url, .params = args, curl = curl)
#         outlist <- xmlParse(tt)
#         outypoo[[i]] <- parseresults(outlist)
#       }
#     })
    
#     registerDoMC(cores=cores)
#     outout <- llply(scientificname, getForm, uri=url, .params=args, curl=curl, .parallel=TRUE)
#     outt <- lapply(outout, parseresults)
#     dd <- do.call(rbind, outt)
  }
  
#   tail(dd); nrow(dd)
  
#   iter <- 0
#   sumreturned <- 0
#   outout <- list()
#   while(sumreturned < maxresults){
#     iter <- iter + 1
#     if(is.null(args)){ tt <- getURL(url) } else
#       { tt <- getForm(url, .params = args, curl = curl) }
#     outlist <- xmlParse(tt)
#     numreturned <- as.numeric(xpathSApply(outlist, "//gbif:summary/@totalReturned", namespaces="gbif"))
#     ss <- tryCatch(xpathApply(outlist, "//gbif:nextRequestUrl", xmlValue)[[1]], error = function(e) e$message)	
#     if(ss=="subscript out of bounds"){url <- NULL} else {
#       url <- sub("&maxresults=[0-9]+", paste("&maxresults=",maxresults-sumreturned,sep=''), ss)
#     }
#     args <- NULL
#     sumreturned <- sumreturned + numreturned
#     if(is.null(url))
#       maxresults <- sumreturned
#     outout[[iter]] <- outlist
#   }
#   outt <- lapply(outout, parseresults)
#   dd <- do.call(rbind, outt)
  
  if(fixnames == "matchorig"){
    dd <- dd[ dd$taxonName %in% scientificname, ]
  } else
    if(fixnames == "changealltoorig"){
      dd$taxonName <- scientificname
    } else
    { NULL } 
  
  if(!is.null(writecsv)){
    write.csv(dd, file=writecsv, row.names=F)
    message("Success! CSV file written")
  } else
  { return( dd ) }
}