

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
  
  z <- match.arg(
    arg = z,
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
    path = paste0('/maps/occurrence/', source, '/',
      z, '/', x, '/', y, format, '?srs=', srs),
    query = query)
    
  # test response status
  stop_for_status(response)
  
) {