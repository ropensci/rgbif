#' Search for GBIF occurrences - simplified for speed
#'
#' @export
#' @template occsearch
#' @template oslimstart
#' @template occ
#' @template occ_data_egs
#' @seealso [downloads()], [occ_search()]
#' @details This does nearly the same thing as [occ_search()], but
#' is a bit simplified for speed, and is for the most common use case where
#' user just wants occurrence data, and not other information like taxon
#' hierarchies and media (e.g., images). Alot of time in [occ_search()]
#' is used parsing data to be more useable downstream. We do less of that
#' in this function.
#' @note Maximum number of records you can get with this function is 100,000.
#' See https://www.gbif.org/developer/occurrence
#' @return An object of class `gbif_data`, which is a S3 class list, with
#' slots for metadata (`meta`) and the occurrence data itself
#' (`data`), and with attributes listing the user supplied arguments
#' and whether it was a "single" or "many" search; that is, if you supply
#' two values of the `datasetKey` parameter to searches are done, and
#' it's a "many". `meta` is a list of length four with offset, limit,
#' endOfRecords and count fields. `data` is a tibble (aka data.frame)

occ_data <- function(taxonKey=NULL, scientificName=NULL, country=NULL,
  publishingCountry=NULL, hasCoordinate=NULL, typeStatus=NULL,
  recordNumber=NULL,
  lastInterpreted=NULL, continent=NULL, geometry=NULL, geom_big="asis",
  geom_size=40, geom_n=10, recordedBy=NULL, recordedByID=NULL,
  identifiedByID=NULL, basisOfRecord=NULL, datasetKey=NULL, eventDate=NULL,
  catalogNumber=NULL, year=NULL, month=NULL, decimalLatitude=NULL,
  decimalLongitude=NULL, elevation=NULL, depth=NULL, institutionCode=NULL,
  collectionCode=NULL, hasGeospatialIssue=NULL, issue=NULL, search=NULL,
  mediaType=NULL, subgenusKey = NULL, repatriated = NULL, phylumKey = NULL,
  kingdomKey = NULL, classKey = NULL, orderKey = NULL, familyKey = NULL,
  genusKey = NULL, establishmentMeans = NULL, protocol = NULL, license = NULL,
  organismId = NULL, publishingOrg = NULL, stateProvince = NULL,
  waterBody = NULL, locality = NULL, limit=500, start=0,
  skip_validate = TRUE, curlopts = list()) {

  geometry <- geometry_handler(geometry, geom_big, geom_size, geom_n)

  url <- paste0(gbif_base(), '/occurrence/search')
  argscoll <- NULL

  .get_occ_data <- function(x=NULL, itervar=NULL, curlopts = list()) {
    if (!is.null(x)) {
      assign(itervar, x)
    }

    # check that wkt is proper format and of 1 of 4 allowed types
    geometry <- check_wkt(geometry, skip_validate = skip_validate)

    # check limit and start params
    check_vals(limit, "limit")
    check_vals(start, "start")

    # Make arg list
    args <- rgbif_compact(
      list(hasCoordinate = hasCoordinate,
        lastInterpreted = lastInterpreted,
        basisOfRecord = basisOfRecord, decimalLatitude = decimalLatitude,
        decimalLongitude = decimalLongitude,
        hasGeospatialIssue = hasGeospatialIssue,
        q = search, repatriated = repatriated, elevation = elevation,
        depth = depth,
        limit = check_limit(as.integer(limit)), eventDate = eventDate,
        month = month, year = year,
        offset = check_limit(as.integer(start))
      )
    )
    args <- c(
      args,
      parse_issues(issue),
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
      ### loop route for limit>0
      iter <- 0
      sumreturned <- 0
      outout <- list()
      while (sumreturned < limit) {
        iter <- iter + 1
        tt <- gbif_GET(url, args, TRUE, curlopts)

        # if no results, assign count var with 0
        if (identical(tt$results, list())) tt$count <- 0

        numreturned <- NROW(tt$results)
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
      ### loop route for limit<300
      outout <- list(gbif_GET(url, args, TRUE, curlopts))
    }

    meta <- outout[[length(outout)]][c('offset', 'limit', 'endOfRecords',
                                       'count')]
    data <- lapply(outout, "[[", "results")

    if (identical(data[[1]], list())) {
      data <- NULL
    } else {
      data <- lapply(data, clean_data)
      data <- data.table::setDF(data.table::rbindlist(data, use.names = TRUE,
                                                      fill = TRUE))
      data <- tibble::as_tibble(prune_result(data))
    }

    list(meta = meta, data = data)
  }

  params <- list(
    taxonKey=taxonKey,scientificName=scientificName,datasetKey=datasetKey,
    catalogNumber=catalogNumber, recordedBy=recordedBy, recordedByID=recordedByID,
    identifiedByID=identifiedByID, geometry=geometry,
    country=country, publishingCountry=publishingCountry,
    recordNumber=recordNumber, q=search,institutionCode=institutionCode,
    collectionCode=collectionCode,continent=continent,
    decimalLatitude=decimalLatitude,decimalLongitude=decimalLongitude,
    depth=depth,year=year,typeStatus=typeStatus,lastInterpreted=lastInterpreted,
    mediaType=mediaType, subgenusKey=subgenusKey,repatriated=repatriated,
    phylumKey=phylumKey, kingdomKey=kingdomKey,classKey=classKey,
    orderKey=orderKey, familyKey=familyKey,genusKey=genusKey,
    establishmentMeans=establishmentMeans,protocol=protocol, license=license,
    organismId=organismId,publishingOrg=publishingOrg,
    stateProvince=stateProvince,waterBody=waterBody, locality=locality,
    limit=limit
  )
  if (!any(sapply(params, length) > 0)) {
    stop(sprintf("At least one of the parmaters must have a value:\n%s",
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
    out <- .get_occ_data(curlopts = curlopts)
  } else {
    out <- lapply(iter[[1]], .get_occ_data, itervar = names(iter), 
      curlopts = curlopts)
    names(out) <- transform_names(iter[[1]])
  }

  if (any(names(argscoll) %in% names(iter))) {
    argscoll[[names(iter)]] <- iter[[names(iter)]]
  }

  structure(out, args = argscoll, class = "gbif_data",
            type = if (length(iter) == 0) "single" else "many")
}
