get_hier <- function(x, h1, h2){
  name <- data.frame(t(data.frame(x[names(x) %in% h1], stringsAsFactors=FALSE)), stringsAsFactors=FALSE)
  if (nrow(name)==0){
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

# Parser for gbif data
# param: input A list
# @param: fields (character) Default ('minimal') will return just taxon name, key, latitude, and
#    longitute. 'all' returns all fields. Or specify each field you want returned by name, e.g.
#    fields = c('name','latitude','altitude').
gbifparser <- function(input, fields='minimal'){
  parse <- function(x){
    x[sapply(x, length) == 0] <- "none"
    h1 <- c('kingdom','phylum','class','order','family','genus','species')
    h2 <- c('kingdomKey','phylumKey','classKey','orderKey','familyKey','genusKey','speciesKey')
    hier <- get_hier(x, h1, h2)
    if (nrow(stats::na.omit(hier)) == 0){
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

clean_data <- function(x){
  # collapse issues
  if (!identical(x, list())) x[names(x) %in% "issues"] <- collapse_issues_vec(x)

  # drop media, facts, relations
  x$media <- NULL
  x$facts <- NULL
  x$relations <- NULL
  x$identifiers <- NULL
  x$extensions <- NULL

  # move columns
  x <- move_col(x, 'issues')
  x <- move_col(x, 'decimalLongitude')
  x <- move_col(x, 'decimalLatitude')
  x <- move_col(x, 'key')
  x <- move_col(x, 'species')
  names(x)[1] <- 'name'

  return(x)
}

# Parser for gbif data
# param: input A list
# param: fields (character) Default ('minimal') will return just taxon name, key, decimalLatitude, and
#    decimalLongitute. 'all' returns all fields. Or specify each field you want returned by name, e.g.
#    fields = c('name','decimalLatitude','altitude').
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
  if (convertvec) {
    do.call(rbind_fill, lapply(x, convert2df))
  } else {
    do.call(rbind_fill, x)
  }
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
  if (!inherits(x, "data.frame")) {
    # data.frame(rbind(x), stringsAsFactors = FALSE)
    tibble::data_frame(rbind(x))
  } else {
    tibble::as_data_frame(x)
  }
}

rbind_rows <- function(x) {
  tmp <- unname(do.call("rbind.data.frame", x))
  tmp <- data.frame(.id = row.names(tmp), V1 = tmp, stringsAsFactors = FALSE)
  row.names(tmp) <- NULL
  tmp
}

# Parser for gbif data
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

#' Custom ggplot2 theme
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


# Capitalize the first letter of a character string.
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

namelkupparser <- function(x){
  tmp <- x[ !names(x) %in% c("descriptions", "vernacularNames", "higherClassificationMap") ]
  tmp <- lapply(tmp, function(x) {
    if (length(x) == 0) {
      NA
    } else if (length(x) > 1 || inherits(x, "list")) {
      paste0(x, collapse = ", ")
    } else {
      x
    }
  })
  df <- data.frame(tmp, stringsAsFactors = FALSE)
  movecols(df, c('key', 'scientificName'))
}

namelkupcleaner <- function(x){
  tmp <- x[ !names(x) %in% c("descriptions", "vernacularNames", "higherClassificationMap") ]
  lapply(tmp, function(x) {
    if (length(x) == 0) {
      NA
    } else if (length(x) > 1 || inherits(x, "list")) {
      paste0(x, collapse = ", ")
    } else {
      x
    }
  })
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

backbone_parser <- function(x){
  tmp <- lapply(x, function(x) if (length(x) == 0) NA else x)
  data.frame(tmp, stringsAsFactors = FALSE)
}

rgbif_compact <- function(l) Filter(Negate(is.null), l)

compact_null <- function(l){
  tmp <- rgbif_compact(l)
  if (length(tmp) == 0) NULL else tmp
}

# REST helpers ---------------------------------------
rgbif_ua <- function() {
  versions <- c(paste0("r-curl/", utils::packageVersion("curl")),
                paste0("crul/", utils::packageVersion("crul")),
                sprintf("rOpenSci(rgbif/%s)", utils::packageVersion("rgbif")))
  paste0(versions, collapse = " ")
}

rgbif_ual <- list(`User-Agent` = rgbif_ua(), `X-USER-AGENT` = rgbif_ua())

gbif_GET <- function(url, args, parse=FALSE, curlopts = list(), mssg = NULL) {
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  temp <- cli$get(query = args)
  if (temp$status_code == 204)
    stop("Status: 204 - not found ", mssg, call. = FALSE)
  if (temp$status_code > 200) {
    mssg <- temp$parse("UTF-8")
    if (grepl("html", mssg)) {
      stop("500 - Server error", call. = FALSE)
    }
    if (length(mssg) == 0 || nchar(mssg) == 0) {
      mssg <- temp$status_http()$message
    }
    if (temp$status_code == 503) mssg <- temp$status_http()$message
    stop(mssg, call. = FALSE)
  }

  # check content type
  stopifnot(temp$response_headers$`content-type` == 'application/json')

  # parse JSON
  json <- jsonlite::fromJSON(temp$parse("UTF-8"), parse)

  # check if spellCheck = TRUE, and if should stop
  if ('spellCheck' %in% names(args)) {
    if (args$spellCheck) {
      if (!"suggestions" %in% names(json$spellCheckResponse)) {
        if (json$spellCheckResponse$correctlySpelled) {
          return(json)
        } else {
          stop("spelling bad, but no suggestions given", call. = FALSE)
        }
      } else {
        mssg <- paste0(
          "spelling bad - suggestions: \n",
          paste0(lapply(json$spellCheckResponse$suggestions, function(z) {
            sprintf("   %s: %s", z$alternatives, z$numFound)
          }), collapse = "\n")
        )
        stop(mssg, call. = FALSE)
      }
    }
  }

  return(json)
}

gbif_GET_content <- function(url, args, curlopts = list()) {
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  temp <- cli$get(query = args)
  if (temp$status_code > 200) stop(temp$parse("UTF-8"), call. = FALSE)
  stopifnot(temp$response_headers$`content-type` == 'application/json')
  temp$parse("UTF-8")
}

# other helpers --------------------
cn <- function(x) if (length(x) == 0) NULL else x

gbif_base <- function() 'https://api.gbif.org/v1'

as_log <- function(x){
  stopifnot(is.logical(x) || is.null(x))
  if (is.null(x)) NULL else if (x) 'true' else 'false'
}

noNA <- function(x) {
  !(any(is.na(x)))
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))

strtrim <- function(str) gsub("^\\s+|\\s+$", "", str)

move_col <- function(x, y) {
  if (y %in% names(x)) {
    x[ c(y, names(x)[-grep(y, names(x))]) ]
  } else {
    x
  }
}

movecols <- function(x, cols){
  other <- names(x)[ !names(x) %in% cols ]
  x[ , c(cols, other) ]
}

transform_names <- function(x) {
  if (all(grepl("POLYGON", x)) && any(nchar(x) > 50)) {
    paste0("geom", seq_along(x))
  } else {
    x
  }
}

get_meta <- function(x){
  if ('endOfRecords' %in% names(x)) {
    data.frame(x[!names(x) == 'results'], stringsAsFactors = FALSE)
  } else {
    NULL
  }
}

list0tochar <- function(x){
  if (class(x) == 'list') {
    tmp <- vapply(x, length, numeric(1))
    if (sum(tmp) == 0) NA else x
  } else {
    x
  }
}

parse_results <- function(x, y){
  if (!is.null(y)) {
    if ('endOfRecords' %in% names(x)) {
      tmp <- x[ !names(x) %in% c('offset','limit','endOfRecords','count') ]
    } else {
      tmp <- x
    }
  } else {
    tmp <- x$results
  }
  if (inherits(tmp, "data.frame")) {
    out <- tryCatch(tibble::as_data_frame(tmp), error = function(e) e)
    if (inherits(out, "error")) tmp else out
  } else {
    tmp
  }
}

check_gbif_arg_set <- function(x) {
  facnms <- c('facet', 'facetMincount', 'facetMultiselect',
              'facetOffset', 'facetLimit')
  if (!all(grepl(paste0(facnms, collapse = "|"), names(x)))) {
    stop("some param names not allowed: ", names(x), call. = FALSE)
  }
}

# pull out args passed in ... that should be combined with
# GET request to GBIF
yank_args <- function(...) {
  dots <- list(...)
  #for (i in seq_along(dots)) cat(names(dots)[i], "  ", dots[[i]])
  # filter out request objects
  dots <- Filter(function(z) !inherits(z, "request"), dots)
  # check that args are in a acceptable set
  check_gbif_arg_set(dots)
  dots
}

`%||%` <- function(x, y) if (is.null(x)) y else x

rgbif_wrap <- function(..., indent = 0, width = getOption("width")) {
  x <- paste0(..., collapse = "")
  wrapped <- strwrap(x, indent = indent, exdent = indent + 5, width = width)
  paste0(wrapped, collapse = "\n")
}

as_many_args <- function(x) {
  if (!is.null(x)) {
    names(x) <- rep(deparse(substitute(x)), length(x))
    return(x)
  } else {
    NULL
  }
}

convmany <- function(x) {
  if (is.null(x)) return(x)
  nms <- deparse(substitute(x))
  if (inherits(x, "character")) {
    if (length(x) == 1) {
      if (grepl(";", x)) {
        x <- strtrim(strsplit(x, ";")[[1]])
      }
    }
  }
  x <- stats::setNames(x, rep(nms, length(x)))
  return(x)
}

check_vals <- function(x, y){
  if (is.na(x) || is.null(x)) stop(sprintf("%s can not be NA or NULL", y),
                                   call. = FALSE)
  if (length(x) > 1) stop(sprintf("%s has to be length 1", y), call. = FALSE)
}

check_for_a_pkg <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

assert <- function (x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
          paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}
