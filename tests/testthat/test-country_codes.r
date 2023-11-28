context("rgb_country_codes")

test_that("returns the correct class", {
  skip_on_cran()
  
  expect_is(rgb_country_codes(country_name="United"), "data.frame")
  expect_is(rgb_country_codes(country_name="the", fuzzy=TRUE), "data.frame")
})

