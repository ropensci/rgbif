context("name_usage")

tt <- name_usage(key=1)
uu <- name_usage(key=3119195, data='references')

test_that("name_usage returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$data$key, "integer")
  expect_is(tt$data$kingdom, "character")
  
  expect_is(uu, "list")
  expect_is(uu$data, "data.frame")
  expect_is(uu$data$sourceTaxonKey, "integer")
  expect_is(uu$data$citation, "character")
})

test_that("name_usage returns the correct value", {
  expect_equal(tt$data$kingdom, "Animalia")
  expect_match(uu$data$citation[1], "Allan Herbarium 2007: New Zealand Plant Names Database Concepts - Asterales.")
})

test_that("name_usage returns the correct dimensions", {
  expect_equal(length(tt), 2)
  expect_equal(NCOL(tt$data), 20)
  
  expect_equal(length(uu), 2)
  expect_equal(NCOL(uu$meta), 3)
  expect_equal(NCOL(uu$data), 2)
})


test_that("name_usage fails correctly", {
  ### Not working right now for some unknown reason
  # Select many options
  expect_error(name_usage(key=3119195, data=c('images','synonyms')))
})
