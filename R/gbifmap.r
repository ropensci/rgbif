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
#' @param geom The geom to use, one of geom_point or geom_jitter. Don't 
#' 		quote them. 
#' @param jitter If you use jitterposition, the amount by which to jitter 
#' 		points in width, height, or both. 
#' @param customize Further arguments passed on to ggplot. 
#' @return Map (using ggplot2 package) of points or tiles on a world map.
#' @details gbifmap takes care of cleaning up the data.frame (removing NA's, etc.) 
#' 		returned from rgbif functions, and creating the map. This function
#' 		gives a simple map of your data.  You can look at the code behing the 
#' 		function itself if you want to build on it to make a map according 
#' 		to your specfications.
#' @examples \dontrun{
#' # Point map, using output from occurrencelist, example 1
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100)
#' gbifmap(input = out) # make a map using vertmap
#' 
#' # Point map, using output from occurrencelist, example 2, a species with more data
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, maxresults = 100)
#' gbifmap(input = out) # make a map
#' gbifmap(input = out, region = 'USA') # make a map, just plotting data for 
#' 
#' # Point map, using output from occurrencelist, many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- llply(splist, function(x) occurrencelist(x, coordinatestatus = T, maxresults = 20))
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
#' 
#' # Customize the plot by passing options to `ggplot()`
#' mycustom <- function(){
#'		list(geom_point(size=9)
#'				)}
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', coordinatestatus = TRUE, maxresults = 100)
#' gbifmap(out, customize = mycustom())
#' }
#' @export
gbifmap <- function(input = NULL, mapdatabase = "world", region = ".", 
										geom = geom_point, jitter = NULL, customize = NULL)
{
	if(is(input, "list"))
		input <- ldply(input, data.frame)
	
	if(all(names(input) %in% c("cellid","minLatitude","maxLatitude","minLongitude","maxLongitude","count"))==TRUE){
		middf <- data.frame(
			lat = input$minLatitude+0.5,
			long = input$minLongitude+0.5,
			count = input$count
		)
		mapp <- map_data(map=mapdatabase, region=region)
		message(paste("Rendering map...plotting ", nrow(input), " tiles", sep=""))
		ggplot(mapp, aes(long, lat)) + # make the plot
			geom_raster(data=middf, aes(long, lat, fill=log10(count), width=1, height=1)) +
			scale_fill_gradient2(low = "white", mid="blue", high = "black") +
			geom_polygon(aes(group=group), fill="white", alpha=0, color="gray80", size=0.8) +
			labs(x="", y="") +
			theme_bw(base_size=14) + 
			customize
	}	else
	{
		tomap <- input[complete.cases(input$decimalLatitude, input$decimalLatitude), ]
		tomap <- input[-(which(tomap$decimalLatitude <=90 || tomap$decimalLongitude <=180)), ]
		world <- map_data(map=mapdatabase, region=region) # get world map data
		message(paste("Rendering map...plotting ", nrow(tomap), " points", sep=""))
		tomap$taxonName <- as.factor(capwords(tomap$taxonName, onlyfirst=T))
		ggplot(world, aes(long, lat)) + # make the plot
			geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
			geom(data=tomap, aes(decimalLongitude, decimalLatitude, colour=taxonName), 
					 alpha=0.4, size=3, position=jitter) +
			labs(x="", y="") +
			theme_bw(base_size=14) + 
			customize
	}
}