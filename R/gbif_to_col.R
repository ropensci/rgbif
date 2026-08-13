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
#' @return A list containing the full API response for each input key. Each element
#' includes:
#' \itemize{
#'   \item \code{gbif_key} - The input GBIF Backbone key
#'   \item \code{usage} - The matched COL taxon usage details (including the COL key)
#'   \item \code{classification} - Full taxonomic classification path
#'   \item \code{diagnostics} - Match quality information (matchType, confidence, etc.)
#'   \item \code{additionalStatus} - Additional status information (e.g., IUCN status)
#'   \item \code{synonym} - Whether the match is a synonym
#' }
#' If only one key is provided, returns an object of class \code{gbif_to_col} with a
#' custom print method. If multiple keys are provided, returns an object of class
#' \code{gbif_to_col_list}. The full API response data is always accessible in the
#' returned list structure.
#'
#' @details
#' This function uses the GBIF species matching API with the `scientificNameID`
#' parameter to resolve GBIF Backbone taxonomy keys to COL Extended Release keys.
#' This is useful when migrating existing code from numeric GBIF Backbone keys
#' to the new COL XR alpha-numeric keys.
#'
#' @references
#' \url{https://techdocs.gbif.org/en/openapi/v2/species}
#'
#' @family name
#'
#' @examples \dontrun{
#' # Convert a single GBIF Backbone key to COL XR
#' result <- gbif_to_col(5231190)  # Calopteryx splendens
#' 
#' # The print method shows a clean summary:
#' # <<GBIF to COL key conversion>>
#' #   GBIF Backbone key: 5231190
#' #   COL Extended Release key: Q2M4
#' #   Scientific name: Calopteryx splendens
#' #   Rank: SPECIES
#' #   Match type: EXACT
#' #   Confidence: 100
#' 
#' # Access the full data structure:
#' result$usage$key                # COL XR key: "Q2M4"
#' result$usage$name               # Scientific name
#' result$classification           # Full taxonomic hierarchy
#' result$diagnostics$matchType    # Quality of match
#' result$diagnostics$confidence   # Confidence score
#'
#' # Convert multiple keys at once
#' results <- gbif_to_col(c(5231190, 2435099, 2877951))
#' results  # Shows summary for all matches
#' 
#' # Extract specific data from multiple results:
#' sapply(results, function(x) x$usage$key)  # Extract all COL keys
#' sapply(results, function(x) x$usage$name) # Extract all names
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
    
    # Build API URL - use v2 API for COL Extended Release keys
    url <- 'https://api.gbif.org/v2/species/match'
    
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
    
    # Return the full API response with the original key
    if (!is.null(tt)) {
      c(list(gbif_key = k), tt)
    } else {
      list(gbif_key = k, usage = NULL, classification = NULL, 
           diagnostics = NULL, additionalStatus = NULL, synonym = NULL)
    }
  })
  
  # If only one key, return a single list; otherwise return list of lists
  if (length(key) == 1) {
    structure(results[[1]], class = "gbif_to_col")
  } else {
    structure(results, class = "gbif_to_col_list")
  }
}

#' @export
print.gbif_to_col <- function(x, ...) {
  cat_n("<<GBIF to COL key conversion>>")
  cat_n("  GBIF Backbone key: ", x$gbif_key)
  
  if (!is.null(x$usage)) {
    cat_n("  COL Extended Release key: ", x$usage$key)
    cat_n("  Scientific name: ", x$usage$name)
    cat_n("  Rank: ", x$usage$rank)
    cat_n("  Status: ", x$usage$status)
  } else {
    cat_n("  COL Extended Release key: <no match>")
  }
  
  if (!is.null(x$diagnostics)) {
    cat_n("  Match type: ", x$diagnostics$matchType)
    cat_n("  Confidence: ", x$diagnostics$confidence)
  }
  
  if (!is.null(x$synonym) && x$synonym) {
    cat_n("  Note: Match is a synonym")
  }
}

#' @export
print.gbif_to_col_list <- function(x, ..., n = 10) {
  total <- length(x)
  cat_n("<<GBIF to COL key conversion (", total, " result", 
        if (total != 1) "s" else "", ")>>")
  cat_n("")
  
  # Determine how many to show
  n_show <- min(n, total)
  
  for (i in seq_len(n_show)) {
    item <- x[[i]]
    gbif_key <- item$gbif_key
    col_key <- if (!is.null(item$usage)) item$usage$key else "<no match>"
    name <- if (!is.null(item$usage)) item$usage$name else NA
    match_type <- if (!is.null(item$diagnostics)) item$diagnostics$matchType else NA
    
    cat_n("  [", i, "] GBIF: ", gbif_key, " -> COL: ", col_key)
    if (!is.na(name)) {
      cat_n("      Name: ", name, " (", match_type, ")")
    }
  }
  
  # Show message if there are more results
  if (total > n_show) {
    cat_n("")
    cat_n("  ... with ", total - n_show, " more result", 
          if ((total - n_show) != 1) "s" else "")
    cat_n("  Use print(x, n = ", total, ") to show all")
  }
}
