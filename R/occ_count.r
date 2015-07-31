#' Get number of occurrence records.
#'
#' @export
#'
#' @param nubKey Species key. PARAMETER NAME CHANGED TO taxonKey.
#' @param taxonKey Species key
#' @param georeferenced Return only occurence records with lat/long data (TRUE) or
#'    all records (FALSE, default).
#' @param basisOfRecord Basis of record
#' @param datasetKey Dataset key
#' @param date Collection date
#' @param year Year data were collected in
#' @param catalogNumber Catalog number. PARAMETER GONE.
#' @param country Country data was collected in, two letter abbreviation. See
#' \url{http://countrycode.org/} for abbreviations.
#' @param protocol Protocol. E.g., 'DWC_ARCHIVE'
#' @param hostCountry Country that hosted the data. PARAMETER GONE.
#' @param publishingCountry Publishing country, two letter ISO country code
#' @param from Year to start at
#' @param to Year to end at
#' @param type One of count (default), schema, basis_of_record, countries, or year.
#' @param ... Further named parameters, such as \code{query}, \code{path}, etc, passed on to
#' \code{\link[httr]{modify_url}} within \code{\link[httr]{GET}} call. Unnamed parameters will be
#' combined with \code{\link[httr]{config}}.
#'
#' @return A single numeric value, or a list of numerics.
#' @references \url{http://www.gbif.org/developer/occurrence#metrics}
#'
#' @details There is a slight difference in the way records are counted here vs.
#' results from \code{\link{occ_search}}. For equivalent outcomes, in the
#' \code{\link{occ_search}} function use \code{hasCoordinate=TRUE}, and
#' \code{hasGeospatialIssue=FALSE} to have the same outcome for this function
#' using \code{georeferenced=TRUE}.
#'
#' @examples \dontrun{
#' occ_count(basisOfRecord='OBSERVATION')
#' occ_count(georeferenced=TRUE)
#' occ_count(country='DE')
#' occ_count(country='CA', georeferenced=TRUE, basisOfRecord='OBSERVATION')
#' occ_count(datasetKey='9e7ea106-0bf8-4087-bb61-dfe4f29e0f17')
#' occ_count(year=2012)
#' occ_count(taxonKey=2435099)
#' occ_count(taxonKey=2435099, georeferenced=TRUE)
#' occ_count(protocol='DWC_ARCHIVE')
#'
#' # Just schema
#' occ_count(type='schema')
#'
#' # Counts by basisOfRecord types
#' occ_count(type='basisOfRecord')
#'
#' # Counts by countries. publishingCountry must be supplied (default to US)
#' occ_count(type='countries')
#'
#' # Counts by year. from and to years have to be supplied, default to 2000 and 2012
#' occ_count(type='year', from=2000, to=2012)
#'
#' # Counts by publishingCountry, must supply a country (default to US)
#' occ_count(type='publishingCountry')
#' occ_count(type='publishingCountry', country='BZ')
#'
#' # Pass on options to httr
#' library('httr')
#' # res <- occ_count(type='year', from=2000, to=2012, config=progress())
#' # res
#' }

occ_count <- function(taxonKey=NULL, georeferenced=NULL, basisOfRecord=NULL,
  datasetKey=NULL, date=NULL, catalogNumber=NULL, country=NULL, hostCountry=NULL,
  year=NULL, from=2000, to=2012, type='count', publishingCountry='US',
  nubKey=NULL, protocol=NULL, ...) {

  calls <- names(sapply(match.call(), deparse))[-1]
  calls_vec <- c("nubKey","hostCountry","catalogNumber") %in% calls
  if(any(calls_vec))
    stop("Parameter name changes: \n nubKey -> taxonKey\nParameters gone: \n hostCountry\n catalogNumber")

  args <- rgbif_compact(list(taxonKey=taxonKey, isGeoreferenced=georeferenced,
                       basisOfRecord=basisOfRecord, datasetKey=datasetKey,
                       date=date, catalogNumber=catalogNumber, country=country,
                       hostCountry=hostCountry, year=year, protocol=protocol))
  type <- match.arg(type, choices=c("count","schema","basisOfRecord","countries","year","publishingCountry"))
  url <- switch(type,
                count = paste0(gbif_base(), '/occurrence/count'),
                schema = paste0(gbif_base(), '/occurrence/count/schema'),
                basisOfRecord = paste0(gbif_base(), '/occurrence/counts/basisOfRecord'),
                countries = paste0(gbif_base(), '/occurrence/counts/countries'),
                year = paste0(gbif_base(), '/occurrence/counts/year'),
                publishingCountry = paste0(gbif_base(), '/occurrence/counts/publishingCountries'))
  args <- switch(type,
                count = args,
                schema = list(),
                basisofRecord = list(),
                countries = rgbif_compact(list(publishingCountry=publishingCountry)),
                year = rgbif_compact(list(from=from, to=to)),
                publishingCountry = rgbif_compact(list(country=ifelse(is.null(country), "US", country) )))
  res <- gbif_GET_content(url, args, ...)
  if(type=='count'){ as.numeric(res) } else { jsonlite::fromJSON(res, FALSE) }
}
