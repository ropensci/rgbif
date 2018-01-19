#' @title Fetch aggregated density maps of GBIF occurrences
#'
#' @export
#'
#' @description This function is a wrapper for the GBIF mapping api version 2.0.
#' The mapping API is a web map tile service making it straightforward to 
#' visualize GBIF content on interactive maps, and overlay content from other 
#' sources. It returns tile maps or vector maps with number of 
#' GBIF records per area unit that can be used in a variety of ways, for example
#' in interactive leaflet web maps. Map details are specified by a number of 
#' query parameters, some of them optional. Full documentation of the GBIF
#' mapping api can be found at https://www.gbif.org/developer/maps
#'
#' @param source (character): Either density for fast, precalculated tiles, 
#' or adhoc for any search. `default = "density"`
#' 
#' @param x (integer): the zoom. `default = 0`
#' 
#' @param y (integer): the column. `default = 0`
#' 
#' @param z (integer): the row. `default = 0`
#' 
#' @param format (character): 
#' .mvt for a vector tile
#' /@Hx.png for a 256px raster tile (for legacy clients)
#' /@1x.png for a 512px raster tile
#' /@2x.png for a 1024px raster tile
#' /@3x.png for a 2048px raster tile
#' /@4x.png for a 4096px raster tile
#' 
#' @param srs (character):
#' 	Spatial reference system. One of:
#' 	EPSG:3857 (Web Mercator)
#' 	EPSG:4326 (WGS84 plate care?)
#' 	EPSG:3575 (Arctic LAEA)
#' 	EPSG:3031 (Antarctic stereographic)
#' 	see below under Projections.
#' 	
#' 	@param bin (optional): square or hex to aggregate occurrence counts into 
#' 	squares or hexagons. Points by default.
#' 	
#' 	@param hexPerTile (optional): sets the size of the hexagons 
#' 	(the number horizontally across a tile)
#' 	
#' 	@param squareSize (optional): sets the size of the squares. Choose a factor 
#' 	of 4096 so they tessalate correctly: probably from 8, 16, 32, 64, 128, 
#' 	256, 512.
#' 	
#' 	@param style (optional): for raster tiles, choose from the available styles. 
#' 	Defaults to classic.point.
#' 	
#' 	@param search (optional): defines what type of subset of all GBIF data to 
#' 	return. Should be one of c("taxonKey", "datasetKey", "country", "publisher",
#' 	"publishingCountry"). Without any search parameter, all occurrences will be 
#' 	returned.
#' 	
#' 	@param id (optional): defines the value to be used as filter criterium in 
#' 	the category supplied by `search`. Appropriate values depend on the
#' 	search category that is used, for example integer for 
#' 	`search = "taxonKey"`. Has to be provided if 
#' 	`search` parameter is specified.
#' 	
#' 	@param year (optional): integer that limits the search to a certain year or, 
#' 	if passing a vector of integers,, multiple years, for example
#' 	`1984` or `c(2016, 2017, 2018)`.
#' 	
#' 	@param basisOfRecord (optional): character or character vector to include 
#' 	records with that basis of record. The full list is: `c("OBSERVATION", 
#' 	"HUMAN_OBSERVATION", "MACHINE_OBSERVATION", "MATERIAL_SAMPLE", 
#' 	"PRESERVED_SPECIMEN", "FOSSIL_SPECIMEN", "LIVING_SPECIMEN", 
#' 	"LITERATURE", "UNKNOWN")`.
#' 	
#' @return ###???
#'
#' @details This function uses the arguments passed on to generate a query
#' to the GBIF web map API. The API returns a web tile object as png that can be
#' read and converted into an R raster object. The break values or nbreaks
#' generate a custom colour palette for the web tile, with each bin
#' corresponding to one grey value. After retrieval, the raster is reclassified
#' to the actual break values. This is a somewhat hacky but nonetheless
#' functional solution in the absence of a GBIF raster API implementation.
#'
#' @author Laurens Geffert, \email{laurensgeffert@@gmail.com}
#' @references \url{https://www.gbif.org/developer/maps}
#' @keywords web map, web tile, GBIF
#' @examples \dontrun{}

map_fetch <- function(
  source = 'density',
  x = 0,
  y = 0,
  z = 0,
  format = '@1x.png',
  srs = 'EPSG:4326',
  bin = NULL,
  hexPerTile = NULL,
  squareSize = NULL,
  style = 'classic.point',
  search = NULL,
  id = NULL,
  year = NULL,
  basisOfRecord = NULL
  ) {
  
  
  # Check input ----------------------------------------------------------------
  source <- match.arg(
    arg = source,
    choices = c('density', 'adhoc'),
    several.ok = FALSE
  )

  if(!is.numeric(x) & !is.integer(x)){
    stop('x value should be numeric or integer.', call. = FALSE)
  }
  
  if(!is.numeric(y) & !is.integer(y)){
    stop('y value should be numeric or integer.', call. = FALSE)
  }
  
  if(!is.numeric(z) & !is.integer(z)){
    stop('z value should be numeric or integer.', call. = FALSE)
  }

  format <- match.arg(
    arg = format,
    choices = c('.mvt', '@Hx.png', '@1x.png', '@2x.png', '@3x.png', '@4x.png'),
    several.ok = FALSE
  )
  
  srs <- match.arg(
    arg = srs,
    choices = c('EPSG:3857', 'EPSG:4326', 'EPSG:3575', 'EPSG:3031'),
    several.ok = FALSE
  )
  
  if (!is.null(bin)) {
    bin <- match.arg(
      arg = bin,
      choices = c(NULL, 'square', 'hex'),
      several.ok = FALSE
    )
  }
  
  if (!is.null(hexPerTile)) {
    hexPerTile <- match.arg(
      arg = hexPerTile,
      choices = c('square', 'hex'),
      several.ok = FALSE
    )
  }
  
  if (!is.null(hexPerTile)) {
    hexPerTile <- match.arg(
      arg = hexPerTile,
      choices = c('square', 'hex'),
      several.ok = FALSE
    )
  }  
  
  if (!is.null(squareSize)) {
    squareSize <- match.arg(
      arg = squareSize,
      choices = c(8, 16, 32, 64, 128, 256, 512),
      several.ok = FALSE
    )
  }
  
  if (!is.null(bin)) {
    bin <- match.arg(
      arg = bin,
      choices = c(
        'purpleHeat.point',
        'blueHeat.point',
        'orangeHeat.point',
        'greenHeat.point',
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
        'outline.poly'
      ),
      several.ok = FALSE
    )
  }
  
  if (!is.null(search)) {
    search <- match.arg(
      arg = search,
      choices = c(
        'taxonKey', 
        'datasetKey', 
        'country', 
        'publisher', 
        'publishingCountry'
        ),
      several.ok = FALSE
    )
  }
  
  if (!is.null(year)) {
    year <- match.arg(
      arg = year,
      choices = 0:2200,
      several.ok = TRUE
    )
  }
  
  if (!is.null(search) & is.null(id)) {
    stop('You have supplied a search category but no search value. 
         Please provide either neither or both, for example: 
         search = "taxonKey", id = 1')
  }
  
  if (!is.null(basisOfRecord)) {
    basisOfRecord <- match.arg(
      arg = basisOfRecord,
      choices = c(
        'OBSERVATION', 
        'HUMAN_OBSERVATION', 
        'MACHINE_OBSERVATION', 
        'MATERIAL_SAMPLE', 
        'PRESERVED_SPECIMEN', 
        'FOSSIL_SPECIMEN', 
        'LIVING_SPECIMEN',
        'LITERATURE',
        'UNKNOWN'
      ),
      several.ok = TRUE
    )
  }
  
  
  # Generate map API query -----------------------------------------------------
  
  # query parameters only needed if at least search OR year are supplied
  if (!is.null(search) | !is.null(year)) {
    query = list(
      'search' = search,
      'id' = id,
      'year' = year
    )
  } else {
    query = NULL
  }
  
  # API call with dynamically generated URL and parameters from query list
  response <- httr::GET(
    url = 'https://api.gbif.org/v2', #should change to `gbif_base()` at some point
    path = paste0('/map/occurrence/', source, '/',
      z, '/', x, '/', y, format, '?srs=', srs),
    query = query)
    
  # test response status
  stop_for_status(response)
  
  return(response)
}

#' TODO:
#' - switch from httr to crul
#' - switch to custom url and move version to path
#' - think output format (check leaflet)
