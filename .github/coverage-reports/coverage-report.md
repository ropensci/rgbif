# GBIF API Coverage Report
Generated: 2026-05-22 15:35:16.893752

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
> - `[x] Ignore` - Add parameter to ignored_parameters for this function in api-mapping.json
> - `[x] Issue` - Create a GitHub issue to implement this parameter

### occ_count - GET /occurrence/search
- **Missing parameters:**
  - `nucleotideSequence.nucleotideSequenceID` [ ] Ignore [ ] Issue
  - `nucleotideSequence.targetGene` [ ] Ignore [ ] Issue
  - `nucleotideSequence.sequence` [ ] Ignore [ ] Issue
  - `nucleotideSequence.sequenceLength` [ ] Ignore [ ] Issue
  - `nucleotideSequence.gcContent` [ ] Ignore [ ] Issue
  - `nucleotideSequence.nonIupacFraction` [ ] Ignore [ ] Issue
  - `nucleotideSequence.nonACGTNFraction` [ ] Ignore [ ] Issue
  - `nucleotideSequence.nFraction` [ ] Ignore [ ] Issue
  - `nucleotideSequence.nRunsCapped` [ ] Ignore [ ] Issue
  - `nucleotideSequence.naturalLanguageDetected` [ ] Ignore [ ] Issue
  - `nucleotideSequence.endsTrimmed` [ ] Ignore [ ] Issue
  - `nucleotideSequence.gapsOrWhitespaceRemoved` [ ] Ignore [ ] Issue
  - `nucleotideSequence.invalid` [ ] Ignore [ ] Issue

### occ_download_stats - GET /occurrence/download/statistics
- **Missing parameters:**
  - `fromDate` [ ] Ignore [ ] Issue
  - `toDate` [ ] Ignore [ ] Issue

### occ_download_stats_export - GET /occurrence/download/statistics/export
- **Missing parameters:**
  - `fromDate` [ ] Ignore [ ] Issue
  - `toDate` [ ] Ignore [ ] Issue

### occ_download_stats_user_country - GET /occurrence/download/statistics/downloadsByUserCountry
- **Missing parameters:**
  - `fromDate` [ ] Ignore [ ] Issue
  - `toDate` [ ] Ignore [ ] Issue

### occ_download_stats_dataset_records - GET /occurrence/download/statistics/downloadedRecordsByDataset
- **Missing parameters:**
  - `fromDate` [ ] Ignore [ ] Issue
  - `toDate` [ ] Ignore [ ] Issue

### occ_download_stats_dataset - GET /occurrence/download/statistics/downloadsByDataset
- **Missing parameters:**
  - `fromDate` [ ] Ignore [ ] Issue
  - `toDate` [ ] Ignore [ ] Issue

### occ_download_stats_source - GET /occurrence/download/statistics/downloadsBySource
- **Missing parameters:**
  - `fromDate` [ ] Ignore [ ] Issue
  - `toDate` [ ] Ignore [ ] Issue

### dataset_search - GET /dataset/search
- **Missing parameters:**
  - `continent` [ ] Ignore [ ] Issue
  - `taxonKey` [ ] Ignore [ ] Issue
  - `recordCount` [ ] Ignore [ ] Issue
  - `modifiedDate` [ ] Ignore [ ] Issue
  - `createdDate` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue
  - `facetMinCount` [ ] Ignore [ ] Issue

### dataset_export - GET /dataset/search/export
- **Missing parameters:**
  - `continent` [ ] Ignore [ ] Issue
  - `taxonKey` [ ] Ignore [ ] Issue
  - `recordCount` [ ] Ignore [ ] Issue
  - `modifiedDate` [ ] Ignore [ ] Issue
  - `createdDate` [ ] Ignore [ ] Issue
  - `installationKey` [ ] Ignore [ ] Issue
  - `endpointType` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue

### datasets - GET /dataset
- **Missing parameters:**
  - `country` [ ] Ignore [ ] Issue
  - `identifierType` [ ] Ignore [ ] Issue
  - `identifier` [ ] Ignore [ ] Issue
  - `machineTagNamespace` [ ] Ignore [ ] Issue
  - `machineTagName` [ ] Ignore [ ] Issue
  - `machineTagValue` [ ] Ignore [ ] Issue
  - `modified` [ ] Ignore [ ] Issue
  - `created` [ ] Ignore [ ] Issue

### dataset_suggest - GET /dataset/suggest
- **Missing parameters:**
  - `continent` [ ] Ignore [ ] Issue
  - `taxonKey` [ ] Ignore [ ] Issue
  - `recordCount` [ ] Ignore [ ] Issue
  - `modifiedDate` [ ] Ignore [ ] Issue
  - `createdDate` [ ] Ignore [ ] Issue
  - `installationKey` [ ] Ignore [ ] Issue
  - `endpointType` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue

### dataset_tag - GET /dataset/{uuid}/tag
- **Missing parameters:**
  - `owner` [ ] Ignore [ ] Issue

### collection_search - GET /grscicoll/collection
- **Missing parameters:**
  - `institution` [ ] Ignore [ ] Issue
  - `occurrenceCount` [ ] Ignore [ ] Issue
  - `typeSpecimenCount` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue

### collection_export - GET /grscicoll/collection/export
- **Missing parameters:**
  - `institution` [ ] Ignore [ ] Issue
  - `contentType` [ ] Ignore [ ] Issue
  - `preservationType` [ ] Ignore [ ] Issue
  - `accessionStatus` [ ] Ignore [ ] Issue
  - `personalCollection` [ ] Ignore [ ] Issue
  - `sourceId` [ ] Ignore [ ] Issue
  - `source` [ ] Ignore [ ] Issue
  - `machineTagNamespace` [ ] Ignore [ ] Issue
  - `machineTagName` [ ] Ignore [ ] Issue
  - `machineTagValue` [ ] Ignore [ ] Issue
  - `identifierType` [ ] Ignore [ ] Issue
  - `identifier` [ ] Ignore [ ] Issue
  - `gbifRegion` [ ] Ignore [ ] Issue
  - `active` [ ] Ignore [ ] Issue
  - `masterSourceType` [ ] Ignore [ ] Issue
  - `numberSpecimens` [ ] Ignore [ ] Issue
  - `displayOnNHCPortal` [ ] Ignore [ ] Issue
  - `replacedBy` [ ] Ignore [ ] Issue
  - `occurrenceCount` [ ] Ignore [ ] Issue
  - `typeSpecimenCount` [ ] Ignore [ ] Issue
  - `sortBy` [ ] Ignore [ ] Issue
  - `sortOrder` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue

### institution_search - GET /grscicoll/institution
- **Missing parameters:**
  - `discipline` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue

### institution_export - GET /grscicoll/institution/export
- **Missing parameters:**
  - `institution` [ ] Ignore [ ] Issue
  - `contentType` [ ] Ignore [ ] Issue
  - `preservationType` [ ] Ignore [ ] Issue
  - `accessionStatus` [ ] Ignore [ ] Issue
  - `personalCollection` [ ] Ignore [ ] Issue
  - `sourceId` [ ] Ignore [ ] Issue
  - `source` [ ] Ignore [ ] Issue
  - `machineTagNamespace` [ ] Ignore [ ] Issue
  - `machineTagName` [ ] Ignore [ ] Issue
  - `machineTagValue` [ ] Ignore [ ] Issue
  - `identifierType` [ ] Ignore [ ] Issue
  - `identifier` [ ] Ignore [ ] Issue
  - `gbifRegion` [ ] Ignore [ ] Issue
  - `active` [ ] Ignore [ ] Issue
  - `masterSourceType` [ ] Ignore [ ] Issue
  - `numberSpecimens` [ ] Ignore [ ] Issue
  - `displayOnNHCPortal` [ ] Ignore [ ] Issue
  - `replacedBy` [ ] Ignore [ ] Issue
  - `occurrenceCount` [ ] Ignore [ ] Issue
  - `typeSpecimenCount` [ ] Ignore [ ] Issue
  - `institutionKey` [ ] Ignore [ ] Issue
  - `sortBy` [ ] Ignore [ ] Issue
  - `sortOrder` [ ] Ignore [ ] Issue
  - `contactUserId` [ ] Ignore [ ] Issue
  - `contactEmail` [ ] Ignore [ ] Issue

### lit_count - GET /literature/search
- **Missing parameters:**
  - `citationType` [ ] Ignore [ ] Issue
  - `doi` [ ] Ignore [ ] Issue
  - `gbifHigherTaxonKey` [ ] Ignore [ ] Issue
  - `gbifNetworkKey` [ ] Ignore [ ] Issue
  - `gbifOccurrenceKey` [ ] Ignore [ ] Issue
  - `gbifProjectIdentifier` [ ] Ignore [ ] Issue
  - `gbifProgrammeAcronym` [ ] Ignore [ ] Issue
  - `gbifTaxonKey` [ ] Ignore [ ] Issue
  - `publisher` [ ] Ignore [ ] Issue
  - `publishingCountry` [ ] Ignore [ ] Issue
  - `source` [ ] Ignore [ ] Issue
  - `websites` [ ] Ignore [ ] Issue
  - `language` [ ] Ignore [ ] Issue
  - `added` [ ] Ignore [ ] Issue
  - `published` [ ] Ignore [ ] Issue
  - `discovered` [ ] Ignore [ ] Issue
  - `modified` [ ] Ignore [ ] Issue

### lit_export - GET /literature/export
- **Missing parameters:**
  - `citationType` [ ] Ignore [ ] Issue
  - `doi` [ ] Ignore [ ] Issue
  - `gbifDatasetKey` [ ] Ignore [ ] Issue
  - `gbifDownloadKey` [ ] Ignore [ ] Issue
  - `gbifHigherTaxonKey` [ ] Ignore [ ] Issue
  - `gbifNetworkKey` [ ] Ignore [ ] Issue
  - `gbifOccurrenceKey` [ ] Ignore [ ] Issue
  - `gbifProjectIdentifier` [ ] Ignore [ ] Issue
  - `gbifProgrammeAcronym` [ ] Ignore [ ] Issue
  - `gbifTaxonKey` [ ] Ignore [ ] Issue
  - `publisher` [ ] Ignore [ ] Issue
  - `publishingOrganizationKey` [ ] Ignore [ ] Issue
  - `publishingCountry` [ ] Ignore [ ] Issue
  - `source` [ ] Ignore [ ] Issue
  - `websites` [ ] Ignore [ ] Issue
  - `language` [ ] Ignore [ ] Issue
  - `added` [ ] Ignore [ ] Issue
  - `published` [ ] Ignore [ ] Issue
  - `discovered` [ ] Ignore [ ] Issue
  - `modified` [ ] Ignore [ ] Issue

### nodes - GET /node/country/{countryCode}
- **Missing parameters:**
  - `countryCode` [ ] Ignore [ ] Issue

### name_lookup - GET /v1/species/search
- **Missing parameters:**
  - `threat` [ ] Ignore [ ] Issue
  - `facetLimit` [ ] Ignore [ ] Issue
  - `facetOffset` [ ] Ignore [ ] Issue

### name_suggest - GET /v1/species/suggest
- **Missing parameters:**
  - `constituentKey` [ ] Ignore [ ] Issue
  - `higherTaxonKey` [ ] Ignore [ ] Issue
  - `status` [ ] Ignore [ ] Issue
  - `isExtinct` [ ] Ignore [ ] Issue
  - `habitat` [ ] Ignore [ ] Issue
  - `threat` [ ] Ignore [ ] Issue
  - `nameType` [ ] Ignore [ ] Issue
  - `nomenclaturalStatus` [ ] Ignore [ ] Issue
  - `origin` [ ] Ignore [ ] Issue
  - `issue` [ ] Ignore [ ] Issue

### name_usage - GET /v1/species
- **Missing parameters:**
  - `sourceId` [ ] Ignore [ ] Issue

