context("organizations")

test_that("returns the correct class", {
  skip_on_cran() # because fixture in .Rbuildignore

  vcr::use_cassette("organizations",
    {
      tt <- organizations()
      uu <- organizations(uuid = "4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
      vv <- organizations(data = "contact", uuid = "4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
    },
    preserve_exact_body_bytes = TRUE
  )

  expect_is(tt, "list")
  expect_is(tt$meta$limit, "integer")
  expect_is(tt$meta$endOfRecords, "logical")

  expect_is(uu, "list")
  expect_is(uu$data$country, "character")

  expect_is(vv, "list")
  expect_is(vv$data$createdBy, "character")

  # returns the correct dimensions
  expect_equal(length(tt), 2)
  expect_equal(NROW(tt$data), 100)
  expect_equal(length(uu), 2)

  expect_equal(length(vv$data), 14)
})

# check that there is metadata for every publisher
test_that("meta count and data are the same length", {
  vcr::use_cassette("organizations_same_length",
    {
      ll <- organizations(limit = 7)
    },
    preserve_exact_body_bytes = TRUE
  )
  expect_is(ll, "list")
  expect_is(ll$data, "data.frame")
  expect_is(ll$data, "tbl_df")
  expect_is(ll$meta, "data.frame")
  # equal to count or limit=7
  expect_true(nrow(ll$data) == ll$meta$count | nrow(ll$data) == 7)
})

# Finds the correct country
test_that("correct country is returned", {
  vcr::use_cassette("organizations_search_country",
    {
      cc <- organizations(country = "BELGIUM")
    },
    preserve_exact_body_bytes = TRUE
  )

  # only one value for country
  expect_length(unique(cc$data$country), 1)
  # The query returns the right country
  expect_identical(
    isocodes[isocodes$code == unique(cc$data$country), "gbif_name"],
    "BELGIUM"
  )
})

# Finds datasets based for a single organisation based on uuid
test_that("find GBIF Secretariat datasets", {
  vcr::use_cassette("organizations_search_uuid",
    {
      gd <- organizations(
        data = "hostedDataset",
        uuid = "fbca90e3-8aed-48b1-84e3-369afbd000ce"
      )
    },
    preserve_exact_body_bytes = TRUE
  )
  # The GBIF Secretariat hosts at least one dataset
  expect_gt(NROW(gd), 1)
  # no records are repeated
  expect_identical(unique(gd$data$results), gd$data$results)
})

# Returns error message on wrong data type, uuid
test_that("Error on bad user input", {
  # doesn't need to be cached because should return error before HTTP request
  expect_error(organizations(data = "not a data type",
                             uid = "fbca90e3-8aed-48b1-84e3-369afbd000ce"),
               )
  expect_error(organizations(uuid = "not a uuid"),
               "Invalid UUID string: not a uuid",
               fixed = TRUE)
})
