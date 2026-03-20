#' Occurrence download statistics
#'
#' Retrieve statistics about GBIF occurrence downloads. Filters for downloads
#' matching the provided criteria, then provides counts by year, month and
#' dataset of the total number of downloads, and the total number of records
#' included in those downloads.
#'
#' @export
#'
#' @param from (character) Start date in format `YYYY-MM`. Optional.
#' @param to (character) End date in format `YYYY-MM`. Optional.
#' @param publishingCountry (character) ISO 2-letter country code. Optional.
#' @param datasetKey (character) Dataset UUID. Optional.
#' @param publishingOrgKey (character) Publishing organization UUID. Optional.
#' @param limit (integer) Number of results to return. Optional.
#' @param offset (integer) Offset for pagination. Optional.
#' @param curlopts list of named curl options passed on to [crul::HttpClient].
#'   See [curl::curl_options] for curl options
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return A list with two slots:
#' 
#' - meta: a single row data.frame with columns: `offset`, `limit`,
#' `endofrecords`, `count`
#' - results: a tibble with the results containing columns: `datasetKey`,
#' `totalRecords`, `numberDownloads`, `year`, `month`
#' 
#' @examples \dontrun{
#' # Get summarized download statistics
#' occ_download_stats()
#' 
#' # Filter by date range and country
#' occ_download_stats(from = "2023-01", to = "2023-12", publishingCountry = "US")
#' 
#' # Filter by publishing organization iNaturalist
#' occ_download_stats(publishingOrgKey = "28eb1a3f-1c15-4a95-931a-4af90ecb574d")
#' }
occ_download_stats <- function(
  from = NULL, 
  to = NULL, 
  publishingCountry = NULL, 
  datasetKey = NULL, 
  publishingOrgKey = NULL, 
  limit = NULL, 
  offset = NULL,
  curlopts = list(http_version = 2)) {
  
  assert(from, "character")
  assert(to, "character")
  assert(publishingCountry, "character")
  assert(datasetKey, "character")
  assert(publishingOrgKey, "character")
  assert(limit, c("integer", "numeric"))
  assert(offset, c("integer", "numeric"))
  
  url <- paste0(gbif_base(), '/occurrence/download/statistics')
  args <- rgbif_compact(list(
    fromDate = from,
    toDate = to,
    publishingCountry = publishingCountry,
    datasetKey = datasetKey,
    publishingOrgKey = publishingOrgKey,
    limit = limit,
    offset = offset
  ))
  
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(res$response_headers$`content-type` == 'application/json')
  tt <- res$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, flatten = TRUE)
  result <- prep_output(out)
  structure(result, 
    class = c("occ_download_stats", "list"),
    args = rgbif_compact(list(
      from = from,
      to = to,
      publishingCountry = publishingCountry,
      datasetKey = datasetKey,
      publishingOrgKey = publishingOrgKey
    ))
  )
}

#' Export summary of occurrence downloads
#'
#' Export a summary of occurrence downloads. Note that `from`, `to`, and 
#' `publishingCountry` are required parameters for this endpoint.
#'
#' @export
#' @param from (character) Start date in format `YYYY-MM`. Required.
#' @param to (character) End date in format `YYYY-MM`. Required.
#' @param publishingCountry (character) ISO 2-letter country code. Required.
#' @param datasetKey (character) Dataset UUID. Optional.
#' @param publishingOrgKey (character) Publishing organization UUID. Optional.
#' @param limit (integer) Number of results to return. Optional.
#' @param offset (integer) Offset for pagination. Optional.
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return A tibble with download summary data
#' 
#' @examples \dontrun{
#' # Export download summary (from, to, and publishingCountry are required)
#' occ_download_stats_export(from = "2023-01", to = "2023-12", publishingCountry = "US")
#' }
occ_download_stats_export <- function(
  from, 
  to, 
  publishingCountry, 
  datasetKey = NULL, 
  publishingOrgKey = NULL, 
  limit = NULL, 
  offset = NULL
  ) {
  
  # Check required parameters
  if (missing(from)) {
    stop("'from' is required for occ_download_stats_export(). ",
      "Provide a start date in format 'YYYY-MM'.", call. = FALSE)
  }
  if (missing(to)) {
    stop("'to' is required for occ_download_stats_export(). ",
      "Provide an end date in format 'YYYY-MM'.", call. = FALSE)
  }
  if (missing(publishingCountry)) {
    stop("'publishingCountry' is required for occ_download_stats_export(). ",
      "Provide an ISO 2-letter country code.", call. = FALSE)
  }
  
  # Check for NULL or NA
  check_vals(from, "from")
  check_vals(to, "to")
  check_vals(publishingCountry, "publishingCountry")
  
  assert(from, "character")
  assert(to, "character")
  assert(publishingCountry, "character")
  assert(datasetKey, "character")
  assert(publishingOrgKey, "character")
  assert(limit, c("integer", "numeric"))
  assert(offset, c("integer", "numeric"))
  
  url <- paste0(gbif_base(), '/occurrence/download/statistics/export')
  args <- rgbif_compact(list(
    fromDate = from,
    toDate = to,
    publishingCountry = publishingCountry,
    datasetKey = datasetKey,
    publishingOrgKey = publishingOrgKey,
    limit = limit,
    offset = offset
  ))
  
  # Build URL with query parameters
  url_query <- paste0(names(args), "=", args, collapse = "&")
  url_query <- utils::URLencode(url_query)
  url_full <- paste0(url, "?", url_query)
  
  # Download TSV to temp file and read
  temp_file <- tempfile()
  utils::download.file(url_full, destfile = temp_file, quiet = TRUE)
  out <- tibble::as_tibble(data.table::fread(temp_file, showProgress = FALSE))
  colnames(out) <- to_camel(colnames(out))
  out
}

#' Downloads by user country
#'
#' Summarizes downloads by month, grouped by the user's country code.
#'
#' @export
#'
#' @param from (character) Start date in format `YYYY-MM`. Optional.
#' @param to (character) End date in format `YYYY-MM`. Optional.
#' @param userCountry (character) ISO 2-letter country code. Optional.
#' @param publishingCountry (character) ISO 2-letter country code. Optional.
#' @param curlopts list of named curl options passed on to [crul::HttpClient].
#'   See [curl::curl_options] for curl options
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return A tibble with download counts by user country and month
#' 
#' @examples \dontrun{
#' # Run with no args to get monthly download counts for all of GBIF 
#' occ_download_stats_user_country()
#' 
#' # Filter by date range
#' occ_download_stats_user_country(from = "2023-01", to = "2023-12")
#' 
#' # Filter by user country
#' occ_download_stats_user_country(userCountry = "US")
#' }
occ_download_stats_user_country <- function(
  from = NULL, 
  to = NULL, 
  userCountry = NULL, 
  publishingCountry = NULL, 
  curlopts = list(http_version = 2)) {
  
  assert(from, "character")
  assert(to, "character")
  assert(userCountry, "character")
  assert(publishingCountry, "character")
  
  url <- paste0(gbif_base(), '/occurrence/download/statistics/downloadsByUserCountry')
  args <- rgbif_compact(list(
    fromDate = from,
    toDate = to,
    userCountry = userCountry,
    publishingCountry = publishingCountry
  ))
  
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(res$response_headers$`content-type` == 'application/json')
  tt <- res$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, simplifyVector = FALSE)
  
  # Convert nested structure to tidy data frame
  # Response: { "2023": {"1": 5, "2": 10}, "2024": {"3": 2} }
  # Output: year, month, number_downloads columns
  rows <- list()
  for (year in names(out)) {
    year_data <- out[[year]]
    for (month in names(year_data)) {
      rows[[length(rows) + 1]] <- list(
        year = as.integer(year),
        month = as.integer(month),
        number_downloads = as.integer(year_data[[month]])
      )
    }
  }
  if (length(rows) == 0) {
    return(tibble::tibble(
      year = integer(),
      month = integer(),
      number_downloads = integer()
    ))
  }
  result <- data.table::rbindlist(rows)
  tibble::as_tibble(result)
}

#' Downloaded records by dataset
#'
#' Summarize downloaded records by dataset.
#'
#' @export
#'
#' @param from (character) Start date in format `YYYY-MM`. Optional.
#' @param to (character) End date in format `YYYY-MM`. Optional.
#' @param publishingCountry (character) ISO 2-letter country code. Optional.
#' @param datasetKey (character) Dataset UUID. Optional.
#' @param publishingOrgKey (character) Publishing organization UUID. Optional.
#' @param curlopts list of named curl options passed on to [crul::HttpClient].
#'   See [curl::curl_options] for curl options
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return A tibble with columns: `year`, `month`, `number_records`. Each row
#'   represents the total number of records downloaded for a given year and month.
#' 
#' @examples \dontrun{
#' # Get downloaded records by dataset
#' occ_download_stats_dataset_records()
#' 
#' # Filter by date range
#' occ_download_stats_dataset_records(from = "2023-01", to = "2023-12")
#' 
#' # Filter by specific dataset
#' occ_download_stats_dataset_records(
#'   datasetKey = "50c9509d-22c7-4a22-a47d-8c48425ef4a7"
#' )
#' }
occ_download_stats_dataset_records <- function(
  from = NULL, 
  to = NULL, 
  publishingCountry = NULL, 
  datasetKey = NULL, 
  publishingOrgKey = NULL,
  curlopts = list(http_version = 2)) {
  
  assert(from, "character")
  assert(to, "character")
  assert(publishingCountry, "character")
  assert(datasetKey, "character")
  assert(publishingOrgKey, "character")
  
  url <- paste0(gbif_base(), '/occurrence/download/statistics/downloadedRecordsByDataset')
  args <- rgbif_compact(list(
    fromDate = from,
    toDate = to,
    publishingCountry = publishingCountry,
    datasetKey = datasetKey,
    publishingOrgKey = publishingOrgKey
  ))
  
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(res$response_headers$`content-type` == 'application/json')
  tt <- res$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, simplifyVector = FALSE)
  
  # Convert nested structure to tidy data frame
  # Response: { "2023": {"1": 5000, "2": 10000}, "2024": {"3": 2000} }
  # Output: year, month, number_records columns
  rows <- list()
  for (year in names(out)) {
    year_data <- out[[year]]
    for (month in names(year_data)) {
      rows[[length(rows) + 1]] <- list(
        year = as.integer(year),
        month = as.integer(month),
        number_records = as.numeric(year_data[[month]])
      )
    }
  }
  if (length(rows) == 0) {
    return(tibble::tibble(
      year = integer(),
      month = integer(),
      number_records = numeric()
    ))
  }
  result <- data.table::rbindlist(rows)
  tibble::as_tibble(result)
}

#' Downloads by dataset
#'
#' Summarize downloads by dataset.
#'
#' @export
#'
#' @param from (character) Start date in format `YYYY-MM`. Optional.
#' @param to (character) End date in format `YYYY-MM`. Optional.
#' @param publishingCountry (character) ISO 2-letter country code. Optional.
#' @param datasetKey (character) Dataset UUID. Optional.
#' @param publishingOrgKey (character) Publishing organization UUID. Optional.
#' @param curlopts list of named curl options passed on to [crul::HttpClient].
#'   See [curl::curl_options] for curl options
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return A tibble with columns: `year`, `month`, `number_downloads`. Each row
#'   represents the total number of downloads for a given year and month.
#' 
#' @examples \dontrun{
#' # Get downloads by dataset
#' occ_download_stats_dataset()
#' 
#' # Filter by date range and publishing country
#' occ_download_stats_dataset(from = "2023-01", publishingCountry = "US")
#' 
#' # Filter by publishing organization (e.g., iNaturalist)
#' occ_download_stats_dataset(publishingOrgKey = "28eb1a3f-1c15-4a95-931a-4af90ecb574d")
#' }
occ_download_stats_dataset <- function(
  from = NULL, 
  to = NULL, 
  publishingCountry = NULL, 
  datasetKey = NULL, 
  publishingOrgKey = NULL,
  curlopts = list(http_version = 2)) {
  
  assert(from, "character")
  assert(to, "character")
  assert(publishingCountry, "character")
  assert(datasetKey, "character")
  assert(publishingOrgKey, "character")
  
  url <- paste0(gbif_base(), '/occurrence/download/statistics/downloadsByDataset')
  args <- rgbif_compact(list(
    fromDate = from,
    toDate = to,
    publishingCountry = publishingCountry,
    datasetKey = datasetKey,
    publishingOrgKey = publishingOrgKey
  ))
  
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(res$response_headers$`content-type` == 'application/json')
  tt <- res$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, simplifyVector = FALSE)
  
  # Convert nested structure to tidy data frame
  # Response: { "2023": {"1": 5000, "2": 10000}, "2024": {"3": 2000} }
  # Output: year, month, number_downloads columns
  rows <- list()
  for (year in names(out)) {
    year_data <- out[[year]]
    for (month in names(year_data)) {
      rows[[length(rows) + 1]] <- list(
        year = as.integer(year),
        month = as.integer(month),
        number_downloads = as.integer(year_data[[month]])
      )
    }
  }
  if (length(rows) == 0) {
    return(tibble::tibble(
      year = integer(),
      month = integer(),
      number_downloads = integer()
    ))
  }
  result <- data.table::rbindlist(rows)
  tibble::as_tibble(result)
}

#' Downloads by source
#'
#' Summarize downloads by source.
#'
#' @export
#'
#' @param from (character) Start date in format `YYYY-MM`. Optional.
#' @param to (character) End date in format `YYYY-MM`. Optional.
#' @param source (character) Restrict to a particular source (e.g., "rgbif", "pygbif"). Optional.
#' @param curlopts list of named curl options passed on to [crul::HttpClient].
#'   See [curl::curl_options] for curl options
#' @note see [downloads] for an overview of GBIF downloads methods
#' @family downloads
#' @return A tibble with columns: `year`, `month`, `number_downloads`. Each row
#'   represents the total number of downloads for a given year and month.
#' 
#' @examples \dontrun{
#' # Get downloads by source
#' occ_download_stats_source()
#' 
#' # Filter by date range
#' occ_download_stats_source(from = "2023-01", to = "2023-12")
#' 
#' # Filter by source
#' occ_download_stats_source(source = "pygbif")
#' }
occ_download_stats_source <- function(
  from = NULL, 
  to = NULL, 
  source = NULL,
  curlopts = list(http_version = 2)) {
  
  assert(from, "character")
  assert(to, "character")
  assert(source, "character")
  
  url <- paste0(gbif_base(), '/occurrence/download/statistics/downloadsBySource')
  args <- rgbif_compact(list(
    fromDate = from,
    toDate = to,
    source = source
  ))
  
  cli <- crul::HttpClient$new(url = url, headers = rgbif_ual, opts = curlopts)
  res <- cli$get(query = args)
  if (res$status_code > 203) {
    if (length(res$content) == 0) res$raise_for_status()
    stop(res$parse("UTF-8"), call. = FALSE)
  }
  stopifnot(res$response_headers$`content-type` == 'application/json')
  tt <- res$parse("UTF-8")
  out <- jsonlite::fromJSON(tt, simplifyVector = FALSE)
  
  # Convert nested structure to tidy data frame
  # Response: { "2023": {"1": 5, "2": 10}, "2024": {"3": 2} }
  # Output: year, month, number_downloads columns
  rows <- list()
  for (year in names(out)) {
    year_data <- out[[year]]
    for (month in names(year_data)) {
      rows[[length(rows) + 1]] <- list(
        year = as.integer(year),
        month = as.integer(month),
        number_downloads = as.integer(year_data[[month]])
      )
    }
  }
  if (length(rows) == 0) {
    return(tibble::tibble(
      year = integer(),
      month = integer(),
      number_downloads = integer()
    ))
  }
  result <- data.table::rbindlist(rows)
  tibble::as_tibble(result)
}

#' @export
print.occ_download_stats <- function(x, ...) {
  cat("<<gbif download statistics>>\n")
  args <- attr(x, "args")
  if (!is.null(args) && length(args) > 0) {
    cat("  Filters:\n")
    if (!is.null(args$from)) cat("    From:", args$from, "\n")
    if (!is.null(args$to)) cat("    To:", args$to, "\n")
    if (!is.null(args$publishingCountry)) 
      cat("    Publishing country:", args$publishingCountry, "\n")
    if (!is.null(args$datasetKey)) 
      cat("    Dataset key:", args$datasetKey, "\n")
    if (!is.null(args$publishingOrgKey)) 
      cat("    Publishing org key:", args$publishingOrgKey, "\n")
  }
  cat("  Records found:", x$meta$count, "\n")
  cat("  Records returned:", nrow(x$results), "\n")
  if (nrow(x$results) > 0) {
    cat("\n")
    print(x$results)
  }
  invisible(x)
}
