#' @title Fetch raster map for specific GBIF occurrences.
#'
#' @export
#'
#' @description This function takes a valid GBIF taxon, dataset, country, or
#' publisher key and returns a raster representing the number of species
#' occurrence records per raster cell for the target group.
#'
#' @param type A value of TAXON, DATASET, COUNTRY or PUBLISHER. If a type other
#' than "TAXON" is chosen then break values cannot be set automatically. A vector
#' of break values will have to be supplied to the "breaks" argument.
#' (\code{default = "TAXON"})
#'
#' @param key The appropriate key for the chosen type (a taxon key,
#' dataset/publisher uuid, or 2 letter ISO country code).
#' (\code{default = 1})
#'
#' @param resolution The number of pixels to which density is aggregated.
#' Valid values are 1, 2, 4, 8, and 16.
#' (\code{default = 1})
#'
#' @param layers Declares the layers to be combined by the server for this tile.
#' Specified as any combination of "OBS" (observations), "SP" (specimen),
#' and "OTH" (other). If no value is given, the value of c("OBS","SP","OTH")
#' is used by default. See Customizing layer content on
#' \url{http://www.gbif.org/developer/maps}.
#' (\code{default = c("OBS","SP","OTH")})
#'
#' @param decades Parameter to restrict the results to a certain time
#' period, specified as decades in the format: c("1990_2000","2000_2010"). If
#' no value is given, the value of c("1990_2000","2000_2010","2010_2020"), i.e.
#' the time from 1990 to present day is used by default.
#' (\code{default = c("1990_2000","2000_2010","2010_2020")})
#'
#' @param living Logical parameter to specify if living specimen should be
#' included in the results.
#' (\code{default = TRUE]})
#'
#' @param fossil Logical parameter to specify if fossils should be included
#' in the results.
#' (\code{default = FALSE]})
#'
#' @param breaks Numeric vector to specify the break points of value
#' bins that should be used to represent species occurrence record numbers in
#' the resulting raster. Number of specified breaks should be 50 or lower,
#' and specified values should span the spectrum of expected number of
#' observations per raster cell to provide maximum contrast between observed
#' values. If you are unsure about what to specify (and your query type is
#' "TAXON"), leave this empty and get results with the standard settings first.
#' In this case, the function willtry to generate a suitable exponential
#' sequence of break values estimated from the total number of species
#' occurrence records available for this key.
#' (\code{default = <dynamic>})
#'
#' @param nbreaks Numeric value to specify the number of breaks to
#' use for the binning of raster values. Should be between 10 and 50. If breaks
#' are specified this values will be ignored.
#' (\code{default = 50})
#'
#' @param x Numeric value to specify the left binding longitude for horizontal
#' position of the raster extent.
#' (\code{default = 0})
#'
#' @param y Numeric value to specify the top binding latitude for vertical
#' position of the raster extent.
#' (\code{default = 0})
#'
#' @param z Numeric value to specify the zoom factor of the raster extent.
#' (\code{default = 0})
#'
#' @param crs_string String to specify the projection of the output raster.
#' (\code{default = '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'})
#'
#' @param ... optional arguments to be passed on to the httr::GET call to the API
#'
#' @return An object of the class \code{\link[raster]{raster}}, with the
#' addition of an attribute 'url' specifying the API call URL that was used to
#' get the data from GBIF. The raster package should be installed and loaded to
#' handle the output of the function. Raster values represent the number of
#' geo-referenced occurrence records in each of the cells. Notice that values
#' indicate integer ranges ("bins") rather than exact values. The bins can be
#' adjusted using the \code{breaks} parameter.The URL attribute can be
#' exctracted from the output: \code{attr(output, which = 'url')}.
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
#' @references \url{http://www.gbif.org/developer/maps}
#' @keywords web map tile, raster, GBIF, bias grid
#' @examples \dontrun{
#'
#' # If you don't want to use the raster package, you can still use this function
#' # to generate an API call to the map API. The returned value will be an httr object
#' # of the class 'response', from which you can extract the url to use it elsewhere:
#'
#' response <- map_fetch()
#' response$url
#'
#' # If you want to use the raster package, as recommended, then:
#' # Make sure required package is loaded
#' if (requireNamespace("raster")){
#'   library(raster)
#'
#'   # To get a map of all bird records on GBIF:
#'   # First find the key for birds on GBIF backbone taxonomy
#'   BirdBackboneKey <- name_backbone('aves')$classKey
#'   # Then run the function with standard settings
#'   BirdDiversityMap <- map_fetch(key = BirdBackboneKey)
#'   plot(BirdDiversityMap)
#' }
#'
#'
#' # If we are interested in an overview of all animal specimen collected between
#' # 1990 to 1930, we an use the query below to get a quick overview
#' if (requireNamespace("raster")){
#'   DivMap1 <- map_fetch(
#'     key = 1,
#'     decades = c('1900_1910','1910_1920','1920_1930'),
#'     layers = 'SP',
#'     living = FALSE,
#'     fossil = FALSE,
#'     breaks = c(1,3,5,10,30,50,100,300,500,1000)
#'   )
#'   plot(DivMap1, asp = 1)
#' }
#'
#' # Moreover, I can use the resulting raster to run some interesting analyses,
#' # like, how does this compare to the equivalent records from the 1950 to 1980 period?
#' if (requireNamespace("raster")){
#'   DivMap2 <- map_fetch(
#'     key = 1,
#'     decades = c('1950_1960','1960_1970','1970_1980'),
#'     layers = 'SP',
#'     living = FALSE,
#'     fossil = FALSE,
#'     breaks = c(1,3,5,10,30,50,100,300,500,1000)
#'     )
#'   plot(DivMap2)
#'
#'   # Since these are rasters, we can do calculations on them!
#'   plot(DivMap2 - DivMap1)
#'
#'   # We can immediately see that more records were collected in North America,
#'   # but collection numbers went down in some areas of Europe, South-East Asia,
#'   # Australia, and Africa.
#' }
#'
#' # We can also use type = 'DATASET' with a dataset key,
#' # for example the specimen collection of the Natural History Museum London.
#' # In this case the function cannot use occ_count to estimate a suitable
#' # set of break values, so we should specify them manually
#' # (Otherwise standard exponential will be used).
#' if (requireNamespace("raster")){
#'   NHML <- map_fetch(
#'     type = 'DATASET',
#'     key = '7e380070-f762-11e1-a439-00145eb45e9a',
#'     breaks = c(1,3,5,10,15,20,50,100,200,500,1000,1500,2000,5000,10000)
#'     )
#'   plot(NHML, asp = 1)
#' }
#'
#' # This is just one quick ad-hoc query.
#' # You can run your own spatial analyses in a similar fashion to investigate
#' # any question you might be interested in.}



library(utils)
library(stats)
library(xml2)
library(ggplot2)
library(httr)
library(data.table)
library(whisker)
library(magrittr)
library(jsonlite)
library(V8)
library(oai)
library(geoaxe)
library(tibble)
library(testthat)
library(knitr)
library(reshape2)
library(maps)
library(sp)
library(rgeos)
library(rgbif)

# URL format
# https://api.gbif.org/v2/maps/occurrence/{source}/{z}/{x}/{y}{format}?srs={srs}{params}
# e.g. https://api.gbif.org/v2/map/occurrence/density/0/0/0@1x.png?style=purpleYellow.point
# e.g. https://api.gbif.org/v2/map/occurrence/density/0/0/0@1x.png?srs=EPSG:4326&style=purpleYellow.point

source = c('density', 'adhoc')
z = NULL
x = 0:5
y = NULL
format = c(
  '.mvt',
  '@Hx.png',
  '@1x.png',
  '@2x.png',
  '@3x.png',
  '@4x.png')
srs = c(
  'EPSG:3857',
  'EPSG:4326',
  'EPSG:3575',
  'EPSG:3031')
# Parameters
bin = c(
  'points',
  'square',
  'hex')
hexPerTile = c()
squareSize = c(8, 16, 32, 64, 128, 256, 512)
style = c(
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
  'outline.poly')

search = c(
  'taxonKey',
  'datasetKey',
  'country',
  'publisher',
  'publishingCountry')
year
basisOfRecord = c(
  'OBSERVATION',
  'HUMAN_OBSERVATION',
  'MACHINE_OBSERVATION',
  'MATERIAL_SAMPLE',
  'PRESERVED_SPECIMEN',
  'FOSSIL_SPECIMEN',
  'LIVING_SPECIMEN',
  'LITERATURE',
  'UNKNOWN')

# Four map projections are supported:
# 4326, 3857, 3575, 3031
# WGS84 Plate Careé, Web Mercator, Arctic LAEA on 10°E, Antarctic Stereographic


# Control input parameters
type <- match.arg(
  arg = type,
  choices = c('TAXON', 'DATASET', 'COUNTRY', 'PUBLISHER'),
  several.ok = FALSE
)

stopifnot(is.numeric(key))








# Generate url -------------------------------------------------------
# https://api.gbif.org/v2/maps/occurrence/{source}/{z}/{x}/{y}{format}?srs={srs}{params}
# e.g. https://api.gbif.org/v2/map/occurrence/density/0/0/0@1x.png?style=purpleYellow.point

url <- sprintf(
  '%s/%s/map/occurrence/%s/%s/%s/%s%s',
  'https://api.gbif.org', # gbif_base(),
  version,
  source,
  z,
  x,
  y,
  format
)

# Make list of URL query parameters
query <- list(
  x = 0,
  y = 0,
  z = 0,
  type = type,
  key = key,
  resolution = resolution
)

# Make temporary file for raster data
temp <- tempfile()
# Actual map fetch
raw_raster <- GET(
  url = url,
  query = query,
  write_disk(temp, overwrite = TRUE),
  ...
)
stop_for_status(raw_raster)




