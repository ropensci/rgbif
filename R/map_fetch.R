#' @title Fetch maps of GBIF occurrences
#'
#' @export
#'
#' @description This function is a wrapper for the GBIF mapping api version 2.0.
#' The mapping API is a web map tile service making it straightforward to
#' visualize GBIF content on interactive maps, and overlay content from other
#' sources. It returns tile maps with number of
#' GBIF records per area unit that can be used in a variety of ways, for example
#' in interactive leaflet web maps. Map details are specified by a number of
#' query parameters, some of them optional. Full documentation of the GBIF
#' mapping api can be found at https://www.gbif.org/developer/maps
#'
#' @param source (character) Either `density` for fast, precalculated tiles,
#' or `adhoc` for any search. Default: `density`
#' @param x (integer sequence) the column. Default: 0:1
#' @param y (integer sequence) the row. Default: 0
#' @param z (integer) the zoom. Default: 0
#' @param format (character) The data format, one of:
#'
#' - `@Hx.png` for a 256px raster tile
#' - `@1x.png` for a 512px raster tile (the default)
#' - `@2x.png` for a 1024px raster tile
#' - `@3x.png` for a 2048px raster tile
#' - `@4x.png` for a 4096px raster tile
#'
#' @param srs (character) Spatial reference system. One of:
#'
#' - `EPSG:3857` (Web Mercator)
#' - `EPSG:4326` (WGS84 plate care?)
#' - `EPSG:3575` (Arctic LAEA on 10 degrees E)
#' - `EPSG:3031` (Antarctic stereographic)
#'
#' @param bin (character) `square` or `hex` to aggregate occurrence counts into
#' squares or hexagons. Points by default. 
#' @param hexPerTile (integer) sets the size of the hexagons
#' (the number horizontally across a tile). 
#' @param squareSize (integer) sets the size of the squares. Choose a factor
#' of 4096 so they tessalate correctly: probably from 8, 16, 32, 64, 128,
#' 256, 512. 
#' @param style (character) for raster tiles, choose from the available styles.
#' Defaults to classic.point for source="density" and "scaled.circle" for source="adhoc".
#' @param taxonKey (integer/numeric/character) search by taxon key, can only
#' supply 1. 
#' @param datasetKey (character) search by taxon key, can only supply 1.
#' @param country (character) search by taxon key, can only supply 1.
#' @param publishingOrg (character) search by taxon key, can only supply 1.
#' @param publishingCountry (character) search by taxon key, can only
#' supply 1. 
#' @param year (integer) integer that limits the search to a certain year or,
#' if passing a vector of integers, multiple years, for example
#' `1984` or `c(2016, 2017, 2018)` or `2010:2015` (years 2010 to 2015). optional
#' @param basisOfRecord (character) one or more basis of record states to
#' include records with that basis of record. The full list is: `c("OBSERVATION",
#' "HUMAN_OBSERVATION", "MACHINE_OBSERVATION", "MATERIAL_SAMPLE",
#' "PRESERVED_SPECIMEN", "FOSSIL_SPECIMEN", "LIVING_SPECIMEN",
#' "LITERATURE", "UNKNOWN")`.
#' @param return (character) Either "png" or "terra". 
#' @param base_style (character)  The style of the base map. 
#' @param plot_terra (logical) Set whether the terra map be default plotted.
#' @param curlopts options passed on to [crul::HttpClient]
#' @param ... additional arguments passed to the adhoc interface. 
#'
#' @return a `magick-image` or `terra::SpatRaster ` object.
#'
#' @details The default settings, `return='png'`, will return a `magick-image` 
#' png. This image will be a composite image of the the occurrence tiles fetched 
#' and a base map. This map is primarily useful as a high quality image of 
#' occurrence records.   
#' 
#' The args `x` and `y` can both be integer sequences. For example, `x=0:3` or 
#' `y=0:1`. Note that the tile index starts at 0. Higher values of `z`, will 
#' will produce more tiles that can be fetched and stitched together. Selecting
#' a too high value for `x` or `y` will produce a blank image.
#' 
#' Setting `return='terra'` will return a `terra::SpatRaster ` object. This
#' is primarily useful if you were interested in the underlying aggregated 
#' occurrence density data. 
#' 
#' See the article 
#'
#' @author John Waller and Laurens Geffert \email{laurensgeffert@@gmail.com}
#' @references https://www.gbif.org/developer/maps
#' @references https://api.gbif.org/v2/map/demo.html
#' @references https://api.gbif.org/v2/map/demo13.html
#' @seealso [mvt_fetch()]
#' @examples \dontrun{
#' 
#' # all occurrences
#' map_fetch()
#' # get artic map
#' map_fetch(srs='EPSG:3031') 
#' # only preserved specimens
#' map_fetch(basisOfRecord="PRESERVED_SPECIMEN")
#' 
#' # Map of occ in Great Britain
#' map_fetch(z=3,y=1,x=7:8,country="GB")
#' # Peguins with artic projection
#' map_fetch(srs='EPSG:3031',taxonKey=2481660,style='glacier.point', 
#' base_style="gbif-dark")
#' 
#' # occ from a long time ago
#' map_fetch(year=1600) 
#' # polygon style 
#' map_fetch(style="iNaturalist.poly",bin="hex")
#' # iNaturalist dataset plotted 
#' map_fetch(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'   style="iNaturalist.poly")
#'  
#' # use source="adhoc" for more filters
#' map_fetch(z=1,
#'   source="adhoc",
#'   iucn_red_list_category="CR",
#'   style="scaled.circles",
#'   base_style='gbif-light')
#' 
#' # cropped map of Hawaii
#' map_fetch(z=5,x=3:4,y=12,source="adhoc",gadmGid="USA.12_1")
#' 
#' 
#' }

map_fetch <- function(
  source = 'density',
  x = 0:1,
  y = 0,
  z = 0,
  format = '@1x.png',
  srs = 'EPSG:4326',
  bin = NULL,
  hexPerTile = NULL,
  squareSize = NULL,
  style = NULL,
  taxonKey = NULL,
  datasetKey = NULL,
  country = NULL,
  publishingOrg = NULL,
  publishingCountry = NULL,
  year = NULL,
  basisOfRecord = NULL,
  return = "png",
  base_style = NULL,
  plot_terra = TRUE,
  curlopts = list(http_version=2),
  ...
  ) {
  
  check_for_a_pkg("png")
  check_for_a_pkg("terra")
  check_for_a_pkg("magick")
  
  # Check input
  assert(format, "character")
  stopifnot(format %in% c('@Hx.png', '@1x.png',
    '@2x.png', '@3x.png', '@4x.png'))
  assert(source, "character")
  assert(x, c('numeric', 'integer'))
  assert(y, c('numeric', 'integer'))
  assert(z, c('numeric', 'integer'))
  assert(srs, "character")
  assert(bin, "character")
  assert(hexPerTile, c('numeric', 'integer'))
  assert(squareSize, c('numeric', 'integer'))
  assert(style, "character")
  assert(taxonKey, c("numeric", "integer", "character"))
  assert(datasetKey, "character")
  assert(country, "character")
  assert(publishingOrg, "character")
  assert(publishingCountry, "character")
  assert(year, c('numeric', 'integer'))
  assert(basisOfRecord, "character")

  # Check input 
  stopifnot(source %in% c('density', 'adhoc'))
  stopifnot(srs %in% c('EPSG:3857', 'EPSG:4326', 'EPSG:3575', 'EPSG:3031'))

  if(!(srs == 'EPSG:4326') & return == "terra") {
    stop("return='terra' is only supported for 'EPSG:4326'.") } 
  
  # special check non default projections
  if(srs %in% c('EPSG:3857', 'EPSG:3575', 'EPSG:3031') & z == 0) {
    message(paste0(srs," only has one tile at z=0, so setting x=0 and y=0."))
    x <- 0; y <- 0
  }
  
  if (!is.null(squareSize)) {
    squareSize <- match.arg(arg = as.character(squareSize),
      choices = c(8, 16, 32, 64, 128, 256, 512), several.ok = FALSE
    )
  }
  
  # density queries can accept only one 
  if(source == "density") {
    den_query <- rgbif_compact(list(taxonKey, datasetKey, country, publishingOrg, publishingCountry))
    if (length(den_query) > 1) {
      message("Supply only one of taxonKey, datasetKey, country, publishingOrg, or publishingCountry. Switching to source='adhoc'.")
      source <- "adhoc"
    }
  }
  
  if(!length(dots(...)) == 0 & !source == "adhoc") {
    message(rgbif_wrap("Un-named args, setting source='adhoc'."))
    source <- "adhoc"
    if(is.null(style)) style <- "scaled.circles"
  }
  
  # set default style based on interface 
  if(is.null(style) & source == "density") style <- "classic.point"
  if(is.null(base_style) & source == "density") base_style <- "gbif-classic"
  
  if(is.null(style) & source == "adhoc") style <- "scaled.circles"
  if(is.null(base_style) & source == "adhoc") base_style <- "gbif-light"
  
  if(!is.null(bin)) stopifnot(bin %in% c('square', 'hex'))
  if(!is.null(style)) stopifnot(style %in% map_styles)
  if(!is.null(base_style) & return == "png") stopifnot(base_style %in% base_styles)
  if(is.null(bin)) {
    default_hex_styles <- map_styles[grepl("marker|poly",map_styles)]  
    if(style %in% default_hex_styles) { 
      message("You are using a map style that works better with arg 'bin' set to 'hex'. Setting bin='hex'. You can also try bin='square'.")
      bin <- "hex" 
    }
  }
  
  # message that point styles don't really work well with bin hex and 
  
  # if((style %in% map_styles[grepl("point",map_styles)]) |
     # is.null(bin)) 
  
  if(source == "adhoc" & style %in% map_styles[grepl("point",map_styles)]) {
    message("The adhoc interface doesn't work well with 'point styles'. Try one of these : ")
    message(paste(map_styles[!grepl("point",map_styles)],collapse="\n"))
  } 
  
  if (!is.null(year)) {
    year <- match.arg(arg = as.character(year), choices = 0:2200,
      several.ok = TRUE)
    if (length(year) > 1) {
      year <- paste0(c(min(year), max(year)), collapse = ",")
    }
  }
  
  query <- rgbif_compact(c(list(srs = srs, taxonKey = taxonKey,
    datasetKey = datasetKey, country = country, publishingOrg = publishingOrg,
    publishingCountry = publishingCountry, year = year,
    bin = bin, squareSize = squareSize, hexPerTile = hexPerTile,
    style = style),dots(...)))
  
  if (!is.null(basisOfRecord)) {
    basisOfRecord <- match.arg(
      arg = basisOfRecord,
      choices = basis_of_record_values,
      several.ok = TRUE
    )
    bs <- as.list(unlist(
      lapply(basisOfRecord, function(x) list(basisOfRecord = x))
    ))
    query <- c(query, bs)
  }
  
  # terra
  if(return == "terra") {
    map_png <- do.call("rbind",lapply(y,function(y) {
      do.call("cbind",lapply(x,function(x) {
      get_map_png(source,z=z,x=x,y=y,format,query,return)
    }))
    }))
  map <- terra::rast(map_png)
  terra::ext(map) <- switch_extent(srs,x,y,z)
  terra::crs(map) <- srs
  if(plot_terra) terra::plot(map)
  map
  }
  
  if(return == "png") {
  
  # get points 
  map_png <- magick::image_append(
    do.call("c",lapply(y,function(y) {
    magick::image_append(
    do.call("c",lapply(x,function(x) { 
    get_map_png(source,z=z,x=x,y=y,format,query,return,srs,curlopts)
  })))
  })),stack=TRUE)
  
  base_png <- magick::image_append(
    do.call("c",lapply(y,function(y) {
    magick::image_append(
    do.call("c",lapply(x,function(x) { 
    get_base_png(srs,z=z,x=x,y=y,
      format=format,base_style=base_style,curlopts=curlopts)
  })))
  })),stack=TRUE)
    
    if(!is.null(base_style)) {
      map <- magick::image_flatten(c(base_png,map_png))
    } else {
      map <- map_png
    }
  }
  
  return(map)
}

switch_extent <- function(srs,x,y,z) {
  
  if(srs == 'EPSG:4326') {
    y_4326 <- rev(-1*ext_(y,z,var="y",d1=-90,d2=90,tot=180,max_z=6,
                          z_seq = c(0, 1, 3, 7, 15, 31, 62)))
    x_4326 <- ext_(x,z,var="x",d1=-180,d2=180,tot=360,max_z=6,
                   z_seq = c(1, 3, 7, 15, 31, 63, 71))                 
    extents <- c(x_4326,y_4326)
  }
  
  # I don't know what is going on here, so I am not going to support it
  # if(srs == 'EPSG:3857') {
    # y_3857 <- rev(-1*ext_(y,z,var="y",d1=-20037508,d2=20037508,tot=40075016,max_z=6,
                          # z_seq = c(0, 1, 3, 7, 15, 31, 61)))
    # x_3857 <- ext_(x,z,var="x",d1=-20037508,d2=20037508,tot=40075016,max_z=6,
                   # z_seq = c(0, 1, 3, 7, 15, 31, 38))
    # extents <- c(x_3857,y_3857)
  # }
  
  # only supporting terra rasters for the these right now. Although these might 
  # work too. 
  # 'EPSG:3575' = c(-6371007.2 * sqrt(2), 6371007.2 * sqrt(2),
  #                 -6371007.2 * sqrt(2), 6371007.2 * sqrt(2)),
  # 'EPSG:3031' = c(-12367396.2185, 12367396.2185, -12367396.2185, 12367396.2185)
  
  return(extents)
}

get_map_png <- function(source,z,x,y,format,query,return,srs,curlopts) {
  path <- file.path('v2/map/occurrence', source, z, x, paste0(y, format))
  cli <- crul::HttpClient$new(url = 'https://api.gbif.org', opts = curlopts)
  res <- cli$get(path, query = query)
  if(length(res$content) == 0) {
    if(return == "png") {
      # get size of tile map tile to make blank tile
      dummy_img <- get_base_png(srs,z,x=0,y=0,format,base_style="gbif-classic")
      img <- magick::image_blank(height=magick::image_info(dummy_img)$height,
                                 width=magick::image_info(dummy_img)$width)
    }
    if(return == "terra") {
      stop("The args chosen returned no data. Try smaller x,y values.")
    }
    
  } else {
    if(return == "terra") img <- png::readPNG(res$content)[,,2]
    if(return == "png") img <- magick::image_read(res$content)
  }
  img
}

get_base_png <- function(srs,z,x,y,format,base_style,curlopts) {
  query <- rgbif_compact(list(style=base_style))
  srs_num <- gsub("[^0-9]","",srs)
  path <- file.path(srs_num,'omt', z, x, paste0(y, format))
  cli <- crul::HttpClient$new(url = 'https://tile.gbif.org', opts = curlopts)
  res <- cli$get(path, query = query)
  if(length(res$content) == 0) {
      message("The args chosen returned no data. Returning blank image.")
      # get size of tile map tile to make blank tile
      dummy_img <- get_base_png(srs,z,x=0,y=0,format,base_style="gbif-classic")
      img <- magick::image_blank(height=magick::image_info(dummy_img)$height,
                                 width=magick::image_info(dummy_img)$width)
  } else {
    img <- magick::image_read(res$content)
    img
    }
    
}

ext_ <- function(x,z,var=NULL,d1=NULL,d2=NULL,tot=NULL,max_z=NULL,z_seq = NULL) {
  z_i <- z + 1
  x_i <- x + 1
  z_seq_i <- z_seq + 1
  n_tiles <- z_seq_i[z_i]
  max_x <- n_tiles - 1
  tiles <- seq(d1,d2,by=tot/n_tiles)
  ext <- tiles[seq(min(x_i),max(x_i)+1)]
  ext <- c(min(ext),max(ext))
  ext
}

map_styles <- c(
  'purpleHeat.point',
  'blueHeat.point',
  'orangeHeat.point',
  'greenHeat.point',
  'green.point',
  'classic.point',
  'purpleYellow.point',
  'fire.point',
  'glacier.point',
  'classic.poly',
  'classic-noborder.poly',
  'purpleYellow.poly',
  'purpleYellow-noborder.poly',
  'green.poly',
  'green2.poly',
  'iNaturalist.poly',
  'purpleWhite.poly',
  'red.poly',
  'blue.marker',
  'orange.marker',
  'outline.poly', 
  'scaled.circles'
)

base_styles <- c(
  'gbif-classic',
  'gbif-light',
  'gbif-middle',
  'gbif-dark',
  'gbif-geyser',
  'gbif-tuatara',
  'gbif-violet',
  'osm-bright',
  'gbif-natural'
)

# enumeration(x="BasisOfRecord")
basis_of_record_values <- c('PRESERVED_SPECIMEN',
                            'FOSSIL_SPECIMEN',
                            'LIVING_SPECIMEN',
                            'OBSERVATION',
                            'HUMAN_OBSERVATION',
                            'MACHINE_OBSERVATION',
                            'MATERIAL_SAMPLE',
                            'LITERATURE',
                            'MATERIAL_CITATION',
                            'OCCURRENCE',
                            'UNKNOWN')
