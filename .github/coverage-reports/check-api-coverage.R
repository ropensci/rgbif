#!/usr/bin/env Rscript
# Check GBIF API coverage by comparing OpenAPI specs with rgbif implementation
# This script compares the GBIF OpenAPI specifications against the api-mapping.json

library(jsonlite)
library(httr)

# Configuration
OPENAPI_URLS <- list(
  occurrence = "https://techdocs.gbif.org/openapi/occurrence.json",
  checklistbank = "https://techdocs.gbif.org/openapi/checklistbank.json",
  registry = "https://techdocs.gbif.org/openapi/registry.json",
  literature = "https://techdocs.gbif.org/openapi/literature.json",
  validator = "https://techdocs.gbif.org/openapi/validator.json"
)

# Get package root
pkg_root <- getwd()
mapping_file <- file.path(pkg_root, ".github", "coverage-reports", "api-mapping.json")
output_dir <- file.path(pkg_root, ".github", "coverage-reports")

# Create output directory
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# Color output helpers
cat_success <- function(...) cat("\033[32m", ..., "\033[0m\n", sep = "")
cat_error <- function(...) cat("\033[31m", ..., "\033[0m\n", sep = "")
cat_warning <- function(...) cat("\033[33m", ..., "\033[0m\n", sep = "")
cat_info <- function(...) cat("\033[36m", ..., "\033[0m\n", sep = "")

# Download OpenAPI spec
download_spec <- function(url, name) {
  cat_info("Downloading ", name, " OpenAPI spec...")
  tryCatch({
    response <- GET(url, timeout(30))
    if (status_code(response) == 200) {
      spec <- content(response, as = "parsed")
      cat_success("  ✓ Downloaded ", name)
      return(spec)
    } else {
      cat_error("  ✗ Failed to download ", name, ": HTTP ", status_code(response))
      return(NULL)
    }
  }, error = function(e) {
    cat_error("  ✗ Error downloading ", name, ": ", e$message)
    return(NULL)
  })
}

# Extract endpoints from OpenAPI spec
extract_endpoints <- function(spec, api_name) {
  endpoints <- list()
  
  if (is.null(spec$paths)) {
    cat_warning("  ! No paths found in ", api_name, " spec")
    return(endpoints)
  }
  
  for (path in names(spec$paths)) {
    path_obj <- spec$paths[[path]]
    
    # Check each HTTP method
    for (method in c("get", "post", "put", "delete", "patch")) {
      if (!is.null(path_obj[[method]])) {
        operation <- path_obj[[method]]
        
        # Extract parameters
        params <- list()
        if (!is.null(operation$parameters)) {
          for (param in operation$parameters) {
            param_info <- list(
              name = param$name,
              location = param$`in`,  # 'in' is reserved, use backticks or different name
              required = isTRUE(param$required),
              type = if (!is.null(param$schema$type)) param$schema$type else "unknown"
            )
            params[[param$name]] <- param_info
          }
        }
        
        # Check for requestBody parameters
        if (!is.null(operation$requestBody)) {
          # Mark that this endpoint has a request body
          params[["_requestBody"]] <- list(
            name = "_requestBody",
            location = "body",
            required = isTRUE(operation$requestBody$required),
            type = "object"
          )
        }
        
        endpoint_key <- paste0(toupper(method), " ", path)
        endpoints[[endpoint_key]] <- list(
          path = path,
          method = toupper(method),
          summary = if (!is.null(operation$summary)) operation$summary else "",
          operationId = if (!is.null(operation$operationId)) operation$operationId else "",
          parameters = params,
          api = api_name
        )
      }
    }
  }
  
  return(endpoints)
}

# Normalize path parameters for comparison
# Replaces all {paramName} with {*} so paths can be matched regardless of parameter names
normalize_path <- function(path) {
  gsub("\\{[^}]+\\}", "{*}", path)
}

# Load mapping file
load_mapping <- function() {
  if (!file.exists(mapping_file)) {
    cat_error("Mapping file not found: ", mapping_file)
    cat_info("Please create the mapping file first.")
    cat_info("You can run: Rscript .github/scripts/generate-mapping-template.R")
    return(NULL)
  }
  
  tryCatch({
    mapping <- fromJSON(mapping_file, simplifyVector = FALSE)
    cat_success("Loaded mapping file with ", length(mapping$mappings), " function mappings")
    return(mapping)
  }, error = function(e) {
    cat_error("Error loading mapping file: ", e$message)
    return(NULL)
  })
}

# Compare coverage
compare_coverage <- function(all_endpoints, mapping) {
  cat_info("\n=== Coverage Analysis ===\n")
  
  # Build implemented endpoints from mapping with normalized paths
  implemented <- list()
  implemented_normalized <- list()  # For comparison
  for (func_mapping in mapping$mappings) {
    endpoint_key <- paste0(func_mapping$method, " ", func_mapping$endpoint)
    normalized_key <- paste0(func_mapping$method, " ", normalize_path(func_mapping$endpoint))
    
    implemented[[endpoint_key]] <- list(
      function_name = func_mapping$function_name,
      parameters = func_mapping$parameters,
      original_endpoint = func_mapping$endpoint,
      parameter_mappings = func_mapping$parameter_mappings
    )
    
    # Store mapping from normalized key to original key for lookup
    if (is.null(implemented_normalized[[normalized_key]])) {
      implemented_normalized[[normalized_key]] <- list()
    }
    implemented_normalized[[normalized_key]][[length(implemented_normalized[[normalized_key]]) + 1]] <- endpoint_key
  }
  
  # Build ignored endpoints list with normalized paths
  ignored_endpoints <- list()
  ignored_normalized <- list()
  ignored_full_normalized <- list()  # For METHOD + path format
  if (!is.null(mapping$ignored_endpoints)) {
    for (ignored in mapping$ignored_endpoints) {
      # Check if endpoint has METHOD prefix (e.g., "POST /path")
      if (grepl("^(GET|POST|PUT|DELETE|PATCH) /", ignored$endpoint)) {
        # Has METHOD, normalize the full "METHOD path" string
        parts <- strsplit(ignored$endpoint, " ", fixed = TRUE)[[1]]
        method <- parts[1]
        path <- paste(parts[-1], collapse = " ")
        normalized_full_key <- paste0(method, " ", normalize_path(path))
        ignored_full_normalized[[normalized_full_key]] <- ignored$reason
      } else {
        # No METHOD, just path - normalize path only
        ignored_normalized[[normalize_path(ignored$endpoint)]] <- ignored$reason
      }
      ignored_endpoints[[ignored$endpoint]] <- ignored$reason
    }
  }
  
  # Find missing endpoints
  missing_endpoints <- list()
  for (endpoint_key in names(all_endpoints)) {
    endpoint <- all_endpoints[[endpoint_key]]
    normalized_key <- paste0(endpoint$method, " ", normalize_path(endpoint$path))
    normalized_path <- normalize_path(endpoint$path)
    
    # Check if endpoint is ignored (check both path-only and method+path formats)
    if (normalized_path %in% names(ignored_normalized) || 
        normalized_key %in% names(ignored_full_normalized)) {
      next
    }
    
    # Check if endpoint is implemented (using normalized path)
    if (!normalized_key %in% names(implemented_normalized)) {
      missing_endpoints[[endpoint_key]] <- endpoint
    }
  }
  
  # Find missing parameters
  missing_params <- list()
  for (endpoint_key in names(implemented)) {
    impl_info <- implemented[[endpoint_key]]
    normalized_key <- paste0(toupper(sub(" .*", "", endpoint_key)), " ", normalize_path(impl_info$original_endpoint))
    
    # Find matching API endpoint using normalized path
    matching_api_endpoint <- NULL
    for (api_key in names(all_endpoints)) {
      api_endpoint <- all_endpoints[[api_key]]
      api_normalized_key <- paste0(api_endpoint$method, " ", normalize_path(api_endpoint$path))
      if (api_normalized_key == normalized_key) {
        matching_api_endpoint <- api_endpoint
        break
      }
    }
    
    if (!is.null(matching_api_endpoint)) {
      api_params <- names(matching_api_endpoint$parameters)
      impl_params <- impl_info$parameters
      
      # Convert to character vector if needed
      if (is.list(impl_params)) {
        impl_params <- unlist(impl_params)
      }
      
      # Remove internal parameters
      api_params <- api_params[!api_params %in% c("_requestBody", "limit", "offset")]
      
      # Apply parameter name mappings if they exist
      if (!is.null(impl_info$parameter_mappings)) {
        for (api_name in names(impl_info$parameter_mappings)) {
          rgbif_name <- impl_info$parameter_mappings[[api_name]]
          # If the rgbif parameter exists and API parameter is in the list, consider it covered
          if (rgbif_name %in% impl_params && api_name %in% api_params) {
            api_params <- api_params[api_params != api_name]
          }
        }
      }
      
      # Check for missing parameters
      missing <- setdiff(api_params, impl_params)
      
      # Filter out ignored parameters
      if (length(missing) > 0 && !is.null(mapping$ignored_parameters)) {
        # Get function-specific ignored parameters
        func_ignored <- NULL
        if (!is.null(mapping$ignored_parameters[[impl_info$function_name]])) {
          func_ignored <- names(mapping$ignored_parameters[[impl_info$function_name]])
        }
        
        # Get general ignored parameters
        general_ignored <- NULL
        if (!is.null(mapping$ignored_parameters$general)) {
          general_ignored <- names(mapping$ignored_parameters$general)
        }
        
        # Combine all ignored parameters
        all_ignored <- c(func_ignored, general_ignored)
        
        # Remove ignored parameters from missing list
        if (!is.null(all_ignored) && length(all_ignored) > 0) {
          missing <- missing[!missing %in% all_ignored]
        }
      }
      if (length(missing) > 0) {
        missing_params[[endpoint_key]] <- list(
          function_name = impl_info$function_name,
          missing_parameters = missing,
          api_parameters = api_params,
          implemented_parameters = impl_params
        )
      }
    }
  }
  
  # Calculate coverage statistics
  # Count unique normalized API endpoints that are implemented
  implemented_api_endpoints <- 0
  for (api_key in names(all_endpoints)) {
    api_endpoint <- all_endpoints[[api_key]]
    normalized_key <- paste0(api_endpoint$method, " ", normalize_path(api_endpoint$path))
    normalized_path <- normalize_path(api_endpoint$path)
    
    # Skip if ignored
    if (normalized_path %in% names(ignored_normalized)) {
      next
    }
    
    # Check if implemented
    if (normalized_key %in% names(implemented_normalized)) {
      implemented_api_endpoints <- implemented_api_endpoints + 1
    }
  }
  
  total_endpoints <- length(all_endpoints)
  ignored_count <- length(ignored_normalized) + length(ignored_full_normalized)
  relevant_endpoints <- total_endpoints - ignored_count
  implemented_count <- implemented_api_endpoints
  missing_count <- length(missing_endpoints)
  
  coverage_pct <- if (relevant_endpoints > 0) {
    round((implemented_count / relevant_endpoints) * 100, 1)
  } else {
    0
  }
  
  # Print summary
  cat_info("Total API endpoints: ", total_endpoints)
  cat_info("Ignored endpoints: ", ignored_count)
  cat_info("Relevant endpoints: ", relevant_endpoints)
  cat_success("Implemented endpoints: ", implemented_count)
  cat_warning("Missing endpoints: ", missing_count)
  cat_info("Coverage: ", coverage_pct, "%\n")
  
  if (length(missing_params) > 0) {
    cat_warning("Functions with missing parameters: ", length(missing_params))
  }
  
  # Return results
  list(
    summary = list(
      total_endpoints = total_endpoints,
      ignored_endpoints = ignored_count,
      relevant_endpoints = relevant_endpoints,
      implemented_endpoints = implemented_count,
      missing_endpoints = missing_count,
      coverage_percentage = coverage_pct,
      functions_with_missing_params = length(missing_params)
    ),
    missing_endpoints = missing_endpoints,
    missing_parameters = missing_params,
    implemented = implemented
  )
}

# Generate detailed reports
generate_reports <- function(results, all_endpoints) {
  # JSON report
  json_file <- file.path(output_dir, "coverage-report.json")
  write_json(results, json_file, pretty = TRUE, auto_unbox = TRUE)
  cat_success("JSON report saved: ", json_file)
  
  # Markdown report
  md_file <- file.path(output_dir, "coverage-report.md")
  md_content <- c(
    paste("# GBIF API Coverage Report"),
    paste("Generated:", Sys.time()),
    "",
    "## Summary",
    "",
    paste("- **Total API endpoints:**", results$summary$total_endpoints),
    paste("- **Ignored endpoints:**", results$summary$ignored_endpoints),
    paste("- **Relevant endpoints:**", results$summary$relevant_endpoints),
    paste("- **Implemented endpoints:**", results$summary$implemented_endpoints),
    paste("- **Missing endpoints:**", results$summary$missing_endpoints),
    paste("- **Coverage:**", paste0(results$summary$coverage_percentage, "%")),
    paste("- **Functions with missing parameters:**", results$summary$functions_with_missing_params),
    ""
  )
  
  if (length(results$missing_endpoints) > 0) {
    md_content <- c(md_content,
      "## Missing Endpoints",
      ""
    )
    for (endpoint_key in names(results$missing_endpoints)) {
      endpoint <- results$missing_endpoints[[endpoint_key]]
      md_content <- c(md_content,
        paste("###", endpoint_key),
        paste("- **API:**", endpoint$api),
        paste("- **Summary:**", endpoint$summary),
        paste("- **Operation ID:**", endpoint$operationId),
        "- [ ] Ignore",
        "- [ ] Issue",
        ""
      )
    }
  }
  
  if (length(results$missing_parameters) > 0) {
    md_content <- c(md_content,
      "## Functions with Missing Parameters",
      ""
    )
    for (endpoint_key in names(results$missing_parameters)) {
      info <- results$missing_parameters[[endpoint_key]]
      md_content <- c(md_content,
        paste("###", info$function_name, "-", endpoint_key),
        "- **Missing parameters:**"
      )
      # Add each parameter as a simple list item
      for (param in info$missing_parameters) {
        md_content <- c(md_content,
          paste0("  - `", param, "`")
        )
      }
      md_content <- c(md_content,
        "- [ ] Ignore",
        "- [ ] Issue",
        ""
      )
    }
  }
  
  writeLines(md_content, md_file)
  cat_success("Markdown report saved: ", md_file)
}

# Main execution
main <- function() {
  cat_info("=== GBIF API Coverage Check ===\n")
  
  # Download OpenAPI specs
  all_specs <- list()
  for (api_name in names(OPENAPI_URLS)) {
    spec <- download_spec(OPENAPI_URLS[[api_name]], api_name)
    if (!is.null(spec)) {
      all_specs[[api_name]] <- spec
    }
  }
  
  if (length(all_specs) == 0) {
    cat_error("\nFailed to download any OpenAPI specs. Exiting.")
    quit(status = 1)
  }
  
  cat_info("\n=== Extracting Endpoints ===\n")
  
  # Extract all endpoints
  all_endpoints <- list()
  for (api_name in names(all_specs)) {
    cat_info("Processing ", api_name, "...")
    endpoints <- extract_endpoints(all_specs[[api_name]], api_name)
    cat_success("  Found ", length(endpoints), " endpoints")
    all_endpoints <- c(all_endpoints, endpoints)
  }
  
  cat_success("\nTotal endpoints extracted: ", length(all_endpoints))
  
  # Load mapping
  cat_info("\n=== Loading Mapping ===\n")
  mapping <- load_mapping()
  if (is.null(mapping)) {
    quit(status = 1)
  }
  
  # Compare coverage
  results <- compare_coverage(all_endpoints, mapping)
  
  # Generate reports
  cat_info("\n=== Generating Reports ===\n")
  generate_reports(results, all_endpoints)
  
  # Print detailed missing endpoints if not too many
  if (length(results$missing_endpoints) > 0 && length(results$missing_endpoints) <= 20) {
    cat_info("\n=== Missing Endpoints (Top 20) ===\n")
    count <- 0
    for (endpoint_key in names(results$missing_endpoints)) {
      count <- count + 1
      if (count > 20) break
      endpoint <- results$missing_endpoints[[endpoint_key]]
      cat_warning(endpoint_key)
      cat("  API: ", endpoint$api, "\n", sep = "")
      if (nchar(endpoint$summary) > 0) {
        cat("  Summary: ", endpoint$summary, "\n", sep = "")
      }
    }
  }
  
  cat_info("\n=== Check Complete ===\n")
  
  # Exit with error if coverage is too low (configurable threshold)
  threshold <- 50  # Can be made configurable via environment variable
  if (results$summary$coverage_percentage < threshold) {
    cat_warning("Warning: Coverage (", results$summary$coverage_percentage, 
                "%) is below threshold (", threshold, "%)")
    # Uncomment to fail the build:
    # quit(status = 1)
  }
  
  cat_success("Coverage check completed successfully!")
}

# Run main
main()
