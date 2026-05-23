# GBIF API Coverage Report
Generated: 2026-05-23 05:23:29.481861

## Summary

- **Total API endpoints:** 444
- **Ignored endpoints:** 313
- **Relevant endpoints:** 131
- **Implemented endpoints:** 127
- **Missing endpoints:** 0
- **Coverage:** 96.9%
- **Functions with missing parameters:** 22

## Functions with Missing Parameters

> **Actions:** Check boxes below and run the `Process Coverage Actions` workflow to automatically update api-mapping.json and create GitHub issues.

### occ_count - GET /occurrence/search
- **Missing parameters:**
  - `nucleotideSequence.nucleotideSequenceID`
  - `nucleotideSequence.targetGene`
  - `nucleotideSequence.sequence`
  - `nucleotideSequence.sequenceLength`
  - `nucleotideSequence.gcContent`
  - `nucleotideSequence.nonIupacFraction`
  - `nucleotideSequence.nonACGTNFraction`
  - `nucleotideSequence.nFraction`
  - `nucleotideSequence.nRunsCapped`
  - `nucleotideSequence.naturalLanguageDetected`
  - `nucleotideSequence.endsTrimmed`
  - `nucleotideSequence.gapsOrWhitespaceRemoved`
  - `nucleotideSequence.invalid`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### occ_download_stats - GET /occurrence/download/statistics
- **Missing parameters:**
  - `fromDate`
  - `toDate`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### occ_download_stats_export - GET /occurrence/download/statistics/export
- **Missing parameters:**
  - `fromDate`
  - `toDate`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### occ_download_stats_user_country - GET /occurrence/download/statistics/downloadsByUserCountry
- **Missing parameters:**
  - `fromDate`
  - `toDate`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### occ_download_stats_dataset_records - GET /occurrence/download/statistics/downloadedRecordsByDataset
- **Missing parameters:**
  - `fromDate`
  - `toDate`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### occ_download_stats_dataset - GET /occurrence/download/statistics/downloadsByDataset
- **Missing parameters:**
  - `fromDate`
  - `toDate`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### occ_download_stats_source - GET /occurrence/download/statistics/downloadsBySource
- **Missing parameters:**
  - `fromDate`
  - `toDate`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### dataset_search - GET /dataset/search
- **Missing parameters:**
  - `continent`
  - `taxonKey`
  - `recordCount`
  - `modifiedDate`
  - `createdDate`
  - `contactUserId`
  - `contactEmail`
  - `facetMinCount`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### dataset_export - GET /dataset/search/export
- **Missing parameters:**
  - `continent`
  - `taxonKey`
  - `recordCount`
  - `modifiedDate`
  - `createdDate`
  - `installationKey`
  - `endpointType`
  - `contactUserId`
  - `contactEmail`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### datasets - GET /dataset
- **Missing parameters:**
  - `country`
  - `identifierType`
  - `identifier`
  - `machineTagNamespace`
  - `machineTagName`
  - `machineTagValue`
  - `modified`
  - `created`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### dataset_suggest - GET /dataset/suggest
- **Missing parameters:**
  - `continent`
  - `taxonKey`
  - `recordCount`
  - `modifiedDate`
  - `createdDate`
  - `installationKey`
  - `endpointType`
  - `contactUserId`
  - `contactEmail`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### dataset_tag - GET /dataset/{uuid}/tag
- **Missing parameters:**
  - `owner`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### collection_search - GET /grscicoll/collection
- **Missing parameters:**
  - `institution`
  - `occurrenceCount`
  - `typeSpecimenCount`
  - `contactUserId`
  - `contactEmail`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### collection_export - GET /grscicoll/collection/export
- **Missing parameters:**
  - `institution`
  - `contentType`
  - `preservationType`
  - `accessionStatus`
  - `personalCollection`
  - `sourceId`
  - `source`
  - `machineTagNamespace`
  - `machineTagName`
  - `machineTagValue`
  - `identifierType`
  - `identifier`
  - `gbifRegion`
  - `active`
  - `masterSourceType`
  - `numberSpecimens`
  - `displayOnNHCPortal`
  - `replacedBy`
  - `occurrenceCount`
  - `typeSpecimenCount`
  - `sortBy`
  - `sortOrder`
  - `contactUserId`
  - `contactEmail`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### institution_search - GET /grscicoll/institution
- **Missing parameters:**
  - `discipline`
  - `contactUserId`
  - `contactEmail`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### institution_export - GET /grscicoll/institution/export
- **Missing parameters:**
  - `institution`
  - `contentType`
  - `preservationType`
  - `accessionStatus`
  - `personalCollection`
  - `sourceId`
  - `source`
  - `machineTagNamespace`
  - `machineTagName`
  - `machineTagValue`
  - `identifierType`
  - `identifier`
  - `gbifRegion`
  - `active`
  - `masterSourceType`
  - `numberSpecimens`
  - `displayOnNHCPortal`
  - `replacedBy`
  - `occurrenceCount`
  - `typeSpecimenCount`
  - `institutionKey`
  - `sortBy`
  - `sortOrder`
  - `contactUserId`
  - `contactEmail`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### lit_count - GET /literature/search
- **Missing parameters:**
  - `citationType`
  - `doi`
  - `gbifHigherTaxonKey`
  - `gbifNetworkKey`
  - `gbifOccurrenceKey`
  - `gbifProjectIdentifier`
  - `gbifProgrammeAcronym`
  - `gbifTaxonKey`
  - `publisher`
  - `publishingCountry`
  - `source`
  - `websites`
  - `language`
  - `added`
  - `published`
  - `discovered`
  - `modified`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### lit_export - GET /literature/export
- **Missing parameters:**
  - `citationType`
  - `doi`
  - `gbifDatasetKey`
  - `gbifDownloadKey`
  - `gbifHigherTaxonKey`
  - `gbifNetworkKey`
  - `gbifOccurrenceKey`
  - `gbifProjectIdentifier`
  - `gbifProgrammeAcronym`
  - `gbifTaxonKey`
  - `publisher`
  - `publishingOrganizationKey`
  - `publishingCountry`
  - `source`
  - `websites`
  - `language`
  - `added`
  - `published`
  - `discovered`
  - `modified`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### nodes - GET /node/country/{countryCode}
- **Missing parameters:**
  - `countryCode`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### name_lookup - GET /v1/species/search
- **Missing parameters:**
  - `threat`
  - `facetLimit`
  - `facetOffset`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### name_suggest - GET /v1/species/suggest
- **Missing parameters:**
  - `constituentKey`
  - `higherTaxonKey`
  - `status`
  - `isExtinct`
  - `habitat`
  - `threat`
  - `nameType`
  - `nomenclaturalStatus`
  - `origin`
  - `issue`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

### name_usage - GET /v1/species
- **Missing parameters:**
  - `sourceId`
- **Actions:**
  - [ ] Ignore - Add all parameters to ignored_parameters
  - [ ] Issue - Create issue to implement these parameters

