#' Search for literature that cites GBIF mediated data
#' 
#' @template occ
#' 
#' @export
#' 
#' @param q (character) Simple full text search parameter. The value for this 
#' parameter can be a simple word or a phrase. Wildcards are not supported.
#' @param countriesOfResearcher (character) Country of institution with which 
#' author is affiliated, e.g. DK (for Denmark). Country codes are 
#' listed in enumeration_country().  
#' @param countriesOfCoverage (character) Country of focus of study, 
#' e.g. BR (for Brazil). Country codes are listed in enumeration_country().  
#' @param literatureType (character) Type of literature ("JOURNAL", 
#' "BOOK_SECTION", "WORKING_PAPER", "REPORT", "GENERIC", "THESIS", "CONFERENCE_PROCEEDINGS", 
#' "WEB_PAGE").
#' @param relevance (character) How is the publication relate to GBIF. See details 
#' ("GBIF_USED", "GBIF_MENTIONED", "GBIF_PUBLISHED", "GBIF_CITED", "GBIF_CITED", 
#' "GBIF_PUBLISHED", "GBIF_ACKNOWLEDGED", "GBIF_AUTHOR").
#' @param year (integer) Year of publication.
#' @param topics (character) Topic of publication.
#' @param datasetKey (character) GBIF dataset uuid referenced in publication.
#' @param publishingOrg (character) Publisher uuid whose dataset is 
#' referenced in publication.
#' @param peerReview (logical) Has publication undergone peer-review? 
#' @param openAccess (logical) Is publication Open Access?
#' @param downloadKey (character) Download referenced in publication.
#' @param doi (character) Digital Object Identifier (DOI).
#' @param journalSource (character) Journal of publication.
#' @param journalPublisher (character) Publisher of journal.
#' @param flatten (logical) should any lists in the resulting data be flattened
#' into comma-seperated strings?
#' @param limit how many records to return. limit=NULL will fetch up to 10,000. 
#' @param ... additional parameters passed to lit_search
#'
#' @details
#' This function enables you to search for literature indexed by GBIF, 
#' including peer-reviewed papers, citing GBIF datasets and downloads. 
#' The literature API powers the 
#' \href{https://www.gbif.org/resource/search?contentType=literature}{literature search}
#' on GBIF.  
#' 
#' The GBIF Secretariat maintains an ongoing 
#' \href{https://www.gbif.org/literature-tracking}{literature tracking programme}, 
#' which identifies research uses and citations of biodiversity information 
#' accessed through GBIF’s global infrastructure. 
#' 
#' In the literature database, \strong{relevance} refers to how publications relate 
#' to GBIF following these definitions:
#' \itemize{
#' \item GBIF_USED : makes substantive use of data in a quantitative analysis (e.g. ecological niche modelling)
#' \item GBIF_CITED : cites a qualitative fact derived in data (e.g. a given species is found in a given country)
#' \item GBIF_DISCUSSED : discusses GBIF as an infrastructure or the use of data
#' \item GBIF_PRIMARY : GBIF is the primary source of data (no longer applied)
#' \item GBIF_ACKNOWLEDGED : acknowledges GBIF (but doesn't use or cite data)
#' \item GBIF_PUBLISHED : describes or talks about data published to GBIF
#' \item GBIF_AUTHOR : authored by GBIF staff
#' \item GBIF_MENTIONED : unspecifically mentions GBIF or the GBIF portal
#' \item GBIF_FUNDED : funded by GBIF or a GBIF-managed funding programme
#' }
#' 
#' The following arguments can take multiple values:
#' \itemize{
#' \item relevance
#' \item countriesOfResearcher
#' \item countriesOfCoverage
#' \item literatureType
#' \item topics
#' \item datasetKey
#' \item publishingOrg
#' \item downloadKey
#' \item doi
#' \item journalSource
#' \item journalPublisher
#' }
#' 
#' If \code{flatten=TRUE}, then \strong{data} will be returned as flat 
#' data.frame with no complex column types (i.e. no lists or data.frames).
#'  
#' \code{limit=NULL} will return up to 10,000 records. The maximum value for
#' \code{limit} is 10,000. If no filters are used, only the first 1,000 records 
#' will be returned, limit must be explicitly set to \code{limit=10000}, to get 
#' the first 10,000 records in this case.  
#' 
#' \code{lit_count()} is a convenience wrapper, which will return the number of 
#' literature references for a certain \code{lit_search()} query. This is the 
#' same as running \code{lit_search()$meta$count}.
#' 
#' @return
#' A named list with two values: \code{$data} and \code{$meta}. \code{$data} is
#' a \code{data.frame} of literature references. 
#' 
#'
#' @examples \dontrun{
#'  # https://www.gbif.org/resource/search?contentType=literature
#'  
#'  lit_search(q="bats")$data 
#'  lit_search(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#'  lit_search(year=2020)
#'  lit_search(year="2011,2020") # year ranges
#'  lit_search(relevance=c("GBIF_CITED","GBIF_USED")) # multiple values
#'  lit_search(relevance=c("GBIF_USED","GBIF_CITED"), 
#'  topics=c("EVOLUTION","PHYLOGENETICS")
#'  
#'  lit_count() # total number of literature referencing GBIF
#'  lit_count(peerReview=TRUE)
#'  # number of citations of iNaturalist 
#'  lit_count(datasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#'  # number of peer-reviewed articles used GBIF mediated data
#'  lit_count(peerReview=TRUE,literatureType="JOURNAL",relevance="GBIF_USED")
#'  
#'  # Typically what is meant by "literature that uses GBIF" 
#'  lit_search(peerReview=TRUE,literatureType="JOURNAL",relevance="GBIF_USED")
#'  lit_count(peerReview=TRUE,literatureType="JOURNAL",relevance="GBIF_USED")
#' }
#' 
#' 
lit_search <- function(
    q=NULL, 
    countriesOfResearcher=NULL, 
    countriesOfCoverage=NULL, 
    literatureType=NULL, 
    relevance=NULL, 
    year=NULL, 
    topics=NULL, 
    datasetKey=NULL, 
    publishingOrg=NULL, 
    peerReview=NULL, 
    openAccess=NULL, 
    downloadKey=NULL, 
    doi=NULL, 
    journalSource=NULL, 
    journalPublisher=NULL,
    flatten=TRUE,
    limit=NULL,
    curlopts = list()
) {
  step <- 1000 # max step size in 1000
  
  # check inputs 
  if(!is_uuid(datasetKey) & !is.null(datasetKey)) stop("'datasetKey' should be a GBIF dataset uuid.")
  if(!is_uuid(publishingOrg) & !is.null(publishingOrg)) stop("'publishingOrg' should be a GBIF publisher uuid.")
  if(!is_download_key(downloadKey) & !is.null(downloadKey)) stop("'downloadKey' should be a GBIF downloadkey.")
  
  assert(q,"character")
  assert(countriesOfResearcher,"character")
  assert(countriesOfCoverage,"character")
  assert(literatureType,"character")
  assert(relevance,"character")
  assert(topics,"character")
  assert(peerReview,"logical")
  assert(openAccess,"logical")
  assert(downloadKey,"character")
  assert(doi,"character")
  assert(journalSource,"character")
  assert(journalPublisher,"character")
  
  # args that take only a single value
  args <- rgbif_compact(list(
    q=q, 
    year=year, 
    peerReview=peerReview, 
    openAccess=openAccess
  ))
  # args that take many values
  args <- c(args,
            convmany(relevance),
            convmany(countriesOfResearcher),
            convmany(countriesOfCoverage),
            convmany(literatureType),
            convmany(topics),
            convmany_rename(datasetKey,"gbifDatasetKey"),
            convmany_rename(publishingOrg,"publishingOrganizationKey"),
            convmany_rename(downloadKey,"gbifDownloadKey"), 
            convmany(doi), 
            convmany_rename(journalSource,"source"), 
            convmany_rename(journalPublisher,"publisher")
  )
  if(is.null(limit)) {
    count_args <- args; count_args$limit <- 0
    limit <- gbif_GET(paste0(gbif_base(), "/literature/search"), count_args, parse=TRUE, curlopts = curlopts, mssg = NULL)$count
    if(length(args) == 0) {
      message("No filters used, but 'limit=NULL' returning just the first 1000 results. If you actually just want the first 10,000 records, use 'limit=10000'.")
      limit <- 1000
      }
  }
  if(limit > 10000) { 
    message("Not returning all records. Max records is 10,000.") 
    limit <- 10000 
  } 
  if(step >= limit) step <- limit
  
  if((limit %% step) == 0) { 
    offset_seq <- seq(from=0,limit-step,by=step)
    limit_seq <- rep(step,length(offset_seq))
    
  } else {
    offset_seq <- seq(from=0,limit,by=step)
    limit_seq <- c(rep(step,length(offset_seq)-1),limit %% step)
  }
  
  if(step == limit) offset_seq <- 0 # only one request needed
  if(length(args) == 0) { 
    urls <- paste0(gbif_base(),"/literature/search?",
                   "offset=",offset_seq,
                   "&limit=",limit_seq)
  } else {
    req <- paste0(names(args),"=",args,collapse="&")
    urls <- paste0(gbif_base(),
                   "/literature/search?",req,
                   "&offset=",offset_seq,
                   "&limit=",limit_seq)
  }
  ll <- gbif_async_get(urls,parse=TRUE)
  data <- process_lit_async_results(ll,flatten=flatten)
  meta <- rgbif_compact(ll[[length(urls)]])
  meta$results <- NULL
  list(data=data,meta=meta)
}

#' @export
#' @rdname lit_search
lit_count <- function(...) {
  
  x <- rgbif_compact(list(...))
  accepted_args <- c("q",
                     "countriesOfResearcher",
                     "countriesOfResearcher",
                     "countriesOfCoverage",
                     "literatureType",
                     "relevance",
                     "year",
                     "topics",
                     "datasetKey",
                     "publishingOrg",
                     "peerReview",
                     "openAccess",
                     "downloadKey",
                     "doi",
                     "journalSource",
                     "journalPublisher")
  if(!all(names(x) %in% accepted_args)) {
    stop(
    paste0(
    "Please use accepted argument from lit_search() :",toString(accepted_args)
    ))}
  
  count <- lit_search(
    q=x$q,
    countriesOfResearcher=x$countriesOfResearcher,
    countriesOfCoverage=x$countriesOfCoverage,
    literatureType=x$literatureType,
    relevance=x$relevance,
    year=x$year,
    topics=x$topics,
    datasetKey=x$datasetKey,
    publishingOrg=x$publishingOrg,
    peerReview=x$peerReview,
    openAccess=x$openAccess,
    downloadKey=x$downloadKey,
    doi=x$doi,
    journalSource=x$journalSource,
    journalPublisher=x$journalPublisher,
    limit=1)$meta$count
  count
}

process_lit_async_results <- function(ll,flatten=TRUE) {
  data_list <- lapply(ll,function(x) x$results)
  # handle complex identifiers
  data_list <- lapply(data_list,function(x) tibble::tibble(x,x$identifiers))
  for(i in 1:length(data_list)) data_list[[i]]$identifiers <- NULL
  for(i in 1:length(data_list)) data_list[[i]]$abstract <- NULL
  data <- bind_rows(data_list)
  # data
  if(flatten) {
    # handle complex identifiers and authors
    data$authors <- sapply(data$authors,function(x) paste0(x$firstName," ",x$lastName,collapse=","))
    # flatten other columns
    data <- tibble::as_tibble(lapply(data,function(x) if(is.list(x)) sapply(x,toString) else x))
  }
  data$x <- NULL
  data
}

