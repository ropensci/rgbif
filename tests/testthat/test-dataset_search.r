context("dataset_search")

tt <- dataset_search(type="OCCURRENCE")
test_that("type query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$descriptions, "list")
  expect_is(tt$data[1,1], "character")
})

# Gets all datasets tagged with keyword "france".
tt <- dataset_search(keyword="france")
test_that("keyword query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data[1,1], "character")
})
test_that("keyword query returns the correct value", {
  expect_equal(as.character(tt$data$publishingCountry[1]), "FR")
  expect_equal(as.character(tt$data[1,4]), "FR")
})
 
# Fulltext search for all datasets having the word "amsterdam" somewhere in 
# its metadata (title, description, etc).
tt <- dataset_search(query="amsterdam")
test_that("search query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$descriptions, "list")
  expect_that(is.null(tt$facets), is_true())
  expect_is(tt$data[1,1], "character")
})

# Limited search
tt <- dataset_search(type="OCCURRENCE", limit=2)
test_that("limited search returns the correct class", {
  expect_is(tt$data, "data.frame")
  expect_is(tt$data[1,1], "character")
})
test_that("limited search returns the correct dims", {
  expect_equal(dim(tt$data), c(2,6))
})
 
# Return just descriptions
tt <- dataset_search(type="OCCURRENCE", return="descriptions")
test_that("limited fields query returns the correct class", {
  expect_is(tt, "list")
})