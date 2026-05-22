#!/usr/bin/env Rscript
# Process checked boxes in coverage-report.md
# Updates api-mapping.json and creates data for GitHub issue creation

library(jsonlite)

# Configuration
pkg_root <- getwd()
report_file <- file.path(pkg_root, ".github", "coverage-reports", "coverage-report.md")
mapping_file <- file.path(pkg_root, ".github", "coverage-reports", "api-mapping.json")
actions_file <- file.path(pkg_root, ".github", "coverage-reports", "actions-to-take.json")

# Color output helpers
cat_success <- function(...) cat("\033[32m", ..., "\033[0m\n", sep = "")
cat_error <- function(...) cat("\033[31m", ..., "\033[0m\n", sep = "")
cat_info <- function(...) cat("\033[36m", ..., "\033[0m\n", sep = "")

# Parse the markdown file to find checked boxes
parse_checkboxes <- function(report_file) {
  if (!file.exists(report_file)) {
    cat_error("Coverage report not found: ", report_file)
    return(NULL)
  }
  
  lines <- readLines(report_file, warn = FALSE)
  
  # Track current context
  current_section <- NULL  # "endpoints" or "parameters"
  current_endpoint <- NULL
  current_function <- NULL
  current_api <- NULL
  
  # Store actions
  endpoint_actions <- list()
  parameter_actions <- list()
  
  for (i in seq_along(lines)) {
    line <- lines[i]
    
    # Detect section
    if (grepl("^## Missing Endpoints", line)) {
      current_section <- "endpoints"
      next
    } else if (grepl("^## Functions with Missing Parameters", line)) {
      current_section <- "parameters"
      next
    }
    
    # Skip if not in a section
    if (is.null(current_section)) next
    
    # Parse endpoint headers
    if (current_section == "endpoints" && grepl("^### ", line)) {
      current_endpoint <- gsub("^### ", "", line)
      next
    }
    
    # Parse function headers
    if (current_section == "parameters" && grepl("^### ", line)) {
      header <- gsub("^### ", "", line)
      # Extract function name and endpoint
      parts <- strsplit(header, " - ", fixed = TRUE)[[1]]
      if (length(parts) >= 2) {
        current_function <- parts[1]
        current_endpoint <- parts[2]
      }
      next
    }
    
    # Parse API for endpoints
    if (current_section == "endpoints" && grepl("^- \\*\\*API:\\*\\*", line)) {
      current_api <- gsub("^- \\*\\*API:\\*\\* ", "", line)
      next
    }
    
    # Parse endpoint actions
    if (current_section == "endpoints" && grepl("^- \\*\\*Actions:\\*\\*", line)) {
      ignore_checked <- grepl("\\[x\\] Ignore|\\[X\\] Ignore", line)
      issue_checked <- grepl("\\[x\\] Issue|\\[X\\] Issue", line)
      
      if (ignore_checked || issue_checked) {
        endpoint_actions[[length(endpoint_actions) + 1]] <- list(
          endpoint = current_endpoint,
          api = current_api,
          ignore = ignore_checked,
          issue = issue_checked
        )
      }
      next
    }
    
    # Parse parameter actions
    if (current_section == "parameters" && grepl("^  - `.*` \\[", line)) {
      # Extract parameter name and checkbox states
      param_match <- regexpr("`[^`]+`", line)
      if (param_match > 0) {
        param_text <- regmatches(line, param_match)
        param_name <- gsub("`", "", param_text)
        
        ignore_checked <- grepl("\\[x\\] Ignore|\\[X\\] Ignore", line)
        issue_checked <- grepl("\\[x\\] Issue|\\[X\\] Issue", line)
        
        if (ignore_checked || issue_checked) {
          parameter_actions[[length(parameter_actions) + 1]] <- list(
            function_name = current_function,
            endpoint = current_endpoint,
            parameter = param_name,
            ignore = ignore_checked,
            issue = issue_checked
          )
        }
      }
    }
  }
  
  list(
    endpoints = endpoint_actions,
    parameters = parameter_actions
  )
}

# Update api-mapping.json with ignored items
update_mapping_file <- function(actions, mapping_file) {
  if (!file.exists(mapping_file)) {
    cat_error("Mapping file not found: ", mapping_file)
    return(FALSE)
  }
  
  mapping <- fromJSON(mapping_file, simplifyVector = FALSE)
  
  # Add ignored endpoints
  for (action in actions$endpoints) {
    if (action$ignore) {
      new_ignored <- list(
        endpoint = action$endpoint,
        api = action$api,
        reason = paste("Not implemented - marked for ignore on", Sys.Date()),
        date_added = as.character(Sys.Date())
      )
      mapping$ignored_endpoints[[length(mapping$ignored_endpoints) + 1]] <- new_ignored
      cat_info("Added ignored endpoint: ", action$endpoint)
    }
  }
  
  # Add ignored parameters
  for (action in actions$parameters) {
    if (action$ignore) {
      func_name <- action$function_name
      param_name <- action$parameter
      
      # Initialize function entry if it doesn't exist
      if (is.null(mapping$ignored_parameters[[func_name]])) {
        mapping$ignored_parameters[[func_name]] <- list()
      }
      
      # Add parameter with reason
      reason <- paste("Not implemented - marked for ignore on", Sys.Date())
      mapping$ignored_parameters[[func_name]][[param_name]] <- reason
      
      cat_info("Added ignored parameter: ", param_name, " for ", func_name)
    }
  }
  
  # Write back to file with pretty formatting
  write(toJSON(mapping, pretty = TRUE, auto_unbox = TRUE), mapping_file)
  cat_success("Updated api-mapping.json")
  
  TRUE
}

# Create actions file for GitHub issue creation
create_actions_file <- function(actions, actions_file) {
  issues_to_create <- list()
  
  # Endpoint issues
  for (action in actions$endpoints) {
    if (action$issue) {
      issues_to_create[[length(issues_to_create) + 1]] <- list(
        type = "endpoint",
        title = paste("API Coverage: Implement endpoint", action$endpoint),
        endpoint = action$endpoint,
        api = action$api,
        labels = c("enhancement", "api-coverage", "endpoint")
      )
    }
  }
  
  # Parameter issues
  for (action in actions$parameters) {
    if (action$issue) {
      issues_to_create[[length(issues_to_create) + 1]] <- list(
        type = "parameter",
        title = paste("API Coverage: Implement parameter", action$parameter, "for", action$function_name),
        function_name = action$function_name,
        endpoint = action$endpoint,
        parameter = action$parameter,
        labels = c("enhancement", "api-coverage", "parameter")
      )
    }
  }
  
  # Write actions file
  write(toJSON(list(issues = issues_to_create), pretty = TRUE, auto_unbox = TRUE), actions_file)
  cat_success("Created actions file with ", length(issues_to_create), " issues to create")
  
  length(issues_to_create)
}

# Reset checkboxes in the markdown file
reset_checkboxes <- function(report_file) {
  if (!file.exists(report_file)) {
    cat_error("Coverage report not found: ", report_file)
    return(FALSE)
  }
  
  lines <- readLines(report_file, warn = FALSE)
  
  # Reset all checked boxes to unchecked
  lines <- gsub("\\[x\\] Ignore", "[ ] Ignore", lines, ignore.case = TRUE)
  lines <- gsub("\\[x\\] Issue", "[ ] Issue", lines, ignore.case = TRUE)
  
  writeLines(lines, report_file)
  cat_success("Reset all checkboxes in coverage report")
  
  TRUE
}

# Main execution
main <- function() {
  cat_info("=== Processing Coverage Report Checkboxes ===\n")
  
  # Parse checkboxes
  cat_info("Parsing coverage report...")
  actions <- parse_checkboxes(report_file)
  
  if (is.null(actions)) {
    cat_error("Failed to parse coverage report")
    quit(status = 1)
  }
  
  total_endpoint_actions <- length(actions$endpoints)
  total_parameter_actions <- length(actions$parameters)
  
  cat_info("Found ", total_endpoint_actions, " endpoint actions")
  cat_info("Found ", total_parameter_actions, " parameter actions")
  
  if (total_endpoint_actions == 0 && total_parameter_actions == 0) {
    cat_info("\nNo actions found. Nothing to do.")
    quit(status = 0)
  }
  
  # Count actions by type
  endpoint_ignore <- if (length(actions$endpoints) > 0) sum(sapply(actions$endpoints, function(x) x$ignore)) else 0
  endpoint_issue <- if (length(actions$endpoints) > 0) sum(sapply(actions$endpoints, function(x) x$issue)) else 0
  parameter_ignore <- if (length(actions$parameters) > 0) sum(sapply(actions$parameters, function(x) x$ignore)) else 0
  parameter_issue <- if (length(actions$parameters) > 0) sum(sapply(actions$parameters, function(x) x$issue)) else 0
  
  cat_info("\nActions breakdown:")
  cat_info("  Endpoints to ignore: ", endpoint_ignore)
  cat_info("  Endpoints to create issues: ", endpoint_issue)
  cat_info("  Parameters to ignore: ", parameter_ignore)
  cat_info("  Parameters to create issues: ", parameter_issue)
  
  # Update mapping file
  cat_info("\n=== Updating api-mapping.json ===\n")
  if (!update_mapping_file(actions, mapping_file)) {
    quit(status = 1)
  }
  
  # Create actions file for GitHub issue creation
  cat_info("\n=== Creating Actions File ===\n")
  num_issues <- create_actions_file(actions, actions_file)
  
  # Reset checkboxes
  cat_info("\n=== Resetting Checkboxes ===\n")
  reset_checkboxes(report_file)
  
  cat_success("\n=== Processing Complete ===")
  cat_info("Summary:")
  cat_info("  - ", endpoint_ignore + parameter_ignore, " items added to ignored lists")
  cat_info("  - ", num_issues, " issues ready to be created")
  cat_info("  - Checkboxes reset in coverage report")
  cat_info("\nNext steps:")
  cat_info("  1. Review changes in api-mapping.json")
  cat_info("  2. GitHub Actions workflow will create issues from actions-to-take.json")
  cat_info("  3. Commit the updated files")
}

# Run main
main()
