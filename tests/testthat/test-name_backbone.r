context("name_backbone")

test_that("name_backbone returns the correct class", {
  vcr::use_cassette("name_backbone", {
    tt <- name_backbone(name = 'Helianthus annuus', rank = 'species')
    uu <- name_backbone(name = 'Helianthus annuus', rank = 'species',
                        verbose = TRUE)
  })

  expect_is(tt, "gbif")
  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
  expect_is(uu, "gbif")
  expect_is(uu$data, "tbl")
  expect_is(uu$data, "tbl_df")
  expect_is(uu$data, "data.frame")
  expect_is(uu$alternatives, "tbl")
  expect_is(uu$alternatives, "tbl_df")
  expect_is(uu$alternatives, "data.frame")
  expect_is(uu$alternatives$phylumKey, "integer")
  expect_is(uu$alternatives$canonicalName, "character")
})

test_that("Throws error because a name is required in the function call", {
  skip_on_cran()
  expect_error(name_backbone(kingdom = 'plants'), "argument \"name\" is missing")
})
