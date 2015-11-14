context("occ_metadata")

test_that("returns the correct class", {
  skip_on_cran()

  a <- occ_metadata(type = "catalogNumber", q=122, pretty=FALSE)
  b <- occ_metadata(type = "collectionCode", q=12, pretty=FALSE)
  # c <- occ_metadata(type = "collector_name", q='juan', pretty=FALSE)
  d <- occ_metadata(type = "institutionCode", q='GB', pretty=FALSE)
  e <- occ_metadata(type = "catalogNumber", q=122, pretty=FALSE)
  f <- occ_metadata(type = "catalogNumber", q=122, limit=10, pretty=FALSE)
  g <- occ_metadata(type = "cat", q=122, pretty=FALSE)

  h <- occ_metadata(type = "recordedBy", q='scott', pretty=FALSE)

  expect_is(a, "character")
  expect_is(b, "character")
  expect_is(d, "character")
  expect_is(e, "character")
  expect_is(f, "character")
  expect_is(g, "character")
  expect_is(h, "character")

  # returns the correct value
  expect_equal(a[[1]], "122")
  expect_equal(b[[1]], "12")
  expect_equal(d[[1]], "GB")
  expect_true(grepl("scott", h[[1]]))

  # returns the correct dimensions
  expect_equal(length(a), 5)
  expect_equal(length(b), 5)
  expect_equal(length(d), 5)
  expect_equal(length(e), 5)
  expect_equal(length(f), 10)
  expect_equal(length(g), 5)
  expect_equal(length(h), 5)
})
