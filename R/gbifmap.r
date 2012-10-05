#' Make a simple map to visualize GBIF data.
#' 
#' Basic function to plot your lat/long data on a map.
#' 
#' @import ggplot2 maps
#' @param input A data.frame, e.g. from calling occurrencelist for example. The 
#' 		data.frame has to have, in addition to any other columns, columns named 
#' 		exactly "decimalLatitude" and "decimalLongitude".
#' @return Map (using ggplot2 package) of points on a world map.
#' @details gbifmap takes care of cleaning up the data.frame (removing NA's, etc.) 
#' 		returned from rgbif functions, and creating the map. This function
#' 		gives a simple map of your data.  You can look at the code behing the 
#' 		function itself if you want to build on it to make a map according 
#' 		to your specfications.
#' @examples \dontrun{
#' # example 1
#' ##  get some data on golden 
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', 
#' 		coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' gbifmap(input = out) # make a map using vertmap
#' 
#' # example 2
#' ##  A species with more data
#' out <- occurrencelist(scientificname = 'Puma concolor', 
#' 		coordinatestatus = TRUE, maxresults = 100, latlongdf = T)
#' gbifmap(input = out) # make a map using vertmap
#' }
#' @export
gbifmap <- function(input = NULL)
{
	if(inherits(input, "NULL")){stop("Please provide a data.frame")} else {NULL}
	if(inherits(input$decimalLatitude, "NULL")){
		stop("need columns named 'Latitude' and 'Longitude'")} else {NULL}
	if(inherits(input$decimalLongitude, "NULL")){
		stop("need columns named 'Latitude' and 'Longitude'")} else {NULL}
	input_ <- input[!is.na(input$decimalLatitude) & !is.na(input$decimalLongitude),] # remove NA's
	input_ <- input_[abs(input_$decimalLatitude) <= 90, ] # remove impossible values of lat
	input_ <- input_[abs(input_$decimalLongitude) <= 180, ] # remove impossible values of long
	world <- map_data("world") # get world map data
	message(paste("Rendering map...plotting ", nrow(input_), " points", sep=""))
	ggplot(world, aes(long, lat)) + # make the plot
		geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
		geom_jitter(data=input_, aes(decimalLongitude, decimalLatitude), alpha=0.4, size=3, colour="darkblue") +
		labs(x="", y="") +
		theme_bw(base_size=14)
}