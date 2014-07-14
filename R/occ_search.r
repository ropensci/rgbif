#' Search for GBIF occurrences.
#'
#' @import httr plyr assertthat
#' @importFrom RJSONIO fromJSON
#' @export
#' @template occsearch
#' @template occ
#' @template all
#' @examples \dontrun{
#' # Search by species name, using \code{\link{name_backbone}} first to get key
#' (key <- name_suggest(q='Helianthus annuus', rank='species')$key[1])
#' occ_search(taxonKey=key, limit=2)
#'
#' # Return 20 results, this is the default by the way
#' occ_search(taxonKey=key, limit=20)
#'
#' # Return just metadata for the search
#' occ_search(taxonKey=key, return='meta')
#'
#' # Instead of getting a taxon key first, you can search for a name directly
#' ## However, note that using this approach (with \code{scientificName="..."})
#' ## you are getting synonyms too. The results for using \code{scientifcName} and
#' ## \code{taxonKey} parameters are the same in this case, but I wouldn't be surprised if for some
#' ## names they return different results
#' occ_search(scientificName = 'Ursus americanus')
#' key <- name_backbone(name = 'Ursus americanus', rank='species')$usageKey
#' occ_search(taxonKey = key)
#'
#' # Search by dataset key
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')
#'
#' # Search by catalog number
#' occ_search(catalogNumber="49366")
#' occ_search(catalogNumber=c("49366","Bird.27847588"))
#'
#' # Get all data, not just lat/long and name
#' occ_search(taxonKey=key, fields='all')
#'
#' # Or get specific fields. Note that this isn't done on GBIF's side of things. This
#' # is done in R, but before you get the return object, so other fields are garbage
#' # collected
#' occ_search(taxonKey=key, fields=c('name','basisOfRecord','protocol'))
#'
#' # Use paging parameters (limit and start) to page. Note the different results
#' # for the two queries below.
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=10,limit=5,
#'    return="data")
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',start=20,limit=5,
#'    return="data")
#'
#' # Many dataset keys
#' occ_search(datasetKey=c("50c9509d-22c7-4a22-a47d-8c48425ef4a7",
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"))
#'
#' # Occurrence data: lat/long data, and associated metadata with occurrences
#' ## If return='data' the output is a data.frame of all data together
#' ## for easy manipulation
#' occ_search(taxonKey=key, return='data')
#'
#' # Taxonomic hierarchy data
#' ## If return='meta' the output is a list of the hierarch for each record
#' occ_search(taxonKey=key, return='hier')
#'
#' # Search by collector name
#' occ_search(collectorName="smith")
#'
#' # Many collector names
#' occ_search(collectorName=c("smith","BJ Stacey"))
#'
#' # Pass in curl options for extra fun
#' library(httr)
#' occ_search(taxonKey=key, limit=20, return='hier', callopts=verbose())
#'
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
#' occ_search(taxonKey=keys, limit=5, return='data')
#'
#' # Search on latitidue and longitude
#' occ_search(search="kingfisher", decimalLatitude=50, decimalLongitude=-10)
#'
#' # Search on a bounding box
#' ## in well known text format
#' occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
#' key <- name_suggest(q='Aesculus hippocastanum')$key[1]
#' occ_search(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
#' ## or using bounding box, converted to WKT internally
#' occ_search(geometry=c(-125.0,38.4,-121.8,40.9))
#' ## Visualize a WKT area
#' library('rgeos')
#' plot(readWKT('POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))'))
#'
#' # Search on country
#' isocodes[grep("France", isocodes$name),"code"]
#' occ_search(country='US', fields=c('name','country'))
#' occ_search(country='FR', fields=c('name','country'))
#' occ_search(country='DE', fields=c('name','country'))
#'
#' # Get only occurrences with lat/long data
#' occ_search(taxonKey=key, hasCoordinate=TRUE)
#'
#' # Get only occurrences that were recorded as living specimens
#' occ_search(taxonKey=key, basisOfRecord="LIVING_SPECIMEN", hasCoordinate=TRUE)
#'
#' # Get occurrences for a particular eventDate
#' occ_search(taxonKey=key, eventDate="2013")
#' occ_search(taxonKey=key, year="2013")
#' occ_search(taxonKey=key, month="6")
#'
#' # Get occurrences based on depth
#' key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, depth="5")
#'
#' # Get occurrences based on elevation
#' key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, elevation=50, hasCoordinate=TRUE)
#'
#' # Get occurrences based on institutionCode
#' occ_search(institutionCode="TLMF")
#' occ_search(institutionCode=c("TLMF","ArtDatabanken"))
#'
#' # Get occurrences based on collectionCode
#' occ_search(collectionCode="Floristic Databases MV - Higher Plants")
#' occ_search(collectionCode=c("Floristic Databases MV - Higher Plants","Artport"))
#'
#' # Get only those occurrences with spatial issues
#' occ_search(taxonKey=key, spatialIssues=TRUE)
#'
#' # Search using a query string
#' occ_search(search="kingfisher")
#'
#' # Range queries
#' ## See Detail for parameters that support range queries
#' occ_search(depth='50,100') # this is a range depth, with lower/upper limits in character string
#' occ_search(depth=c(50,100)) # this is not a range search, but does two searches for each depth
#'
#' ## Range search with year
#' occ_search(year='1999,2000')
#'
#' ## Range search with latitude
#' occ_search(decimalLatitude='29.59,29.6')
#'
#' # Search by specimen type status
#' ## Look for possible values of the \code{typeStatus} parameter looking at the typestatus dataset
#' occ_search(typeStatus = 'allotype', fields = c('name','typeStatus'))
#'
#' # Search by specimen record number
#' ## This is the record number of the person/group that submitted the data, not GBIF's numbers
#' ## You can see that many different groups have record number 1, so not super helpful
#' occ_search(recordNumber = 1, fields = c('name','recordNumber','recordedBy'))
#'
#' # Search by last time interpreted: Date the record was last modified in GBIF
#' ## The \code{lastInterpreted} parameter accepts ISO 8601 format dates, including
#' ## yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd. Range queries are accepted for \code{lastInterpreted}
#' occ_search(lastInterpreted = '2014-04-02', fields = c('name','lastInterpreted'))
#'
#' # Search by continent
#' ## One of africa, antarctica, asia, europe, north_america, oceania, or south_america
#' occ_search(continent = 'south_america', return = 'meta')
#' occ_search(continent = 'africa', return = 'meta')
#' occ_search(continent = 'oceania', return = 'meta')
#' occ_search(continent = 'antarctica', return = 'meta')
#'
#' # Search for occurrences with images
#' occ_search(mediatype = 'StillImage', return='media')
#' occ_search(mediatype = 'MovingImage', return='media')
#' occ_search(mediatype = 'Sound', return='media')
#' 
#' # Query based on issues - see Details for options
#' occ_search(taxonKey=1, issue='DEPTH_UNLIKELY', fields = 
#'    c('name','key','decimalLatitude','decimalLongitude','depth'))
#'    
#' # Show all records in the Arizona State Lichen Collection that cant be matched to the GBIF 
#' # backbone properly:
#' occ_search(datasetKey='84c0e1a0-f762-11e1-a439-00145eb45e9a', 
#'    issue=c('TAXON_MATCH_NONE','TAXON_MATCH_HIGHERRANK'))
#' }
#' 
#' \donttest{
#' # If you try multiple values for two different parameters you are wacked on the hand
#' occ_search(taxonKey=c(2482598,2492010), collectorName=c("smith","BJ Stacey"))
#'
#' # Get a lot of data, here 1500 records for Helianthus annuus
#' out <- occ_search(taxonKey=key, limit=1500, return="data")
#' nrow(out)
#'
#' # If you pass in an invalid polygon you get hopefully informative errors
#'
#' ### the WKT string is fine, but GBIF says bad polygon
#' wkt <- 'POLYGON((-178.59375 64.83258989321493,-165.9375 59.24622380205539,
#' -147.3046875 59.065977905449806,-130.78125 51.04484764446178,-125.859375 36.70806354647625,
#' -112.1484375 23.367471303759686,-105.1171875 16.093320185359257,-86.8359375 9.23767076398516,
#' -82.96875 2.9485268155066175,-82.6171875 -14.812060061226388,-74.8828125 -18.849111862023985,
#' -77.34375 -47.661687803329166,-84.375 -49.975955187343295,174.7265625 -50.649460483096114,
#' 179.296875 -42.19189902447192,-176.8359375 -35.634976650677295,176.8359375 -31.835565983656227,
#' 163.4765625 -6.528187613695323,152.578125 1.894796132058301,135.703125 4.702353722559447,
#' 127.96875 15.077427674847987,127.96875 23.689804541429606,139.921875 32.06861069132688,
#' 149.4140625 42.65416193033991,159.2578125 48.3160811030533,168.3984375 57.019804336633165,
#' 178.2421875 59.95776046458139,-179.6484375 61.16708631440347,-178.59375 64.83258989321493))'
#'
#' occ_search(geometry = gsub("\n", '', wkt))
#'
#' ### unable to parse due to last number pair needing two numbers, not one
#' wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0,-125.8))'
#' occ_search(geometry = wkt)
#'
#' ### unable to parse due to unclosed string
#' wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0))'
#' occ_search(geometry = wkt)
#' ### another of the same
#' wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0,-125.8 36.7))'
#' occ_search(geometry = wkt)
#'
#' ### returns no results
#' wkt <- 'LINESTRING(3 4,10 50,20 25)'
#' occ_search(geometry = wkt)
#'
#' ### Apparently a point is allowed, but haven't successfully retrieved data, so returns nothing
#' wkt <- 'POINT(45 -122)'
#' occ_search(geometry = wkt)
#' }

occ_search <- function(taxonKey=NULL, scientificName=NULL, country=NULL, publishingCountry=NULL,
  hasCoordinate=NULL, typeStatus=NULL, recordNumber=NULL, lastInterpreted=NULL, continent=NULL,
  geometry=NULL, collectorName=NULL, basisOfRecord=NULL, datasetKey=NULL, eventDate=NULL,
  catalogNumber=NULL, year=NULL, month=NULL, decimalLatitude=NULL, decimalLongitude=NULL,
  elevation=NULL, depth=NULL, institutionCode=NULL, collectionCode=NULL,
  spatialIssues=NULL, issue=NULL, search=NULL, mediatype=NULL, callopts=list(), limit=20, start=NULL,
  fields = 'minimal', return='all')
{
  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("georeferenced","altitude","latitude","longitude") %in% calls
  if(any(calls_vec))
    stop("Parameter name changes: \n georeferenced -> hasCoordinate\n altitude -> elevation\n latitude -> decimalLatitude\n longitude - > decimalLongitude")

  geometry <- geometry_handler(geometry)

  url = 'http://api.gbif.org/v1/occurrence/search'
  getdata <- function(x=NULL, itervar=NULL)
  {
    if(!is.null(x))
      assign(itervar, x)

    # check that wkt is proper format and of 1 of 4 allowed types
    geometry <- check_wkt(geometry)

    # Make arg list
    args <- compact(list(taxonKey=taxonKey, scientificName=scientificName, country=country,
      publishingCountry=publishingCountry, hasCoordinate=hasCoordinate, typeStatus=typeStatus, recordNumber=recordNumber,
      lastInterpreted=lastInterpreted, continent=continent,geometry=geometry, collectorName=collectorName,
      basisOfRecord=basisOfRecord, datasetKey=datasetKey, eventDate=eventDate, catalogNumber=catalogNumber,
      year=year, month=month, decimalLatitude=decimalLatitude, decimalLongitude=decimalLongitude,
      elevation=elevation, depth=depth, institutionCode=institutionCode,
      collectionCode=collectionCode, spatialIssues=spatialIssues, issue=issue, q=search, mediaType=mediatype,
      limit=as.integer(limit), offset=start))

    iter <- 0
    sumreturned <- 0
    outout <- list()
    while(sumreturned < limit){
      iter <- iter + 1
      temp <- GET(url, query=args, callopts)
#       stop_for_status(temp)
      if(temp$status_code > 200){
        stop(content(temp, as = "text"))
      }
      assert_that(temp$headers$`content-type`=='application/json')
      res <- content(temp, as = 'text', encoding = "UTF-8")
      tt <- RJSONIO::fromJSON(res)

      numreturned <- length(tt$results)
      sumreturned <- sumreturned + numreturned

      if(tt$count < limit)
        limit <- tt$count

      if(sumreturned < limit){
        args$limit <- limit-sumreturned
        args$offset <- sumreturned
      }
      outout[[iter]] <- tt
    }

    meta <- outout[[length(outout)]][c('offset','limit','endOfRecords','count')]
    data <- do.call(c, lapply(outout, "[[", "results"))

    if(return=='data'){
      if(identical(data, list())){
        paste("no data found, try a different search")
      } else
      {
        data <- gbifparser(input=data, fields=fields)
        ldfast(lapply(data, "[[", "data"))
      }
    } else
    if(return=='hier'){
      if(identical(data, list())){
        paste("no data found, try a different search")
      } else
      {
        data <- gbifparser(input=data, fields=fields)
        unique(lapply(data, "[[", "hierarchy"))
      }
    } else
      if(return=='media'){
        if(identical(data, list())){
          paste("no data found, try a different search")
        } else
        {
          data <- gbifparser(input=data, fields=fields)
          sapply(data, "[[", "media")
        }
      } else
    if(return=='meta'){
      data.frame(meta, stringsAsFactors=FALSE)
    } else
    {
      if(identical(data, list())){
        dat2 <- paste("no data found, try a different search")
        hier2 <- paste("no data found, try a different search")
        media <- paste("no data found, try a different search")
      } else
      {
        data <- gbifparser(input=data, fields=fields)
        dat2 <- ldfast(lapply(data, "[[", "data"))
        hier2 <- unique(lapply(data, "[[", "hierarchy"))
        media <- unique(lapply(data, "[[", "media"))
      }
      list(meta=meta, hierarchy=hier2, data=dat2, media=media)
    }
  }

  params <- list(taxonKey=taxonKey,scientificName=scientificName,datasetKey=datasetKey,catalogNumber=catalogNumber,
                 collectorName=collectorName,geometry=geometry,country=country,recordNumber=recordNumber,
                 q=search,institutionCode=institutionCode,collectionCode=collectionCode,continent=continent,
                 decimalLatitude=decimalLatitude,decimalLongitude=decimalLongitude,depth=depth,year=year,
                 typeStatus=typeStatus,lastInterpreted=lastInterpreted,mediatype=mediatype)
  if(!any(sapply(params, length)>0))
    stop("at least one of the parmaters taxonKey, scientificName, datasetKey, catalogNumber, collectorName, geometry, country, recordNumber, search, institutionCode, collectionCode, decimalLatitude, decimalLongitude, depth, year, typeStatus, lastInterpreted, continent, or mediatype must have a value")
  iter <- params[which(sapply(params, length)>1)]
  if(length(names(iter))>1)
    stop("You can have multiple values for only one of taxonKey, scientificName, datasetKey, catalogNumber, collectorName, geometry, country, recordNumber, search, institutionCode, collectionCode, decimalLatitude, decimalLongitude, depth, year, typeStatus, lastInterpreted, or continent")

  if(length(iter)==0){
    out <- getdata()
  } else
  {
    out <- lapply(iter[[1]], getdata, itervar = names(iter))
    names(out) <- iter[[1]]
  }

#   class(out) <- "gbif"
#   return(out)
}

geometry_handler <- function(x){
  if(!is.null(x)){
    if(!is.character(x)){
      gbif_bbox2wkt(bbox=x)
    } else { x }
  } else { x }
}

# #' @method print gbif
# #' @export
# #' @rdname occ_search
# print.gbif <- function(x, ...)
# {
# #   if(all(names(x) %in% c('meta', 'hierarchy', 'data', 'media'))){
# #     x <- x[!names(x) %in% 'media']
# #   }
#   
#   function (x, ..., n = 10) 
#   {
#     cat(spocc_wrap(sprintf("Species [%s]", pastemax(x$data))), 
#         "\n")
#     cat(sprintf("First 10 rows of [%s]\n\n", names(x$data)[1]))
#     trunc_mat(occinddf(x), n = n)
#   }
# # 
# #   rows <- lapply(x, function(y) vapply(y$data, nrow, numeric(1)))
# #   perspp <- lapply(rows, function(z) c(sum(z), length(z)))
# #   cat("Summary of results - occurrences found for:", "\n")
# #   cat(" gbif  :", perspp$gbif[1], "records across", perspp$gbif[2], "species", 
# #       "\n")
# #   cat(" bison : ", perspp$bison[1], "records across", perspp$bison[2], "species", 
# #       "\n")
# #   cat(" inat  : ", perspp$inat[1], "records across", perspp$inat[2], "species", 
# #       "\n")
# #   cat(" ebird : ", perspp$ebird[1], "records across", perspp$ebird[2], "species", 
# #       "\n")
# #   cat(" ecoengine : ", perspp$ecoengine[1], "records across", perspp$ecoengine[2], 
# #       "species", "\n")
# #   cat(" antweb : ", perspp$antweb[1], "records across", perspp$antweb[2], 
# #       "species", "\n")
# }