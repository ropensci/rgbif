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
        alldata <- alldata[c('name','longitude','latitude')]
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
        alldata[c('scientificName','verbatimLatitude','verbatimLongitude')]
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
#' @importFrom plyr rbind.fill
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