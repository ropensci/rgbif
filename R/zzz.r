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
gbifxmlToDataFrame <- function(doc, format) {
	nodes <- getNodeSet(doc, "//to:TaxonOccurrence")
	if (length(nodes) == 0) 
		return(data.frame())
	if(!is.na(format) & format=="darwin"){
		varNames <- c("country", "stateProvince", 
									"county", "locality", "decimalLatitude", "decimalLongitude", 
									"coordinateUncertaintyInMeters", "maximumElevationInMeters", 
									"minimumElevationInMeters", "maximumDepthInMeters", 
									"minimumDepthInMeters", "institutionCode", "collectionCode", 
									"catalogNumber", "basisOfRecordString", "collector", 
									"earliestDateCollected", "latestDateCollected", "gbifNotes")
	}else{
		varNames <- c("country", "decimalLatitude", "decimalLongitude", 
									"catalogNumber", "earliestDateCollected", "latestDateCollected" )
	}
	dims <- c(length(nodes), length(varNames))
	ans <- as.data.frame(replicate(dims[2], rep(as.character(NA), 
									dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
	names(ans) <- varNames
	for (i in seq(length = dims[1])) {
		ans[i, ] <- xmlSApply(nodes[[i]], xmlValue)[varNames]
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