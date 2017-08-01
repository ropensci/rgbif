
# Generate colour palette ------------------------------------------------------
# Helper function to generate a colour ramp that will be used to map colours to
# value bins of the species occurrence count raster.
get_colours <- function(type, key, colour_breaks = NULL, colour_nbreaks = NULL){
  breaks <- colour_breaks
  nbreaks <- colour_nbreaks
  # If breaks are supplied, nbreaks will be ignored
  if(!is.null(breaks) & !is.null(nbreaks)){
    warning('Both "breaks" and "nbreaks" value supplied. "nbreaks" will be ignored!', call. = FALSE)
    }
  if(is.null(breaks)){
    if(is.null(nbreaks)){
      warning('No breaks or number of breaks value supplied for the reclassification of species occurrence count values. The function will try to estimate suitable values from the total number of records for the taxon, but you should carefully check the results and consider supplying values manually via the "breaks" or the "nbreaks" argument of the function.', call. = FALSE)
      nbreaks <- 50
      }

    # If type is TAXON we can use occ_count to estimate total number of records
    if(type == 'TAXON'){
      # Estimate good breaks from the number of records for the taxon.
      # Start with an exponential series of 50 break values:
      breaks <- seq(1, nbreaks, by = 1) ^ 3

      # A useful sequence depends on taxon, number of records, and extent.
      # For key = 1 (animalia), which has a total of 400,000,000 records,
      # a working top category seems to be around 10,000.
      # Get total number of records for the taxon
      noccs <- occ_count(key, georeferenced = TRUE)
      # Get an estimate of a suitable maximum
      # This number is somewhat arbitrary. What could be a good way to scale this?
      break_max <- noccs / 50000; if(break_max < nbreaks) break_max = nbreaks
      break_min <- 1
      # Rescale to 1 - max
      rescale_vector <- function(x, min_value, max_value) {
        return((max_value - min_value) / (max(x) - min(x)) * (x - max(x)) + max_value)
        }
      breaks <- rescale_vector(
        x = breaks,
        max_value = break_max,
        min_value = break_min) %>%
        round(digits = 0) %>%
        as.integer() %>%
        unique
    # If type other than TAXON we will use a standard colour key (exponential)
    }else{
      breaks <- seq(1, 50, by = 1) ^ 2
      }

    nbreaks <- length(breaks)
    }

  # If breaks are supplied manually
  if(!is.null(breaks)) {
    # Check input for valid format:
    # Check if breaks are numeric
    if(!is.numeric(breaks) && !is.integer(breaks)) {
      stop('Break values supplied are not numeric or integer', call. = FALSE)
      }
    # Check if breaks are too many
    if(length(breaks) > 50){
      stop('Break values supplied are too many (>50)', call. = FALSE)
      }
    # Check if breaks are positive
    if(min(breaks) < 0) {
      stop('Break values supplied contain negative values', call. = FALSE)
      }
    breaks <- as.integer(breaks)
    # Check if breaks are monotonic
    if(!all(breaks < c(breaks[-1], max(breaks + 1)))) {
      stop('Break values supplied are not monotonic', call. = FALSE)
      }
    nbreaks <- length(breaks)
    }

  # Generate actual url snippet using the values generated above
  url_colours <- ''
  tile_map_colours <- c('01','02','03','04','05','06','07','08','09','0A','0B','0C','0D',
                        '0E','0F','10','11','12','13','14','15','16','17','18','19','1A',
                        '1B','1C','1D','1E','1F','20','21','22','23','24','25','26','27',
                        '28','29','2A','2B','2C','2D','2E','2F','30','31','32','33','34',
                        '35','36','37','38','39','3A','3B','3C','3D','3E','3F','40','41',
                        '42','43','44','45','46','47','48','49','4A','4B','4C','4D','4E',
                        '4F','50','51','52','53','54','55','56','57','58','59','5A','5B',
                        '5C','5D','5E','5F','60','61','62','63','64','65','66','67','68',
                        '69','6A','6B','6C','6D','6E','6F','70','71','72','73','74','75',
                        '76','77','78','79','7A','7B','7C','7D','7E','7F','80','81','82',
                        '83','84','85','86','87','88','89','8A','8B','8C','8D','8E','8F',
                        '90','91','92','93','94','95','96','97','98','99','9A','9B','9C',
                        '9D','9E','9F','A0','A1','A2','A3','A4','A5','A6','A7','A8','A9',
                        'AA','AB','AC','AD','AE','AF','B0','B1','B2','B3','B4','B5','B6',
                        'B7','B8','B9','BA','BB','BC','BD','BE','BF','C0','C1','C2','C3',
                        'C4','C5','C6','C7','C8','C9','CA','CB','CC','CD','CE','CF','D0',
                        'D1','D2','D3','D4','D5','D6','D7','D8','D9','DA','DB','DC','DD',
                        'DE','DF','E0','E1','E2','E3','E4','E5','E6','E7','E8','E9','EA',
                        'EB','EC','ED','EE','EF','F0','F1','F2','F3','F4','F5','F6','F7',
                        'F8','F9','FA','FB','FC','FD','FE','FF')
  # Null colour
  url_colours <- paste0(url_colours, '0,0,#000000FF|')
  # First colour
  colour <- tile_map_colours[1]
  url_colours <-
    paste0(
      url_colours,
      '0,',
      breaks[1], ',#',
      colour,colour,colour,'FF|'
      )
  # All other tile_map_colours
  for(i in 2:nbreaks) {
    # Make a ruleset for each value
    colour <- tile_map_colours[i]
    url_colours <-
      paste0(
        url_colours,
        breaks[i-1], ',',
        breaks[i], ',#',
        colour,colour,colour,'FF|'
        )
    }
  # Last colour: use break value for floor instead of for ceiling
  colour <- tile_map_colours[i+1]
  url_colours <- paste0(
    url_colours,
    breaks[nbreaks],',,#',
    colour,colour,colour,'FF'
    )

  # Get a table of raster values and number of record values they correspond to
  breakstab <- cbind(
    'from' = 0:nbreaks,
    'to' = 0:nbreaks+1,
    'becomes' = c(0,breaks))

  return(list(url_colours, breakstab))
}


# Generate layer selection string ----------------------------------------------
# Helper function to generate a query string from layers, decades, living, and fossil.
get_layers <- function(layers, decades, living, fossil) {
  all_layers <- NULL
  for(layer in layers){
    for(decade in decades){
      all_layers <- c(all_layers, paste0(layer,'_',decade))
      }
    }

  if(living) all_layers <- c(all_layers, 'LIVING')
  if(fossil) all_layers <- c(all_layers, 'FOSSIL')

  return(all_layers)
}


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
map_fetch <- function(
  type = 'TAXON',
  key = 1,
  resolution = 1,
  layers = c('OBS','SP','OTH'),
  living = TRUE,
  fossil = FALSE,
  decades = c('NO_YEAR','PRE_1900','1900_1910','1910_1920','1920_1930',
              '1930_1940','1940_1950','1950_1960','1960_1970','1970_1980',
              '1980_1990','1990_2000','2000_2010','2010_2020'),
  crs_string = '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0',
  breaks = NULL,
  nbreaks = NULL,
  x = 0,
  y = 0,
  z = 0,
  ...
  ) {

  # Check if required raster package is loaded
  raster_package_loaded = TRUE
  if(!'package:raster' %in% search()){
    warning('"raster" package is recommended for this function, but was not found. The function will return the API call, but you will not be able to use the main data output properly. We recommend you install the raster package via install.packages("raster") and load it via load(raster)!',
            call. = FALSE)
    raster_package_loaded = FALSE
    }
  # Check type of search. If other than 'TAXON', breaks cannot be set automatically
  if(type != 'TAXON' & is.null(breaks)){
    warning(paste(
      'Automatic setting of breaks is not supported for type',
      type,'. A standard scale will be used, but results will likely be better when supplying manual break values',
      call. = FALSE)
      )
    }

  # Check input ----------------------------------------------------------------
  if(!is.numeric(x) & !is.integer(x)){
    stop('x value supplied is not numeric.', call. = FALSE)
    }
  if(!is.numeric(y) & !is.integer(y)){
    stop('y value supplied is not numeric.', call. = FALSE)
    }
  if(!is.numeric(z) & !is.integer(z)){
    stop('z value supplied is not numeric.', call. = FALSE)
    }
  if(!is.numeric(resolution) & !is.integer(resolution)){
    stop('Value supplied for argument "resolution" is not numeric.',
         call. = FALSE)
    }
  if(!is.logical(living)){
    stop('Non-logical value supplied for argument "living". Please use TRUE or FALSE to select or deselect living specimen records', call. = FALSE)
    }
  if(!is.logical(fossil)){
    stop('Non-logical value supplied for argument "fossil". Please use TRUE or FALSE to select or deselect fossil specimen records', call. = FALSE)
    }
  if(!is.null(breaks)){
    if(!is.numeric(breaks) & !is.integer(breaks)){
      stop('Break values supplied are not numeric.', call. = FALSE)
      }
    }
  if(exists('nbreaks') & !is.null(nbreaks)){
    if(!is.numeric(nbreaks) & !is.integer(nbreaks)){
      stop('Number of breaks value supplied is not numeric.',
           call. = FALSE)
      }
    if(nbreaks < 1 | nbreaks > 50){
      stop('Breaks value invalid. Use a value between 1 and 50',
           call. = FALSE)
      }
    }

  type <- match.arg(
    arg = type,
    choices = c('TAXON', 'DATASET', 'COUNTRY', 'PUBLISHER'),
    several.ok = FALSE
    )
  resolution <- match.arg(
    arg = as.character(resolution),
    choices = c(1, 2, 4, 8, 16),
    several.ok = FALSE
    )
  decades <- match.arg(
    arg = decades,
    choices = c('NO_YEAR','PRE_1900','1900_1910','1910_1920','1920_1930',
                '1930_1940','1940_1950','1950_1960','1960_1970','1970_1980',
                '1980_1990','1990_2000','2000_2010','2010_2020'),
    several.ok = TRUE
    )
  layers <- match.arg(
    arg = layers,
    choices = c('OBS','SP','OTH'),
    several.ok = TRUE
    )

  # Generate map API query -----------------------------------------------------
  # URL string creation using httr

  # Get layers using helper function
  layers <- get_layers(
    layers = layers,
    decades = decades,
    living = living,
    fossil = fossil
    )
  # Get colours using helper function
  colour_values <- get_colours(
    type = type,
    key = key,
    colour_breaks = breaks,
    colour_nbreaks = nbreaks
    )

  # Make list of URL query parameters
  query <- list(
    # Single value parameters can simply be passed on
    x = x,
    y = y,
    z = z,
    type = type,
    key = key,
    resolution = resolution
    )

  # Multiple value parameters are iterated over
  for(layer in layers){
    query <- c(query, 'layer' = layer)
    }
  # Append colour mapping
  query <- c(query, 'colors' = colour_values[[1]])


  # Generate output file -------------------------------------------------------

  # Make temporary file for raster data
  temp <- tempfile()
  raw_raster <- GET(
    url = paste0(gbif_base(), '/map/density/tile'),
    query = query,
    write_disk(temp, overwrite = TRUE),
    ...
    )
  stop_for_status(raw_raster)

  # If raster package is not loaded, return raw response
  if(!raster_package_loaded){
    return(raw_raster)

  # If raster package is loaded, return processed raster
  }else{
    # Make map tile into raster
    rgb_raster <- raster::stack(temp)
    data_raster <- rgb_raster[[1]] %>%
      # Get actual bins of species number values
      raster::reclassify(
        rcl = colour_values[[2]],
        right = TRUE
        )

    # Add CRS string to the raster
    if(raster_package_loaded){
      raster::crs(data_raster) <- crs_string
      }
    # Add URL string to the raster
    attr(data_raster, which = 'url') <- raw_raster$url

    return(data_raster)
  }
}
