# testthat::test_file("tests/testthat/test-gbif_to_col.r")

context("gbif_to_col")

test_that("gbif_to_col works with single key", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_single_v2", {
    result <- gbif_to_col(5231190)
  })
  
  expect_true(inherits(result, "gbif_to_col"))
  expect_true("gbif_key" %in% names(result))
  expect_true("usage" %in% names(result))
  expect_true("usage" %in% names(result))
  expect_true("classification" %in% names(result))
  expect_true("diagnostics" %in% names(result))
  expect_equal(result$gbif_key, "5231190")
  
  # Check nested structure
  expect_true("key" %in% names(result$usage))
  expect_true("name" %in% names(result$usage))
  expect_true("rank" %in% names(result$usage))
  expect_true("matchType" %in% names(result$diagnostics))
  expect_true("confidence" %in% names(result$diagnostics))
})

test_that("gbif_to_col works with multiple keys", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_multiple_v2", {
    result <- gbif_to_col(c(5231190, 2435099, 2877951))
  })
  
  expect_true(inherits(result, "gbif_to_col_list"))
  expect_equal(length(result), 3)
  
  # Check each element has correct structure
  for (i in seq_along(result)) {
    expect_true("gbif_key" %in% names(result[[i]]))
    expect_true("usage" %in% names(result[[i]]))
  }
  
  # Check GBIF keys match input
  gbif_keys <- sapply(result, function(x) x$gbif_key)
  expect_equal(gbif_keys, c("5231190", "2435099", "2877951"))
  
  # Check all have COL keys
  col_keys <- sapply(result, function(x) x$usage$key)
  expect_true(all(!is.na(col_keys)))
})

test_that("gbif_to_col handles invalid keys gracefully", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_invalid_v2", {
    result <- gbif_to_col(999999999)
  })
  
  expect_true(inherits(result, "gbif_to_col"))
  expect_equal(result$gbif_key, "999999999")
  # Check that result has the expected structure
  expect_true("gbif_key" %in% names(result))
  # Invalid keys return diagnostics but no usage
  expect_true("diagnostics" %in% names(result))
  expect_equal(result$diagnostics$matchType, "NONE")
  # Usage is not returned for invalid keys
  expect_false("usage" %in% names(result))
})

test_that("gbif_to_col requires key parameter", {
  expect_error(gbif_to_col())
  expect_error(gbif_to_col(NULL), "key parameter is required")
  expect_error(gbif_to_col(character(0)), "key parameter is required")
})

test_that("gbif_to_col returns correct structure", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_structure_v2", {
    result <- gbif_to_col(5231190)
  })
  
  expect_true(inherits(result, "gbif_to_col"))
  
  # Check main list elements
  expected_elements <- c("gbif_key", "usage", "classification", "diagnostics", "synonym")
  expect_true(all(expected_elements %in% names(result)))
  
  # Check usage elements
  if (!is.null(result$usage)) {
    expected_usage <- c("key", "name", "canonicalName", "rank", "status")
    expect_true(all(expected_usage %in% names(result$usage)))
  }
  
  # Check diagnostics elements
  if (!is.null(result$diagnostics)) {
    expected_diagnostics <- c("matchType", "confidence")
    expect_true(all(expected_diagnostics %in% names(result$diagnostics)))
  }
})

test_that("print method works for single result", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_print_single_v2", {
    result <- gbif_to_col(5231190)
  })
  
  # Capture print output
  output <- capture.output(print(result))
  
  # Check that output contains key information
  expect_true(any(grepl("GBIF to COL key conversion", output)))
  expect_true(any(grepl("GBIF Backbone key:", output)))
  expect_true(any(grepl("COL Extended Release key:", output)))
})

test_that("print method works for multiple results", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_print_multiple_v2", {
    result <- gbif_to_col(c(5231190, 2435099, 2877951))
  })
  
  # Capture print output
  output <- capture.output(print(result))
  
  # Check that output contains summary information
  expect_true(any(grepl("3 results", output)))
  expect_true(any(grepl("GBIF:", output)))
  expect_true(any(grepl("COL:", output)))
})
