#' Search for dataset metadata.
#'
#' @name dataset_search
#' @param query Simple full text search parameter. The value for this parameter 
#' can be a simple word or a phrase. Wildcards are not supported.
#' @param type The primary type of the dataset. Available values: "OCCURRENCE", 
#' "CHECKLIST", "METADATA", "SAMPLING_EVENT", "MATERIAL_ENTITY".
#' @param publishingCountry Filters datasets by their owning organization's 
#' country given as a ISO 639-1 (2 letter) country code.
#' @param subtype The sub-type of the dataset.The sub-type of the dataset. 
#' Available values: "TAXONOMIC_AUTHORITY", "NOMENCLATOR_AUTHORITY", 
#' "INVENTORY_THEMATIC", "INVENTORY_REGIONAL", "GLOBAL_SPECIES_DATASET", 
#' "DERIVED_FROM_OCCURRENCE", "SPECIMEN", "OBSERVATION".
#' @param license The dataset's licence. Available values: "CC0_1_0", 
#' "CC_BY_4_0", "CC_BY_NC_4_0", "UNSPECIFIED", "UNSUPPORTED".
#' @param keyword Filters datasets by a case insensitive plain text keyword. 
#' The search is done on the merged collection of tags, the dataset 
#' keywordCollections and temporalCoverages.
#' @param publishingOrg Filters datasets by their publishing organization 
#' UUID key.
#' @param hostingOrg Filters datasets by their hosting organization UUID key 
#' @param endorsingNodeKey Node UUID key that endorsed this dataset's publisher.
#' @param decade Filters datasets by their temporal coverage broken down to 
#' decades. Decades are given as a full year, e.g. 1880, 1960, 2000, etc, and 
#' will return datasets wholly contained in the decade as well as those that 
#' cover the entire decade or more. Ranges can be used like this "1800,1900".
#' @param projectId Filter or facet based on the project ID of a given dataset. 
#' A dataset can have a project id if it is the result of a project. 
#' Multiple datasets can have the same project id.
#' @param hostingCountry Filters datasets by their hosting organization's 
#' country given as a ISO 639-1 (2 letter) country code.
#' @param networkKey Filters network UUID associated to a dataset.
#' @param doi DOI of the dataset.
#' @param facet A facet name used to retrieve the most frequent values for a field.
#' @param facetLimit Facet parameters allow paging requests using the parameters 
#' facetOffset and facetLimit.
#' @param facetOffset Facet parameters allow paging requests using the 
#' parameters facetOffset and facetLimit
#' @param facetMincount Used in combination with the facet parameter.
#' @param facetMultiselect Used in combination with the facet parameter.
#' @param limit Controls the number of results in the page. Using too high a 
#' value will be overwritten with the default maximum threshold, depending on
#' the service. Sensible defaults are used so this may be omitted.
#' @param start Determines the offset for the search results. A limit of 20 
#' and offset of 40 will get the third page of 20 results. Some services have 
#' a maximum offset.
#' @param description Logical whether to return descriptions.  
#' @param curlopts options passed on to [crul::HttpClient].
#' 
#' @details
#' `dataset_search()` searches and returns metadata on GBIF datasets from the 
#' registry. This function does not search occurrence data, only metadata on 
#' the datasets that contain may contain occurrence data. It also searches over 
#' other dataset types, such checklist and metadata datasets. Only a sample of 
#' results is returned.
#' 
#' `dataset_export()`  function will download a `tibble` of the results of a 
#' `dataset_search()`. This function is primarily useful if you want the full results of a 
#' `dataset_search()`. 
#' 
#' Use `dataset_search(facet="x",limit=0)$facets` to get simple group by counts
#' for different parameters. 
#'
#' @return A `list` for `dataset_search()`. A `tibble` for `dataset_export()`.
#' 
#' @references 
#' https://techdocs.gbif.org/en/openapi/v1/registry#/Datasets/searchDatasets
#' 
#' @export
#'
#' @examples \dontrun{
#' # search metadata on all datasets and return a sample
#' dataset_search()
#' # dataset_export() # download info on all +90K datasets 
#' 
#' dataset_search(publishingCountry = "US")
#' dataset_search(type = "OCCURRENCE") 
#' dataset_search(keyword = "bird")
#' dataset_search(subtype = "TAXONOMIC_AUTHORITY") 
#' dataset_search(license = "CC0_1_0") 
#' dataset_search(query = "frog") 
#' dataset_search(publishingCountry = "UA") 
#' dataset_search(publishingOrg = "e2e717bf-551a-4917-bdc9-4fa0f342c530") 
#' dataset_search(hostingOrg = "7ce8aef0-9e92-11dc-8738-b8a03c50a862") 
#' dataset_search(decade="1890,1990",limit=5)
#' dataset_search(projectId = "GRIIS") 
#' dataset_search(hostingCountry = "NO") 
#' dataset_search(networkKey = "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e") 
#' dataset_search(doi='10.15468/aomfnb') 
#' 
#' # search multiple values 
#' dataset_search(projectId = "GRIIS;BID-AF2020-140-REG") 
#' dataset_search(hostingCountry = "NO;SE")
#' dataset_search(doi="10.15468/aomfnb;10.15468/igasai")
#' 
#' # multiple filters
#' dataset_search(license = "CC0_1_0",subtype = "TAXONOMIC_AUTHORITY")
#' # dataset_export(license = "CC0_1_0",subtype = "TAXONOMIC_AUTHORITY")
#' 
#' # using dataset export to get all datasets 
#' dataset_export(decade="1800,1900")
#' dataset_export(projectId="GRIIS")
#' 
#' # get simple group by counts 
#' dataset_search(facet="type",limit=0,facetLimit=5)$facets 
#' dataset_search(facet="publishingCountry",limit=0,facetLimit=5)$facets
#' dataset_search(facet="license",limit=0,facetLimit=5, facetMincount=10000)
#' 
#' }
dataset_search <- function(query = NULL,
                           type = NULL,
                           publishingCountry = NULL,  
                           subtype = NULL,
                           license = NULL,
                           keyword = NULL,
                           publishingOrg = NULL,
                           hostingOrg = NULL,
                           endorsingNodeKey = NULL,
                           decade = NULL,
                           projectId = NULL,
                           hostingCountry = NULL,
                           networkKey = NULL,
                           doi = NULL, 
                           facet = NULL,
                           facetLimit = NULL, 
                           facetOffset = NULL, 
                           facetMincount = NULL,
                           facetMultiselect = NULL,
                           limit = 100,
                           start = NULL,
                           description = FALSE,
                           curlopts = list()) {

  assert(query,"character")
  assert(type,"character")
  assert(subtype,"character")
  assert(license,"character")
  assert(keyword,"character")
  assert(publishingOrg,"character")
  assert(hostingOrg,"character")
  assert(endorsingNodeKey,"character")
  assert(publishingCountry,"character")
  assert(projectId,"character")
  assert(hostingCountry,"character")
  assert(networkKey,"character")
  assert(doi,"character")
  assert(facet,"character")
  
  # args with single value 
  args <- as.list(
    rgbif_compact(c(q=query,
                    limit=limit,
                    offset=start,
                    facetLimit=facetLimit,
                    facetOffset=facetOffset,
                    facetMincount=facetMincount,
                    facetMultiselect=facetMultiselect
                    )))
  
  args <- rgbif_compact(c(
    args,
    convmany(type),
    convmany(subtype),
    convmany(license),
    convmany(keyword),
    convmany(publishingOrg),
    convmany(hostingOrg),
    convmany(endorsingNodeKey),
    convmany(decade),
    convmany(publishingCountry),
    convmany(projectId),
    convmany(hostingCountry),
    convmany(networkKey),
    convmany(doi),
    convmany(facet)
  ))
  
  url <- paste0(gbif_base(), '/dataset/search')
  tt <- gbif_GET(url, args, FALSE, curlopts)
  # metadata
  meta <- tt[c('offset','limit','endOfRecords','count')]

  # facets
  facets <- tt$facets
  if (!length(facets) == 0) {
    facetsdat <- lapply(facets, function(x)
      do.call(rbind, lapply(x$counts, data.frame, stringsAsFactors = FALSE)))
    names(facetsdat) <- strsplit(facet, ";")[[1]]
  } else {
    facetsdat <- NULL
  }

  # data
  if (length(tt$results) == 0) {
    out <- NULL
  } else {
    out <- tibble::as_tibble(setdfrbind(lapply(tt$results, parse_dataset_search)))
  }
  
  if(description) {
    descs <- lapply(tt$results, "[[", "description")
    names(descs) <- sapply(tt$results, "[[", "title")
    list(meta = data.frame(meta), data = out, facets = facetsdat, descriptions = descs)
  } else {
    list(meta = data.frame(meta), data = out, facets = facetsdat)
  }  
}

parse_dataset_search <- function(x){
  tmp <- rgbif_compact(list(
                      datasetKey = x$key,
                      title = x$title,
                      doi = x$doi,
                      license = x$license,
                      type = x$type,
                      subType = x$subtype,
                      hostingOrganizationKey = x$hostingOrganizationKey,
                      hostingOrganizationTitle = x$hostingOrganizationTitle,
                      hostingCountry = x$hostingCountry,
                      publishingOrganizationKey = x$publishingOrganizationKey,
                      publishingOrganizationTitle = x$publishingOrganizationTitle,
                      publishingCountry = x$publishingCountry,
                      endorsingNodeKey = x$endorsingNodeKey,
                      networkKeys = paste(unlist(x$networkKeys),collapse=","),
                      projectIdentifier = x$projectIdentifier,
                      occurrenceRecordsCount = x$recordCount,
                      nameUsagesCount = x$nameUsagesCount
                      ))
  data.frame(tmp, stringsAsFactors = FALSE)
}





