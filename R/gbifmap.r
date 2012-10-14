#' Make a simple map to visualize GBIF data.
#' 
#' Basic function to plot your lat/long data on a map.
#' 
#' @import ggplot2 maps
#' @param input Either a single data.frame or a list of data.frame's (e.g., from
#' 		different speies). The data.frame has to have, in addition to any other 
#' 		columns, columns named exactly "decimalLatitude" and "decimalLongitude".
#' @param mapdatabase The map database to use in mapping. What you choose here 
#' 		determines what you can choose in the region parameter. One of: county, 
#' 		state, usa, world, world2, france, italy, or nz. 
#' @param region The region of the world to map. From the maps package, run 
#' 		\code{sort(unique(map_data("world")$region))} to see region names for the
#' 		world database layer, or e.g., \code{sort(unique(map_data("state")$region))}
#' 		for the state layer.
#' @param pointtype The geom to use, one of geom_point or geom_jitter. Don't 
#' 		quote them. 
#' @param jitterposition If you use jitterposition, the amount by which to jitter 
#' 		points in width, height, or both. 
#' @return Map (using ggplot2 package) of points or tiles on a world map.
#' @details gbifmap takes care of cleaning up the data.frame (removing NA's, etc.) 
#' 		returned from rgbif functions, and creating the map. This function
#' 		gives a simple map of your data.  You can look at the code behing the 
#' 		function itself if you want to build on it to make a map according 
#' 		to your specfications.
#' @examples \dontrun{
#' # Point map, using output from occurrencelist, example 1
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' gbifmap(input = out) # make a map using vertmap
#' 
#' # Point map, using output from occurrencelist, example 2, a species with more data
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' gbifmap(input = out) # make a map
#' gbifmap(input = out, region = 'USA') # make a map, just plotting data for 
#' 
#' # Point map, using output from occurrencelist, many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Buteo regalis')
#' out <- lapply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 100, latlongdf = T))
#' gbifmap(out)
#' 
#' # Tile map, using output from densitylist, Canada
#' out2 <- densitylist(originisocountrycode = "CA") # data for Canada
#' gbifmap(out2) # on world map
#' gbifmap(out2, region="Canada") # on Canada map
#' 
#' # Tile map, using gbifdensity, a specific data provider key
#' # 191 for 'University of Texas at El Paso'
#' out2 <- densitylist(dataproviderkey = 191) # data for the US
#' gbifmap(out2) # on world map
#' 
#' # Get occurrences or density by area, using min/max lat/long coordinates
#' out <- occurrencelist(minlatitude=30, maxlatitude=35, minlongitude=-100, maxlongitude=-95, 
#' 		coordinatestatus = T, maxresults = 5000, latlongdf = T)
#' 
#' # Using `geom_point`
#' gbifmap(out, "state", "texas", geom_point)
#' 
#' # Using geom_jitter to move the points apart from one another
#' gbifmap(out, "state", "texas", geom_jitter, position_jitter(width = 0.3, height = 0.3))
#' 
#' # And move points a lot
#' gbifmap(out, "state", "texas", geom_jitter, position_jitter(width = 1, height = 1))
#' }
#' @export
gbifmap <- function(input = NULL, mapdatabase = "world", region = ".", 
										pointtype = geom_point, jitterposition = NULL)
{
	if(class(input)=="data.frame"){nn<-names(input)} else{nn<-names(input[[1]])}
	if(all(
		nn %in% c("cellid","minLatitude","maxLatitude","minLongitude","maxLongitude","count")
	)==TRUE){ 
		middf <- data.frame(
			lat = input$minLatitude+0.5,
			long = input$minLongitude+0.5,
			count = input$count
		)
		mapp <- map_data(map=mapdatabase, region=region)
		numtiles <- nrow(input)
		message(paste("Rendering map...plotting ", numtiles, " tiles", sep=""))
		ggplot(mapp, aes(long, lat)) + # make the plot
			geom_raster(data=middf, aes(long, lat, fill=log10(count), width=1, height=1)) +
			scale_fill_gradient2(low = "white", mid="blue", high = "black") +
			geom_polygon(aes(group=group), fill="white", alpha=0, color="gray80", size=0.8) +
			labs(x="", y="") +
			theme_bw(base_size=14)
	}	else
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
			
			world <- map_data(map=mapdatabase, region=region) # get world map data
			numpoints <- sum(sapply(tomap, nrow, USE.NAMES=F))
			message(paste("Rendering map...plotting ", numpoints, " points", sep=""))
			if(length(tomap) == 1){
				position2 <- jitterposition
				ggplot(world, aes(long, lat)) + # make the plot
					geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
					pointtype(data=tomap[[1]], aes(decimalLongitude, decimalLatitude), 
										alpha=0.4, size=3, colour="darkblue", position=position2) +
					labs(x="", y="") +
					theme_bw(base_size=14)
			} else
			{
				tomapdf <- ldply(tomap)
				tomapdf$taxonName <- as.factor(capwords(tomapdf$taxonName, onlyfirst=T))
				ggplot(world, aes(long, lat)) + # make the plot
					geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
					pointtype(data=tomapdf, aes(decimalLongitude, decimalLatitude, colour=taxonName), 
										 alpha=0.4, size=3) +
					labs(x="", y="") +
					theme_bw(base_size=14)
			}
		}
}