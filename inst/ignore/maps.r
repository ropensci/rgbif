#' Lookup names in all taxonomies in GBIF.
#'
#' @import httr ggmap png ggplot2
#' @export
#' 
#' @template all
#' @param type (required) A value of TAXON, DATASET, COUNTRY or PUBLISHER
#' @param key (required) The appropriate key for the chosen type (a taxon key, 
#'    xdataset/publisher uuid or 2 letter ISO country code)
#' @param resolution (optional) The number of pixels (Default: 1) to which density is aggregated. 
#'    Valid values are 1, 2, 4, 8, and 16.
#' @param layer (optional) Declares the layers to be combined by the server for this tile. See 
#'    Customizing layer content
#' @param palette (optional) Selects a predefined color palette. See styling a layer
#' @param colors (optional) Provides a user defined set of rules for coloring the layer. See 
#'    styling a layer
#' @param saturation (optional) Allows selection of a hue value between 0.0 and 1.0 when 
#'    saturation is set to true. See styling a layer
#' @param hue (optional) Allows selection of a hue value between 0.0 and 1.0 when saturation is 
#'    set to true. See styling a layer
#' @examples \dontrun{
#' maps(x=4, y=5, z=5, type='TAXON', key=1, layer='OTH_2010_2020', palette='yellows_reds')
#' }

maps <- function(x=0, y=0, z=3, type=NULL, key=NULL, resolution=1, layer=NULL, palette=NULL, 
  colors=NULL, saturation=NULL, hue=NULL, callopts=list())
{
  url <- 'http://api.gbif.org/v1/map/density/tile'
  args <- as.list(rgbif_compact(c(x=x, y=y, z=z, type=type, key=key, resolution=resolution, 
              layer=layer, palette=palette, colors=colors, saturation=saturation, hue=hue)))
  temp <- GET(url, query=args, callopts)
  stop_for_status(temp)
  assert_that(temp$headers$`content-type`=='image/png')
  res <- content(temp, as = 'raw')
  gg <- readPNG(res)
  ggimage(gg, fullpage = TRUE)
}

# theme_nothing <- function (base_size = 12)
# {
#   theme(line = element_blank(), 
#         rect = element_rect(fill = "grey", colour = "grey", size=0, linetype=), 
#         text = element_blank(), 
#         axis.ticks.length = unit(0, "cm"), 
#         axis.ticks.margin = unit(0.01, "cm"), 
#         legend.position = "none", 
#         panel.margin = unit(0, "lines"), 
#         plot.margin = unit(c(0, 0, -0.5, -0.5), "lines"), complete=TRUE)
# }