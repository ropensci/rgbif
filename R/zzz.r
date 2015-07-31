get_hier <- function(x, h1, h2){
  name <- data.frame(t(data.frame(x[names(x) %in% h1], stringsAsFactors=FALSE)), stringsAsFactors=FALSE)
  if(nrow(name)==0){
    data.frame(name=NA, key=NA, rank=NA, row.names=NULL, stringsAsFactors=FALSE)
  } else {
    name$ranks <- row.names(name)
    name <- name[order(match(name$ranks, h1)), ]
    tt <- as.matrix(name[,1])
    row.names(tt) <- name[,2]
    name <- tt
    key <- t(data.frame(x[names(x) %in% h2], stringsAsFactors=FALSE))
    data.frame(name=name, key=key, rank=row.names(name), row.names=NULL, stringsAsFactors=FALSE)
  }
}

#' Parser for gbif data
#' @param input A list
#' @param fields (character) Default ('minimal') will return just taxon name, key, latitude, and
#'    longitute. 'all' returns all fields. Or specify each field you want returned by name, e.g.
#'    fields = c('name','latitude','altitude').
#' @export
#' @keywords internal
gbifparser <- function(input, fields='minimal'){
  parse <- function(x){
    x[sapply(x, length) == 0] <- "none"
    h1 <- c('kingdom','phylum','class','order','family','genus','species')
    h2 <- c('kingdomKey','phylumKey','classKey','orderKey','familyKey','genusKey','speciesKey')
    hier <- get_hier(x, h1, h2)
    if (nrow(na.omit(hier)) == 0){
      if (!is.null(x[['species']])){
        usename <- x[['species']]
      } else if(!is.null(x[['scientificName']])) {
        usename <- x[['scientificName']]
      } else {
        usename <- "none"
      }
    } else {
      usename <- hier[[nrow(hier),"name"]]
    }

    # issues
    x[names(x) %in% "issues"] <- collapse_issues(x)

    # media
    if ("media" %in% names(x)) {
      media <- x[names(x) %in% "media"]
      media <- lapply(media$media, as.list)
      media2 <- list()
      iter <- seq(1, length(media), 2)
      for(i in iter){
        media2[[i]] <- as.list(unlist(c(media[i], media[i+1])))
      }
      media2 <- rgbif_compact(media2)
      media2$key <- x$key
      media2$species <- x$species
      media2$decimalLatitude <- x$decimalLatitude
      media2$decimalLongitude <- x$decimalLongitude
      media2$country <- x$country
      media2 <- list(media2)
      names(media2) <- x$key
      x <- x[!names(x) %in% "media"] # remove images
    } else { media2 <- list() }

    # all other data
    alldata <- data.frame(name=usename, x, stringsAsFactors=FALSE)
    if(any(fields=='minimal')){
      if(all(c('decimalLatitude','decimalLongitude') %in% names(alldata)))
      {
        alldata <- alldata[c('name','key','decimalLatitude','decimalLongitude','issues')]
      } else {
        alldata <- data.frame(alldata['name'], alldata['key'],
                              decimalLatitude=NA, decimalLongitude=NA,
                              alldata['issues'], stringsAsFactors=FALSE)
      }
    } else if(any(fields == 'all')) {
      # rearrange columns
      firstnames <- c('name','key','decimalLatitude','decimalLongitude','issues')
      alldata <- alldata[c(firstnames[firstnames %in% names(alldata)],
                names(alldata)[-unlist(rgbif_compact(sapply(firstnames, function(z) { tmp <- grep(z, names(alldata)); if(!length(tmp) == 0) tmp }, USE.NAMES = FALSE)))] ) ]
    } else {
      alldata <- alldata[names(alldata) %in% fields]
    }
    list(hierarchy=hier, media=media2, data=alldata)
  }
  if(is.numeric(input[[1]])){
    parse(input)
  } else {
    lapply(input, parse)
  }
}

#' Parser for gbif data
#' @param input A list
#' @param fields (character) Default ('minimal') will return just taxon name, key, decimalLatitude, and
#'    decimalLongitute. 'all' returns all fields. Or specify each field you want returned by name, e.g.
#'    fields = c('name','decimalLatitude','altitude').
#' @export
#' @keywords internal
gbifparser_verbatim <- function(input, fields='minimal'){
  parse <- function(x){
#     alldata <- data.frame(key=x$key, x$fields, stringsAsFactors=FALSE)
    nn <- vapply(names(x), function(z){
      tmp <- strsplit(z, "/")[[1]]
      tmp[length(tmp)]
    }, "", USE.NAMES = FALSE)

    names(x) <- nn

    if(any(fields=='minimal')){
      if(all(c('decimalLatitude','decimalLongitude') %in% names(x))) {
        x[c('scientificName','key','decimalLatitude','decimalLongitude')]
      } else {
        list(scientificName=x[['scientificName']], key=x[['key']], decimalLatitude=NA, decimalLongitude=NA, stringsAsFactors=FALSE)
      }
    } else if(any(fields == 'all')) {
      x[vapply(x, length, 0) == 0] <- "none"
      x
    } else {
      x[vapply(x, length, 0) == 0] <- "none"
      x[names(x) %in% fields]
    }
  }
  if(is.numeric(input[[1]])){
    data.frame(parse(input), stringsAsFactors = FALSE)
  } else {
    do.call(rbind_fill, lapply(input, function(w) data.frame(parse(w), stringsAsFactors = FALSE)))
  }
}


ldfast <- function(x, convertvec=FALSE){
  if (convertvec)
    do.call(rbind_fill, lapply(x, convert2df))
  else
    do.call(rbind_fill, x)
}

ldfast_names <- function(x, convertvec=FALSE){
  for (i in seq_along(x)) {
    x[[i]] <- data.frame(.id = names(x)[i], x[[i]], stringsAsFactors = FALSE)
  }
  if (convertvec) {
    do.call(rbind_fill, lapply(x, convert2df))
  } else {
    do.call(rbind_fill, x)
  }
}

convert2df <- function(x){
  if (!inherits(x, "data.frame"))
    data.frame(rbind(x), stringsAsFactors = FALSE)
  else
    x
}

rbind_rows <- function(x) {
  tmp <- unname(do.call("rbind.data.frame", x))
  tmp <- data.frame(.id = row.names(tmp), V1 = tmp, stringsAsFactors = FALSE)
  row.names(tmp) <- NULL
  tmp
}

#' Parser for gbif data
#' @param input A list
#' @param minimal Get minimal input, default to TRUE
#' @export
#' @keywords internal
datasetparser <- function(input, minimal=TRUE){
  parse <- function(x){
    x[sapply(x, length) == 0] <- "none"
    contacts <- ldfast(x$contacts, TRUE)
    endpoints <- ldfast(x$endpoints, TRUE)
    identifiers <- ldfast(x$identifiers, TRUE)
    rest <- x[!names(x) %in% c('contacts','endpoints','identifiers')]
    list(other=rest, contacts=contacts, endpoints=endpoints, identifiers=identifiers)
  }
  if(is.character(input[[1]])){
    parse(input)
  } else {
    lapply(input, parse)
  }
}

#' Lookup-table for 2 character country ISO codes
#' @name isocodes
#' @docType data
#' @keywords data
NULL

#' Custom ggplot2 theme
#' @import ggplot2
#' @export
#' @keywords internal
blanktheme <- function(){
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        plot.margin = u_nit())
}

u_nit <- function() {
  structure(c(0, 0, 0, 0), unit = c("null", "null", "null", "null"
  ), valid.unit = c(5L, 5L, 5L, 5L), class = "unit")
}


#' Capitalize the first letter of a character string.
#'
#' @param s A character string
#' @param strict Should the algorithm be strict about capitalizing. Defaults to FALSE.
#' @param onlyfirst Capitalize only first word, lowercase all others. Useful for
#'   	taxonomic names.
#' @examples
#' gbif_capwords(c("using AIC for model selection"))
#' gbif_capwords(c("using AIC for model selection"), strict=TRUE)
#' @export
#' @keywords internal
gbif_capwords <- function(s, strict = FALSE, onlyfirst = FALSE) {
  cap <- function(s) paste(toupper(substring(s,1,1)),
  {s <- substring(s,2); if(strict) tolower(s) else s}, sep = "", collapse = " " )
  if(!onlyfirst){
    sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
  } else {
    sapply(s, function(x)
      paste(toupper(substring(x,1,1)),
            tolower(substring(x,2)),
            sep="", collapse=" "), USE.NAMES=F)
  }
}

#' Get the possible values to be used for (taxonomic) rank arguments in GBIF
#'   	API methods.
#'
#' @examples \dontrun{
#' taxrank()
#' }
#' @export
taxrank <- function() {
  c("kingdom", "phylum", "class", "order", "family", "genus", "species",
    "infraspecific")
}

#' Parser for name_usage endpoints, for fxns name_lookup and name_backbone
#'
#' @param x A list.
#' @export
#' @keywords internal
namelkupparser <- function(x){
  tmp <- x[ !names(x) %in% c("descriptions", "vernacularNames", "higherClassificationMap") ]
  tmp <- lapply(tmp, function(x) {
    if (length(x) == 0) {
      NA
    } else if (length(x) > 1 || is(x, "list")) {
      paste0(x, collapse = ", ")
    } else {
      x
    }
  })
  df <- data.frame(tmp, stringsAsFactors = FALSE)
  movecols(df, c('key', 'scientificName'))
}

nameusageparser <- function(z){
  tomove <- c('key', 'scientificName')
  tmp <- lapply(z, function(y) {
    if (length(y) == 0) NA else y
  })
  df <- data.frame(tmp, stringsAsFactors = FALSE)
  if (all(tomove %in% names(df))) {
    movecols(df, tomove)
  } else {
    df
  }
}

# if (is(y, "list")) {
#   lapply(y, function(w) if (length(w) == 0) NA else w)
# } else {

movecols <- function(x, cols){
  other <- names(x)[ !names(x) %in% cols ]
  x[ , c(cols, other) ]
}

backbone_parser <- function(x){
  tmp <- lapply(x, function(x) if (length(x) == 0) NA else x)
  data.frame(tmp, stringsAsFactors = FALSE)
}

#' Parse results from call to occurrencelist endpoint
#'
#' @param x A list
#' @param ... Further args passed on to gbifxmlToDataFrame
#' @param removeZeros remove zeros or not
#' @export
#' @keywords internal
parseresults <- function(x, ..., removeZeros=removeZeros)
{
  df <- gbifxmlToDataFrame(x, ...)

  if(nrow(df[!is.na(df$decimalLatitude),])==0){
    return( df )
  } else
  {
    df <- commas_to_periods(df)

    df_num <- df[!is.na(df$decimalLatitude),]
    df_nas <- df[is.na(df$decimalLatitude),]

    df_num$decimalLongitude <- as.numeric(df_num$decimalLongitude)
    df_num$decimalLatitude <- as.numeric(df_num$decimalLatitude)
    i <- df_num$decimalLongitude == 0 & df_num$decimalLatitude == 0
    if (removeZeros) {
      df_num <- df_num[!i, ]
    } else {
      df_num[i, "decimalLatitude"] <- NA
      df_num[i, "decimalLongitude"] <- NA
    }
    temp <- rbind(df_num, df_nas)
    return( temp )
  }
}


#' Convert commas to periods in lat/long data
#'
#' @param dataframe A data.frame
#' @export
#' @keywords internal
commas_to_periods <- function(dataframe) {
  dataframe$decimalLatitude <- gsub("\\,", ".", dataframe$decimalLatitude)
  dataframe$decimalLongitude <- gsub("\\,", ".", dataframe$decimalLongitude)
  return( dataframe )
}


# Code based on the `gbifxmlToDataFrame` function from dismo package
# (http://cran.r-project.org/web/packages/dismo/index.html),
# by Robert Hijmans, 2012-05-31, License: GPL v3
gbifxmlToDataFrame <- function(doc, format) {
  nodes <- getNodeSet(doc, "//to:TaxonOccurrence")
  if (length(nodes) == 0)
    return(data.frame())
  if (!is.null(format) & format == "darwin") {
    varNames <- c("occurrenceID", "country", "stateProvince",
                  "county", "locality", "decimalLatitude", "decimalLongitude",
                  "coordinateUncertaintyInMeters", "maximumElevationInMeters",
                  "minimumElevationInMeters", "maximumDepthInMeters",
                  "minimumDepthInMeters", "institutionCode", "collectionCode",
                  "catalogNumber", "basisOfRecordString", "collector",
                  "earliestDateCollected", "latestDateCollected", "gbifNotes")
  } else {
    varNames <- c("occurrenceID", "country", "decimalLatitude", "decimalLongitude",
                  "catalogNumber", "earliestDateCollected", "latestDateCollected" )
  }
  dims <- c(length(nodes), length(varNames))
  ans <- as.data.frame(replicate(dims[2], rep(as.character(NA),
                                              dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
  names(ans) <- varNames
  for (i in seq(length = dims[1])) {
    ans[i, 1] <- xmlAttrs(nodes[[i]])[['gbifKey']]
    ans[i, -1] <- xmlSApply(nodes[[i]], xmlValue)[varNames[-1]]
  }
  nodes <- getNodeSet(doc, "//to:Identification")
  varNames <- c("taxonName")
  dims = c(length(nodes), length(varNames))
  tax = as.data.frame(replicate(dims[2], rep(as.character(NA),
                                             dims[1]), simplify = FALSE), stringsAsFactors = FALSE)
  names(tax) = varNames
  for (i in seq(length = dims[1])) {
    tax[i, ] = xmlSApply(nodes[[i]], xmlValue)[varNames]
  }
  cbind(tax, ans)
}

#' Convert a bounding box to a Well Known Text polygon, and a WKT to a bounding box
#'
#' @param minx Minimum x value, or the most western longitude
#' @param miny Minimum y value, or the most southern latitude
#' @param maxx Maximum x value, or the most eastern longitude
#' @param maxy Maximum y value, or the most northern latitude
#' @param bbox A vector of length 4, with the elements: minx, miny, maxx, maxy
#' @return gbif_bbox2wkt returns an object of class charactere, a Well Known Text string
#' of the form 'POLYGON((minx miny, maxx miny, maxx maxy, minx maxy, minx miny))'.
#'
#' gbif_wkt2bbox returns a numeric vector of length 4, like c(minx, miny, maxx, maxy).
#' @export
#' @examples \dontrun{
#' # Convert a bounding box to a WKT
#' ## Pass in a vector of length 4 with all values
#' mm <- gbif_bbox2wkt(bbox=c(38.4,-125.0,40.9,-121.8))
#' read_wkt(mm)
#'
#' ## Or pass in each value separately
#' mm <- gbif_bbox2wkt(minx=38.4, miny=-125.0, maxx=40.9, maxy=-121.8)
#' read_wkt(mm)
#'
#' # Convert a WKT object to a bounding box
#' wkt <- "POLYGON((38.4 -125,40.9 -125,40.9 -121.8,38.4 -121.8,38.4 -125))"
#' gbif_wkt2bbox(wkt)
#' }

gbif_bbox2wkt <- function(minx=NA, miny=NA, maxx=NA, maxy=NA, bbox=NULL){
  if(is.null(bbox)) bbox <- c(minx, miny, maxx, maxy)

  stopifnot(length(bbox)==4) #check for 4 digits
  stopifnot(noNA(bbox)) #check for NAs
  stopifnot(is.numeric(as.numeric(bbox))) #check for numeric-ness
  paste('POLYGON((',
        sprintf('%s %s',bbox[1],bbox[2]), ',', sprintf(' %s %s',bbox[3],bbox[2]), ',',
        sprintf(' %s %s',bbox[3],bbox[4]), ',', sprintf(' %s %s',bbox[1],bbox[4]), ',',
        sprintf(' %s %s',bbox[1],bbox[2]),
        '))', sep="")
}

#' @param wkt A Well Known Text object.
#' @export
#' @rdname gbif_bbox2wkt

gbif_wkt2bbox <- function(wkt=NULL){
  stopifnot(!is.null(wkt))
  tmp <- read_wkt(wkt)$bbox
  as.vector(tmp)
}

rgbif_compact <- function (l) Filter(Negate(is.null), l)

compact_null <- function (l){
  tmp <- Filter(Negate(is.null), l)
  if(length(tmp) == 0) NULL else tmp
}

collapse_issues <- function(x){
  tmp <- x[names(x) %in% "issues"][[1]]
  tmp <- gbifissues[ gbifissues$issue %in% tmp, "code" ]
  paste(tmp, collapse=",")
}

#' Pipe operator
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

gbif_GET <- function(url, args, parse=FALSE, ...){
  temp <- GET(url, query = args, ...)

  if (temp$status_code == 204) stop("Status: 204 - not found", call. = FALSE)
  if (temp$status_code > 200) {
    mssg <- content(temp)
    if (length(mssg) == 0) mssg <- http_status(temp)$message
    if (temp$status_code == 503) mssg <- http_status(temp)$message
    stop(mssg, call. = FALSE)
  }
  stopifnot(temp$headers$`content-type` == 'application/json')
  res <- content(temp, as = 'text', encoding = "UTF-8")
  jsonlite::fromJSON(res, parse)
}

gbif_GET_content <- function(url, args, ...) {
  temp <- GET(url, query = cn(args), ...)
  if (temp$status_code > 200) warning(content(temp, as = "text"))
  stopifnot(temp$headers$`content-type` == 'application/json')
  content(temp, as = 'text', encoding = "UTF-8")
}

cn <- function(x) if (length(x) == 0) NULL else x

gbif_base <- function() 'http://api.gbif.org/v1'

#' Table of GBIF issues, with codes used in data output, full issue name, and descriptions.
#'
#' Table has the following fields:
#'
#' \itemize{
#'   \item code. Code for issue, making viewing data easier.
#'   \item issue. Full name of the issue.
#'   \item description. Description of the issue.
#' }
#'
#' @export
#' @usage gbif_issues()
#' @source \url{http://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html}
gbif_issues <- function() gbifissues

gbifissues <- structure(list(
  code = c("bri", "ccm", "cdc", "conti", "cdiv",
    "cdout", "cdrep", "cdrepf", "cdreps", "cdround", "cucdmis", "cudc",
    "cuiv", "cum", "depmms", "depnn", "depnmet", "depunl", "elmms",
    "elnn", "elnmet", "elunl", "gass84", "gdativ", "iddativ", "iddatunl",
    "mdativ", "mdatunl", "muldativ", "muluriiv", "preneglat", "preneglon",
    "preswcd", "rdativ", "rdatm", "rdatunl", "refuriiv", "txmatfuz",
    "txmathi", "txmatnon", "typstativ", "zerocd"),
  issue = c("BASIS_OF_RECORD_INVALID",
     "CONTINENT_COUNTRY_MISMATCH", "CONTINENT_DERIVED_FROM_COORDINATES",
     "CONTINENT_INVALID", "COORDINATE_INVALID", "COORDINATE_OUT_OF_RANGE",
     "COORDINATE_REPROJECTED", "COORDINATE_REPROJECTION_FAILED", "COORDINATE_REPROJECTION_SUSPICIOUS",
     "COORDINATE_ROUNDED", "COUNTRY_COORDINATE_MISMATCH", "COUNTRY_DERIVED_FROM_COORDINATES",
     "COUNTRY_INVALID", "COUNTRY_MISMATCH", "DEPTH_MIN_MAX_SWAPPED",
     "DEPTH_NON_NUMERIC", "DEPTH_NOT_METRIC", "DEPTH_UNLIKELY", "ELEVATION_MIN_MAX_SWAPPED",
     "ELEVATION_NON_NUMERIC", "ELEVATION_NOT_METRIC", "ELEVATION_UNLIKELY",
     "GEODETIC_DATUM_ASSUMED_WGS84", "GEODETIC_DATUM_INVALID", "IDENTIFIED_DATE_INVALID",
     "IDENTIFIED_DATE_UNLIKELY", "MODIFIED_DATE_INVALID", "MODIFIED_DATE_UNLIKELY",
     "MULTIMEDIA_DATE_INVALID", "MULTIMEDIA_URI_INVALID", "PRESUMED_NEGATED_LATITUDE",
     "PRESUMED_NEGATED_LONGITUDE", "PRESUMED_SWAPPED_COORDINATE",
     "RECORDED_DATE_INVALID", "RECORDED_DATE_MISMATCH", "RECORDED_DATE_UNLIKELY",
     "REFERENCES_URI_INVALID", "TAXON_MATCH_FUZZY", "TAXON_MATCH_HIGHERRANK",
     "TAXON_MATCH_NONE", "TYPE_STATUS_INVALID", "ZERO_COORDINATE"),
  description = c("The given basis of record is impossible to interpret or seriously different from the recommended vocabulary.",
     "The interpreted continent and country do not match up.",
     "The interpreted continent is based on the coordinates, not the verbatim string information.",
     "Uninterpretable continent values found.", "Coordinate value given in some form but GBIF is unable to interpret it.",
     "Coordinate has invalid lat/lon values out of their decimal max range.",
     "The original coordinate was successfully reprojected from a different geodetic datum to WGS84.",
     "The given decimal latitude and longitude could not be reprojected to WGS84 based on the provided datum.",
     "Indicates successful coordinate reprojection according to provided datum, but which results in a datum shift larger than 0.1 decimal degrees.",
     "Original coordinate modified by rounding to 5 decimals.",
     "The interpreted occurrence coordinates fall outside of the indicated country.",
     "The interpreted country is based on the coordinates, not the verbatim string information.",
     "Uninterpretable country values found.", "Interpreted country for dwc:country and dwc:countryCode contradict each other.",
     "Set if supplied min>max", "Set if depth is a non numeric value",
     "Set if supplied depth is not given in the metric system, for example using feet instead of meters",
     "Set if depth is larger than 11.000m or negative.", "Set if supplied min > max elevation",
     "Set if elevation is a non numeric value", "Set if supplied elevation is not given in the metric system, for example using feet instead of meters",
     "Set if elevation is above the troposphere (17km) or below 11km (Mariana Trench).",
     "Indicating that the interpreted coordinates assume they are based on WGS84 datum as the datum was either not indicated or interpretable.",
     "The geodetic datum given could not be interpreted.", "The date given for dwc:dateIdentified is invalid and cant be interpreted at all.",
     "The date given for dwc:dateIdentified is in the future or before Linnean times (1700).",
     "A (partial) invalid date is given for dc:modified, such as a non existing date, invalid zero month, etc.",
     "The date given for dc:modified is in the future or predates unix time (1970).",
     "An invalid date is given for dc:created of a multimedia object.",
     "An invalid uri is given for a multimedia object.", "Latitude appears to be negated, e.g. 32.3 instead of -32.3",
     "Longitude appears to be negated, e.g. 32.3 instead of -32.3",
     "Latitude and longitude appear to be swapped.", "A (partial) invalid date is given, such as a non existing date, invalid zero month, etc.",
     "The recording date specified as the eventDate string and the individual year, month, day are contradicting.",
     "The recording date is highly unlikely, falling either into the future or represents a very old date before 1600 that predates modern taxonomy.",
     "An invalid uri is given for dc:references.", "Matching to the taxonomic backbone can only be done using a fuzzy, non exact match.",
     "Matching to the taxonomic backbone can only be done on a higher rank and not the scientific name.",
     "Matching to the taxonomic backbone cannot be done cause there was no match at all or several matches with too little information to keep them apart (homonyms).",
     "The given type status is impossible to interpret or seriously different from the recommended vocabulary.",
     "Coordinate is the exact 0/0 coordinate, often indicating a bad null coordinate."
  )), .Names = c("code", "issue", "description"), class = "data.frame", row.names = c(NA, -42L))

as_log <- function(x){
  stopifnot(is.logical(x) || is.null(x))
  if (is.null(x)) NULL else if(x) 'true' else 'false'
}

noNA <- function(x) {
  !(any(is.na(x)))
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))
strtrim <- function(str) gsub("^\\s+|\\s+$", "", str)
