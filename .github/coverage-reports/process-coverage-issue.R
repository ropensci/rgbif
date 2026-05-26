#!/usr/bin/env Rscript

# Process API Coverage Report Issue
# This script fetches a GitHub issue containing the coverage report,
# parses checked boxes, and prepares actions (ignore items, create issues)

# Required environment variables:
# - ISSUE_NUMBER: The GitHub issue number containing the coverage report
# - GITHUB_REPOSITORY: The repository (e.g., "owner/repo")
# - GH_TOKEN: GitHub token for API access

library(jsonlite)

# Configuration
report_file <- ".github/coverage-reports/coverage-report.md"
mapping_file <- ".github/coverage-reports/api-mapping.json"
actions_file <- ".github/coverage-reports/actions-to-take.json"

# Helper functions for colored output
cat_error <- function(...) cat("\033[31m", ..., "\033[0m\n", sep = "")
cat_success <- function(...) cat("\033[32m", ..., "\033[0m\n", sep = "")
cat_info <- function(...) cat("\033[36m", ..., "\033[0m\n", sep = "")
cat_warning <- function(...) cat("\033[33m", ..., "\033[0m\n", sep = "")

#' Fetch issue body from GitHub
fetch_issue_body <- function(issue_number, repo) {
  token <- Sys.getenv("GH_TOKEN")
  if (token == "") {
    cat_error("Error: GH_TOKEN environment variable not set")
    return(NULL)
  }
  
  # Use gh CLI API to fetch issue (more reliable than issue view)
  cmd <- sprintf('gh api repos/%s/issues/%s --jq .body', repo, issue_number)
  body <- tryCatch({
    system(cmd, intern = TRUE)
  }, error = function(e) {
    cat_error("Error fetching issue:", e$message)
    return(NULL)
  })
  
  if (is.null(body) || length(body) == 0) {
    return(NULL)
  }
  
  return(paste(body, collapse = "\n"))
}

#' Parse checkboxes from issue body
#' Returns list with endpoints and parameters that have actions
parse_issue_checkboxes <- function(issue_body) {
  lines <- strsplit(issue_body, "\n")[[1]]
  
  endpoints <- list()
  parameters <- list()
  
  current_section <- NULL
  current_function <- NULL
  current_endpoint <- NULL
  current_api <- NULL
  
  i <- 1
  while (i <= length(lines)) {
    line <- lines[i]
    
    # Check for missing endpoints section
    if (grepl("^## Missing Endpoints", line)) {
      current_section <- "endpoints"
      i <- i + 1
      next
    }
    
    # Check for missing parameters section
    if (grepl("^## Functions with Missing Parameters", line)) {
      current_section <- "parameters"
      i <- i + 1
      next
    }
    
    # Parse endpoint headers
    if (current_section == "endpoints" && grepl("^### [A-Z]+ /", line)) {
      endpoint_match <- regmatches(line, regexec("^### ([A-Z]+ /[^ ]+)", line))[[1]]
      if (length(endpoint_match) > 1) {
        current_endpoint <- endpoint_match[2]
        current_api <- NULL
        
        # Look ahead for API line
        if (i + 1 <= length(lines)) {
          api_line <- lines[i + 1]
          api_match <- regmatches(api_line, regexec("^- \\*\\*API:\\*\\* (.+)$", api_line))[[1]]
          if (length(api_match) > 1) {
            current_api <- api_match[2]
          }
        }
        
        # Look ahead for checkbox lines (new format: separate lines)
        ignore_checked <- FALSE
        issue_checked <- FALSE
        for (j in (i+1):min(i+10, length(lines))) {
          check_line <- lines[j]
          if (grepl("- \\[x\\] Ignore|\\[X\\] Ignore", check_line, ignore.case = TRUE)) {
            ignore_checked <- TRUE
          }
          if (grepl("- \\[x\\] Issue|\\[X\\] Issue", check_line, ignore.case = TRUE)) {
            issue_checked <- TRUE
          }
          # Stop at next section
          if (grepl("^###", check_line)) break
        }
        
        if (ignore_checked || issue_checked) {
          endpoints[[length(endpoints) + 1]] <- list(
            endpoint = current_endpoint,
            api = current_api,
            ignore = ignore_checked,
            issue = issue_checked
          )
        }
      }
    }
    
    # Parse parameter function headers
    if (current_section == "parameters" && grepl("^### [a-z_]+ - [A-Z]+ /", line)) {
      func_match <- regmatches(line, regexec("^### ([a-z_]+) - ([A-Z]+ /[^ ]+)", line))[[1]]
      if (length(func_match) > 2) {
        current_function <- func_match[2]
        current_endpoint <- func_match[3]
        
        # Collect all parameters for this function
        param_list <- c()
        ignore_checked <- FALSE
        issue_checked <- FALSE
        
        # Look ahead to collect parameters and check Actions
        for (j in (i+1):min(i+50, length(lines))) {
          check_line <- lines[j]
          
          # Collect parameter names
          if (grepl("^  - `[^`]+`$", check_line)) {
            param_match <- regmatches(check_line, regexec("^  - `([^`]+)`$", check_line))[[1]]
            if (length(param_match) > 1) {
              param_list <- c(param_list, param_match[2])
            }
          }
          
          # Check for Actions checkboxes
          if (grepl("- \\[x\\] Ignore|\\[X\\] Ignore", check_line, ignore.case = TRUE)) {
            ignore_checked <- TRUE
          }
          if (grepl("- \\[x\\] Issue|\\[X\\] Issue", check_line, ignore.case = TRUE)) {
            issue_checked <- TRUE
          }
          
          # Stop at next function section
          if (grepl("^###", check_line) && j > i + 1) break
        }
        
        # If any action is checked, add entry for this function with all its parameters
        if ((ignore_checked || issue_checked) && length(param_list) > 0) {
          parameters[[length(parameters) + 1]] <- list(
            function_name = current_function,
            endpoint = current_endpoint,
            parameters = param_list,
            ignore = ignore_checked,
            issue = issue_checked
          )
        }
      }
    }
    
    i <- i + 1
  }
  
  return(list(endpoints = endpoints, parameters = parameters))
}

#' Update mapping file with ignored items
update_mapping_file <- function(actions, mapping_file) {
  if (!file.exists(mapping_file)) {
    cat_error("Mapping file not found:", mapping_file)
    return(FALSE)
  }
  
  mapping <- fromJSON(mapping_file, simplifyVector = FALSE)
  
  # Add ignored endpoints
  for (endpoint_action in actions$endpoints) {
    if (endpoint_action$ignore) {
      # Check if already in ignored list
      already_ignored <- any(sapply(mapping$ignored_endpoints, function(x) {
        x$endpoint == endpoint_action$endpoint
      }))
      
      if (!already_ignored) {
        mapping$ignored_endpoints[[length(mapping$ignored_endpoints) + 1]] <- list(
          endpoint = endpoint_action$endpoint,
          api = endpoint_action$api,
          reason = sprintf("Not implemented - marked for ignore on %s", Sys.Date()),
          date_added = as.character(Sys.Date())
        )
        cat_success("Added ignored endpoint:", endpoint_action$endpoint)
      }
    }
  }
  
  # Add ignored parameters
  for (param_action in actions$parameters) {
    if (param_action$ignore) {
      if (is.null(mapping$ignored_parameters)) {
        mapping$ignored_parameters <- list()
      }
      
      func_name <- param_action$function_name
      
      # Initialize function entry if it doesn't exist
      if (is.null(mapping$ignored_parameters$function_specific[[func_name]])) {
        if (is.null(mapping$ignored_parameters$function_specific)) {
          mapping$ignored_parameters$function_specific <- list()
        }
        mapping$ignored_parameters$function_specific[[func_name]] <- list()
      }
      
      # Add all parameters from the list
      for (param_name in param_action$parameters) {
        # Check if already ignored
        if (!param_name %in% mapping$ignored_parameters$function_specific[[func_name]]) {
          mapping$ignored_parameters$function_specific[[func_name]] <- 
            c(mapping$ignored_parameters$function_specific[[func_name]], param_name)
          cat_success(sprintf("Added ignored parameter: %s for %s", param_name, func_name))
        }
      }
    }
  }
  
  # Write updated mapping
  write(toJSON(mapping, pretty = TRUE, auto_unbox = TRUE), mapping_file)
  cat_success("Updated", mapping_file)
  
  return(TRUE)
}

#' Create actions file for GitHub issue creation
create_actions_file <- function(actions, actions_file) {
  issues_to_create <- list()
  
  # Create issues for endpoints
  for (endpoint_action in actions$endpoints) {
    if (endpoint_action$issue) {
      issues_to_create[[length(issues_to_create) + 1]] <- list(
        type = "endpoint",
        title = sprintf("API Coverage: Implement endpoint %s", endpoint_action$endpoint),
        endpoint = endpoint_action$endpoint,
        api = endpoint_action$api,
        labels = c("enhancement", "api-coverage", "endpoint")
      )
    }
  }
  
  # Create issues for parameters
  for (param_action in actions$parameters) {
    if (param_action$issue) {
      # Create a single issue for all parameters
      param_list <- paste(sprintf("`%s`", param_action$parameters), collapse = ", ")
      issues_to_create[[length(issues_to_create) + 1]] <- list(
        type = "parameter",
        title = sprintf("API Coverage: Implement parameters for %s", param_action$function_name),
        function_name = param_action$function_name,
        endpoint = param_action$endpoint,
        parameters = param_action$parameters,
        labels = c("enhancement", "api-coverage", "parameter")
      )
    }
  }
  
  # Write actions file
  actions_data <- list(issues = issues_to_create)
  write(toJSON(actions_data, pretty = TRUE, auto_unbox = TRUE), actions_file)
  
  cat_success("Created actions file with", length(issues_to_create), "issues to create")
  
  return(length(issues_to_create))
}

#' Update issue to reset checkboxes
reset_issue_checkboxes <- function(issue_number, repo, original_body) {
  # Replace [x] and [X] with [ ] in checkbox lines
  lines <- strsplit(original_body, "\n")[[1]]
  
  for (i in seq_along(lines)) {
    # Reset checkboxes in Actions lines and parameter lines
    if (grepl("\\[x\\]|\\[X\\]", lines[i])) {
      lines[i] <- gsub("\\[x\\]", "[ ]", lines[i])
      lines[i] <- gsub("\\[X\\]", "[ ]", lines[i])
    }
  }
  
  updated_body <- paste(lines, collapse = "\n")
  
  # Update the issue using gh CLI
  temp_file <- tempfile(fileext = ".md")
  writeLines(updated_body, temp_file)
  
  cmd <- sprintf('gh issue edit %s --repo %s --body-file %s', issue_number, repo, temp_file)
  result <- system(cmd, intern = TRUE)
  
  unlink(temp_file)
  
  cat_success("Reset all checkboxes in issue #", issue_number)
  
  return(TRUE)
}

#' Main function
main <- function() {
  cat_info("=== Processing Coverage Report Issue ===\n")
  
  # Get environment variables
  issue_number <- Sys.getenv("ISSUE_NUMBER")
  repo <- Sys.getenv("GITHUB_REPOSITORY")
  
  if (issue_number == "" || repo == "") {
    cat_error("Error: Required environment variables not set")
    cat_error("  ISSUE_NUMBER:", issue_number)
    cat_error("  GITHUB_REPOSITORY:", repo)
    quit(status = 1)
  }
  
  cat_info("Fetching issue #", issue_number, " from ", repo, "\n")
  
  # Fetch issue body
  issue_body <- fetch_issue_body(issue_number, repo)
  if (is.null(issue_body)) {
    cat_error("Failed to fetch issue body")
    quit(status = 1)
  }
  
  cat_info("Parsing checkboxes...\n")
  
  # Parse checkboxes
  actions <- parse_issue_checkboxes(issue_body)
  
  cat_info("Found", length(actions$endpoints), "endpoint actions")
  cat_info("Found", length(actions$parameters), "parameter actions")
  
  endpoint_ignore <- if (length(actions$endpoints) > 0) sum(sapply(actions$endpoints, function(x) x$ignore)) else 0
  endpoint_issue <- if (length(actions$endpoints) > 0) sum(sapply(actions$endpoints, function(x) x$issue)) else 0
  parameter_ignore <- if (length(actions$parameters) > 0) sum(sapply(actions$parameters, function(x) x$ignore)) else 0
  parameter_issue <- if (length(actions$parameters) > 0) sum(sapply(actions$parameters, function(x) x$issue)) else 0
  
  cat_info("\nActions breakdown:")
  cat_info("  Endpoints to ignore: ", endpoint_ignore)
  cat_info("  Endpoints to create issues: ", endpoint_issue)
  cat_info("  Parameters to ignore: ", parameter_ignore)
  cat_info("  Parameters to create issues: ", parameter_issue)
  
  total_actions <- endpoint_ignore + endpoint_issue + parameter_ignore + parameter_issue
  
  if (total_actions == 0) {
    cat_warning("\nNo checkboxes were checked - nothing to process")
    quit(status = 0)
  }
  
  # Update mapping file
  cat_info("\n=== Updating api-mapping.json ===\n")
  if (!update_mapping_file(actions, mapping_file)) {
    quit(status = 1)
  }
  
  # Create actions file for GitHub issue creation
  cat_info("\n=== Creating Actions File ===\n")
  num_issues <- create_actions_file(actions, actions_file)
  
  # Reset checkboxes in the issue
  cat_info("\n=== Resetting Checkboxes in Issue ===\n")
  reset_issue_checkboxes(issue_number, repo, issue_body)
  
  # Summary
  cat_success("\n=== Processing Complete ===")
  cat_info("Summary:")
  cat_info("  -", endpoint_ignore + parameter_ignore, "items added to ignored lists")
  cat_info("  -", num_issues, "issues ready to be created")
  cat_info("  - Checkboxes reset in issue #", issue_number)
  cat_info("\nNext steps:")
  cat_info("  1. Review changes in api-mapping.json")
  cat_info("  2. GitHub Actions workflow will create issues from actions-to-take.json")
  cat_info("  3. Commit the updated files")
}

# Run main function
main()
