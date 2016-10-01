
#' @title Call map API for bias grid
#' @description This function takes a valid GBIF taxon key to identify a
#' target group and returns a raster representing number of species occurrence
#' records per raster cell for the target group. This raster can be used as
#' bias grid for species distribution models of a species in that group.
#' @param taxonkey a valid GBIF taxon key as returned by ###
#' @param decades optional parameter to restrict the results to a certain time
#' period, specified as decades in the format: c("1990_2000","2000_2010"). If
#' no value is given, the value of c("1990_2000","2000_2010","2010_2020"), i.e.
#' the time from 1990 to present day is used by default.
#' @param layers optional parameter to specify the types of observations to
#' consider, specified as any combination of "OBS" (observations), "SP"
#' (specimen), and "OTH" (other). If no value is given, the value of
#' c("OBS","SP","OTH") is used by default.
#' @param living optional logical parameter to specify if living specimen should
#'  be included in the results. Default is TRUE.
#' @param fossil optional logical parameter to specify if fossils should be
#' included in the results. Default is FALSE.
#' @param breaks optional numeric vector to specify the break points of value
#' bins that shouls be used to represent species occurrence record numbers in
#' the resulting raster. This should be 50 or lower, but span the spectrum of
#' expected number of observations per raster cell to provide maximum
#' contrast between observed values. If you are unsure about what to specify,
#' leave this empty and get results with the standard settings first. In this
#' case, BioGeoBias will try to generate a suitable exponential sequence of
#' break values estimated from the total number of species occurrence records
#' available for yours species.
#' @param nbreaks optional numeric parameter to specify the number of breaks to
#' use for the binning of raster values. Should be between 10 and 50. If breaks
#' is specified this values will be ignored. Default is 50.
#' @param latMax maximum latitude of a rectancular bounding box restricting the
#' search for species occurrences of the target group (optional).
#' @param x numeric value to specify the longitudinal position of the raster
#' extent. Default is 0.
#' @param y numeric value to specify the latitudinal position of the raster
#' extent. Default is 0.
#' @param z numeric value to specify the zoom factor of the raster extent.
#' Default is 0 for global extent.
#' @author Jan Laurens Geffert, \email{laurensgeffert@@gmail.com}
#' @details This function uses the arguments passed on to generate a query
#' to the GBIF web map API. The API returns a web tile object that can be read
#' as a png and converted into an R raster object. The break values or nbreaks
#' generate a custom colour palette for the web tile, with each bin
#' corresponding to one grey value. After retrieval, the raster is reclassified
#' to the actual break values. This is a somewhat hacky but nonetheless
#' functional solution in the absence of a GBIF raster API or an rgbif map API
#' implementation.
#' @references \url{http://en.wikipedia.org/wiki/List_of_Crayola_crayon_colors}
#' @seealso \url{http://www.ecography.org/accepted-article/performance-tradeoffs-target-group-bias-correction-species-distribution-models}
#' @keywords sampling bias, web map tile, grid, raster, GBIF
#' @export

# GENERATE MAP API CALL STRING -------------------------------------------------
call_map_api <- function(
  taxonkey = 1,
  decades = c('NO_YEAR','PRE_1900','1900_1910','1910_1920','1920_1930','1930_1940','1940_1950','1950_1960','1960_1970','1970_1980','1980_1990','1990_2000','2000_2010','2010_2020'),
  layers = c('OBS','SP','OTH'),
  living = TRUE,
  fossil = FALSE,
  breaks = NULL,
  nbreaks = NULL,
  x = 0,
  y = 0,
  z = 0) {

  # Check input arguments
  if(!is.numeric(x) & !is.integer(x)) stop('x value supplied is not numeric.')
  if(!is.numeric(y) & !is.integer(y)) stop('y value supplied is not numeric.')
  if(!is.numeric(z) & !is.integer(z)) stop('z value supplied is not numeric.')
  if(!is.numeric(taxonkey) & !is.integer(taxonkey)){
    stop('value supplied for argument "taxonkey" is not numeric.')
  }
  # issues:
  # - include spatial filter
  # - include date filter
  # - include functionality to use custom species list instead of taxon
  # - add optional smoothing using spline?

  if(exists('breaks') & !is.null(breaks)){
    if(!is.numeric(breaks) & !is.integer(breaks)){
      stop('break values supplied are not numeric.')
    }
  }
  if(exists('nbreaks') & !is.null(nbreaks)){
    if(!is.numeric(nbreaks) & !is.integer(nbreaks)){
      stop('number of breaks value supplied is not numeric.')
    }
    if(nbreaks > 99){
      stop('nbreaks value too large. Use a value between 1 and 99')
    }
    if(nbreaks < 1){
      stop('nbreaks value too small. Use a value between 1 and 99')
    }
  }
  decades = match.arg(decades, several.ok = TRUE)
  layers = match.arg(layers, several.ok = TRUE)
  if(!is.logical(living)){
    stop('non-logical value supplied for argument "living". Please use TRUE or FALSE to select or deselect living specimen records')
  }
  if(!is.logical(fossil)){
    stop('non-logical value supplied for argument "fossil". Please use TRUE or FALSE to select or deselect fossil specimen records')
  }

  # The basic query string to start with
  url_base <- 'http://api.gbif.org/v1/map/density/tile?'

  # Specify the extent of the layer to be returned.
  # x for left binding longitude
  # y for top(?) binding latitude
  # z for zoom (0 for maximum extent)
  url_extent <- paste0('x=',x,'&y=',y,'&z=',z)

  # Specify the taxon that the search will look at
  url_taxon <- paste0('&type=TAXON&key=',taxonkey)


  # Generate layer selection string --------------------------------------------
  # Function to generate a query string from layers and decades
  get_layers <- function(layers, decades) {
    url_string = ''
    for(layer in layers){
      for(decade in decades){
        url_string <- paste0(url_string,'&layer=',layer,'_',decade)
      }
    }
    return(url_string)
  }
  # LAYERS: Specify which types of records to include.
  # OBS for observations
  # SP for specimen
  # OTH for other
  # Standard settings will include all three
  # DECADES: Specify the temporal extent.
  # Standard settings will look at the last 3 decades
  url_layers <- get_layers(layers = layers, decades = decades)

  # Should living specimen be included? Boolean
  # Standard settings will include living specimen.
  # This string only needs to be included if TRUE
  url_living <- ifelse(living, '&layer=LIVING', '')
  # Should fossil specimen be included? Boolean
  # Standard settings will exclude fossils.
  # This string only needs to be included if TRUE
  url_fossil <- ifelse(fossil, '&layer=FOSSIL', '')

  # Generate colour palette ----------------------------------------------------
  get_colours <- function(taxonkey, colour_breaks = NULL, colour_nbreaks = NULL){
    breaks = colour_breaks
    nbreaks = colour_nbreaks
    # If breaks are supplied, nbreaks will be ignored
    if(!is.null(breaks) & !is.null(nbreaks)){
      warning('Warning: Both "breaks" and "nbreaks" value supplied. "nbreaks" will be ignored!')
    }
    if(is.null(breaks)){
      if(is.null(nbreaks)){
        warning('Warning: No breaks or number of breaks value supplied for the reclassification of species occurrence count values. BioGeoBias will try to estimate suitable values from the total number of records for the taxon, but you should carefully check the results and consider supplying values manually via the "breaks" or the "nbreaks" argument of the function.')
        nbreaks = 50
      }

      # Estimate good breaks from the number of records for the taxon.
      # Start with an exponential series of 50 break values:
      breaks <- seq(1,nbreaks, by = 1) ^ 3

      # A useful sequence depends on taxon, number of records, and extent.
      # For taxonkey = 1 (animalia), which has a total of 400,000,000 records,
      # a working top category seems to be around 10,000.
      # Get total number of records for the taxon
      noccs <- occ_count(taxonkey, georeferenced = TRUE)
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
      nbreaks <- length(breaks)
    }

    # If breaks are supplied manually
    if(!is.null(breaks)) {
      # Check input for valid format:
      # Check if breaks are numeric
      if(!is.numeric(breaks) && !is.integer(breaks)) {
        stop('Error: break values supplied are not numeric or integer')
      }
      # Check if breaks are too many
      if(length(breaks) > 50){
        stop('Error: break values supplied are too many (>50)')
      }
      # Check if breaks are positive
      if(min(breaks) < 0) {
        stop('Error: break values supplied contain negative values')
      }
      breaks <- as.integer(breaks)
      # Check if breaks are monotonic
      if(!all(breaks < c(breaks[-1], max(breaks + 1)))) {
        stop('Error: break values supplied are not monotonic')
      }
      nbreaks <- length(breaks)
    }

    # Generate actual url snippet using the values generated above
    url_colours <- '&colors='
    colours <- c('01','02','03','04','05','06','07','08','09','0A','0B','0C','0D',
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
    url_colours <- paste0(url_colours, '0%2C0%2C%23000000FF%7C')
    # First colour
    colour <- colours[1]
    url_colours <-
      paste0(
      url_colours,
      '0%2C',
      breaks[1], '%2C%23',
      colour,colour,colour,'FF%7C')
    # All other colours
    for(i in 2:nbreaks) {
      # Make a ruleset for each value
      colour <- colours[i]
      url_colours <-
        paste0(
        url_colours,
        breaks[i-1], '%2C',
        breaks[i], '%2C%23',
        colour,colour,colour,'FF%7C')
    }
    # Last colour: use break value for floor instead of for ceiling
    colour <- colours[i+1]
    url_colours <- paste0(
      url_colours,
      breaks[nbreaks],'%2C%2C%23',
      colour,colour,colour,'FF')
    url_colours <- URLencode(url_colours)

    # Get a table of raster values and number of record values they correspond to
    breakstab <- cbind(
      'from' = 0:nbreaks,
      'to' = 0:nbreaks+1,
      'becomes' = c(0,breaks))

    return(list(url_colours, breakstab))
  }

  # Get colours
  url_colours <- get_colours(
    taxonkey = taxonkey,
    colour_breaks = breaks,
    colour_nbreaks = nbreaks)

  # Actual map API query -------------------------------------------------------
  # Generate the final query string from the individual building blocks
  url_query <- paste0(
    url_base,
    url_extent,
    url_taxon,
    url_layers,
    url_living,
    url_fossil,
    url_colours[[1]])

  # Get map tile from server
  temp <- tempfile()
  download.file(url_query, temp, mode="wb")

  # Make map tile into raster
  rgb_raster <- raster::stack(temp)
  data_raster <- rgb_raster[[1]] %>%
  # Get actual bins of species number values
    raster::reclassify(
    rcl = url_colours[[2]],
    right = TRUE)

  return(data_raster)
}


