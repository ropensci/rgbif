#' Plot a class of gbiflist, gbifdensity
#' @param x input
#' @export
gbifmap <- function() UseMethod("gbifmap")

#' Make a simple map to visualize GBIF data.
#' 
#' Basic function to plot your lat/long data on a map.
#' 
#' @import ggplot2 maps
#' @S3method gbifmap gbiflist
#' @param input Either a single data.frame or a list of data.frame's (e.g., from
#'     different speies). The data.frame has to have, in addition to any other 
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
#' @return Map (using ggplot2 package) of points on a map.
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
#' out <- occurrencelist_many(splist, coordinatestatus = T, maxresults = 20)
#' gbifmap(out)
#' 
#' # Get occurrences or density by area, using min/max lat/long coordinates
#' # Setting scientificname="*" so we just get any species
#' out <- occurrencelist(scientificname="*", minlatitude=30, maxlatitude=35, minlongitude=-100, maxlongitude=-95, coordinatestatus = TRUE, maxresults = 500)
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
gbifmap.gbiflist <- function(input = NULL, mapdatabase = "world", region = ".", 
                     geom = geom_point, jitter = NULL, customize = NULL)
{
  if(!is.gbiflist(input))
    stop("Input is not of class gbiflist")
  
  input <- data.frame(input)
  input$decimalLatitude <- as.numeric(input$decimalLatitude)
  input$decimalLongitude <- as.numeric(input$decimalLongitude)
  
  tomap <- input[complete.cases(input$decimalLatitude, input$decimalLatitude), ]
  tomap <- input[-(which(tomap$decimalLatitude <=90 || tomap$decimalLongitude <=180)), ]
  tomap$taxonName <- as.factor(capwords(tomap$taxonName, onlyfirst=TRUE))
  
  if(length(unique(tomap$taxonName))==1){ theme2 <- theme(legend.position="none") } else 
  { theme2 <- NULL }
  
  world <- map_data(map=mapdatabase, region=region) # get world map data
  message(paste("Rendering map...plotting ", nrow(tomap), " points", sep=""))
  
  ggplot(world, aes(long, lat)) + # make the plot
    geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
    geom(data=tomap, aes(decimalLongitude, decimalLatitude, colour=taxonName), 
         alpha=0.4, size=3, position=jitter) +
    labs(x="", y="") +
    theme_bw(base_size=14) +
    theme2 + 
    customize
}


#' Make a simple map to visualize GBIF data density data
#' 
#' Basic function to plot your lat/long data on a map.
#' 
#' @import ggplot2 maps
#' @S3method gbifmap gbifdens
#' @param input Either a single data.frame or a list of data.frame's (e.g., from
#'     different speies). The data.frame has to have, in addition to any other 
#'   	columns, columns named exactly "decimalLatitude" and "decimalLongitude".
#' @param mapdatabase The map database to use in mapping. What you choose here 
#' 		determines what you can choose in the region parameter. One of: county, 
#' 		state, usa, world, world2, france, italy, or nz. 
#' @param region The region of the world to map. From the maps package, run 
#' 		\code{sort(unique(map_data("world")$region))} to see region names for the
#' 		world database layer, or e.g., \code{sort(unique(map_data("state")$region))}
#' 		for the state layer.
#' @param customize Further arguments passed on to ggplot. 
#' @return Map (using ggplot2 package) of tiles on a map.
#' @details gbifmap takes care of cleaning up the data.frame (removing NA's, etc.) 
#' 		returned from rgbif functions, and creating the map. This function
#' 		gives a simple map of your data.  You can look at the code behing the 
#' 		function itself if you want to build on it to make a map according 
#' 		to your specfications.
#' @examples \dontrun{
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
#' # Modify the plotting region
#' out <- densitylist(originisocountrycode="US")
#' gbifmap(out, mapdatabase="usa")
#' }
gbifmap.gbifdens <- function(input = NULL, mapdatabase = "world", region = ".", customize = NULL)
{
  if(!is.gbifdens(input))
    stop("Input is not of class gbifdens")
  
  input <- data.frame(input)
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
}