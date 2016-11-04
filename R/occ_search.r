#' Search for GBIF occurrences
#'
#' @export
#' @template occsearch
#' @template oslimstart
#' @template occ
#' @template occ_search_egs
#' @template occfacet
#' @param fields (character) Default ('all') returns all fields. 'minimal'
#' returns just taxon name, key, latitude, and longitute. Or specify each field
#' you want returned by name, e.g. fields = c('name','latitude','elevation').
#' @param return One of data, hier, meta, or all. If data, a data.frame with the
#' data. hier returns the classifications in a list for each record. meta
#' returns the metadata for the entire call. all gives all data back in
#' a list.
#' @seealso \code{\link{downloads}}, \code{\link{occ_data}},
#' \code{\link{occ_facet}}
#' @return An object of class \code{gbif}, which is a S3 class list, with
#' slots for metadata (\code{meta}), the occurrence data itself (\code{data}),
#' the taxonomic hierarchy data (\code{hier}), and media metadata (\code{media}).
#' In addition, the object has attributes listing the user supplied arguments
#' and whether it was a "single" or "many" search; that is, if you supply two
#' values of the \code{datasetKey} parameter to searches are done, and it's a
#' "many". \code{meta} is a list of length four with offset, limit, endOfRecords and
#' count fields. \code{data} is a tibble (aka data.frame). \code{hier} is a
#' list of data.frame's of the unique set of taxa found, where each data.frame
#' is its taxonomic classification. \code{media} is a list of media objects,
#' where each element holds a set of metadata about the media object. If
#' the \code{return} parameter is set to something other than default you get
#' back just the \code{meta}, \code{data}, \code{hier}, or \code{media}.

occ_search <- function(taxonKey=NULL, scientificName=NULL, country=NULL,
  publishingCountry=NULL, hasCoordinate=NULL, typeStatus=NULL, recordNumber=NULL,
  lastInterpreted=NULL, continent=NULL, geometry=NULL, geom_big="asis",
  geom_size=40, geom_n=10, recordedBy=NULL, basisOfRecord=NULL, datasetKey=NULL,
  eventDate=NULL, catalogNumber=NULL, year=NULL, month=NULL, decimalLatitude=NULL,
  decimalLongitude=NULL, elevation=NULL, depth=NULL, institutionCode=NULL,
  collectionCode=NULL, hasGeospatialIssue=NULL, issue=NULL, search=NULL,
  mediaType=NULL, subgenusKey = NULL, repatriated = NULL, phylumKey = NULL,
  kingdomKey = NULL, classKey = NULL, orderKey = NULL, familyKey = NULL,
  genusKey = NULL, establishmentMeans = NULL, protocol = NULL, license = NULL,
  organismId = NULL, publishingOrg = NULL, stateProvince = NULL,
  waterBody = NULL, locality = NULL, limit=500, start=0, fields = 'all',
  return='all', spellCheck = NULL, facet = NULL, facetMincount = NULL,
  facetMultiselect = NULL, ...) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("georeferenced","altitude","latitude","longitude") %in% calls
  if (any(calls_vec)) {
    stop("Parameter name changes: \n georeferenced -> hasCoordinate\n altitude -> elevation\n latitude -> decimalLatitude\n longitude - > decimalLongitude")
  }

  geometry <- geometry_handler(geometry, geom_big, geom_size, geom_n)

  url <- paste0(gbif_base(), '/occurrence/search')
  argscoll <- NULL

  .get_occ_search <- function(x=NULL, itervar=NULL, ...) {
    if (!is.null(x)) {
      assign(itervar, x)
    }

    # check that wkt is proper format and of 1 of 4 allowed types
    geometry <- check_wkt(geometry)

    # check limit and start params
    check_vals(limit, "limit")
    check_vals(start, "start")

    # Make arg list
    args <- rgbif_compact(
      list(
        taxonKey=taxonKey, scientificName=scientificName, country=country,
        publishingCountry=publishingCountry, hasCoordinate=hasCoordinate, typeStatus=typeStatus,
        recordNumber=recordNumber, lastInterpreted=lastInterpreted, continent=continent,
        geometry=geometry, recordedBy=recordedBy, basisOfRecord=basisOfRecord,
        datasetKey=datasetKey, eventDate=eventDate, catalogNumber=catalogNumber,
        year=year, month=month, decimalLatitude=decimalLatitude,
        decimalLongitude=decimalLongitude, elevation=elevation, depth=depth,
        institutionCode=institutionCode, collectionCode=collectionCode,
        hasGeospatialIssue=hasGeospatialIssue, q=search, mediaType=mediaType,
        subgenusKey=subgenusKey,
        repatriated=repatriated, phylumKey=phylumKey, kingdomKey=kingdomKey,
        classKey=classKey, orderKey=orderKey, familyKey=familyKey,
        genusKey=genusKey, establishmentMeans=establishmentMeans,
        protocol=protocol, license=license, organismId=organismId,
        publishingOrg=publishingOrg, stateProvince=stateProvince,
        waterBody=waterBody, locality=locality,
        limit=check_limit(as.integer(limit)),
        offset=check_limit(as.integer(start)), spellCheck = spellCheck,
        facetMincount = facetMincount, facetMultiselect = facetMultiselect
      )
    )
    args <- c(args, parse_issues(issue), collargs("facet"), yank_args(...))

    argscoll <<- args

    if (limit >= 300) {
      ### loop route for no facet and limit>0
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
    } else {
      ### loop route for facet or limit=0
      outout <- list(gbif_GET(url, args, FALSE, ...))
    }

    meta <- outout[[length(outout)]][c('offset', 'limit', 'endOfRecords', 'count')]
    data <- do.call(c, lapply(outout, "[[", "results"))
    facets <- do.call(c, lapply(outout, "[[", "facets"))

    if (return == 'data') {
      if (identical(data, list())) {
        paste("no data found, try a different search")
      } else {
        data <- gbifparser(input = data, fields = fields)
        df <- data.table::setDF(
          data.table::rbindlist(
            lapply(data, "[[", "data"), use.names = TRUE, fill = TRUE
          )
        )
        tibble::as_data_frame(prune_result(df))
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
    } else if (return == 'facet') {
      stats::setNames(lapply(facets, function(z) {
        tibble::as_data_frame(
          data.table::rbindlist(z$counts, use.names = TRUE, fill = TRUE)
        )
      }), vapply(tt$facets, function(x) to_camel(x$field), ""))
    } else if (return == 'meta') {
      tibble::as_data_frame(meta)
    } else {
      if (identical(data, list())) {
        dat2 <- NULL
        hier2 <- NULL
        media <- NULL
      } else {
        data <- gbifparser(input = data, fields = fields)
        dat2 <- tibble::as_data_frame(prune_result(ldfast(lapply(data, "[[", "data"))))
        hier2 <- unique(lapply(data, "[[", "hierarchy"))
        media <- unique(lapply(data, "[[", "media"))
      }
      fac <- stats::setNames(lapply(facets, function(z) {
        tibble::as_data_frame(
          data.table::rbindlist(z$counts, use.names = TRUE, fill = TRUE)
        )
      }), vapply(facets, function(x) to_camel(x$field), ""))
      list(meta = meta, hierarchy = hier2, data = dat2,
           media = media, facets = fac)
    }
  }

  params <- list(
    taxonKey=taxonKey,scientificName=scientificName,datasetKey=datasetKey,
    catalogNumber=catalogNumber,
    recordedBy=recordedBy,geometry=geometry,country=country,
    publishingCountry=publishingCountry,recordNumber=recordNumber,
    q=search,institutionCode=institutionCode,collectionCode=collectionCode,continent=continent,
    decimalLatitude=decimalLatitude,decimalLongitude=decimalLongitude,depth=depth,year=year,
    typeStatus=typeStatus,lastInterpreted=lastInterpreted,mediaType=mediaType,
    subgenusKey=subgenusKey,repatriated=repatriated,
    phylumKey=phylumKey, kingdomKey=kingdomKey,classKey=classKey,
    orderKey=orderKey, familyKey=familyKey,genusKey=genusKey,
    establishmentMeans=establishmentMeans,protocol=protocol, license=license,
    organismId=organismId,publishingOrg=publishingOrg,
    stateProvince=stateProvince,waterBody=waterBody, locality=locality,
    limit=limit
  )
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
    out <- .get_occ_search(...)
  } else {
    out <- lapply(iter[[1]], .get_occ_search, itervar = names(iter), ...)
    names(out) <- transform_names(iter[[1]])
  }

  if (any(names(argscoll) %in% names(iter))) {
    argscoll[[names(iter)]] <- iter[[names(iter)]]
  }
  argscoll$fields <- fields

  if (!return %in% c('meta', 'hier')) {
    if (inherits(out, "data.frame")) {
      class(out) <- c('tbl_df', 'data.frame', 'gbif')
    } else {
      class(out) <- "gbif"
      attr(out, 'type') <- if (length(iter) == 0) "single" else "many"
    }
  }
  structure(out, return = return, args = argscoll)
}

# helpers -------------------------
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
