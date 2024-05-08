#' Search for GBIF occurrences
#'
#' @export
#' @template occsearch
#' @template oslimstart
#' @template occ
#' @template occ_search_egs
#' @template occfacet
#' @param fields (character) Default ('all') returns all fields. 'minimal'
#' returns just taxon name, key, datasetKey, latitude, and longitute. Or specify each field
#' you want returned by name, e.g. fields = c('name','latitude','elevation').
#' @param return Defunct. All components (meta, hierarchy, data, media,
#' facets) are returned now; index to the one(s) you want. See [occ_data()]
#' if you just want the data component
#' @param ... additional facet parameters
#' @seealso [downloads()], [occ_data()]
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

occ_search <- function(taxonKey = NULL,
                       scientificName = NULL,
                       country = NULL,
                       publishingCountry = NULL, 
                       hasCoordinate = NULL, 
                       typeStatus = NULL,
                       recordNumber = NULL,
                       lastInterpreted = NULL,
                       continent = NULL,
                       geometry = NULL,
                       geom_big = "asis",
                       geom_size = 40,
                       geom_n = 10,
                       recordedBy = NULL,
                       recordedByID = NULL,
                       identifiedByID =NULL,
                       basisOfRecord = NULL,
                       datasetKey = NULL,
                       eventDate = NULL,
                       catalogNumber = NULL,
                       year = NULL,
                       month = NULL,
                       decimalLatitude = NULL,
                       decimalLongitude = NULL,
                       elevation = NULL,
                       depth = NULL,
                       institutionCode = NULL,
                       collectionCode = NULL,
                       hasGeospatialIssue = NULL,
                       issue = NULL,
                       search = NULL,
                       mediaType = NULL,
                       subgenusKey = NULL,
                       repatriated = NULL,
                       phylumKey = NULL,
                       kingdomKey = NULL,
                       classKey = NULL,
                       orderKey = NULL,
                       familyKey = NULL,
                       genusKey = NULL,
                       speciesKey = NULL,
                       establishmentMeans = NULL,
                       degreeOfEstablishment = NULL,
                       protocol = NULL,
                       license = NULL,
                       organismId = NULL,
                       publishingOrg = NULL,
                       stateProvince = NULL,
                       waterBody = NULL,
                       locality = NULL,
                       occurrenceStatus = 'PRESENT',
                       gadmGid = NULL,
                       coordinateUncertaintyInMeters = NULL,
                       verbatimScientificName = NULL,
                       eventId = NULL,
                       identifiedBy = NULL,
                       networkKey = NULL,
                       verbatimTaxonId = NULL,
                       occurrenceId = NULL,
                       organismQuantity = NULL,
                       organismQuantityType = NULL,
                       relativeOrganismQuantity = NULL,
                       iucnRedListCategory = NULL,
                       lifeStage = NULL,
                       isInCluster = NULL,
                       distanceFromCentroidInMeters=NULL,
                       sex = NULL,
                       dwcaExtension = NULL,
                       gbifId = NULL,
                       gbifRegion = NULL,
                       projectId = NULL,
                       programme = NULL,
                       preparations = NULL,
                       datasetId = NULL,
                       datasetName = NULL,
                       publishedByGbifRegion = NULL,
                       island = NULL,
                       islandGroup = NULL,
                       recordedById = NULL,
                       taxonId = NULL,
                       taxonConceptId = NULL,
                       taxonomicStatus = NULL,
                       acceptedTaxonKey = NULL,
                       collectionKey = NULL,
                       institutionKey = NULL,
                       otherCatalogNumbers = NULL,
                       georeferencedBy = NULL,
                       installationKey = NULL,
                       hostingOrganizationKey = NULL,
                       crawlId = NULL,
                       modified = NULL,
                       higherGeography = NULL,
                       fieldNumber = NULL,
                       parentEventId = NULL,
                       samplingProtocol = NULL,
                       sampleSizeUnit = NULL,
                       pathway = NULL,
                       gadmLevel0Gid = NULL,
                       gadmLevel1Gid = NULL,
                       gadmLevel2Gid = NULL,
                       gadmLevel3Gid = NULL,
                       earliestEonOrLowestEonothem = NULL,
                       latestEonOrHighestEonothem = NULL,
                       earliestEraOrLowestErathem = NULL,
                       latestEraOrHighestErathem = NULL,
                       earliestPeriodOrLowestSystem = NULL,
                       latestPeriodOrHighestSystem = NULL,
                       earliestEpochOrLowestSeries = NULL,
                       latestEpochOrHighestSeries = NULL,
                       earliestAgeOrLowestStage = NULL,
                       latestAgeOrHighestStage = NULL,
                       lowestBiostratigraphicZone = NULL,
                       highestBiostratigraphicZone = NULL,
                       group = NULL,
                       formation = NULL,
                       member = NULL,
                       bed = NULL,
                       associatedSequences = NULL,
                       isSequenced = NULL,
                       startDayOfYear = NULL,
                       endDayOfYear = NULL,
                       limit = 500,
                       start = 0,
                       fields = 'all',
                       return = NULL,
                       facet = NULL,
                       facetMincount = NULL,
                       facetMultiselect = NULL,
                       skip_validate = TRUE,
                       curlopts = list(http_version=2), 
                       ...) {
  
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
    
    # args that take a single value
    args <- rgbif_compact(
      list(
        hasCoordinate = hasCoordinate,
        hasGeospatialIssue = hasGeospatialIssue,
        occurrenceStatus = occurrenceStatus,
        q = search,
        repatriated = repatriated,
        isSequenced = isSequenced,
        limit = check_limit(as.integer(limit)),
        isInCluster = isInCluster,
        offset = check_limit(as.integer(start))
      )
    )
    # args that can take multiple values 
    args <- c(
      args, 
      parse_issues(issue),
      collargs("facet"),
      yank_args(...),
      convmany(lastInterpreted),
      convmany(decimalLatitude),
      convmany(decimalLongitude),
      convmany(elevation),
      convmany(depth), 
      convmany(eventDate), 
      convmany(month), 
      convmany(year),
      convmany(coordinateUncertaintyInMeters),
      convmany(organismQuantity),
      convmany(organismQuantityType),
      convmany(relativeOrganismQuantity),
      convmany(taxonKey),
      convmany(scientificName),
      convmany(country),
      convmany(publishingCountry),
      convmany(datasetKey),
      convmany(typeStatus),
      convmany(recordNumber),
      convmany(continent),
      convmany(recordedBy),
      convmany(recordedByID),
      convmany(identifiedByID),
      convmany(catalogNumber),
      convmany(institutionCode),
      convmany(collectionCode),
      convmany(geometry),
      convmany(mediaType),
      convmany(subgenusKey),
      convmany(phylumKey),
      convmany(kingdomKey),
      convmany(classKey),
      convmany(orderKey),
      convmany(familyKey),
      convmany(genusKey),
      convmany(speciesKey),
      convmany(establishmentMeans),
      convmany(degreeOfEstablishment),
      convmany(protocol),
      convmany(license),
      convmany(organismId),
      convmany(publishingOrg),
      convmany(stateProvince),
      convmany(waterBody),
      convmany(locality),
      convmany(basisOfRecord),
      convmany(gadmGid),
      convmany(verbatimScientificName),
      convmany(eventId),
      convmany(identifiedBy),
      convmany(networkKey),
      convmany(occurrenceId),
      convmany(iucnRedListCategory),
      convmany(lifeStage),
      convmany(distanceFromCentroidInMeters),
      convmany(sex),
      convmany(dwcaExtension),
      convmany(gbifId),
      convmany(gbifRegion),
      convmany(projectId),
      convmany(programme),
      convmany(preparations),
      convmany(datasetId),
      convmany(datasetName),
      convmany(publishedByGbifRegion),
      convmany(island),
      convmany(islandGroup),
      convmany(taxonId),
      convmany(taxonConceptId),
      convmany(taxonomicStatus),
      convmany(acceptedTaxonKey),
      convmany(collectionKey),
      convmany(institutionKey),
      convmany(otherCatalogNumbers),
      convmany(georeferencedBy),
      convmany(installationKey),
      convmany(hostingOrganizationKey),
      convmany(crawlId),
      convmany(modified),
      convmany(higherGeography),
      convmany(fieldNumber),
      convmany(parentEventId),
      convmany(samplingProtocol),
      convmany(sampleSizeUnit),
      convmany(pathway),
      convmany(gadmLevel0Gid),
      convmany(gadmLevel1Gid),
      convmany(gadmLevel2Gid),
      convmany(gadmLevel3Gid),
      convmany(earliestEonOrLowestEonothem),
      convmany(latestEonOrHighestEonothem),
      convmany(earliestEraOrLowestErathem),
      convmany(latestEraOrHighestErathem),
      convmany(earliestPeriodOrLowestSystem),
      convmany(latestPeriodOrHighestSystem),
      convmany(earliestEpochOrLowestSeries),
      convmany(latestEpochOrHighestSeries),
      convmany(earliestAgeOrLowestStage),
      convmany(latestAgeOrHighestStage),
      convmany(lowestBiostratigraphicZone),
      convmany(highestBiostratigraphicZone),
      convmany(group),
      convmany(formation),
      convmany(member),
      convmany(bed),
      convmany(associatedSequences),
      convmany(startDayOfYear),
      convmany(endDayOfYear)
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
    taxonKey=taxonKey,
    scientificName=scientificName,
    datasetKey=datasetKey,
    catalogNumber=catalogNumber,
    recordedBy=recordedBy,
    recordedByID=recordedByID,
    identifiedByID=identifiedByID,
    geometry=geometry,
    country=country,
    publishingCountry=publishingCountry,
    recordNumber=recordNumber,
    q=search,
    institutionCode=institutionCode,
    collectionCode=collectionCode,
    continent=continent,
    decimalLatitude=decimalLatitude,
    decimalLongitude=decimalLongitude,
    depth=depth,
    year=year,
    typeStatus=typeStatus,
    lastInterpreted=lastInterpreted,
    mediaType=mediaType,
    subgenusKey=subgenusKey,
    repatriated=repatriated,
    phylumKey=phylumKey,
    kingdomKey=kingdomKey,
    classKey=classKey,
    orderKey=orderKey,
    familyKey=familyKey,
    genusKey=genusKey,
    speciesKey=speciesKey,
    establishmentMeans=establishmentMeans,
    protocol=protocol,
    license=license,
    organismId=organismId,
    publishingOrg=publishingOrg,
    stateProvince=stateProvince,
    waterBody=waterBody,
    locality=locality,
    limit=limit, 
    basisOfRecord=basisOfRecord, 
    occurrenceStatus=occurrenceStatus,
    gadmGid=gadmGid,
    verbatimScientificName=verbatimScientificName,
    eventId=eventId,
    identifiedBy=identifiedBy,
    networkKey=networkKey,
    occurrenceId=occurrenceId,
    organismQuantity=organismQuantity,
    organismQuantityType=organismQuantityType,
    relativeOrganismQuantity=relativeOrganismQuantity,
    iucnRedListCategory=iucnRedListCategory,
    lifeStage=lifeStage,
    coordinateUncertaintyInMeters=coordinateUncertaintyInMeters,
    distanceFromCentroidInMeters=distanceFromCentroidInMeters,
    sex=sex,
    dwcaExtension=dwcaExtension,
    gbifId=gbifId,
    gbifRegion=gbifRegion,
    projectId=projectId,
    programme=programme,
    preparations=preparations,
    datasetId=datasetId,
    datasetName=datasetName,
    publishedByGbifRegion=publishedByGbifRegion,
    island=island,
    islandGroup=islandGroup,
    taxonId=taxonId,
    taxonConceptId=taxonConceptId,
    taxonomicStatus=taxonomicStatus,
    acceptedTaxonKey=acceptedTaxonKey,
    collectionKey=collectionKey,
    institutionKey=institutionKey,
    otherCatalogNumbers=otherCatalogNumbers,
    georeferencedBy=georeferencedBy,
    installationKey=installationKey,
    hostingOrganizationKey=hostingOrganizationKey,
    crawlId=crawlId,
    modified=modified,
    higherGeography=higherGeography,
    fieldNumber=fieldNumber,
    parentEventId=parentEventId,
    samplingProtocol=samplingProtocol,
    sampleSizeUnit=sampleSizeUnit,
    pathway=pathway,
    gadmLevel0Gid=gadmLevel0Gid,
    gadmLevel1Gid=gadmLevel1Gid,
    gadmLevel2Gid=gadmLevel2Gid,
    gadmLevel3Gid=gadmLevel3Gid,
    earliestEonOrLowestEonothem=earliestEonOrLowestEonothem,
    latestEonOrHighestEonothem=latestEonOrHighestEonothem,
    earliestEraOrLowestErathem=earliestEraOrLowestErathem,
    latestEraOrHighestErathem=latestEraOrHighestErathem,
    earliestPeriodOrLowestSystem=earliestPeriodOrLowestSystem,
    latestPeriodOrHighestSystem=latestPeriodOrHighestSystem,
    earliestEpochOrLowestSeries=earliestEpochOrLowestSeries,
    latestEpochOrHighestSeries=latestEpochOrHighestSeries,
    earliestAgeOrLowestStage=earliestAgeOrLowestStage,
    latestAgeOrHighestStage=latestAgeOrHighestStage,
    lowestBiostratigraphicZone=lowestBiostratigraphicZone,
    highestBiostratigraphicZone=highestBiostratigraphicZone,
    group=group,
    formation=formation,
    member=member,
    bed=bed,
    associatedSequences=associatedSequences,
    isSequenced=isSequenced,
    startDayOfYear=startDayOfYear,
    endDayOfYear=endDayOfYear
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
    stop("Maximum request size is 1 million. Please use occ_download() for large requests.")
  } else {
    x
  }
}

possparams <- function(){
  "taxonKey, speciesKey, scientificName, datasetKey, catalogNumber, recordedBy,
  recordedByID, identifiedByID, geometry, country, publishingCountry,
  recordNumber, search, institutionCode, collectionCode, decimalLatitude,
  decimalLongitude, depth, year, typeStatus, lastInterpreted, occurrenceStatus,
  continent, gadmGid, verbatimScientificName, eventId, identifiedBy, networkKey, 
  occurrenceId, iucnRedListCategory, lifeStage, degreeOfEstablishment, 
  distanceFromCentroidInMeters, or mediatype"
}
