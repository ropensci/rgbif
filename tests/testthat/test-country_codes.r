context("rgb_country_codes")

test_that("returns the correct class", {
  skip_on_cran()
  
  expect_is(rgb_country_codes(country_name="United"), "data.frame")
  expect_is(rgb_country_codes(country_name="the", fuzzy=TRUE), "data.frame")
})

test_that("returns the correct value", {
  skip_on_cran()
  
  expect_equal(as.character(rgb_country_codes(country_name="United States")[2,"name"]), 
               "United States")
  expect_equal(as.character(rgb_country_codes(country_name="the", 
                                          fuzzy=TRUE)[2,"name"]), 
               "Saint Barthalemy")
})
