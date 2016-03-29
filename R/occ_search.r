#' Search for GBIF occurrences
#'
#' @export
#' @template occsearch
#' @template oslimstart
#' @template occ
#' @template occ_search_egs
#' @param fields (character) Default ('all') returns all fields. 'minimal' returns just taxon name,
#'    key, latitude, and longitute. Or specify each field you want returned by name, e.g.
#'    fields = c('name','latitude','elevation').
#' @param return One of data, hier, meta, or all. If data, a data.frame with the
#'    data. hier returns the classifications in a list for each record. meta
#'    returns the metadata for the entire call. all gives all data back in a list.
#' @param x Output from a call to occ_search
#' @param n Number of rows of the data to print.
#' @seealso \code{\link{downloads}}, \code{\link{occ_data}}

occ_search <- function(taxonKey=NULL, scientificName=NULL, country=NULL, publishingCountry=NULL,
  hasCoordinate=NULL, typeStatus=NULL, recordNumber=NULL, lastInterpreted=NULL, continent=NULL,
  geometry=NULL, geom_big="asis", geom_size=40, geom_n=10, recordedBy=NULL, basisOfRecord=NULL,
  datasetKey=NULL, eventDate=NULL,
  catalogNumber=NULL, year=NULL, month=NULL, decimalLatitude=NULL, decimalLongitude=NULL,
  elevation=NULL, depth=NULL, institutionCode=NULL, collectionCode=NULL,
  hasGeospatialIssue=NULL, issue=NULL, search=NULL, mediaType=NULL, limit=500, start=0,
  fields = 'all', return='all', ...) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("georeferenced","altitude","latitude","longitude") %in% calls
  if (any(calls_vec)) {
    stop("Parameter name changes: \n georeferenced -> hasCoordinate\n altitude -> elevation\n latitude -> decimalLatitude\n longitude - > decimalLongitude")
  }

  geometry <- geometry_handler(geometry, geom_big, geom_size, geom_n)

  url <- paste0(gbif_base(), '/occurrence/search')

  .get_occ_search <- function(x=NULL, itervar=NULL) {
    if (!is.null(x)) {
      assign(itervar, x)
    }

    # check that wkt is proper format and of 1 of 4 allowed types
    geometry <- check_wkt(geometry)

    # check limit and start params
    check_vals(limit, "limit")
    check_vals(start, "start")

    # Make arg list
    args <- rgbif_compact(list(taxonKey=taxonKey, scientificName=scientificName, country=country,
      publishingCountry=publishingCountry, hasCoordinate=hasCoordinate, typeStatus=typeStatus,
      recordNumber=recordNumber, lastInterpreted=lastInterpreted, continent=continent,
      geometry=geometry, recordedBy=recordedBy, basisOfRecord=basisOfRecord,
      datasetKey=datasetKey, eventDate=eventDate, catalogNumber=catalogNumber,
      year=year, month=month, decimalLatitude=decimalLatitude,
      decimalLongitude=decimalLongitude, elevation=elevation, depth=depth,
      institutionCode=institutionCode, collectionCode=collectionCode,
      hasGeospatialIssue=hasGeospatialIssue, q=search, mediaType=mediaType,
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

      if (tt$count < limit) {
        limit <- tt$count
      }

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
        df <- ldfast(lapply(data, "[[", "data"))
        prune_result(df)
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
        data <- gbifparser(input = data, fields = fields)
        sapply(data, "[[", "media")
      }
    } else if (return == 'meta') {
      data.frame(meta, stringsAsFactors = FALSE)
    } else {
      if (identical(data, list())) {
        dat2 <- paste("no data found, try a different search")
        hier2 <- paste("no data found, try a different search")
        media <- paste("no data found, try a different search")
      } else {
        data <- gbifparser(input = data, fields = fields)
        dat2 <- prune_result(ldfast(lapply(data, "[[", "data")))
        hier2 <- unique(lapply(data, "[[", "hierarchy"))
        media <- unique(lapply(data, "[[", "media"))
      }
      list(meta = meta, hierarchy = hier2, data = dat2, media = media)
    }
  }

  params <- list(taxonKey=taxonKey,scientificName=scientificName,datasetKey=datasetKey,
    catalogNumber=catalogNumber,
    recordedBy=recordedBy,geometry=geometry,country=country,
    publishingCountry=publishingCountry,recordNumber=recordNumber,
    q=search,institutionCode=institutionCode,collectionCode=collectionCode,continent=continent,
    decimalLatitude=decimalLatitude,decimalLongitude=decimalLongitude,depth=depth,year=year,
    typeStatus=typeStatus,lastInterpreted=lastInterpreted,mediaType=mediaType,
    limit=limit)
  if (!any(sapply(params, length) > 0)) {
    stop(sprintf("At least one of the parmaters must have a value:\n%s", possparams()),
         call. = FALSE)
  }
  iter <- params[which(sapply(params, length) > 1)]
  if (length(names(iter)) > 1) {
    stop(sprintf("You can have multiple values for only one of:\n%s", possparams()),
         call. = FALSE)
  }

  if (length(iter) == 0) {
    out <- .get_occ_search()
  } else {
    out <- lapply(iter[[1]], .get_occ_search, itervar = names(iter))
    names(out) <- transform_names(iter[[1]])
  }

  if (any(names(argscoll) %in% names(iter))) {
    argscoll[[names(iter)]] <- iter[[names(iter)]]
  }
  argscoll$fields <- fields

  if (!return %in% c('meta', 'hier')) {
    if (is(out, "data.frame")) {
      class(out) <- c('data.frame', 'gbif')
    } else {
      class(out) <- "gbif"
      attr(out, 'type') <- if (length(iter) == 0) "single" else "many"
    }
  }
  structure(out, return = return, args = argscoll)
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
      cat(sprintf("First 10 rows of data from %s\n\n", substring(names(x)[1], 1, 50)))
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
  tt <- list()
  for (i in seq_along(arrrgs)) {
    tt[[i]] <- sprintf("%s=%s", names(arrrgs)[i],
                       if (length(arrrgs[[i]]) > 1) {
                         substring(paste0(arrrgs[[i]], collapse = ","), 1, 100)
                       } else {
                         substring(arrrgs[[i]], 1, 100)
                       })
  }
  paste0(tt, collapse = ", ")
}

pastemax <- function(z, type='counts', n=10){
  xnames <- names(z)
  xnames <- sapply(xnames, function(x) {
    if (nchar(x) > 8) {
      paste0(substr(x, 1, 6), "..", collapse = "")
    } else {
      x
    }
  }, USE.NAMES = FALSE)
  yep <- switch(type,
         counts = vapply(z, function(y) y$meta$count, numeric(1), USE.NAMES = FALSE),
         returned = vapply(z, function(y) NROW(y$data), numeric(1), USE.NAMES = FALSE),
         hier = vapply(z, function(y) length(y$hierarchy), numeric(1), USE.NAMES = FALSE),
         media = vapply(z, function(y) length(y$media), numeric(1), USE.NAMES = FALSE)
  )
  tt <- list()
  for (i in seq_along(xnames)) {
    tt[[i]] <- sprintf("%s (%s)", xnames[i], yep[[i]])
  }
  paste0(tt, collapse = ", ")
}

parse_issues <- function(x){
  sapply(x, function(y) list(issue = y), USE.NAMES = FALSE)
}

check_limit <- function(x){
  if (x > 1000000L) {
    stop("
      Maximum request size is 1 million. As a solution, either use the
      GBIF web interface, or in R, split up your request in a way that
      makes sense for your use case. E.g., you could split up your
      request into geographic chunks, by country or by bounding box. Or
      you could split up your request taxonomically, e.g., if you want
      data for all species in a large family of birds, split up by
      some higher taxonomic level, like tribe or genus.")
  } else {
    x
  }
}

possparams <- function(){
  "   taxonKey, scientificName, datasetKey, catalogNumber, recordedBy, geometry,
   country, publishingCountry, recordNumber, search, institutionCode, collectionCode,
   decimalLatitude, decimalLongitude, depth, year, typeStatus, lastInterpreted,
   continent, or mediatype"
}

check_vals <- function(x, y){
  if (is.na(x) || is.null(x)) stop(sprintf("%s can not be NA or NULL", y), call. = FALSE)
  if (length(x) > 1) stop(sprintf("%s has to be length 1", y), call. = FALSE)
}
