#' Capitalize the first letter of a character string.
#' 
#' @param s A character string
#' @param strict Should the algorithm be strict about capitalizing. Defaults to FALSE.
#' @param onlyfirst Capitalize only first word, lowercase all others. Useful for 
#' 		taxonomic names.
#' @examples 
#' capwords(c("using AIC for model selection"))
#' capwords(c("using AIC for model selection"), strict=TRUE)
#' @export
#' @keywords internal
capwords <- function(s, strict = FALSE, onlyfirst = FALSE) {
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


#' Coerces data.frame columns to the specified classes
#' 
#' @param d A data.frame.
#' @param colClasses A vector of column attributes, one of: 
#'    numeric, factor, character, etc.
#' @examples
#' dat <- data.frame(xvar = seq(1:10), yvar = rep(c("a","b"),5)) # make a data.frame
#' str(dat)
#' str(colClasses(dat, c("factor","factor")))
#' @export
#' @keywords internal
colClasses <- function(d, colClasses) {
  colClasses <- rep(colClasses, len=length(d))
  d[] <- lapply(seq_along(d), function(i) switch(colClasses[i], 
      numeric=as.numeric(d[[i]]), 
      character=as.character(d[[i]]), 
      Date=as.Date(d[[i]], origin='1970-01-01'), 
      POSIXct=as.POSIXct(d[[i]], origin='1970-01-01'), 
      factor=as.factor(d[[i]]),
      as(d[[i]], colClasses[i]) ))
  d
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