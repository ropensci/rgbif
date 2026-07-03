#' Convert GBIF Backbone taxon keys to COL Extended Release keys
#'
#' @export
#' @param key (integer or character) One or more GBIF Backbone numeric taxon keys
#' to convert to COL Extended Release alpha-numeric keys. Can be a single value
#' or a vector of values.
#' @param checklistKey (character) The key of the COL checklist to use. Defaults
#' to COL Extended Release. Generally should not need to change this.
#' @param curlopts A list of curl options passed on to [httr::GET()].
#'
#' @return A tibble with columns for the input GBIF key and the corresponding
#' COL Extended Release usageKey. If a match is not found, the COL key will be NA.
#' Additional columns include matchType, confidence, and status to help assess
#' the quality of the match.
#'
#' @details
#' This function uses the GBIF species matching API with the `scientificNameID`
#' parameter to resolve GBIF Backbone taxonomy keys to COL Extended Release keys.
#' This is useful when migrating existing code from numeric GBIF Backbone keys
#' to the new COL XR alpha-numeric keys.
#'
#' The function prefixes each key with "gbif:" before querying the API, following
#' the GBIF identifier convention.
#'
#' @references
#' \url{https://techdocs.gbif.org/en/openapi/v1/species}
#'
#' @family name
#'
#' @examples \dontrun{
#' # Convert a single GBIF Backbone key to COL XR
#' gbif_to_col(5231190)  # Calopteryx splendens
#'
#' # Convert multiple keys at once
#' gbif_to_col(c(5231190, 2435099, 2877951))
#'
#' # The result includes match quality information
#' result <- gbif_to_col(5231190)
#' result$gbif_key      # Original GBIF key: 5231190
#' result$col_usageKey  # COL XR key: "Q2M4"
#' result$matchType     # Quality of match
#' result$confidence    # Confidence score
#' }
gbif_to_col <- function(key, 
  checklistKey = "7ddf754f-d193-4cc9-b351-99906754a03b",
  curlopts = list(http_version = 2)) {
  
  # Validate input
  if (is.null(key) || length(key) == 0) {
    stop("key parameter is required", call. = FALSE)
  }
  
  # Convert key to character/numeric if needed
  key <- as.character(key)
  
  # Process each key
  results <- lapply(key, function(k) {
    # Build scientificNameID in GBIF format
    scientificNameID <- paste0("gbif:", k)
    
    # Build API URL
    url <- paste0(gbif_base(), '/species/match')
    
    # Build query arguments
    args <- rgbif_compact(list(
      checklistKey = checklistKey,
      scientificNameID = scientificNameID
    ))
    
    # Make the API call
    tt <- tryCatch({
      gbif_GET(url, args, FALSE, curlopts)
    }, error = function(e) {
      warning("Failed to convert key ", k, ": ", e$message, call. = FALSE)
      return(NULL)
    })
    
    # Extract relevant fields
    if (!is.null(tt)) {
      data.frame(
        gbif_key = k,
        col_usageKey = tt$usageKey %||% NA_character_,
        col_scientificName = tt$scientificName %||% NA_character_,
        matchType = tt$matchType %||% NA_character_,
        confidence = tt$confidence %||% NA_integer_,
        status = tt$status %||% NA_character_,
        rank = tt$rank %||% NA_character_,
        stringsAsFactors = FALSE
      )
    } else {
      data.frame(
        gbif_key = k,
        col_usageKey = NA_character_,
        col_scientificName = NA_character_,
        matchType = NA_character_,
        confidence = NA_integer_,
        status = NA_character_,
        rank = NA_character_,
        stringsAsFactors = FALSE
      )
    }
  })
  
  # Combine results into a single data frame
  result_df <- do.call(rbind, results)
  
  # Convert to tibble
  tibble::as_tibble(result_df)
}
