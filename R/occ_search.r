#' Search for GBIF occurrences.
#'
#' @export
#' @importFrom httr GET POST DELETE content stop_for_status http_status add_headers authenticate write_disk content_type_json accept_json
#' @importFrom XML getNodeSet xmlAttrs xmlSApply xmlValue htmlParse xpathApply xmlToList
#'
#' @template occsearch
#' @template oslimstart
#' @template occ
#' @param x Output from a call to occ_search
#' @param n Number of rows of the data to print.
#' @seealso \code{\link{downloads}}
#' @examples \dontrun{
#' # Search by species name, using \code{\link{name_backbone}} first to get key
#' (key <- name_suggest(q='Helianthus annuus', rank='species')$key[1])
#' occ_search(taxonKey=key, limit=2)
#'
#' # Return 20 results, this is the default by the way
#' occ_search(taxonKey=key, limit=20)
#'
#' # Return just metadata for the search
#' occ_search(taxonKey=key, limit=100, return='meta')
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
#' occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data', limit=20)
#'
#' # Search by catalog number
#' occ_search(catalogNumber="49366", limit=20)
#' occ_search(catalogNumber=c("49366","Bird.27847588"), limit=20)
#'
#' # Get all data, not just lat/long and name
#' occ_search(taxonKey=key, fields='all', limit=20)
#'
#' # Or get specific fields. Note that this isn't done on GBIF's side of things. This
#' # is done in R, but before you get the return object, so other fields are garbage
#' # collected
#' occ_search(taxonKey=key, fields=c('name','basisOfRecord','protocol'), limit=20)
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
#'    "7b5d6a48-f762-11e1-a439-00145eb45e9a"), limit=20)
#'
#' # Occurrence data: lat/long data, and associated metadata with occurrences
#' ## If return='data' the output is a data.frame of all data together
#' ## for easy manipulation
#' occ_search(taxonKey=key, return='data', limit=20)
#'
#' # Taxonomic hierarchy data
#' ## If return='meta' the output is a list of the hierarch for each record
#' occ_search(taxonKey=key, return='hier', limit=10)
#'
#' # Search by collector name
#' occ_search(collectorName="smith", limit=20)
#'
#' # Many collector names
#' occ_search(collectorName=c("smith","BJ Stacey"), limit=20)
#'
#' # Pass in curl options for extra fun
#' library('httr')
#' occ_search(taxonKey=key, limit=20, return='hier', config=verbose())
#' # occ_search(taxonKey=key, limit=20, return='hier', config=progress())
#' # occ_search(taxonKey=key, limit=20, return='hier', config=timeout(1))
#'
#' # Search for many species
#' splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
#' keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
#' occ_search(taxonKey=keys, limit=5, return='data')
#'
#' # Search using a synonym name
#' #  Note that you'll see a message printing out that the accepted name will be used
#' occ_search(scientificName = 'Pulsatilla patens', fields = c('name','scientificName'), limit=5)
#'
#' # Search on latitidue and longitude
#' occ_search(search="kingfisher", decimalLatitude=50, decimalLongitude=-10)
#'
#' # Search on a bounding box
#' ## in well known text format
#' occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit=20)
#' key <- name_suggest(q='Aesculus hippocastanum')$key[1]
#' occ_search(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))',
#'    limit=20)
#' ## or using bounding box, converted to WKT internally
#' occ_search(geometry=c(-125.0,38.4,-121.8,40.9), limit=20)
#'
#' # Search on country
#' occ_search(country='US', fields=c('name','country'), limit=20)
#' isocodes[grep("France", isocodes$name),"code"]
#' occ_search(country='FR', fields=c('name','country'), limit=20)
#' occ_search(country='DE', fields=c('name','country'), limit=20)
#' occ_search(country=c('US','DE'), fields=c('name','country'), limit=20)
#'
#' # Get only occurrences with lat/long data
#' occ_search(taxonKey=key, hasCoordinate=TRUE, limit=20)
#'
#' # Get only occurrences that were recorded as living specimens
#' occ_search(taxonKey=key, basisOfRecord="LIVING_SPECIMEN", hasCoordinate=TRUE, limit=20)
#'
#' # Get occurrences for a particular eventDate
#' occ_search(taxonKey=key, eventDate="2013", limit=20)
#' occ_search(taxonKey=key, year="2013", limit=20)
#' occ_search(taxonKey=key, month="6", limit=20)
#'
#' # Get occurrences based on depth
#' key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, depth="5", limit=20)
#'
#' # Get occurrences based on elevation
#' key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
#' occ_search(taxonKey=key, elevation=50, hasCoordinate=TRUE, limit=20)
#'
#' # Get occurrences based on institutionCode
#' occ_search(institutionCode="TLMF", limit=20)
#' occ_search(institutionCode=c("TLMF","ArtDatabanken"), limit=20)
#'
#' # Get occurrences based on collectionCode
#' occ_search(collectionCode="Floristic Databases MV - Higher Plants", limit=20)
#' occ_search(collectionCode=c("Floristic Databases MV - Higher Plants","Artport"))
#'
#' # Get only those occurrences with spatial issues
#' occ_search(taxonKey=key, hasGeospatialIssue=TRUE, limit=20)
#'
#' # Search using a query string
#' occ_search(search="kingfisher", limit=20)
#'
#' # Range queries
#' ## See Detail for parameters that support range queries
#' occ_search(depth='50,100') # this is a range depth, with lower/upper limits in character string
#' occ_search(depth=c(50,100)) # this is not a range search, but does two searches for each depth
#'
#' ## Range search with year
#' occ_search(year='1999,2000', limit=20)
#'
#' ## Range search with latitude
#' occ_search(decimalLatitude='29.59,29.6')
#'
#' # Search by specimen type status
#' ## Look for possible values of the typeStatus parameter looking at the typestatus dataset
#' occ_search(typeStatus = 'allotype', fields = c('name','typeStatus'))
#'
#' # Search by specimen record number
#' ## This is the record number of the person/group that submitted the data, not GBIF's numbers
#' ## You can see that many different groups have record number 1, so not super helpful
#' occ_search(recordNumber = 1, fields = c('name','recordNumber','recordedBy'))
#'
#' # Search by last time interpreted: Date the record was last modified in GBIF
#' ## The lastInterpreted parameter accepts ISO 8601 format dates, including
#' ## yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd. Range queries are accepted for lastInterpreted
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
#' ## one issue
#' occ_search(taxonKey=1, issue='DEPTH_UNLIKELY', fields =
#'    c('name','key','decimalLatitude','decimalLongitude','depth'))
#' ## two issues
#' occ_search(taxonKey=1, issue=c('DEPTH_UNLIKELY','COORDINATE_ROUNDED'))
#' # Show all records in the Arizona State Lichen Collection that cant be matched to the GBIF
#' # backbone properly:
#' occ_search(datasetKey='84c0e1a0-f762-11e1-a439-00145eb45e9a',
#'    issue=c('TAXON_MATCH_NONE','TAXON_MATCH_HIGHERRANK'))
#'
#' # Parsing output by issue
#' (res <- occ_search(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit = 50))
#' ## what do issues mean, can print whole table, or search for matches
#' head(gbif_issues())
#' gbif_issues()[ gbif_issues()$code %in% c('cdround','cudc','gass84','txmathi'), ]
#' ## or parse issues in various ways
#' ### remove data rows with certain issue classes
#' library('magrittr')
#' res %>% occ_issues(gass84)
#' ### split issues into separate columns
#' res %>% occ_issues(mutate = "split")
#' ### expand issues to more descriptive names
#' res %>% occ_issues(mutate = "expand")
#' ### split and expand
#' res %>% occ_issues(mutate = "split_expand")
#' ### split, expand, and remove an issue class
#' res %>% occ_issues(-cudc, mutate = "split_expand")
#'
#' # If you try multiple values for two different parameters you are wacked on the hand
#' # occ_search(taxonKey=c(2482598,2492010), collectorName=c("smith","BJ Stacey"))
#'
#' # Get a lot of data, here 1500 records for Helianthus annuus
#' # out <- occ_search(taxonKey=key, limit=1500, return="data")
#' # nrow(out)
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
#' # occ_search(geometry = gsub("\n", '', wkt))
#'
#' ### unable to parse due to last number pair needing two numbers, not one
#' # wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0,-125.8))'
#' # occ_search(geometry = wkt)
#'
#' ### unable to parse due to unclosed string
#' # wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0))'
#' # occ_search(geometry = wkt)
#' ### another of the same
#' # wkt <- 'POLYGON((-178.5 64.8,-165.9 59.2,-147.3 59.0,-130.7 51.0,-125.8 36.7))'
#' # occ_search(geometry = wkt)
#'
#' ### returns no results
#' # wkt <- 'LINESTRING(3 4,10 50,20 25)'
#' # occ_search(geometry = wkt)
#'
#' ### Apparently a point is allowed, but haven't successfully retrieved data, so returns nothing
#' # wkt <- 'POINT(45 -122)'
#' # occ_search(geometry = wkt)
#' }

occ_search <- function(taxonKey=NULL, scientificName=NULL, country=NULL, publishingCountry=NULL,
  hasCoordinate=NULL, typeStatus=NULL, recordNumber=NULL, lastInterpreted=NULL, continent=NULL,
  geometry=NULL, collectorName=NULL, basisOfRecord=NULL, datasetKey=NULL, eventDate=NULL,
  catalogNumber=NULL, year=NULL, month=NULL, decimalLatitude=NULL, decimalLongitude=NULL,
  elevation=NULL, depth=NULL, institutionCode=NULL, collectionCode=NULL,
  hasGeospatialIssue=NULL, issue=NULL, search=NULL, mediatype=NULL, limit=500, start=0,
  fields = 'all', return='all', ...) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("georeferenced","altitude","latitude","longitude") %in% calls
  if(any(calls_vec))
    stop("Parameter name changes: \n georeferenced -> hasCoordinate\n altitude -> elevation\n latitude -> decimalLatitude\n longitude - > decimalLongitude")

  geometry <- geometry_handler(geometry)

  url <- paste0(gbif_base(), '/occurrence/search')
  getdata <- function(x=NULL, itervar=NULL) {
    if(!is.null(x))
      assign(itervar, x)

    # check that wkt is proper format and of 1 of 4 allowed types
    geometry <- check_wkt(geometry)

    # check limit and start params
    check_vals(limit, "limit")
    check_vals(start, "start")

    # Check synonym if scientificName was given
    if (!is.null(scientificName)) {
      sciname_old <- scientificName
      namecheck <- name_backbone(scientificName)
      if (namecheck$synonym){
        scientificName <- namecheck[[tolower(namecheck$rank)]]
        message(sprintf("%s is a synonym of %s \n the latter used & will include synonym records", sciname_old, scientificName))
      }
    }

    # Make arg list
    args <- rgbif_compact(list(taxonKey=taxonKey, scientificName=scientificName, country=country,
      publishingCountry=publishingCountry, hasCoordinate=hasCoordinate, typeStatus=typeStatus,
      recordNumber=recordNumber, lastInterpreted=lastInterpreted, continent=continent,
      geometry=geometry, collectorName=collectorName, basisOfRecord=basisOfRecord,
      datasetKey=datasetKey, eventDate=eventDate, catalogNumber=catalogNumber,
      year=year, month=month, decimalLatitude=decimalLatitude,
      decimalLongitude=decimalLongitude, elevation=elevation, depth=depth,
      institutionCode=institutionCode, collectionCode=collectionCode,
      hasGeospatialIssue=hasGeospatialIssue, q=search, mediaType=mediatype,
      limit=check_limit(as.integer(limit)), offset=check_limit(as.integer(start))))
    args <- c(args, parse_issues(issue))
    argscoll <<- args

    iter <- 0
    sumreturned <- 0
    outout <- list()
    while (sumreturned < limit) {
      iter <- iter + 1
      tt <- gbif_GET(url, args, FALSE, ...)

      # if no results, assign count var with 0
      if (identical(tt$results, list())) tt$count <- 0

      numreturned <- length(tt$results)
      sumreturned <- sumreturned + numreturned

      if (tt$count < limit)
        limit <- tt$count

      if (sumreturned < limit) {
        args$limit <- limit - sumreturned
        args$offset <- sumreturned + start
      }
      outout[[iter]] <- tt
    }

    meta <- outout[[length(outout)]][c('offset', 'limit', 'endOfRecords', 'count')]
    data <- do.call(c, lapply(outout, "[[", "results"))

    if (return == 'data') {
      if (identical(data, list())) {
        paste("no data found, try a different search")
      } else {
        data <- gbifparser(input = data, fields = fields)
        ldfast(lapply(data, "[[", "data"))
      }
    } else if (return == 'hier') {
      if (identical(data, list())) {
        paste("no data found, try a different search")
      } else {
        data <- gbifparser(input = data, fields = fields)
        unique(lapply(data, "[[", "hierarchy"))
      }
    } else if (return == 'media') {
      if (identical(data, list())) {
        paste("no data found, try a different search")
      } else {
        data <- gbifparser(input=data, fields=fields)
        sapply(data, "[[", "media")
      }
    } else if (return == 'meta'){
      data.frame(meta, stringsAsFactors=FALSE)
    } else {
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
                 collectorName=collectorName,geometry=geometry,country=country,
                 publishingCountry=publishingCountry,recordNumber=recordNumber,
                 q=search,institutionCode=institutionCode,collectionCode=collectionCode,continent=continent,
                 decimalLatitude=decimalLatitude,decimalLongitude=decimalLongitude,depth=depth,year=year,
                 typeStatus=typeStatus,lastInterpreted=lastInterpreted,mediatype=mediatype,
                 limit=limit)
  if (!any(sapply(params, length) > 0))
    stop(sprintf("At least one of the parmaters must have a value:\n%s", possparams()), call. = FALSE)
  iter <- params[which(sapply(params, length) > 1)]
  if (length(names(iter)) > 1)
    stop(sprintf("You can have multiple values for only one of:\n%s", possparams()), call. = FALSE)

  if (length(iter) == 0) {
    out <- getdata()
  } else {
    out <- lapply(iter[[1]], getdata, itervar = names(iter))
    names(out) <- iter[[1]]
  }

  if(any(names(argscoll) %in% names(iter))){
    argscoll[[names(iter)]] <- iter[[names(iter)]]
  }
  argscoll$fields <- fields

  if (is(out, "data.frame")) {
    class(out) <- c('data.frame', 'gbif')
  } else {
    class(out) <- "gbif"
    attr(out, 'type') <- if (length(iter) == 0) "single" else "many"
  }
  structure(out, return = return, args = argscoll)
}

geometry_handler <- function(x){
  if(!is.null(x)){
    if(!is.character(x)){
      gbif_bbox2wkt(bbox=x)
    } else { x }
  } else { x }
}

#' @method print gbif
#' @export
#' @rdname occ_search
print.gbif <- function(x, ..., n = 10) {
  if (attr(x, "type") == "single" & all(c('meta','data','hierarchy','media') %in% names(x))){
    cat(rgbif_wrap(sprintf("Records found [%s]", x$meta$count)), "\n")
    cat(rgbif_wrap(sprintf("Records returned [%s]", NROW(x$data))), "\n")
    cat(rgbif_wrap(sprintf("No. unique hierarchies [%s]", length(x$hierarchy))), "\n")
    cat(rgbif_wrap(sprintf("No. media records [%s]", length(x$media))), "\n")
    cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
    cat(sprintf("First 10 rows of data\n\n"))
    if (is(x$data, "data.frame")) trunc_mat(x$data, n = n) else cat(x$data)
  } else if (attr(x, "type") == "many") {
    if (!attr(x, "return") == "all") {
      if(is(x, "gbif")) x <- unclass(x)
      attr(x, "type") <- NULL
      attr(x, "return") <- NULL
      print(x)
    } else {
      cat(rgbif_wrap(sprintf("Occ. found [%s]", pastemax(x))), "\n")
      cat(rgbif_wrap(sprintf("Occ. returned [%s]", pastemax(x, "returned"))), "\n")
      cat(rgbif_wrap(sprintf("No. unique hierarchies [%s]", pastemax(x, "hier"))), "\n")
      cat(rgbif_wrap(sprintf("No. media records [%s]", pastemax(x, "media"))), "\n")
      cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
      cat(sprintf("First 10 rows of data from %s\n\n", names(x)[1]))
      if(is(x[[1]]$data, "data.frame")) trunc_mat(x[[1]]$data, n = n) else cat(x[[1]]$data)
    }
  } else {
    if(is(x, "gbif")) x <- unclass(x)
    attr(x, "type") <- NULL
    attr(x, "return") <- NULL
    print(x)
  }
}

pasteargs <- function(b){
  arrrgs <- attr(b, "args")
  arrrgs <- rgbif_compact(arrrgs)
  tt <- list(); for(i in seq_along(arrrgs)){ tt[[i]] <- sprintf("%s=%s", names(arrrgs)[i],
          if(length(arrrgs[[i]]) > 1) paste0(arrrgs[[i]], collapse = ",") else arrrgs[[i]]) }
  paste0(tt, collapse = ", ")
}

pastemax <- function(z, type='counts', n=10){
  xnames <- names(z)
  xnames <- sapply(xnames, function(x) if(nchar(x)>8) paste0(substr(x, 1, 6), "..", collapse = "") else x, USE.NAMES = FALSE)
  yep <- switch(type,
         counts = vapply(z, function(y) y$meta$count, numeric(1), USE.NAMES = FALSE),
         returned = vapply(z, function(y) NROW(y$data), numeric(1), USE.NAMES = FALSE),
         hier = vapply(z, function(y) length(y$hierarchy), numeric(1), USE.NAMES = FALSE),
         media = vapply(z, function(y) length(y$media), numeric(1), USE.NAMES = FALSE)
  )
  tt <- list(); for(i in seq_along(xnames)){ tt[[i]] <- sprintf("%s (%s)", xnames[i], yep[[i]]) }
  paste0(tt, collapse = ", ")
}

parse_issues <- function(x){
  sapply(x, function(y) list(issue = y), USE.NAMES = FALSE)
}

check_limit <- function(x){
  if(x > 1000000L)
    stop("
      Maximum request size is 1 million. As a solution, either use the
      GBIF web interface, or in R, split up your request in a way that
      makes sense for your use case. E.g., you could split up your
      request into geographic chunks, by country or by bounding box. Or
      you could split up your request taxonomically, e.g., if you want
      data for all species in a large family of birds, split up by
      some higher taxonomic level, like tribe or genus.")
  else
    x
}

possparams <- function(){
  "   taxonKey, scientificName, datasetKey, catalogNumber, collectorName, geometry,
   country, publishingCountry, recordNumber, search, institutionCode, collectionCode,
   decimalLatitude, decimalLongitude, depth, year, typeStatus, lastInterpreted,
   continent, or mediatype"
}

check_vals <- function(x, y){
  if(is.na(x) || is.null(x)) stop(sprintf("%s can not be NA or NULL", y), call. = FALSE)
  if(length(x) > 1) stop(sprintf("%s has to be length 1", y), call. = FALSE)
}
