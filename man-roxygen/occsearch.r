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
#' @param geoDistance (character) Filters to match occurrence records with coordinate values
#' within a specified distance of a coordinate. Distance may be specified in 
#' kilometres (km) or metres (m). Example : "90,100,5km"
#' @param sex (character) The sex of the biological individual(s) represented in the occurrence.
#' @param dwcaExtension (character) A known Darwin Core Archive extension RowType. 
#' Limits the search to occurrences which have this extension, although they will 
#' not necessarily have any useful data recorded using the extension.
#' @param gbifId (numeric) The unique GBIF key for a single occurrence.
#' @param gbifRegion (character) Gbif region based on country code.
#' @param projectId (character) The identifier for a project, which is often 
#' assigned by a funded programme.
#' @param programme (character) A group of activities, often associated with a 
#' specific funding stream, such as the GBIF BID programme.
#' @param preparations (character) Preparation or preservation method for 
#' a specimen.
#' @param datasetId (character) The ID of the dataset. Parameter may be 
#' repeated. Example : https://doi.org/10.1594/PANGAEA.315492
#' @param datasetName (character) The exact name of the dataset. Not the same as
#' dataset title. 
#' @param publishedByGbifRegion (character) GBIF region based on the owning 
#' organization's country.
#' @param island (character) The name of the island on or near which the 
#' location occurs.
#' @param islandGroup (character) The name of the island group in which the 
#' location occurs.
#' @param taxonId (character) The taxon identifier provided to GBIF by the data 
#' publisher. Example : urn:lsid:dyntaxa.se:Taxon:103026
#' @param taxonConceptId (character) An identifier for the taxonomic concept to 
#' which the record refers - not for the nomenclatural details of a taxon. 
#' Example : 8fa58e08-08de-4ac1-b69c-1235340b7001
#' @param taxonomicStatus (character) A taxonomic status. Example : SYNONYM
#' @param acceptedTaxonKey (numeric) A taxon key from the GBIF backbone. Only 
#' synonym taxa are included in the search, so a search for Aves with 
#' acceptedTaxonKey=212 will match occurrences identified as birds, but not 
#' any known family, genus or species of bird.
#' @param collectionKey (character) A key (UUID) for a collection registered in 
#' the Global Registry of Scientific Collections. 
#' Example : dceb8d52-094c-4c2c-8960-75e0097c6861
#' @param institutionKey (character) A key (UUID) for an institution registered 
#' in the Global Registry of Scientific Collections.
#' @param otherCatalogNumbers (character) Previous or alternate fully qualified 
#' catalog numbers.
#' @param georeferencedBy (character) Name of a person, group, or organization
#' who determined the georeference (spatial representation) for the location. 
#' Example : Brad Millen
#' @param installationKey (character) The occurrence installation key (a UUID).
#' Example : 17a83780-3060-4851-9d6f-029d5fcb81c9
#' @param hostingOrganizationKey (character) The key (UUID) of the publishing 
#' organization whose installation (server) hosts the original dataset. 
#' Example : fbca90e3-8aed-48b1-84e3-369afbd000ce
#' @param crawlId (numeric) Crawl attempt that harvested this record.
#' @param modified (character) The most recent date-time on which the 
#' occurrence was changed, according to the publisher. Can be a range. 
#' Example : 2023-02-20
#' @param higherGeography (character) Geographic name less specific than the 
#' information captured in the locality term.
#' @param fieldNumber (character) An identifier given to the event in the field.
#' Often serves as a link between field notes and the event.
#' @param parentEventId (character) An identifier for the information associated
#' with a sampling event.
#' @param samplingProtocol (character) The name of, reference to, or description
#' of the method or protocol used during a sampling event. 
#' Example : malaise trap
#' @param sampleSizeUnit (character) The unit of measurement of the size 
#' (time duration, length, area, or volume) of a sample in a sampling event. 
#' Example : hectares
#' @param pathway (character) The process by which an organism came to be in a 
#' given place at a given time, as defined in the GBIF Pathway vocabulary. 
#' Example : Agriculture
#' @param gadmLevel0Gid (character) A GADM geographic identifier at the zero 
#' level, for example AGO.
#' @param gadmLevel1Gid (character) A GADM geographic identifier at the first 
#' level, for example AGO.1_1.
#' @param gadmLevel2Gid (character) A GADM geographic identifier at the second 
#' level, for example AFG.1.1_1.
#' @param gadmLevel3Gid (character) A GADM geographic identifier at the third 
#' level, for example AFG.1.1.1_1.
#' @param earliestEonOrLowestEonothem (character) geochronologic era term.
#' @param latestEonOrHighestEonothem (character) geochronologic era term.
#' @param earliestEraOrLowestErathem (character) geochronologic era term.
#' @param latestEraOrHighestErathem (character) geochronologic era term.
#' @param earliestPeriodOrLowestSystem (character) geochronologic era term.
#' @param latestPeriodOrHighestSystem (character) geochronologic era term.
#' @param earliestEpochOrLowestSeries (character) geochronologic era term.
#' @param latestEpochOrHighestSeries (character) geochronologic era term.
#' @param earliestAgeOrLowestStage (character) geochronologic era term.
#' @param latestAgeOrHighestStage (character) geochronologic era term.
#' @param lowestBiostratigraphicZone (character) geochronologic era term.
#' @param highestBiostratigraphicZone (character) geochronologic era term.
#' @param group (character) The full name of the lithostratigraphic group from 
#' which the material entity was collected.
#' @param formation (character) The full name of the lithostratigraphic 
#' formation from which the material entity was collected.
#' @param member (character) The full name of the lithostratigraphic member 
#' from which the material entity was collected.
#' @param bed (character) The full name of the lithostratigraphic bed from 
#' which the material entity was collected.
#' @param associatedSequences (character) Identifier (publication, global unique
#' identifier, URI) of genetic sequence information associated with the 
#' material entity. Example : http://www.ncbi.nlm.nih.gov/nuccore/U34853.1
#' @param isSequenced (logical) Indicates whether `associatedSequences` genetic 
#' sequence information exists.
#' @param startDayOfYear (numeric) The earliest integer day of the year on 
#' which the event occurred.
#' @param endDayOfYear (numeric) The latest integer day of the year on 
#' which the event occurred.
#' @param skip_validate (logical) whether to skip `wellknown::validate_wkt`
#' call or not. passed down to [check_wkt()]. Default: `TRUE`
#' @param checklistKey (character) The checklist uuid. This determines which taxonomy 
#' will be used for the search in conjunction with other taxon keys or scientificName. 
#' If this is not specified, the GBIF backbone taxonomy will be used.

#' 
#' @section Multiple values passed to a parameter:
#' There are some parameters you can pass multiple values to in a vector,
#' each value of which produces a different request (multiple different
#' requests = c("a","b")). Some parameters allow multiple values to be passed 
#' in the same request (multiple same request = "a;b") in a semicolon separated 
#' string (e.g., 'a;b'); if given we'll do a single request with that parameter
#' repeated for each value given (e.g., `foo=a&foo=b` if the parameter
#' is `foo`).  
#' 
#' See article [Multiple Values](https://docs.ropensci.org/rgbif/articles/multiple_values.html).
#' 
#' @section Hierarchies:
#' Hierarchies are returned with each occurrence object. There is no
#' option to return them from the API. However, within the \code{occ_search}
#' function you can select whether to return just hierarchies, just data, all
#' of data and hierarchies and metadata, or just metadata. If all hierarchies
#' are the same we just return one for you.
#'
#' @section curl debugging:
#' You can pass parameters not defined in this function into the call to
#' the GBIF API to control things about the call itself using \code{curlopts}.
#' See an example below that passes in the \code{verbose} function to get
#' details on the http call.
#'
#' @section WKT:
#' Examples of valid WKT objects:
#' \itemize{
#'  \item 'POLYGON((-19.5 34.1, 27.8 34.1, 35.9 68.1, -25.3 68.1, -19.5 34.1))'
#'  \item 'MULTIPOLYGON(((-123 38,-116 38,-116 43,-123 43,-123 38)),((-97 41,-93 41,-93 45,-97 45,-97 41)))'
#'  \item 'POINT(-120 40)'
#'  \item 'LINESTRING(3 4,10 50,20 25)'
#' }
#'
#' Note that GBIF expects counter-clockwise winding order for WKT. You can
#' supply clockwise WKT, but GBIF treats it as an exclusion, so you get all
#' data not inside the WKT area. [occ_download()] behaves differently
#' in that you should simply get no data back at all with clockwise WKT.
#'
#' @section Long WKT:
#' Options for handling long WKT strings:
#' Note that long WKT strings are specially handled when using \code{\link{occ_search}} or
#' \code{\link{occ_data}}. Here are the three options for long WKT strings (> 1500 characters),
#' set one of these three via the parameter \code{geom_big}:
#' \itemize{
#'  \item asis - the default setting. This means we don't do anything internally. That is,
#'  we just pass on your WKT string just as we've done before in this package.
#'  \item axe - this option is deprecated since rgbif v3.8.0. Might return error, 
#'  since the GBIF's polygon interpretation has changed. 
#'
#'  This method uses \code{sf::st_make_grid} and \code{sf::st_intersection}, which has 
#'  two parameters \code{cellsize} and \code{n}. You can tweak those parameters here by
#'  tweaking \code{geom_size} and \code{geom_n}. \code{geom_size} seems to be more useful in
#'  toggling the number of WKT strings you get back.
#'
#'  See \code{\link{wkt_parse}} to manually break make WKT bounding box from a larger WKT
#'  string, or break a larger WKT string into many smaller ones.
#'
#'  \item bbox - this option checks whether your WKT string is longer than 1500 characters,
#'  and if it is we create a bounding box from the WKT, do the GBIF search with that
#'  bounding box, then prune the resulting data to only those occurrences in your original
#'  WKT string. There is a big caveat however. Because we create a bounding box from the WKT,
#'  and the \code{limit} parameter determines some subset of records to get, then when we
#'  prune the resulting data to the WKT, the number of records you get could be less than
#'  what you set with your \code{limit} parameter. However, you could set the limit to be
#'  high enough so that you get all records back found in that bounding box, then you'll
#'  get all the records available within the WKT.
#' }
#'
#'
#' @section Counts:
#' There is a slight difference in the way records are counted here vs.
#' results from \code{\link{occ_count}}. For equivalent outcomes, in this
#' function use \code{hasCoordinate=TRUE}, and \code{hasGeospatialIssue=FALSE}
#' to have the same outcome using \code{\link{occ_count}} with
#' \code{isGeoreferenced=TRUE}
#'
#' @references https://www.gbif.org/developer/occurrence#search

