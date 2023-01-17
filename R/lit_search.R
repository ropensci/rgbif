#' Search for literature that cites GBIF mediated data
#' 
#' @template otherlimstart
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
#' @param gbifDatasetKey (character) GBIF dataset uuid referenced in publication.
#' @param publishingOrganizationKey (character) Publisher uuid whose dataset is 
#' referenced in publication.
#' @param peerReview (logical) Has publication undergone peer-review? 
#' @param openAccess (logical) Is publication Open Access?
#' @param gbifDownloadKey (character) Download referenced in publication.
#' @param doi (character) Digital Object Identifier (DOI).
#' @param source (character) Journal of publication.
#' @param publisher (character) Publisher of journal.
#' @param flatten (logical) should any lists in the resulting data be flattened
#' into comma-seperated strings?
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
#' \item gbifDatasetKey
#' \item publishingOrganizationKey
#' \item gbifDownloadKey
#' \item doi
#' \item source
#' \item publisher
#' }
#' 
#' If \code{flatten=TRUE}, then \strong{data} will be returned as flat 
#' data.frame with no complex column types (i.e. no lists or data.frames).
#' 
#' \code{lit_all_gbif()} is a convenience wrapper, which will return all
#' peer-reviewed literature that cites or uses GBIF mediated data in a single 
#' \code{data.frame}. 
#' 
#' \code{lit_all_dataset()} is a convenience wrapper, which will return
#' literature citations for a given single GBIF dataset uuid. This corresponds to what 
#' currently appears on \href{https://www.gbif.org/dataset/50c9509d-22c7-4a22-a47d-8c48425ef4a7}{dataset pages} 
#' for "citations". Does not accept multiple values. 
#' 
#' \code{lit_count()} is a convenience wrapper, which will return the number of 
#' literature references for a certain \code{lit_search()} query.
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
#'  lit_search(gbifDatasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#'  lit_search(year=2020)
#'  lit_search(year="2011,2020") # year ranges
#'  lit_search(relevance=c("GBIF_CITED","GBIF_USED")) # multiple values
#'  lit_search(relevance=c("GBIF_USED","GBIF_CITED"), 
#'  topics=c("EVOLUTION","PHYLOGENETICS")
#'  
#'  # number of citations of iNaturalist 
#'  lit_count() # total number of literature referencing GBIF
#'  lit_count(peerReview=TRUE)
#'  lit_count(gbifDatasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#'  # number of peer-reviewed articles used GBIF mediated data
#'  lit_count(peerReview=TRUE,literatureType="JOURNAL",relevance="GBIF_USED")
#'  
#'  # fetches all from this query: 
#'  # lit_search(peerReview=TRUE,literatureType="JOURNAL",relevance="GBIF_USED")
#'  lit_all_gbif() 
#'  
#'  # fetches all data from this query:
#'  # lit_search(gbifDatasetKey="50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#'  lit_all_dataset("50c9509d-22c7-4a22-a47d-8c48425ef4a7")
#' 
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
  gbifDatasetKey=NULL, 
  publishingOrganizationKey=NULL, 
  peerReview=NULL, 
  openAccess=NULL, 
  gbifDownloadKey=NULL, 
  doi=NULL, 
  source=NULL, 
  publisher=NULL,
  flatten=TRUE,
  start=0,
  limit=500,
  curlopts = list()
  ) {
  if(limit > 1000) stop("Max 'limit' is 1000.")
  if(start > 10000) stop("Max 'start' is 10000.")
  if((start + limit) >= 10000) stop("Max 'start' + 'limit' is 10,000.")
  if(!is_uuid(gbifDatasetKey) & !is.null(gbifDatasetKey)) stop("'gbifDatasetKey' should be a GBIF dataset uuid.")
  if(!is_uuid(publishingOrganizationKey) & !is.null(publishingOrganizationKey)) stop("'publishingOrganizationKey' should be a GBIF publisher uuid.")
  if(!is_download_key(gbifDownloadKey) & !is.null(gbifDownloadKey)) stop("'gbifDownloadKey' should be a GBIF downloadkey.")
  assert(q,"character") 
  assert(countriesOfResearcher,"character")
  assert(countriesOfCoverage,"character") 
  assert(literatureType,"character") 
  assert(relevance,"character") 
  assert(topics,"character") 
  assert(peerReview,"logical")
  assert(openAccess,"logical")
  assert(gbifDownloadKey,"character")
  assert(doi,"character") 
  assert(source,"character")
  assert(publisher,"character")
  
  # args that take only a single value
  args <- rgbif_compact(list(
          q=q, 
          year=year, 
          peerReview=peerReview, 
          openAccess=openAccess, 
          offset=start,
          limit=limit
          ))
  # args that take many values
  args <- c(args,
            convmany(relevance),
            convmany(countriesOfResearcher),
            convmany(countriesOfCoverage),
            convmany(literatureType),
            convmany(topics),
            convmany(gbifDatasetKey), 
            convmany(publishingOrganizationKey),
            convmany(gbifDownloadKey), 
            convmany(doi), 
            convmany(source), 
            convmany(publisher)
            )
  url <- paste0(gbif_base(), "/literature/search")
  ll <- gbif_GET(url, args, parse=TRUE, curlopts = curlopts, mssg = NULL) 
  data <- ll$results
  if(flatten) {
  # handle complex identifiers and authors 
  data$authors <- sapply(data$authors,function(x) paste0(x$firstName," ",x$lastName,collapse=","))
  data <- tibble::tibble(data,data$identifiers)
  data$identifiers <- NULL 
  # flatten other columns
  data <- dplyr::as_tibble(lapply(data,function(x) if(is.list(x)) sapply(x,toString) else x))
  }
  ll$results <- NULL
  meta <- rgbif_compact(ll) 
  list(data=data,meta=meta)
}

#' @export
#' @rdname lit_search
lit_all_gbif <- function(nrows=NULL,
                         peerReview=TRUE,
                         flatten=TRUE,
                         step=1000) {
  # check inputs
  assert(peerReview,"logical")
  assert(flatten,"logical")
  if(step > 1000) stop("Max step is 1000.")
  if(is.null(nrows)) nrows <- lit_count(literatureType="JOURNAL",relevance="GBIF_USED",peerReview=peerReview)
  if((nrows + step) >= 10000) stop("Max 'nrows' + 'step' is 10,000.")
  if(nrows > 10000) { 
    message("Max allowed 10,000 records. Contact helpdesk@gbif.org for more.")
    nrows <- 9999 }
  if(step >= nrows) step <- nrows
  if((nrows %% step) == 0) { offset_seq <- seq(from=0,nrows,by=step) 
  } else { 
    offset_seq <- c(seq(from=0,nrows,by=step),nrows) 
    }
  if(step == nrows) offset_seq <- 0 # only one request needed 
  
  # make async request
  req <- "literatureType=journal&relevance=GBIF_USED"
  if(!is.null(peerReview)) {
    if(peerReview) { req <- paste0(req,"&peerReview=true") 
    } else { req <- paste0(req,"&peerReview=false") }
  }
  
  urls <- paste0(gbif_base(),
                 "/literature/search?",req,
                 "&offset=",offset_seq,
                 "&limit=",step)
  ll <- gbif_async_get(urls,parse=TRUE)
  data <- process_lit_async_results(ll,flatten=flatten)
  data
}

#' @export
#' @rdname lit_search
lit_all_dataset <- function(gbifDatasetKey=NULL,
                        peerReview=NULL,
                        nrows=NULL,
                        step=1000,
                        flatten=TRUE) {
  # check inputs
  if(!is_uuid(gbifDatasetKey)) stop("'gbifDatasetKey' should be a GBIF datasetkey uuid.")
  assert(peerReview,"logical")
  assert(flatten,"logical")
  if(step > 1000) stop("Max step is 1000.")
  if(is.null(nrows)) nrows <- lit_count(gbifDatasetKey=gbifDatasetKey,peerReview=peerReview)
  if((nrows + step) >= 10000) stop("Max 'nrows' + 'step' is 10,000.")
  if(nrows > 10000) {
    message("Max allowed 10,000 records. Contact helpdesk@gbif.org.")
    nrows <- 9999 }
  
  if(step >= nrows) step <- nrows
  if((nrows %% step) == 0) { offset_seq <- seq(from=0,nrows,by=step)
    } else {
    offset_seq <- c(seq(from=0,nrows,by=step),nrows) }
  if(step == nrows) offset_seq <- 0 # only one request needed
  
  # make async request
  req <- paste0("&gbifDatasetKey=",gbifDatasetKey)
  if(!is.null(peerReview)) {
    if(peerReview) { req <- paste0(req,"&peerReview=true") }
      else { req <- paste0(req,"&peerReview=false") }
  }
  urls <- paste0(gbif_base(),
                 "/literature/search?",req,
                 "&offset=",offset_seq,
                 "&limit=",step)
  ll <- gbif_async_get(urls,parse=TRUE)
  data <- process_lit_async_results(ll,flatten=flatten)
  data
}

#' @export
#' @rdname lit_search
lit_count <- function(...) {
  
  x <- rgbif_compact(list(...))
  accepted_args <- c("q","countriesOfResearcher","countriesOfResearcher","countriesOfCoverage",
    "literatureType","relevance","year","topics","gbifDatasetKey",
    "publishingOrganizationKey","peerReview","openAccess","gbifDownloadKey",
    "doi","source","publisher")
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
    gbifDatasetKey=x$gbifDatasetKey,
    publishingOrganizationKey=x$publishingOrganizationKey,
    peerReview=x$peerReview,
    openAccess=x$openAccess,
    gbifDownloadKey=x$gbifDownloadKey,
    doi=x$doi,
    source=x$source,
    publisher=x$publisher,
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
    data <- dplyr::as_tibble(lapply(data,function(x) if(is.list(x)) sapply(x,toString) else x))
  }
  data$x <- NULL
  data
}

