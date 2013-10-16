#' Make a map to visualize GBIF occurrence data.
#' 
#' @template map
#' @import grid ggplot2 maps
#' @examples \dontrun{
#' # Make a map of Puma concolor occurrences
#' key <- gbif_lookup(name='Puma concolor', kingdom='plants')$speciesKey
#' dat <- occ_search(taxonKey=key, return='data', limit=300)
#' gbifmap(input=dat)
#'
#' # Plot more Puma concolor occurrences
#' dat <- occ_search(taxonKey=key, return='data', limit=1200)
#' nrow(dat)
#' gbifmap(input=dat)
#' }
#' @export
gbifmap <- function(input = NULL, mapdatabase = "world", region = ".", 
                    geom = geom_point, jitter = NULL, customize = NULL)
{
  long = NULL
  lat = NULL
  group = NULL
  longitude = NULL
  latitude = NULL
  name = NULL
  
#   if(!is.gbiflist(input))
#     stop("Input is not of class gbiflist")

  tomap <- input[complete.cases(input$latitude, input$latitude), ]
  tomap <- tomap[!tomap$longitude==0 & !tomap$latitude==0,]
  tomap <- input[-(which(tomap$latitude <=90 || tomap$longitude <=180)), ]
  tomap$name <- as.factor(gbif_capwords(tomap$name, onlyfirst=TRUE))
  
  if(length(unique(tomap$name))==1){ theme2 <- theme(legend.position="none") } else 
  { theme2 <- NULL }
  
  world <- map_data(map=mapdatabase, region=region)
  message(paste("Rendering map...plotting ", nrow(tomap), " points", sep=""))
  
  ggplot(world, aes(long, lat)) +
    geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
    geom(data=tomap, aes(longitude, latitude, colour=name), 
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