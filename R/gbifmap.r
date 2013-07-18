#' Make a simple map to visualize GBIF point data.
#' 
#' @template map
#' @examples \dontrun{
#' # Point map, using output from occurrencelist, example 1
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius',
#'    coordinatestatus = TRUE, maxresults = 100)
#' gbifmap_list(input = out) # make a map using vertmap
#' 
#' # Point map, using output from occurrencelist, example 2, a species with more data
#' out <- occurrencelist(scientificname = 'Puma concolor', coordinatestatus = TRUE, 
#'    maxresults = 100)
#' gbifmap_list(input = out) # make a map
#' gbifmap_list(input = out, region = 'USA') # make a map, just using the US map
#' 
#' # Point map, using output from occurrencelist, many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 20)
#' gbifmap_list(out)
#' 
#' # Point map, using output from occurrencelist, many species
#' splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa', 'Ceyx fallax', 
#'    'Picoides lignarius', 'Campephilus leucopogon')
#' out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 100)
#' gbifmap_list(out)
#' 
#' # Get occurrences or density by area, using min/max lat/long coordinates
#' # Setting scientificname="*" so we just get any species
#' out <- occurrencelist(scientificname="*", minlatitude=30, maxlatitude=35,
#'    minlongitude=-100, maxlongitude=-95, coordinatestatus = TRUE, maxresults = 500)
#' 
#' # Using `geom_point`
#' gbifmap_list(out, "state", "texas", geom_point)
#' 
#' # Using geom_jitter to move the points apart from one another
#' gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 0.3, 
#'    height = 0.3))
#' 
#' # And move points a lot
#' gbifmap_list(out, "state", "texas", geom_jitter, position_jitter(width = 1, height = 1))
#' 
#' # Customize the plot by passing options to `ggplot()`
#' mycustom <- function(){
#'    list(geom_point(size=9)
#'        )}
#' out <- occurrencelist(scientificname = 'Accipiter erythronemius', 
#'    coordinatestatus = TRUE, maxresults = 100)
#' gbifmap_list(out, customize = mycustom())
#' }
#' @export
gbifmap_list <- function(input = NULL, mapdatabase = "world", region = ".", 
                     geom = geom_point, jitter = NULL, customize = NULL)
{
  long = NULL
  lat = NULL
  group = NULL
  decimalLongitude = NULL
  decimalLatitude = NULL
  taxonName = NULL
  
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
    scale_color_brewer("", type="qual", palette=6) +
    labs(x="", y="") +
    theme_bw(base_size=14) +
    theme(legend.position = "bottom", legend.key = element_blank()) +
    guides(col = guide_legend(nrow=2)) +
    blanktheme() +
    theme2 + 
    customize
}


#' Make a simple map to visualize GBIF data density data
#' 
#' @template map
#' @examples \dontrun{
#' # Tile map, using output from densitylist, Canada
#' out2 <- densitylist(originisocountrycode = "CA") # data for Canada
#' gbifmap_dens(out2) # on world map
#' gbifmap_dens(out2, region="Canada") # on Canada map
#' 
#' # Tile map, using gbifdensity, a specific data provider key
#' # 191 for 'University of Texas at El Paso'
#' out2 <- densitylist(dataproviderkey = 191) # data for the US
#' gbifmap_dens(out2) # on world map
#' 
#' # Modify the plotting region
#' out <- densitylist(originisocountrycode="US")
#' gbifmap_dens(out, mapdatabase="usa")
#' }
#' @export
gbifmap_dens <- function(input = NULL, mapdatabase = "world", region = ".", 
                             geom = geom_point, jitter = NULL, customize = NULL)
{
  long = NULL
  lat = NULL
  group = NULL
  
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
    theme(legend.position = "bottom", legend.key = element_blank()) +
    blanktheme() +
    customize
}