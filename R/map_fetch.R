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
#' @param source (character) Either `density` for fast, precalculated tiles,
#' or `adhoc` for any search. Default: `density`
#' @param x (integer) the zoom. Default: 0
#' @param y (integer) the column. Default: 0
#' @param z (integer) the row. Default: 0
#' @param format (character) The data format, one of:
#'
#' - `.mvt` for a vector tile
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
#' squares or hexagons. Points by default. optional
#' @param hexPerTile (integer) sets the size of the hexagons
#' (the number horizontally across a tile). optional
#' @param squareSize (integer) sets the size of the squares. Choose a factor
#' of 4096 so they tessalate correctly: probably from 8, 16, 32, 64, 128,
#' 256, 512. optional
#' @param style (character) for raster tiles, choose from the available styles.
#' Defaults to classic.point. optional. THESE DON'T WORK YET.
#' @param search (character) defines what type of subset of all GBIF data to
#' return. Should be one of "taxonKey", "datasetKey", "country", "publisher",
#' "publishingCountry". Without any search parameter, all occurrences will be
#' returned. optional
#' @param id (character) defines the value to be used as filter criterium in
#' the category supplied by `search`. Appropriate values depend on the
#' search category that is used, for example integer for
#' `search = "taxonKey"`. Has to be provided if
#' `search` parameter is specified. optional
#' @param year (integer) integer that limits the search to a certain year or,
#' if passing a vector of integers, multiple years, for example
#' `1984` or `c(2016, 2017, 2018)`. optional
#' @param basisOfRecord (character) one or more basis of record states to
#' include records with that basis of record. The full list is: `c("OBSERVATION",
#' "HUMAN_OBSERVATION", "MACHINE_OBSERVATION", "MATERIAL_SAMPLE",
#' "PRESERVED_SPECIMEN", "FOSSIL_SPECIMEN", "LIVING_SPECIMEN",
#' "LITERATURE", "UNKNOWN")`. optional
#' @param ... curl options passed on to [crul::HttpClient]
#'
#' @return an object of class `RasterLayer` if png format used, or
#' raw bytes when mvt format chosen
#'
#' @details This function uses the arguments passed on to generate a query
#' to the GBIF web map API. The API returns a web tile object as png that is
#' read and converted into an R raster object. The break values or nbreaks
#' generate a custom colour palette for the web tile, with each bin
#' corresponding to one grey value. After retrieval, the raster is reclassified
#' to the actual break values. This is a somewhat hacky but nonetheless
#' functional solution in the absence of a GBIF raster API implementation.
#'
#' We add extent and set the projection for the output. You can reproject
#' after retrieving the output.
#'
#' @note Styles don't work yet, sorry, we'll try to fix it asap.
#'
#' @author Laurens Geffert \email{laurensgeffert@@gmail.com}
#' @references https://www.gbif.org/developer/maps
#' @keywords web map, web tile, GBIF
#' @examples \dontrun{
#' if (
#'  requireNamespace("png", quietly = TRUE) && 
#'  requireNamespace("raster", quietly = TRUE)
#' ) {
#'   x <- map_fetch(search = "taxonKey", id = 3118771, year = 2010)
#'   x
#'   # gives a RasterLayer object
#'   class(x)
#'   # visualize
#'   library(raster)
#'   plot(x)
#'
#'   # different srs
#'   ## 3857
#'   y <- map_fetch(search = "taxonKey", id = 3118771, year = 2010, srs = "EPSG:3857")
#'   plot(y)
#'   ## 3031
#'   z <- map_fetch(search = "taxonKey", id = 3118771, year = 2010, srs = "EPSG:3031")
#'   plot(z)
#'   # 3575
#'   z <- map_fetch(search = "taxonKey", id = 3118771, year = 2010, srs = "EPSG:3575")
#'   plot(z)
#'
#'   # bin
#'   plot(map_fetch(search = "taxonKey", id = 212, year = 1998, bin = "hex",
#'      hexPerTile = 30, style = "classic-noborder.poly"))
#'
#'   # map vector tile, gives back raw bytes
#'   x <- map_fetch(search = "taxonKey", id = 3118771, year = 2010,
#'     format = ".mvt")
#'   x[1:10]
#'  }
#' }

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
  basisOfRecord = NULL,
  ...
  ) {

  check_for_a_pkg("png")
  check_for_a_pkg("raster")

  assert(source, "character")
  assert(x, c('numeric', 'integer'))
  assert(y, c('numeric', 'integer'))
  assert(z, c('numeric', 'integer'))
  assert(format, "character")
  assert(srs, "character")
  assert(bin, "character")
  assert(hexPerTile, c('numeric', 'integer'))
  assert(squareSize, c('numeric', 'integer'))
  assert(style, "character")
  assert(search, "character")
  assert(id, c("numeric", "integer", "character"))
  assert(year, c('numeric', 'integer'))
  assert(basisOfRecord, "character")

  # Check input ---------------------------------------------------------------
  source <- match.arg(
    arg = source,
    choices = c('density', 'adhoc'),
    several.ok = FALSE
  )

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

  if (!is.null(squareSize)) {
    squareSize <- match.arg(arg = as.character(squareSize),
      choices = c(8, 16, 32, 64, 128, 256, 512), several.ok = FALSE
    )
  }

  if (!is.null(bin)) {
    bin <- match.arg(arg = bin, choices = c('square', 'hex'))
  }

  if (!is.null(style)) {
    style <- match.arg(arg = style, choices = map_styles, several.ok = FALSE)
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
    year <- match.arg(arg = as.character(year), choices = 0:2200,
      several.ok = TRUE)
  }

  if (!is.null(search) && is.null(id)) {
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

  query <- rgbif_compact(list(srs = srs, search = search, id = id, year = year,
    bin = bin, squareSize = squareSize, hexPerTile = hexPerTile, style = style,
    basisOfRecord = basisOfRecord))

  path <- file.path('v2/map/occurrence', source, z, x, paste0(y, format))
  cli <- crul::HttpClient$new(url = 'https://api.gbif.org', opts = list(...))
  res <- cli$get(path, query = query)
  if (!grepl("mvt", format)) {
    map_png <- png::readPNG(res$content)
    map <- raster::raster(map_png[,,2])
    raster::extent(map) <- switch_extent(srs)
    raster::crs(map) <- crs_string(srs)
    return(map)
  } else {
    res$content
  }
}

crs_string <- function(x) {
  strg <- switch(
    x,
    'EPSG:3857' = '+init=epsg:3857',
    'EPSG:4326' = '+init=epsg:4326',
    'EPSG:3575' = '+init=epsg:3575',
    'EPSG:3031' = '+init=epsg:3031'
  )
  sp::CRS(strg)
}

switch_extent <- function(x) {
  switch(
    x,
    'EPSG:3857' = raster::extent(-180, 180, -85.1, 85.1),
    'EPSG:4326' = raster::extent(-180, 180, -90, 90),
    'EPSG:3575' = raster::extent(-6371007.2 * sqrt(2), 6371007.2 * sqrt(2),
      -6371007.2 * sqrt(2), 6371007.2 * sqrt(2)),
    'EPSG:3031' = raster::extent(-12367396.2185, 12367396.2185,
      -12367396.2185, 12367396.2185)
  )
}

map_styles <- c(
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
)

