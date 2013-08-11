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
      alldata <- alldata[c('name','longitude','latitude')]
    list(hierarch=hier, data=alldata)
  }
  if(is.numeric(input[[1]])){
    parse(input)
  } else
  {
    lapply(input, parse)
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