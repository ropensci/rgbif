context("gbif_to_col")

test_that("gbif_to_col works with single key", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_single", {
    result <- gbif_to_col(5231190)
  })
  
  expect_is(result, "tbl_df")
  expect_equal(nrow(result), 1)
  expect_true("gbif_key" %in% names(result))
  expect_true("col_usageKey" %in% names(result))
  expect_true("matchType" %in% names(result))
  expect_equal(result$gbif_key, "5231190")
})

test_that("gbif_to_col works with multiple keys", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_multiple", {
    result <- gbif_to_col(c(5231190, 2435099, 2877951))
  })
  
  expect_is(result, "tbl_df")
  expect_equal(nrow(result), 3)
  expect_equal(result$gbif_key, c("5231190", "2435099", "2877951"))
  expect_true(all(!is.na(result$col_usageKey)))
})

test_that("gbif_to_col handles invalid keys gracefully", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_invalid", {
    result <- gbif_to_col(999999999)
  })
  
  expect_is(result, "tbl_df")
  expect_equal(nrow(result), 1)
  # Invalid keys may return NA or NONE matchType
  expect_true(!is.null(result$matchType))
})

test_that("gbif_to_col requires key parameter", {
  expect_error(gbif_to_col(), "key parameter is required")
  expect_error(gbif_to_col(NULL), "key parameter is required")
})

test_that("gbif_to_col returns correct columns", {
  skip_on_cran()
  
  vcr::use_cassette("gbif_to_col_columns", {
    result <- gbif_to_col(5231190)
  })
  
  expected_cols <- c("gbif_key", "col_usageKey", "col_scientificName", 
                     "matchType", "confidence", "status", "rank")
  expect_true(all(expected_cols %in% names(result)))
})
