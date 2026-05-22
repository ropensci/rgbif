# Comprehensive rgbif API Function Mapping

This document maps all exported rgbif functions that make GBIF API calls, organized by function family.

## Occurrence Functions (occ_*)

### Search and Retrieval
```
occ_search: /occurrence/search (GET) [taxonKey, scientificName, country, publishingCountry, hasCoordinate, typeStatus, recordNumber, lastInterpreted, continent, geometry, recordedBy, recordedByID, identifiedByID, basisOfRecord, datasetKey, eventDate, catalogNumber, year, month, decimalLatitude, decimalLongitude, elevation, depth, institutionCode, collectionCode, hasGeospatialIssue, issue, search, mediaType, subgenusKey, repatriated, phylumKey, kingdomKey, classKey, orderKey, familyKey, genusKey, speciesKey, establishmentMeans, degreeOfEstablishment, protocol, license, organismId, publishingOrg, stateProvince, waterBody, locality, occurrenceStatus, gadmGid, coordinateUncertaintyInMeters, verbatimScientificName, eventId, identifiedBy, networkKey, verbatimTaxonId, occurrenceId, organismQuantity, organismQuantityType, relativeOrganismQuantity, iucnRedListCategory, lifeStage, isInCluster, distanceFromCentroidInMeters, geoDistance, sex, dwcaExtension, gbifId, gbifRegion, projectId, programme, preparations, datasetId, datasetName, publishedByGbifRegion, island, islandGroup, taxonId, taxonConceptId, taxonomicStatus, acceptedTaxonKey, collectionKey, institutionKey, otherCatalogNumbers, georeferencedBy, installationKey, hostingOrganizationKey, crawlId, modified, higherGeography, fieldNumber, parentEventId, samplingProtocol, sampleSizeUnit, pathway, gadmLevel0Gid, gadmLevel1Gid, gadmLevel2Gid, gadmLevel3Gid, earliestEonOrLowestEonothem, latestEonOrHighestEonothem, earliestEraOrLowestErathem, latestEraOrHighestErathem, earliestPeriodOrLowestSystem, latestPeriodOrHighestSystem, earliestEpochOrLowestSeries, latestEpochOrHighestSeries, earliestAgeOrLowestStage, latestAgeOrHighestStage, lowestBiostratigraphicZone, highestBiostratigraphicZone, group, formation, member, bed, associatedSequences, isSequenced, startDayOfYear, endDayOfYear, checklistKey, limit, start, fields, facet, facetMincount, facetMultiselect, skip_validate]

occ_data: /occurrence/search (GET) [taxonKey, scientificName, country, publishingCountry, hasCoordinate, typeStatus, recordNumber, lastInterpreted, continent, geometry, recordedBy, recordedByID, identifiedByID, basisOfRecord, datasetKey, eventDate, catalogNumber, year, month, decimalLatitude, decimalLongitude, elevation, depth, institutionCode, collectionCode, hasGeospatialIssue, issue, search, mediaType, subgenusKey, repatriated, phylumKey, kingdomKey, classKey, orderKey, familyKey, genusKey, speciesKey, establishmentMeans, degreeOfEstablishment, protocol, license, organismId, publishingOrg, stateProvince, waterBody, locality, occurrenceStatus, gadmGid, coordinateUncertaintyInMeters, verbatimScientificName, eventId, identifiedBy, networkKey, verbatimTaxonId, occurrenceId, organismQuantity, organismQuantityType, relativeOrganismQuantity, iucnRedListCategory, lifeStage, isInCluster, distanceFromCentroidInMeters, skip_validate, limit, start]

occ_get: /occurrence/{key} (GET) [key, fields]

occ_get_verbatim: /occurrence/{key}/verbatim (GET) [key, fields]

occ_facet: /occurrence/search (GET) [facet, facetMincount]
```

### Pre-computed Counts
```
occ_count_country: /occurrence/counts/countries (GET) [publishingCountry]

occ_count_pub_country: /occurrence/counts/publishingCountries (GET) [country]

occ_count_year: /occurrence/counts/year (GET) [year]

occ_count_basis_of_record: /occurrence/counts/basisOfRecord (GET) []
```

## Occurrence Download Functions (occ_download_*)

### Download Creation and Management
```
occ_download: /occurrence/download/request (POST) [body, type, format, verbatim_extensions, checklistKey, user, pwd, email]

occ_download_prep: /occurrence/download/request (PREP) [body, type, format, verbatim_extensions, checklistKey, user, pwd, email]

occ_download_sql: /occurrence/download/request (POST) [q, format, user, pwd, email, validate]

occ_download_list: /occurrence/download/user/{user} (GET) [user, pwd, limit, start]

occ_download_meta: /occurrence/download/{key} (GET) [key]

occ_download_get: /occurrence/download/request/{key} (GET) [key, path, overwrite]

occ_download_cancel: /occurrence/download/request/{key} (DELETE) [key, user, pwd]

occ_download_describe: /occurrence/download/describe/{format} (GET) [x]

occ_download_dataset_activity: /occurrence/download/dataset/{datasetKey} (GET) [dataset, limit, start]
```

### Download Statistics
```
occ_download_stats: /occurrence/download/statistics (GET) [from, to, publishingCountry, datasetKey, publishingOrgKey, limit, offset]

occ_download_stats_export: /occurrence/download/statistics/export (GET) [from, to, publishingCountry, datasetKey, publishingOrgKey, limit, offset]

occ_download_stats_user_country: /occurrence/download/statistics/downloadsByUserCountry (GET) [from, to, userCountry, publishingCountry]

occ_download_stats_dataset_records: /occurrence/download/statistics/downloadedRecordsByDataset (GET) [from, to, publishingCountry, datasetKey, publishingOrgKey]

occ_download_stats_dataset: /occurrence/download/statistics/downloadsByDataset (GET) [from, to, publishingCountry, datasetKey, publishingOrgKey]

occ_download_stats_source: /occurrence/download/statistics/downloadsBySource (GET) [from, to, source]
```

## Dataset Functions (dataset_*)

### Search and Discovery
```
dataset_search: /dataset/search (GET) [query, type, publishingCountry, subtype, license, keyword, publishingOrg, hostingOrg, endorsingNodeKey, decade, projectId, hostingCountry, networkKey, doi, installationKey, endpointType, category, facet, facetLimit, facetOffset, facetMincount, facetMultiselect, limit, start, description]

dataset: /dataset/ or /dataset/deleted/ (GET) [country, type, identifierType, identifier, machineTagNamespace, machineTagName, machineTagValue, modified, query, deleted, limit, start]

dataset_suggest: /dataset/suggest (GET) [query, type, publishingCountry, subtype, license, keyword, publishingOrg, hostingOrg, endorsingNodeKey, decade, projectId, hostingCountry, networkKey, doi, category, limit, start, description]

dataset_doi: /dataset/doi/{doi} (GET) [doi, limit, start]

dataset_gridded: /dataset/{uuid}/gridded (GET) [uuid, min_dis, min_per, return, min_dis_count, warn]
```

### Dataset Details by UUID
```
dataset_get: /dataset/{uuid} (GET) [uuid]

dataset_process: /dataset/{uuid}/process (GET) [uuid, limit, start]

dataset_networks: /dataset/{uuid}/networks (GET) [uuid, limit, start]

dataset_constituents: /dataset/{uuid}/constituents (GET) [uuid, limit, start]

dataset_comment: /dataset/{uuid}/comment (GET) [uuid]

dataset_contact: /dataset/{uuid}/contact (GET) [uuid]

dataset_endpoint: /dataset/{uuid}/endpoint (GET) [uuid]

dataset_identifier: /dataset/{uuid}/identifier (GET) [uuid]

dataset_machinetag: /dataset/{uuid}/machineTag (GET) [uuid]

dataset_tag: /dataset/{uuid}/tag (GET) [uuid]

dataset_metrics: /dataset/{uuid}/metrics (GET) [uuid]
```

### Dataset Lists
```
dataset_duplicate: /dataset/duplicate/ (GET) [limit, start]

dataset_noendpoint: /dataset/withNoEndpoint/ (GET) [limit, start]
```

## Taxonomic Name Functions (name_*)

```
name_lookup: /species/search (GET) [query, rank, higherTaxonKey, status, isExtinct, habitat, nameType, datasetKey, origin, nomenclaturalStatus, limit, start, facet, facetMincount, facetMultiselect, type, hl, issue, constituentKey, verbose]

name_backbone: /species/match (GET) [name, rank, kingdom, phylum, class, order, superfamily, family, subfamily, tribe, subtribe, genus, subgenus, species, usageKey, taxonID, taxonConceptID, scientificNameID, scientificNameAuthorship, genericName, specificEpithet, infraspecificEpithet, verbatimTaxonRank, exclude, strict, verbose, checklistKey, start, limit]

name_suggest: /species/suggest (GET) [q, datasetKey, rank, fields, start, limit]

name_usage: /species/{key} (GET) [key, name, data, language, datasetKey, uuid, sourceId, rank, limit, start]

name_parse: /parser/name (POST) [scientificname]
```

## GRSciColl Functions

### Collections
```
collection_search: /grscicoll/collection (GET) [query, name, fuzzyName, preservationType, contentType, numberSpecimens, accessionStatus, personalCollection, sourceId, source, code, alternativeCode, contact, institutionKey, country, city, gbifRegion, machineTagNamespace, machineTagName, machineTagValue, identifier, identifierType, active, displayOnNHCPortal, masterSourceType, replacedBy, sortBy, sortOrder, offset, limit, format]
```

### Institutions
```
institution_search: /grscicoll/institution (GET) [query, type, institutionalGovernance, disciplines, name, fuzzyName, numberSpecimens, occurrenceCount, typeSpecimenCount, sourceId, source, code, alternativeCode, contact, institutionKey, country, city, gbifRegion, machineTagNamespace, machineTagName, machineTagValue, identifier, identifierType, active, displayOnNHCPortal, masterSourceType, replacedBy, sortBy, sortOrder, offset, limit, format]
```

## Literature Functions (lit_*)

```
lit_search: /literature/search (GET) [q, countriesOfResearcher, countriesOfCoverage, literatureType, relevance, year, topics, datasetKey, publishingOrg, peerReview, openAccess, downloadKey, doi, journalSource, journalPublisher, flatten, abstract, limit]
```

## Registry Entity Functions

### Networks
```
networks: /network (GET) [data, uuid, query, identifier, identifierType, limit, start]
```

### Nodes
```
nodes: /node (GET) [data, uuid, query, identifier, identifierType, limit, start, isocode]
```

### Organizations
```
organizations: /organization (GET) [data, country, uuid, query, limit, start]
```

### Installations
```
installations: /installation (GET) [data, uuid, query, identifier, identifierType, limit, start]

installation_search: /installation (GET) [query, type, identifierType, identifier, machineTagNamespace, machineTagName, machineTagValue, modified, limit, offset]
```

## Derived Dataset Functions

```
derived_dataset: /derivedDataset (POST) [citation_data, title, description, source_url, gbif_download_doi, user, pwd]

derived_dataset_prep: /derivedDataset (PREP) [citation_data, title, description, source_url, gbif_download_doi, user, pwd]
```

## Geocoding Functions

```
gbif_geocode: /geocode/reverse (GET) [latitude, longitude]
```

## Enumeration Functions

```
enumeration: /enumeration/basic/{type} (GET) [x]

enumeration_country: /enumeration/country/ (GET) []
```

## Summary Statistics

- **Total API-calling functions**: 72
- **Occurrence functions**: 13
- **Download functions**: 15
- **Dataset functions**: 19
- **Name/taxonomy functions**: 5
- **GRSciColl functions**: 2
- **Literature functions**: 1
- **Registry functions**: 5
- **Derived dataset functions**: 2
- **Geocoding functions**: 1
- **Enumeration functions**: 2
- **Deprecated/legacy functions**: 7 (networks, occ_facet, etc.)

## Notes

1. Functions ending with `_prep` are preparation functions that validate but don't execute API calls
2. Some functions like `dataset`, `nodes`, `organizations`, `installations`, `networks` have a `data` parameter that modifies the endpoint path
3. Export functions (e.g., `collection_export`, `institution_export`, `lit_export`, `dataset_export`) download full results but use the same base endpoints as their search counterparts
4. All functions accept a `curlopts` parameter for curl options (excluded from parameter lists above for brevity)
5. The `...` parameter (variadic arguments) is excluded from listings where present
