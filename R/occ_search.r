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
#' @param return Defunct. All components (meta, hierarchy, data, media,
#' facets) are returned now; index to the one(s) you want. See [occ_data()]
#' if you just want the data component
#' @param ... additional facet parameters
#' @seealso [downloads()], [occ_data()], [occ_facet()]
#' @note Maximum number of records you can get with this function is 100,000.
#' See https://www.gbif.org/developer/occurrence
#' @return An object of class `gbif`, which is a S3 class list, with
#' slots for metadata (`meta`), the occurrence data itself (`data`),
#' the taxonomic hierarchy data (`hier`), and media metadata
#' (`media`).
#' In addition, the object has attributes listing the user supplied arguments
#' and whether it was a 'single' or 'many' search; that is, if you supply two
#' values of the `datasetKey` parameter to searches are done, and it's a
#' 'many'. `meta` is a list of length four with offset, limit,
#' endOfRecords and count fields. `data` is a tibble (aka data.frame). `hier`
#' is a list of data.frames of the unique set of taxa found, where each
#' data.frame is its taxonomic classification. `media` is a list of media
#' objects, where each element holds a set of metadata about the media object.

occ_search <- function(taxonKey=NULL, scientificName=NULL, country=NULL,
  publishingCountry=NULL, hasCoordinate=NULL, typeStatus=NULL,
  recordNumber=NULL, lastInterpreted=NULL, continent=NULL, geometry=NULL,
  geom_big="asis",
  geom_size=40, geom_n=10, recordedBy=NULL, recordedByID=NULL,
  identifiedByID=NULL, basisOfRecord=NULL, datasetKey=NULL,
  eventDate=NULL, catalogNumber=NULL, year=NULL, month=NULL,
  decimalLatitude=NULL,
  decimalLongitude=NULL, elevation=NULL, depth=NULL, institutionCode=NULL,
  collectionCode=NULL, hasGeospatialIssue=NULL, issue=NULL, search=NULL,
  mediaType=NULL, subgenusKey = NULL, repatriated = NULL, phylumKey = NULL,
  kingdomKey = NULL, classKey = NULL, orderKey = NULL, familyKey = NULL,
  genusKey = NULL, establishmentMeans = NULL, protocol = NULL, license = NULL,
  organismId = NULL, publishingOrg = NULL, stateProvince = NULL,
  waterBody = NULL, locality = NULL, limit=500, start=0, fields = 'all',
  return=NULL, facet = NULL, facetMincount = NULL,
  facetMultiselect = NULL, skip_validate = TRUE, curlopts = list(), ...) {

  pchk(return, "occ_search")
  geometry <- geometry_handler(geometry, geom_big, geom_size, geom_n)
  url <- paste0(gbif_base(), '/occurrence/search')
  argscoll <- NULL

  .get_occ_search <- function(x=NULL, itervar=NULL, curlopts = list()) {
    if (!is.null(x)) {
      assign(itervar, x)
    }

    # check that wkt is proper format and of 1 of 4 allowed types
    geometry <- check_wkt(geometry, skip_validate = skip_validate)

    # check limit and start params
    check_vals(limit, "limit")
    check_vals(start, "start")

    args <- rgbif_compact(
      list(hasCoordinate = hasCoordinate,
        lastInterpreted = lastInterpreted,
        basisOfRecord = basisOfRecord, decimalLatitude = decimalLatitude,
        decimalLongitude = decimalLongitude,
        hasGeospatialIssue = hasGeospatialIssue,
        q = search, repatriated = repatriated, elevation = elevation,
        depth = depth, limit = check_limit(as.integer(limit)),
        eventDate = eventDate, month = month, year = year,
        offset = check_limit(as.integer(start))
      )
    )
    args <- c(
      args, parse_issues(issue), collargs("facet"), yank_args(...),
      convmany(taxonKey), convmany(scientificName), convmany(country),
      convmany(publishingCountry), convmany(datasetKey),
      convmany(typeStatus), convmany(recordNumber), convmany(continent),
      convmany(recordedBy), convmany(recordedByID), convmany(identifiedByID),
      convmany(catalogNumber), convmany(institutionCode),
      convmany(collectionCode), convmany(geometry), convmany(mediaType),
      convmany(subgenusKey), convmany(phylumKey), convmany(kingdomKey),
      convmany(classKey), convmany(orderKey), convmany(familyKey),
      convmany(genusKey), convmany(establishmentMeans), convmany(protocol),
      convmany(license), convmany(organismId), convmany(publishingOrg),
      convmany(stateProvince), convmany(waterBody), convmany(locality)
    )

    argscoll <<- args

    if (limit >= 300) {
      ### loop route for no facet and limit>0
      iter <- 0
      sumreturned <- 0
      outout <- list()
      while (sumreturned < limit) {
        iter <- iter + 1
        tt <- gbif_GET(url, args, FALSE, curlopts)

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
      outout <- list(gbif_GET(url, args, FALSE, curlopts))
    }

    meta <- outout[[length(outout)]][c('offset', 'limit', 'endOfRecords',
                                       'count')]
    data <- do.call(c, lapply(outout, "[[", "results"))
    facets <- do.call(c, lapply(outout, "[[", "facets"))
    if (identical(data, list())) {
      dat2 <- NULL
      hier2 <- NULL
      media <- NULL
    } else {
      data <- gbifparser(input = data, fields = fields)
      dat2 <- tibble::as_tibble(
        prune_result(setdfrbind(lapply(data, "[[", "data"))))
      hier2 <- unique(lapply(data, "[[", "hierarchy"))
      media <- unique(lapply(data, "[[", "media"))
    }
    fac <- stats::setNames(lapply(facets, function(z) {
      tibble::as_tibble(
        data.table::rbindlist(z$counts, use.names = TRUE, fill = TRUE)
      )
    }), vapply(facets, function(x) to_camel(x$field), ""))
    list(meta = meta, hierarchy = hier2, data = dat2,
         media = media, facets = fac)
  }

  params <- list(
    taxonKey=taxonKey,scientificName=scientificName,datasetKey=datasetKey,
    catalogNumber=catalogNumber,
    recordedBy=recordedBy,recordedByID=recordedByID, identifiedByID=identifiedByID,
    geometry=geometry, country=country,
    publishingCountry=publishingCountry,recordNumber=recordNumber,
    q=search,institutionCode=institutionCode,collectionCode=collectionCode,
    continent=continent,
    decimalLatitude=decimalLatitude,decimalLongitude=decimalLongitude,
    depth=depth,year=year,
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
    stop(sprintf("At least one of these parameters must have a value:\n%s",
                 possparams()),
         call. = FALSE)
  }
  iter <- params[which(sapply(params, length) > 1)]
  if (length(names(iter)) > 1) {
    stop(sprintf("You can have multiple values for only one of:\n%s",
                 possparams()),
         call. = FALSE)
  }

  if (length(iter) == 0) {
    out <- .get_occ_search(curlopts = curlopts)
  } else {
    out <- lapply(iter[[1]], .get_occ_search, itervar = names(iter),
                  curlopts = curlopts)
    names(out) <- transform_names(iter[[1]])
  }

  if (any(names(argscoll) %in% names(iter))) {
    argscoll[[names(iter)]] <- iter[[names(iter)]]
  }
  argscoll$fields <- fields
  structure(out, class = "gbif", args = argscoll,
    type = if (length(iter) == 0) "single" else "many")
}

# helpers -------------------------
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
  "taxonKey, scientificName, datasetKey, catalogNumber, recordedBy,
  recordedByID, identifiedByID, geometry, country, publishingCountry,
  recordNumber, search, institutionCode, collectionCode, decimalLatitude,
  decimalLongitude, depth, year, typeStatus, lastInterpreted,
  continent, or mediatype"
}
