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

  expect_is(a, "character")
  expect_is(b, "character")
  expect_is(d, "character")
  expect_is(e, "character")
  expect_is(f, "character")
  expect_is(g, "character")
  
  # returns the correct value
  expect_equal(a[[1]], "122")
  expect_equal(b[[1]], "12")
  expect_equal(d[[1]], "GB")
  
  # returns the correct dimensions
  expect_equal(length(a), 5)
  expect_equal(length(b), 5)
  expect_equal(length(d), 5)
  expect_equal(length(e), 5)
  expect_equal(length(f), 10)
  expect_equal(length(g), 5)
})

test_that("fails correctly", {
  skip_on_cran()
  # FAILS: collector name - collector_name endpoint down on 2014-04-23
  expect_error(occ_metadata(type = "collector_name", q='jane'))
})
