#' The density web service provides access to records showing the density
#' 		of occurrence records from the GBIF Network by one-degree cell.
#'
#' This is similar to the densitylist function. You can get the same data.frame
#' 		of results as densitylist with this function, but you can also get a
#' 		species list or data.frame of species and their counts for any degree cell.
#'
#' @import RCurl XML plyr
#' @param taxonconceptKey Unique key for taxon (numeric). Count only records
#' 		which are for the taxon identified by the supplied numeric key, including
#' 		any records provided under synonyms of the taxon concerned, and any
#' 		records for child taxa (e.g. all genera and species within a family).
#' 		May be repeted in single request.
#' @param dataproviderkey Filter records to those provided by the supplied
#'    numeric key for a data provider. See provider(). (character)
#' @param dataresourcekey Filter records to those provided by the supplied
#'    numeric key for a data resource See resource(). (character)
#' @param resourcenetworkkey  count only records which have been made available
#' 		by resources identified as belonging to the network identified by the
#' 		supplied numeric key.
#' @param originisocountrycode Return density records for occurrences which
#' 		occurred within the country identified by the supplied 2-letter ISO code.
#' @param format Specifies the format in which the records are to be returned,
#' 		one of: brief or kml (character)
#' @param spplist Get the species list for a 1 degree cell. One of "none",
#' 		"random", "greatest", or "all". "none" returns the data.frame of count of
#' 		specimens by 1 degree cells without species list. "random" returns a
#' 		species list selected randomly from one of the cells. "greatest" returns
#' 		a species list selected from the cell with the greatest number of specimens.
#' 		"all" returns species lists from all cells in a list. Be aware that
#' 		calling "all" could take quite a while, so plan accordingly.
#' @param listcount Return a species list ('splist') or a data.frame of the
#' 		species and the count for each species ('counts').
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
# 		bbb<-xmlParse(content(GET(x),as="text"))
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