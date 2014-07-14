#' Make a map to visualize GBIF occurrence data.
#' 
#' @template map
#' @import grid ggplot2 maps
#' @export
#' @examples \dontrun{
#' # Make a map of Puma concolor occurrences
#' key <- name_backbone(name='Puma concolor')$speciesKey
#' dat <- occ_search(taxonKey=key, return='data', limit=100)
#' gbifmap(input=dat) 
#'
#' # Plot more Puma concolor occurrences
#' dat <- occ_search(taxonKey=key, return='data', limit=1200)
#' nrow(dat)
#' gbifmap(input=dat)
#' 
#' # More than 1 species
#' library("plyr")
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_backbone(name=x, kingdom='plants')$speciesKey,
#'    USE.NAMES=FALSE)
#' dat <- occ_search(taxonKey=keys, return='data', limit=50)
#' gbifmap(ldply(dat))
#' }

gbifmap <- function(input = NULL, mapdatabase = "world", region = ".", 
                    geom = geom_point, jitter = NULL, customize = NULL)
{  
  tomap <- input[complete.cases(input$decimalLatitude, input$decimalLatitude), ]
  tomap <- tomap[!tomap$decimalLongitude==0 & !tomap$decimalLatitude==0,]
  tomap <- input[-(which(tomap$decimalLatitude <=90 || tomap$decimalLongitude <=180)), ]
  tomap$name <- as.factor(gbif_capwords(tomap$name, onlyfirst=TRUE))
  
  if(length(unique(tomap$name))==1){ theme2 <- theme(legend.position="none") } else 
  { theme2 <- NULL }
  
  world <- map_data(map=mapdatabase, region=region)
  message(paste("Rendering map...plotting ", nrow(tomap), " points", sep=""))
  
  ggplot(world, aes(long, lat)) +
    geom_polygon(aes(group=group), fill="white", color="gray40", size=0.2) +
    geom(data=tomap, aes(decimalLongitude, decimalLatitude, colour=name), 
         alpha=0.4, size=3, position=jitter) +
    scale_color_brewer("", type="qual", palette=6) +
    labs(x="", y="") +
    theme_bw(base_size=14) +
    theme(legend.position = "bottom", legend.key = element_blank()) +
    guides(col = guide_legend(nrow=2)) +
    coord_fixed(ratio = 1) +
    blanktheme() +
    theme2 + 
    customize
}