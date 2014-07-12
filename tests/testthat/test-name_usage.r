context("name_usage")

tt <- name_usage(key=1)
uu <- name_usage(key=3119195, data='references')

test_that("name_usage returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$key, "numeric")
  expect_is(tt$kingdom, "character")
  
  expect_is(uu, "list")
  expect_is(uu$results, "list")
  expect_is(uu$results[[1]]$sourceTaxonKey, "numeric")
  expect_is(uu$results[[1]]$citation, "character")
})

test_that("name_usage returns the correct value", {
  expect_equal(as.character(tt$kingdom), "Animalia")
  expect_equal(as.character(uu$results[[1]]$citation), "Allan Herbarium 2007: New Zealand Plant Names Database Concepts - Asterales.")
})

test_that("name_usage returns the correct dimensions", {
  expect_equal(length(tt), 17)
  
  expect_equal(length(uu), 4)
  expect_equal(length(uu$results), 6)
  expect_equal(length(uu$results[[1]]), 2)
  expect_equal(length(uu$results[[1]]$sourceTaxonKey), 1)
})