context("occ_metadata")

a <- occ_metadata(type = "catalog_number", q=122, pretty=FALSE)
b <- occ_metadata(type = "collection_code", q=12, pretty=FALSE)
# c <- occ_metadata(type = "collector_name", q='juan', pretty=FALSE)
d <- occ_metadata(type = "institution_code", q='GB', pretty=FALSE)
e <- occ_metadata(type = "catalog_number", q=122, pretty=FALSE)
f <- occ_metadata(type = "catalog_number", q=122, limit=10, pretty=FALSE)
g <- occ_metadata(type = "cat", q=122, pretty=FALSE)

test_that("returns the correct class", {
  expect_is(a, "character")
  expect_is(b, "character")
#   expect_is(c, "character")
  expect_is(d, "character")
  expect_is(e, "character")
  expect_is(f, "character")
  expect_is(g, "character")
})

test_that("returns the correct value", {
  expect_equal(a[[1]], "122")
  expect_equal(b[[1]], "12")
  expect_equal(d[[1]], "GB")
})

test_that("returns the correct dimensions", {
  expect_equal(length(a), 5)
  expect_equal(length(b), 5)
#   expect_equal(length(c), 5)
  expect_equal(length(d), 5)
  expect_equal(length(e), 5)
  expect_equal(length(f), 10)
  expect_equal(length(g), 5)
})