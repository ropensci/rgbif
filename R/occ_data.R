#' Legacy alternative to occ_search  
#'
#' @param taxonKey (numeric) A taxon key from the GBIF backbone. All included 
#' and synonym taxa are included in the search, so a search for aves with 
#' taxononKey=212 will match all birds, no matter which species. You can pass 
#' many keys to \code{occ_search(taxonKey=c(1,212))}.
#' @param scientificName A scientific name from the GBIF backbone. All included
#' and synonym taxa are included in the search.
#' @param country (character) The 2-letter country code (ISO-3166-1) 
#' in which the occurrence was recorded. \code{enumeration_country()}.
#' @param datasetKey (character) The occurrence dataset uuid key. That can be 
#' found in the dataset page url. For example, "7e380070-f762-11e1-a439-00145
#' eb45e9a" is the key for [Natural History Museum (London) Collection Specimens](https://www.gbif.org/dataset/7e380070-f762-11e1-a439-00145eb45e9a).
#' @param eventDate (character) Occurrence date in ISO 8601 format: yyyy, 
#' yyyy-MM, yyyy-MM-dd, or MM-dd. Supports range queries, 'smaller,larger' 
#' ('1990,1991', whereas '1991,1990' wouldn't work).
#' @param catalogNumber (character) An identifier of any form assigned by the 
#' source within a physical collection or digital dataset for the record which 
#' may not unique, but should be fairly unique in combination with the 
#' institution and collection code.
#' @param recordedBy (character) The person who recorded the occurrence.
#' @param recordedByID (character) Identifier (e.g. ORCID) for the person who
#' recorded the occurrence
#' @param identifiedByID (character) Identifier (e.g. ORCID) for the person who
#' provided the taxonomic identification of the occurrence.
#' @param collectionCode (character) An identifier of any form assigned by the 
#' source to identify the physical collection or digital dataset uniquely within 
#' the text of an institution.
#' @param institutionCode An identifier of any form assigned by the source to 
#' identify the institution the record belongs to.
#' @param basisOfRecord (character) The specific nature of the data record. See 
#' [here](https://gbif.github.io/parsers/apidocs/org/gbif/api/vocabulary/BasisOfRecord.html).
#'    
#'    \itemize{
#'      \item "FOSSIL_SPECIMEN" 
#'      \item "HUMAN_OBSERVATION" 
#'      \item "MATERIAL_CITATION" 
#'      \item "MATERIAL_SAMPLE" 
#'      \item "LIVING_SPECIMEN" 
#'      \item "MACHINE_OBSERVATION" 
#'      \item "OBSERVATION" 
#'      \item "PRESERVED_SPECIMEN" 
#'      \item "OCCURRENCE"  
#'    }
#' @param year The 4 digit year. A year of 98 will be interpreted as AD 98. 
#' Supports range queries, 'smaller,larger' (e.g., '1990,1991', whereas 1991,
#' 1990' wouldn't work).
#' @param month The month of the year, starting with 1 for January. Supports 
#' range queries, 'smaller,larger' (e.g., '1,2', whereas '2,1' wouldn't work).
#' @param search (character) Query terms. The value for this parameter can be a 
#' simple word or a phrase. For example, [search="puma"](https://www.gbif.org/occurrence/search?q=puma)
#' @param decimalLatitude Latitude in decimals between -90 and 90 based on 
#' WGS84. Supports range queries, 'smaller,larger' (e.g., '25,30', whereas 
#' '30,25' wouldn't work).
#' @param decimalLongitude Longitude in decimals between -180 and 180 based on 
#' WGS84. Supports range queries (e.g., '-0.4,-0.2', whereas '-0.2,-0.4' 
#' wouldn't work).
#' @param publishingCountry The 2-letter country code (as per ISO-3166-1) of 
#' the country in which the occurrence was recorded. See 
#' \code{enumeration_country()}. 
#' @param elevation Elevation in meters above sea level. Supports range 
#' queries, 'smaller,larger' (e.g., '5,30', whereas '30,5' wouldn't work).
#' @param depth Depth in meters relative to elevation. For example 10 meters 
#' below a lake surface with given elevation. Supports range queries, 
#' 'smaller,larger' (e.g., '5,30', whereas '30,5' wouldn't work). 
#' @param geometry (character) Searches for occurrences inside a polygon in 
#' Well Known Text (WKT) format. A WKT shape written as either 
#'  
#'  \itemize{
#'   \item "POINT"
#'   \item "LINESTRING" 
#'   \item "LINEARRING"
#'   \item "POLYGON"
#'   \item "MULTIPOLYGON"
#'  }
#'
#' For Example, "POLYGON((37.08 46.86,38.06 46.86,38.06 47.28,37.08 47.28,
#' 37.0 46.8))". See also the section **WKT** below.
#' @param geom_big (character) One"bbox" or "asis" (default). 
#' @param geom_size (integer) An integer indicating size of the cell. Default: 
#' 40.
#' @param geom_n (integer) An integer indicating number of cells in each 
#' dimension. Default: 10.
#' @param hasGeospatialIssue (logical) Includes/excludes occurrence records 
#' which contain spatial issues (as determined in our record interpretation), 
#' i.e. \code{hasGeospatialIssue=TRUE} returns only those records with spatial 
#' issues while \code{hasGeospatialIssue=FALSE} includes only records without 
#' spatial issues. The absence of this parameter returns any record with or 
#' without spatial issues.
#' @param issue (character) One or more of many possible issues with each 
#' occurrence record. Issues passed to this parameter filter results by 
#' the issue. One of many [options](https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html). 
#' See [here](https://data-blog.gbif.org/post/issues-and-flags/) for definitions.
#' @param hasCoordinate (logical) Return only occurrence records with lat/long 
#' data (\code{TRUE}) or all records (\code{FALSE}, default).
#' @param typeStatus Type status of the specimen. One of many 
#' [options](https://www.gbif.org/occurrence/search?type_status=PARATYPE). 
#' @param recordNumber Number recorded by collector of the data, different from 
#' GBIF record number. 
#' @param lastInterpreted Date the record was last modified in GBIF, in ISO 
#' 8601 format: yyyy, yyyy-MM, yyyy-MM-dd, or MM-dd.  Supports range queries, 
#' 'smaller,larger' (e.g., '1990,1991', whereas '1991,1990' wouldn't work).
#' @param continent The source supplied continent. 
#'
#' \itemize{
#'  \item "africa" 
#'  \item "antarctica" 
#'  \item "asia" 
#'  \item "europe" 
#'  \item "north_america"
#'  \item "oceania"
#'  \item "south_america"
#' }
#' 
#' Continent is not inferred but only populated if provided by the 
#' dataset publisher. Applying this filter may exclude many relevant records.
#' @param mediaType (character) Media type of "MovingImage", "Sound", or 
#' "StillImage".
#' @param repatriated (character) Searches for records whose publishing country
#' is different to the country where the record was recorded in.
#' @param kingdomKey (numeric) Kingdom classification key.
#' @param phylumKey (numeric) Phylum classification key.
#' @param classKey (numeric) Class classification key.
#' @param orderKey (numeric) Order classification key.
#' @param familyKey (numeric) Family classification key.
#' @param genusKey (numeric) Genus classification key.
#' @param speciesKey (numeric) Species classification key.
#' @param subgenusKey (numeric) Subgenus classification key.
#' @param establishmentMeans (character) provides information about whether an
#'  organism or organisms have been introduced to a given place and time through 
#'  the direct or indirect activity of modern humans.
#' 
#' \itemize{
#'  \item "Introduced"
#'  \item "Native"
#'  \item "NativeReintroduced"
#'  \item "Vagrant"
#'  \item "Uncertain"
#'  \item "IntroducedAssistedColonisation"
#'  }
#'  
#' @param degreeOfEstablishment (character) Provides information about degree to 
#' which an Organism survives, reproduces, and expands its range at the given 
#' place and time. One of many [options](https://www.gbif.org/occurrence/search?advanced=1&degree_of_establishment=Managed).
#' @param protocol (character) Protocol or mechanism used to provide the
#' occurrence record. One of many [options](https://www.gbif.org/occurrence/search?protocol=DWC_ARCHIVE&advanced=1).
#' @param license (character) The type license applied to the dataset or record.
#' 
#'  \itemize{
#'  \item "CC0_1_0"
#'  \item "CC_BY_4_0"
#'  \item "CC_BY_NC_4_0"
#'  }
#' 
#' @param organismId (numeric) An identifier for the Organism instance (as
#' opposed to a particular digital record of the Organism). May be a globally
#' unique identifier or an identifier specific to the data set.
#' @param publishingOrg (character) The publishing organization key (a UUID).
#' @param stateProvince (character) The name of the next smaller administrative
#' region than country (state, province, canton, department, region, etc.) in
#' which the Location occurs.
#' @param waterBody (character) The name of the water body in which the
#' locations occur
#' @param locality (character) The specific description of the place.
#' @param occurrenceStatus (character)  Default is "PRESENT". Specify whether 
#' search should return "PRESENT" or "ABSENT" data.
#' @param gadmGid (character) The gadm id of the area occurrences are desired 
#' from. https://gadm.org/.
#' @param coordinateUncertaintyInMeters A number or range between 0-1,000,000 
#' which specifies the desired coordinate uncertainty. A coordinateUncertainty
#' InMeters=1000 will be interpreted all records with exactly 1000m. Supports 
#' range queries, 'smaller,larger' (e.g., '1000,10000', whereas '10000,1000' 
#' wouldn't work).
#' @param verbatimScientificName (character) Scientific name as provided by the 
#' source.
#' @param verbatimTaxonId (character) The taxon identifier provided to GBIF by 
#' the data publisher.
#' @param eventId (character) identifier(s) for a sampling event.
#' @param identifiedBy (character)  names of people, groups, or organizations.
#' @param networkKey (character) The occurrence network key (a uuid) 
#' who assigned the Taxon to the subject.
#' @param occurrenceId (character) occurrence id from source. 
#' @param organismQuantity A number or range which 
#' specifies the desired organism quantity. An organismQuantity=5 
#' will be interpreted all records with exactly 5. Supports range queries, 
#' smaller,larger (e.g., '5,20', whereas '20,5' wouldn't work). 
#' @param organismQuantityType (character) The type of quantification system 
#' used for the quantity of organisms. For example, "individuals" or "biomass".
#' @param relativeOrganismQuantity (numeric) A relativeOrganismQuantity=0.1 will
#' be interpreted all records with exactly 0.1 The relative measurement of the 
#' quantity of the organism (a number between 0-1). Supports range queries,  
#' "smaller,larger" (e.g., '0.1,0.5', whereas '0.5,0.1' wouldn't work).
#' @param iucnRedListCategory (character) The IUCN threat status category. 
#' 
#' \itemize{
#'  \item "NE" (Not Evaluated) 
#'  \item "DD" (Data Deficient)
#'  \item "LC" (Least Concern)
#'  \item "NT" (Near Threatened)
#'  \item "VU" (Vulnerable)
#'  \item "EN" (Endangered)
#'  \item "CR" (Critically Endangered) 
#'  \item "EX" (Extinct)
#'  \item "EW" (Extinct in the Wild)
#'  }
#' @param lifeStage (character) the life stage of the occurrence. One of many 
#' [options](https://www.gbif.org/occurrence/search?advanced=1&life_stage=Tadpole).
#' @param isInCluster (logical) identify potentially related records on GBIF.
#' @param distanceFromCentroidInMeters A number or range. A value of "2000,*"
#' means at least 2km from known centroids. A value of "0" would mean occurrences 
#' exactly on known centroids. A value of "0,2000" would mean within 2km of 
#' centroids. Max value is 5000.
#' @param skip_validate (logical) whether to skip wellknown::validate_wkt call 
#' or not. passed down to check_wkt(). Default: TRUE
#' @param limit Number of records to return. Default: 500. Note that the per
#' request maximum is 300, but since we set it at 500 for the function, we
#' do two requests to get you the 500 records (if there are that many).
#' Note that there is a hard maximum of 100,000, which is calculated as the
#' \code{limit+start}, so \code{start=99,000} and \code{limit=2000} won't work
#' @param start Record number to start at. Use in combination with limit to
#' page through results. Note that we do the paging internally for you, but
#' you can manually set the \code{start} parameter
#' @param curlopts (list) 
#' 
#' @details 
#' This function is a legacy alternative to `occ_search()`. It is not 
#' recommended to use `occ_data()` as it is not as flexible as `occ_search()`.
#' New search terms will not be added to this function and it is only supported
#' for legacy reasons. 
#' 
#' @return An object of class `gbif_data`, which is a S3 class list, with
#' slots for metadata (`meta`) and the occurrence data itself
#' (`data`), and with attributes listing the user supplied arguments
#' and whether it was a "single" or "many" search; that is, if you supply
#' two values of the `datasetKey` parameter to searches are done, and
#' it's a "many". `meta` is a list of length four with offset, limit,
#' endOfRecords and count fields. `data` is a tibble (aka data.frame)
#' @export
#'
occ_data <- function(taxonKey=NULL,
                    scientificName=NULL, 
                    country=NULL,
                    publishingCountry=NULL,
                    hasCoordinate=NULL, 
                    typeStatus=NULL,
                    recordNumber=NULL,
                    lastInterpreted=NULL,
                    continent=NULL,
                    geometry=NULL,
                    geom_big="asis",
                    geom_size=40,
                    geom_n=10,
                    recordedBy=NULL,
                    recordedByID=NULL,
                    identifiedByID=NULL,
                    basisOfRecord=NULL,
                    datasetKey=NULL,
                    eventDate=NULL,
                    catalogNumber=NULL,
                    year=NULL,
                    month=NULL,
                    decimalLatitude=NULL,
                    decimalLongitude=NULL,
                    elevation=NULL,
                    depth=NULL,
                    institutionCode=NULL,
                    collectionCode=NULL,
                    hasGeospatialIssue=NULL,
                    issue=NULL,
                    search=NULL,
                    mediaType=NULL,
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
                    distanceFromCentroidInMeters = NULL,
                    skip_validate = TRUE,
                    limit=500,
                    start=0,
                    curlopts = list(http_version=2)) {

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
      list(
        hasCoordinate = hasCoordinate,
        hasGeospatialIssue = hasGeospatialIssue,
        occurrenceStatus = occurrenceStatus,
        q = search,
        repatriated = repatriated,
        limit = check_limit(as.integer(limit)),
        isInCluster = isInCluster,
        offset = check_limit(as.integer(start))
      )
    )
    args <- c(
      args,
      parse_issues(issue),
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
      convmany(distanceFromCentroidInMeters)
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
    distanceFromCentroidInMeters=distanceFromCentroidInMeters
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
