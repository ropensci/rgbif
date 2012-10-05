#' Make a simple map to visualize GBIF data.
#' 
#' Basic function to plot your lat/long data on a map.
#' 
#' @import ggplot2 maps
#' @param input Either a single data.frame or a list of data.frame's (e.g., from
#' 		different speies). The data.frame has to have, in addition to any other 
#' 		columns, columns named exactly "decimalLatitude" and "decimalLongitude".
#' @return Map (using ggplot2 package) of points on a world map.
#' @details gbifmap takes care of cleaning up the data.frame (removing NA's, etc.) 
#' 		returned from rgbif functions, and creating the map. This function
#' 		gives a simple map of your data.  You can look at the code behing the 
#' 		function itself if you want to build on it to make a map according 
#' 		to your specfications.
#' @examples \dontrun{
#' # example 1
#' ##  get some data on golden 
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' gbifmap(input = out) # make a map using vertmap
#' 
#' # example 2
#' ##  A species with more data
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' gbifmap(input = out) # make a map using vertmap
#' 
#' # Many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Buteo regalis')
#' out <- lapply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 100, latlongdf = T))
#' gbifmap(out)
#' }
#' @export
gbifmap <- function(input = NULL)
{
	if(class(input)=="data.frame"){
		input2 <- list(input)
		input3 <- list(input)
		} else
		if(class(input)=="list"){
			input2 <- list(input[[1]])
			input3 <- input
			} else
				stop("input must be a data.frame or a list of data.frame's")
	if(inherits(input2[[1]], "NULL")){stop("Please provide a data.frame")} else {NULL}
	if(inherits(input2[[1]]$decimalLatitude, "NULL")){
		stop("need columns named 'Latitude' and 'Longitude'")} else {NULL}
	if(inherits(input2[[1]]$decimalLongitude, "NULL")){
		stop("need columns named 'Latitude' and 'Longitude'")} else {NULL}
	
	mapp <- function(x) {
		x_ <- x[!is.na(x$decimalLatitude) & !is.na(x$decimalLongitude),] # remove NA's
		x_ <- x_[abs(x_$decimalLatitude) <= 90, ] # remove impossible values of lat
		x_[abs(x_$decimalLongitude) <= 180, ] # remove impossible values of long
	}
	tomap <- lapply(input3, mapp)
	
	world <- map_data("world") # get world map data
	numpoints <- sum(sapply(tomap, nrow, USE.NAMES=F))
	message(paste("Rendering map...plotting ", numpoints, " points", sep=""))
	if(length(tomap) == 1){
		ggplot(world, aes(long, lat)) + # make the plot
			geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
			geom_point(data=tomap[[1]], aes(decimalLongitude, decimalLatitude), alpha=0.4, size=3, colour="darkblue") +
			labs(x="", y="") +
			theme_bw(base_size=14)
	} else
		{
			tomapdf <- ldply(tomap)
			tomapdf$taxonName <- as.factor(capwords(tomapdf$taxonName, onlyfirst=T))
			ggplot(world, aes(long, lat)) + # make the plot
				geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
				geom_point(data=tomapdf, aes(decimalLongitude, decimalLatitude, colour=taxonName), alpha=0.4, size=3) +
				labs(x="", y="") +
				theme_bw(base_size=14)
		}
}