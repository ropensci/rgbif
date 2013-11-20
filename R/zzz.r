#' Parser for gbif data
#' @param input A list
#' @param minimal Get minimal input, default to TRUE
#' @export
#' @keywords internal
gbifparser <- function(input, minimal=TRUE){
  parse <- function(x){
    x[sapply(x, length) == 0] <- "none"
    h1 <- c('kingdom','phylum','clazz','order','family','genus','species')
    h2 <- c('kingdomKey','phylumKey','classKey','orderKey','familyKey','genusKey','speciesKey')
    name <- t(data.frame(x[names(x) %in% h1]))
    key <- t(data.frame(x[names(x) %in% h2]))
    hier <- data.frame(name=name, key=key, rank=row.names(name), row.names=NULL)
    usename <- hier[[nrow(hier),"name"]]
    #     geog <- data.frame(name=usename, x[!names(x) %in% c(h1,h2)])
    alldata <- data.frame(name=usename, x)
    if(minimal)
      if(all(c('latitude','longitude') %in% names(alldata)))
      {
        alldata <- alldata[c('name','key','longitude','latitude')]
      } else
      {
        alldata <- alldata['name']
        alldata <- data.frame(alldata, latitude=NA, longitude=NA)
      }
    list(hierarch=hier, data=alldata)
  }
  if(is.numeric(input[[1]])){
    parse(input)
  } else
  {
    lapply(input, parse)
  }
}

#' Parser for gbif data
#' @param input A list
#' @param minimal Get minimal input, default to TRUE
#' @export
#' @keywords internal
gbifparser_verbatim <- function(input, minimal=TRUE){
  parse <- function(x){
    alldata <- data.frame(key=x$key, x$fields)
    if(minimal){
      if(all(c('verbatimLatitude','verbatimLongitude') %in% names(alldata)))
      {
        alldata[c('scientificName','key','verbatimLatitude','verbatimLongitude')]
      } else
      {
        name <- alldata['scientificName']
        data.frame(name, verbatimLatitude=NA, verbatimLongitude=NA)
      }
    } else
    {
      alldata
    }
  }
  if(is.numeric(input[[1]])){
    parse(input)
  } else
  {
    rbind.fill(lapply(input, parse))
  }
}


#' Replacement function for ldply that should be faster.
#'
#' @import plyr
#' @param x A list.
#' @param convertvec Convert a vector to a data.frame before rbind is called.
#' @export
#' @keywords internal
ldfast <- function(x, convertvec=FALSE){
  convert2df <- function(x){
    if(!inherits(x, "data.frame"))
      data.frame(rbind(x))
    else
      x
  }
  if(convertvec)
    do.call(rbind.fill, lapply(x, convert2df))
  else
    do.call(rbind.fill, x)
}

#' Parser for gbif data
#' @param input A list
#' @param minimal Get minimal input, default to TRUE
#' @export
#' @keywords internal
datasetparser <- function(input, minimal=TRUE){
  parse <- function(x){
    x[sapply(x, length) == 0] <- "none"
    contacts <- ldfast(x$contacts, TRUE)
    endpoints <- ldfast(x$endpoints, TRUE)
    identifiers <- ldfast(x$identifiers, TRUE)
    rest <- x[!names(x) %in% c('contacts','endpoints','identifiers')]
    list(other=rest, contacts=contacts, endpoints=endpoints, identifiers=identifiers)
  }
  if(is.character(input[[1]])){
    parse(input)
  } else
  {
    lapply(input, parse)
  }
}

#' Lookup-table for 2 character country ISO codes
#' @name isocodes
#' @docType data
#' @keywords data
NULL

#' Custom ggplot2 theme
#' @import ggplot2 grid
#' @export
#' @keywords internal
blanktheme <- function(){
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        plot.margin = rep(unit(0,"null"),4))
}


#' Capitalize the first letter of a character string.
#' 
#' @param s A character string
#' @param strict Should the algorithm be strict about capitalizing. Defaults to FALSE.
#' @param onlyfirst Capitalize only first word, lowercase all others. Useful for 
#'   	taxonomic names.
#' @examples 
#' gbif_capwords(c("using AIC for model selection"))
#' gbif_capwords(c("using AIC for model selection"), strict=TRUE)
#' @export
#' @keywords internal
gbif_capwords <- function(s, strict = FALSE, onlyfirst = FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)),
{s <- substring(s,2); if(strict) tolower(s) else s}, sep = "", collapse = " " )
  if(!onlyfirst){
    sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
  } else
  {
    sapply(s, function(x) 
      paste(toupper(substring(x,1,1)), 
            tolower(substring(x,2)), 
            sep="", collapse=" "), USE.NAMES=F)
  }
}

#' Get the possible values to be used for (taxonomic) rank arguments in GBIF 
#'   	API methods.
#' 
#' @examples \dontrun{
#' taxrank()
#' }
#' @export
taxrank <- function() 
{
  c("kingdom", "phylum", "class", "order", "family", "genus","species", 
    "infraspecific")
}

#' Parser for name_usage endpoints, for fxns name_lookup and name_backbone
#' 
#' @param x A list.
#' @export
#' @keywords internal
namelkupparser <- function(x){
  data.frame(
    compact(
      x[c('key','nubKey','parentKey','parent','kingdom','phylum',"clazz","order","family",
          "genus","kingdomKey","phylumKey","classKey","orderKey","familyKey","genusKey",
          "canonicalName","authorship","nameType","rank","numOccurrences")]
    )
  )
}


#' Parse results from call to occurrencelist endpoint
#'
#' @param x A list
#' @param ... Further args passed on to gbifxmlToDataFrame
#' @param removeZeros remove zeros or not
#' @export
#' @keywords internal
parseresults <- function(x, ..., removeZeros=removeZeros)
{
df <- gbifxmlToDataFrame(x, ...)

if(nrow(df[!is.na(df$decimalLatitude),])==0){
return( df )
} else
{ 
df <- commas_to_periods(df)

df_num <- df[!is.na(df$decimalLatitude),]
df_nas <- df[is.na(df$decimalLatitude),]

df_num$decimalLongitude <- as.numeric(df_num$decimalLongitude)
df_num$decimalLatitude <- as.numeric(df_num$decimalLatitude)
i <- df_num$decimalLongitude == 0 & df_num$decimalLatitude == 0
if (removeZeros) {
df_num <- df_num[!i, ]
} else
{
df_num[i, "decimalLatitude"] <- NA
df_num[i, "decimalLongitude"] <- NA
}
temp <- rbind(df_num, df_nas)
return( temp )
}
}


#' Convert commas to periods in lat/long data
#'
#' @param dataframe A data.frame
#' @export
#' @keywords internal
commas_to_periods <- function(dataframe)
{
dataframe$decimalLatitude <- gsub("\\,", ".", dataframe$decimalLatitude)
dataframe$decimalLongitude <- gsub("\\,", ".", dataframe$decimalLongitude)
return( dataframe )
}


#' Code based on the `gbifxmlToDataFrame` function from dismo package
#' (http://cran.r-project.org/web/packages/dismo/index.html),
#' by Robert Hijmans, 2012-05-31, License: GPL v3
#' @param doc A parsed XML document.
#' @param format Format to use.
#' @export
#' @keywords internal
gbifxmlToDataFrame <- function(doc, format) {
  nodes <- getNodeSet(doc, "//to:TaxonOccurrence")
  if (length(nodes) == 0)
    return(data.frame())
  if(!is.null(format) & format=="darwin"){
    varNames <- c("occurrenceID", "country", "stateProvince",
                  "county", "locality", "decimalLatitude", "decimalLongitude",
                  "coordinateUncertaintyInMeters", "maximumElevationInMeters",
                  "minimumElevationInMeters", "maximumDepthInMeters",
                  "minimumDepthInMeters", "institutionCode", "collectionCode",
                  "catalogNumber", "basisOfRecordString", "collector",
                  "earliestDateCollected", "latestDateCollected", "gbifNotes")
  } else{
    varNames <- c("occurrenceID", "country", "decimalLatitude", "decimalLongitude",
                  "catalogNumber", "earliestDateCollected", "latestDateCollected" )
  }
  dims <- c(length(nodes), length(varNames))
  ans <- as.data.frame(replicate(dims[2], rep(as.character(NA),
                                              dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
  names(ans) <- varNames
  for (i in seq(length = dims[1])) {
    ans[i, 1] <- xmlAttrs(nodes[[i]])[['gbifKey']]
    ans[i, -1] <- xmlSApply(nodes[[i]], xmlValue)[varNames[-1]]
  }
  nodes <- getNodeSet(doc, "//to:Identification")
  varNames <- c("taxonName")
  dims = c(length(nodes), length(varNames))
  tax = as.data.frame(replicate(dims[2], rep(as.character(NA),
                                             dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
  names(tax) = varNames
  for (i in seq(length = dims[1])) {
    tax[i, ] = xmlSApply(nodes[[i]], xmlValue)[varNames]
  }
  cbind(tax, ans)
}