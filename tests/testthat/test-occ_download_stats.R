# Run this test file:
# testthat::test_file("tests/testthat/test-occ_download_stats.R")
# Or run all tests: devtools::test()
# Or from package root: testthat::test_dir("tests/testthat", filter = "occ_download_stats")

context("occ_download_stats")

test_that("occ_download_stats works with various parameters", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_stats", {
    # Basic usage
    tt <- occ_download_stats()
    # With date filters
    tt_dates <- occ_download_stats(from = "2023-01", to = "2023-12")
    # With publishingCountry
    tt_country <- occ_download_stats(publishingCountry = "US")
    # With datasetKey
    tt_dataset <- occ_download_stats(
      datasetKey = "50c9509d-22c7-4a22-a47d-8c48425ef4a7"
    )
    # With publishingOrgKey
    tt_org <- occ_download_stats(
      publishingOrgKey = "28eb1a3f-1c15-4a95-931a-4af90ecb574d"
    )
    # With pagination
    tt_limit <- occ_download_stats(limit = 5)
    tt_offset <- occ_download_stats(limit = 5, offset = 5)
  })
  
  # Basic usage assertions
  expect_is(tt, "occ_download_stats")
  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_equal(sort(names(tt$meta)), 
    c("count", "endofrecords", "limit", "offset"))
  expect_is(tt$results, "tbl_df")
  expect_equal(NROW(tt$meta), 1)
  expect_gte(NROW(tt$results), 20)
  expect_equal(names(tt$results), 
    c("datasetKey", "totalRecords", "numberDownloads", "year", "month"))
    
  # Test print method
  expect_output(print(tt), "gbif download statistics")
  expect_output(print(tt), "Records found")
  expect_output(print(tt), "Records returned")
  
  # Date filters assertions
  expect_is(tt_dates, "occ_download_stats")
  args <- attr(tt_dates, "args")
  expect_equal(args$from, "2023-01")
  expect_equal(args$to, "2023-12")
  expect_output(print(tt_dates), "Filters")
  expect_output(print(tt_dates), "From: 2023-01")
  expect_output(print(tt_dates), "To: 2023-12")
  expect_equal(unique(tt_dates$results$year), c(2023))
  expect_true(all(tt_dates$results$month %in% 1:12))

  # publishingCountry assertions
  expect_is(tt_country, "occ_download_stats")
  expect_equal(attr(tt_country, "args")$publishingCountry, "US")

  # datasetKey assertions
  expect_is(tt_dataset, "occ_download_stats")
  expect_equal(attr(tt_dataset, "args")$datasetKey, 
    "50c9509d-22c7-4a22-a47d-8c48425ef4a7")
  expect_equal(unique(tt_dataset$results$datasetKey), 
    "50c9509d-22c7-4a22-a47d-8c48425ef4a7")

  # publishingOrgKey assertions
  expect_is(tt_org, "occ_download_stats")
  expect_equal(attr(tt_org, "args")$publishingOrgKey, 
    "28eb1a3f-1c15-4a95-931a-4af90ecb574d")
 
  # Pagination assertions
  expect_is(tt_limit, "occ_download_stats")
  expect_lte(NROW(tt_limit$results), 5)
  expect_is(tt_offset, "occ_download_stats")
  expect_equal(tt_offset$meta$offset, 5)
})

test_that("occ_download_stats fails well", {
  skip_on_cran()

  # Type checking
  expect_error(occ_download_stats(from = 123),
    "from must be of class character")
  expect_error(occ_download_stats(to = 123),
    "to must be of class character")
  expect_error(occ_download_stats(publishingCountry = 123),
    "publishingCountry must be of class character")
  expect_error(occ_download_stats(datasetKey = 123),
    "datasetKey must be of class character")
  expect_error(occ_download_stats(publishingOrgKey = 123),
    "publishingOrgKey must be of class character")
  expect_error(occ_download_stats(limit = "x"),
    "limit must be of class integer, numeric")
  expect_error(occ_download_stats(offset = "x"),
    "offset must be of class integer, numeric")
})

test_that("occ_download_stats_export works", {
  skip_on_cran()
  skip_on_ci()

    # Basic usage with required parameters
    tt <- occ_download_stats_export(
      from = "2023-01", 
      to = "2023-12", 
      publishingCountry = "US"
    )
    
    # With optional datasetKey
    tt_dataset <- occ_download_stats_export(
      from = "2023-01",
      to = "2023-12",
      publishingCountry = "US",
      datasetKey = "50c9509d-22c7-4a22-a47d-8c48425ef4a7"
    )
  
  # Basic assertions
  expect_is(tt, "tbl_df")
  expect_gt(NROW(tt), 10)
  
  # Check expected columns exist (now in camelCase)
  expect_true("datasetKey" %in% names(tt))
  expect_true(any(grepl("totalRecord", names(tt), ignore.case = TRUE)))
  expect_true(any(grepl("download", names(tt), ignore.case = TRUE)))
  expect_true(any(grepl("numberDownloads", names(tt), ignore.case = TRUE)))
  expect_true(any(grepl("year", names(tt), ignore.case = TRUE)))
  expect_true(any(grepl("month", names(tt), ignore.case = TRUE)))
  
  # Dataset filter assertions
  expect_is(tt_dataset, "tbl_df")
  expect_gte(NROW(tt_dataset), 10)
})

test_that("occ_download_stats_export fails well", {
  skip_on_cran()

  # Required parameter checks
  expect_error(occ_download_stats_export(),
    "'from' is required")
  expect_error(occ_download_stats_export(from = "2023-01"),
    "'to' is required")
  expect_error(occ_download_stats_export(from = "2023-01", to = "2023-12"),
    "'publishingCountry' is required")
  
  # NULL or NA checks
  expect_error(occ_download_stats_export(
      from = NULL, 
      to = "2023-12", 
      publishingCountry = "US"
    ),
    "from can not be NA or NULL")
  expect_error(occ_download_stats_export(
      from = NA, 
      to = "2023-12", 
      publishingCountry = "US"
    ),
    "from can not be NA or NULL")
  expect_error(occ_download_stats_export(
      from = "2023-01", 
      to = NULL, 
      publishingCountry = "US"
    ),
    "to can not be NA or NULL")
  expect_error(occ_download_stats_export(
      from = "2023-01", 
      to = "2023-12", 
      publishingCountry = NULL
    ),
    "publishingCountry can not be NA or NULL")
  
  # Type checking
  expect_error(occ_download_stats_export(
      from = 123, 
      to = "2023-12", 
      publishingCountry = "US"
    ),
    "from must be of class character")
  expect_error(occ_download_stats_export(
      from = "2023-01", 
      to = 123, 
      publishingCountry = "US"
    ),
    "to must be of class character")
  expect_error(occ_download_stats_export(
      from = "2023-01", 
      to = "2023-12", 
      publishingCountry = 123
    ),
    "publishingCountry must be of class character")
  expect_error(occ_download_stats_export(
      from = "2023-01", 
      to = "2023-12", 
      publishingCountry = "US",
      datasetKey = 123
    ),
    "datasetKey must be of class character")
})

test_that("occ_download_stats_user_country works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_stats_user_country", {
    # Basic usage - all countries
    tt <- occ_download_stats_user_country()
  })
  
  # Basic assertions
  expect_is(tt, "tbl_df")
  expect_gt(NROW(tt), 100)
  
  # Check expected columns
  expect_true(all(c("year", "month", "number_downloads") %in% names(tt)))
  
  # Check data types
  expect_true(is.integer(tt$year) || is.numeric(tt$year))
  expect_true(is.integer(tt$month) || is.numeric(tt$month))
  expect_true(is.integer(tt$number_downloads) || is.numeric(tt$number_downloads))
  
  # Check month values are valid (1-12)
  expect_true(all(tt$month >= 1 & tt$month <= 12))
})

test_that("occ_download_stats_user_country fails well", {
  skip_on_cran()

  # Type checking
  expect_error(occ_download_stats_user_country(from = 123),
    "from must be of class character")
  expect_error(occ_download_stats_user_country(to = 123),
    "to must be of class character")
  expect_error(occ_download_stats_user_country(userCountry = 123),
    "userCountry must be of class character")
  expect_error(occ_download_stats_user_country(publishingCountry = 123),
    "publishingCountry must be of class character")
})

test_that("occ_download_stats_dataset_records works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_stats_dataset_records", {
    # Basic usage - all datasets
    tt <- occ_download_stats_dataset_records()
    # Filter by date range
    tt_dates <- occ_download_stats_dataset_records(
      from = "2023-01", 
      to = "2023-12"
    )
    # Filter by publishing country
    tt_pub <- occ_download_stats_dataset_records(publishingCountry = "DK")
    # Filter by specific dataset
    tt_dataset <- occ_download_stats_dataset_records(
      datasetKey = "50c9509d-22c7-4a22-a47d-8c48425ef4a7"
    )
    # Filter by publishing org
    tt_org <- occ_download_stats_dataset_records(
      publishingOrgKey = "28eb1a3f-1c15-4a95-931a-4af90ecb574d"
    )
    # Multiple filters
    tt_filtered <- occ_download_stats_dataset_records(
      from = "2023-01",
      to = "2023-12",
      publishingCountry = "DK"
    )
  })
  
  # Basic assertions
  expect_is(tt, "tbl_df")
  expect_gt(NROW(tt), 100)
  
  # Check expected columns
  expect_true(all(c("year", "month", "number_records") %in% names(tt)))
  
  # Check data types
  expect_true(is.integer(tt$year) || is.numeric(tt$year))
  expect_true(is.integer(tt$month) || is.numeric(tt$month))
  expect_true(is.numeric(tt$number_records))
  
  # Check month values are valid (1-12)
  expect_true(all(tt$month >= 1 & tt$month <= 12))
  
  # Check records are positive
  expect_true(all(tt$number_records > 0))
  
  # Date filter assertions
  expect_is(tt_dates, "tbl_df")
  expect_equal(unique(tt_dates$year), 2023)
  expect_true(all(tt_dates$month %in% 1:12))
  
  # Publishing country filter assertions
  expect_is(tt_pub, "tbl_df")
  expect_gte(NROW(tt_pub), 100)
  
  # Dataset filter assertions
  expect_is(tt_dataset, "tbl_df")
  expect_gte(NROW(tt_dataset), 100)
  
  # Publishing org filter assertions
  expect_is(tt_org, "tbl_df")
  expect_gte(NROW(tt_org), 100)
  
  # Multiple filters assertion
  expect_is(tt_filtered, "tbl_df")
})

test_that("occ_download_stats_dataset_records fails well", {
  skip_on_cran()

  # Type checking
  expect_error(occ_download_stats_dataset_records(from = 123),
    "from must be of class character")
  expect_error(occ_download_stats_dataset_records(to = 123),
    "to must be of class character")
  expect_error(occ_download_stats_dataset_records(publishingCountry = 123),
    "publishingCountry must be of class character")
  expect_error(occ_download_stats_dataset_records(datasetKey = 123),
    "datasetKey must be of class character")
  expect_error(occ_download_stats_dataset_records(publishingOrgKey = 123),
    "publishingOrgKey must be of class character")
})

test_that("occ_download_stats_dataset works", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_stats_dataset", {
    # Basic usage - all datasets
    tt <- occ_download_stats_dataset()
    # Filter by date range
    tt_dates <- occ_download_stats_dataset(
      from = "2023-01", 
      to = "2023-12"
    )
    # Filter by publishing country
    tt_pub <- occ_download_stats_dataset(publishingCountry = "DK")
    # Filter by specific dataset
    tt_dataset <- occ_download_stats_dataset(
      datasetKey = "50c9509d-22c7-4a22-a47d-8c48425ef4a7"
    )
    # Filter by publishing organization
    tt_org <- occ_download_stats_dataset(
      publishingOrgKey = "28eb1a3f-1c15-4a95-931a-4af90ecb574d"
    )
    # Multiple filters
    tt_filtered <- occ_download_stats_dataset(
      from = "2023-01",
      to = "2023-12",
      publishingCountry = "DK",
      publishingOrgKey = "28eb1a3f-1c15-4a95-931a-4af90ecb574d"
    )
  })
  
  # Basic assertions
  expect_is(tt, "tbl_df")
  expect_gt(NROW(tt), 100)
  
  # Check expected columns
  expect_true(all(c("year", "month", "number_downloads") %in% names(tt)))
  
  # Check data types
  expect_true(is.integer(tt$year) || is.numeric(tt$year))
  expect_true(is.integer(tt$month) || is.numeric(tt$month))
  expect_true(is.integer(tt$number_downloads) || is.numeric(tt$number_downloads))
  
  # Check month values are valid (1-12)
  expect_true(all(tt$month >= 1 & tt$month <= 12))
  
  # Check downloads are positive
  expect_true(all(tt$number_downloads > 0))
  
  # Date filter assertions
  expect_is(tt_dates, "tbl_df")
  if (NROW(tt_dates) > 0) {
    expect_equal(unique(tt_dates$year), 2023)
    expect_true(all(tt_dates$month %in% 1:12))
  }
  
  # Publishing country filter assertions
  expect_is(tt_pub, "tbl_df")
  expect_gte(NROW(tt_pub), 100)
  
  # Dataset filter assertions
  expect_is(tt_dataset, "tbl_df")
  expect_gte(NROW(tt_dataset), 100)
  
  # Publishing org filter assertions
  expect_is(tt_org, "tbl_df")
  expect_gte(NROW(tt_org), 100)
  
  # Multiple filters assertion
  expect_is(tt_filtered, "tbl_df")
})

test_that("occ_download_stats_dataset fails well", {
  skip_on_cran()

  # Type checking
  expect_error(occ_download_stats_dataset(from = 123),
    "from must be of class character")
  expect_error(occ_download_stats_dataset(to = 123),
    "to must be of class character")
  expect_error(occ_download_stats_dataset(publishingCountry = 123),
    "publishingCountry must be of class character")
  expect_error(occ_download_stats_dataset(datasetKey = 123),
    "datasetKey must be of class character")
  expect_error(occ_download_stats_dataset(publishingOrgKey = 123),
    "publishingOrgKey must be of class character")
})

test_that("occ_download_stats_source works", {
  skip_on_cran()

  vcr::use_cassette("occ_download_stats_source", {
    # Basic usage
    tt <- occ_download_stats_source()
    # Filter by date range
    tt_dates <- occ_download_stats_source(
      from = "2023-01", 
      to = "2023-12"
    )
    # Filter by source
    tt_source <- occ_download_stats_source(source = "pygbif")
    # Multiple filters
    tt_filtered <- occ_download_stats_source(
      from = "2023-01",
      to = "2023-12",
      source = "rgbif"
    )
  })
  
  # Basic assertions
  expect_is(tt, "tbl_df")
  expect_gt(NROW(tt), 10)
  
  # Check expected columns
  expect_true(all(c("year", "month", "number_downloads") %in% names(tt)))
  
  # Check data types
  expect_true(is.integer(tt$year) || is.numeric(tt$year))
  expect_true(is.integer(tt$month) || is.numeric(tt$month))
  expect_true(is.integer(tt$number_downloads) || is.numeric(tt$number_downloads))
  
  # Check month values are valid (1-12)
  expect_true(all(tt$month >= 1 & tt$month <= 12))
  
  # Check downloads are positive
  expect_true(all(tt$number_downloads > 0))
  
  # Date filter assertions
  expect_is(tt_dates, "tbl_df")
  if (NROW(tt_dates) > 0) {
    expect_equal(unique(tt_dates$year), 2023)
    expect_true(all(tt_dates$month %in% 1:12))
  }
  
  # Source filter assertions
  expect_is(tt_source, "tbl_df")
  expect_gte(NROW(tt_source), 10)
  
  # Multiple filters assertion
  expect_is(tt_filtered, "tbl_df")
})

test_that("occ_download_stats_source fails well", {
  skip_on_cran()

  # Type checking
  expect_error(occ_download_stats_source(from = 123),
    "from must be of class character")
  expect_error(occ_download_stats_source(to = 123),
    "to must be of class character")
  expect_error(occ_download_stats_source(source = 123),
    "source must be of class character")
})


