#' Search for GBIF occurrences.
#'
#' @import httr plyr assertthat
#' @importFrom RJSONIO fromJSON
#' @export
#' @template occsearch
#' @template occ
#' @template all
#' @param x Output from a call to occ_search
#' @param ... Further print args not used.
#' @param n Number of rows of the data to print.
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
#' occ_search(country='US', fields=c('name','country'))
#' isocodes[grep("France", isocodes$name),"code"]
#' occ_search(country='FR', fields=c('name','country'))
#' occ_search(country='DE', fields=c('name','country'))
#' occ_search(country=c('US','DE'), fields=c('name','country'))
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
#' occ_search(taxonKey=1, issue='DEPTH_UNLIKELY', fields = 
#'    c('name','key','decimalLatitude','decimalLongitude','depth'))
#' }
#' 
#' \donttest{
#' #### FIXME: ISSUES NEED TO BE PASSED IN AS MULTIPLE ISSUE PARAMETERS, FIX THIS
#' # Show all records in the Arizona State Lichen Collection that cant be matched to the GBIF 
#' # backbone properly:
#' occ_search(datasetKey='84c0e1a0-f762-11e1-a439-00145eb45e9a', 
#'    issue=c('TAXON_MATCH_NONE','TAXON_MATCH_HIGHERRANK'))
#'    
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
    args <- rgbif_compact(list(taxonKey=taxonKey, scientificName=scientificName, country=country,
      publishingCountry=publishingCountry, hasCoordinate=hasCoordinate, typeStatus=typeStatus, recordNumber=recordNumber,
      lastInterpreted=lastInterpreted, continent=continent,geometry=geometry, collectorName=collectorName,
      basisOfRecord=basisOfRecord, datasetKey=datasetKey, eventDate=eventDate, catalogNumber=catalogNumber,
      year=year, month=month, decimalLatitude=decimalLatitude, decimalLongitude=decimalLongitude,
      elevation=elevation, depth=depth, institutionCode=institutionCode,
      collectionCode=collectionCode, spatialIssues=spatialIssues, issue=issue, q=search, mediaType=mediatype,
      limit=as.integer(limit), offset=start))
    argscoll <<- args 

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

  if(any(names(argscoll) %in% names(iter))){
    argscoll[[names(iter)]] <- iter[[names(iter)]]
  }
  argscoll$fields <- fields

  if(is(out, "data.frame")){
    class(out) <- c('data.frame','gbif')
  } else { 
    class(out) <- "gbif"
    attr(out, 'type') <- if(length(iter)==0) "single" else "many"
  }
  attr(out, 'return') <- return
  attr(out, 'args') <- argscoll
  
  return(out)
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
print.gbif <- function (x, ..., n = 10)
{
  if(attr(x, "type") == "single" & all(c('meta','data','hierarchy','media') %in% names(x))){  
    cat(rgbif_wrap(sprintf("Records found [%s]", x$meta$count)), "\n")
    cat(rgbif_wrap(sprintf("Records returned [%s]", NROW(x$data))), "\n")
    cat(rgbif_wrap(sprintf("No. unique hierarchies [%s]", length(x$hierarchy))), "\n")
    cat(rgbif_wrap(sprintf("No. media records [%s]", length(x$media))), "\n")
    cat(rgbif_wrap(sprintf("Args [%s]", pasteargs(x))), "\n")
    cat(sprintf("First 10 rows of data\n\n"))
    if(is(x$data, "data.frame")) trunc_mat(x$data, n = n) else cat(x$data)
  } else if(attr(x, "type") == "many") {
    if(!attr(x, "return") == "all"){
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

trunc_mat <- function(x, n = NULL){
  rows <- nrow(x)
  if (!is.na(rows) && rows == 0)
    return()
  if (is.null(n)) {
    if (is.na(rows) || rows > 100) { n <- 10 }
    else { n <- rows }
  }
  df <- as.data.frame(head(x, n))
  if (nrow(df) == 0)
    return()
  #   is_list <- vapply(df, is.list, logical(1))
  #   df[is_list] <- lapply(df[is_list], function(x) vapply(x, obj_type, character(1)))
  mat <- format(df, justify = "left")
  width <- getOption("width")
  values <- c(format(rownames(mat))[[1]], unlist(mat[1, ]))
  names <- c("", colnames(mat))
  w <- pmax(nchar(values), nchar(names))
  cumw <- cumsum(w + 1)
  too_wide <- cumw[-1] > width
  if (all(too_wide)) {
    too_wide[1] <- FALSE
    df[[1]] <- substr(df[[1]], 1, width)
  }
  shrunk <- format(df[, !too_wide, drop = FALSE])
  needs_dots <- is.na(rows) || rows > n
  if (needs_dots) {
    dot_width <- pmin(w[-1][!too_wide], 3)
    dots <- vapply(dot_width, function(i) paste(rep(".", i), collapse = ""), FUN.VALUE = character(1))
    shrunk <- rbind(shrunk, .. = dots)
  }
  print(shrunk)
  if (any(too_wide)) {
    vars <- colnames(mat)[too_wide]
    types <- vapply(df[too_wide], type_sum, character(1))
    var_types <- paste0(vars, " (", types, ")", collapse = ", ")
    cat(rgbif_wrap("Variables not shown: ", var_types), "\n", sep = "")
  }
}

rgbif_wrap <- function (..., indent = 0, width = getOption("width")){
  x <- paste0(..., collapse = "")
  wrapped <- strwrap(x, indent = indent, exdent = indent + 5, width = width)
  paste0(wrapped, collapse = "\n")
}

#' Type summary
#' @export
#' @keywords internal
type_sum <- function (x) UseMethod("type_sum")

#' @method type_sum default
#' @export
#' @rdname type_sum
type_sum.default <- function (x) unname(abbreviate(class(x)[1], 4))

#' @method type_sum character
#' @export
#' @rdname type_sum
type_sum.character <- function (x) "chr"

#' @method type_sum Date
#' @export
#' @rdname type_sum
type_sum.Date <- function (x) "date"

#' @method type_sum factor
#' @export
#' @rdname type_sum
type_sum.factor <- function (x) "fctr"  

#' @method type_sum integer
#' @export
#' @rdname type_sum
type_sum.integer <- function (x) "int"

#' @method type_sum logical
#' @export
#' @rdname type_sum
type_sum.logical <- function (x) "lgl"

#' @method type_sum array
#' @export
#' @rdname type_sum
type_sum.array <- function (x){
  paste0(NextMethod(), "[", paste0(dim(x), collapse = ","), 
         "]")
}

#' @method type_sum matrix
#' @export
#' @rdname type_sum
type_sum.matrix <- function (x){
  paste0(NextMethod(), "[", paste0(dim(x), collapse = ","),
         "]")
}

#' @method type_sum numeric
#' @export
#' @rdname type_sum
type_sum.numeric <- function (x) "dbl"

#' @method type_sum POSIXt
#' @export
#' @rdname type_sum
type_sum.POSIXt <- function (x) "time"

obj_type <- function (x)
{
  if (!is.object(x)) {
    paste0("<", type_sum(x), if (!is.array(x))
      paste0("[", length(x), "]"), ">")
  }
  else if (!isS4(x)) {
    paste0("<S3:", paste0(class(x), collapse = ", "), ">")
  }
  else {
    paste0("<S4:", paste0(is(x), collapse = ", "), ">")
  }
}

# pastemax <- function (z, n = 10){
#     rrows <- vapply(z, nrow, integer(1))
#     tt <- list()
#     for (i in seq_along(rrows)) {
#       tt[[i]] <- sprintf("%s (%s)", gsub("_", " ", names(rrows[i])), 
#                          rrows[[i]])
#     }
#     paste0(tt, collapse = ", ")
# }