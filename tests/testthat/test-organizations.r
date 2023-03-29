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

# Finds the correct country
test_that("correct country is returned", {
  vcr::use_cassette("organizations_search_country",
    {
      cc <- organizations(country = "BL")
    },
    preserve_exact_body_bytes = TRUE
  )

  # only one value for country
  expect_length(unique(cc$data$country), 1)
  # The query returns the right country
  expect_identical(unique(cc$data$country),"BL")
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
  skip_on_cran()
  
  expect_error(organizations(
              data = "not a data type",
              uuid = "fbca90e3-8aed-48b1-84e3-369afbd000ce"),
              "should be one of"
              )
  expect_error(organizations(uuid = "not a uuid"),
               "Invalid UUID string: not a uuid",
               fixed = TRUE)
})
