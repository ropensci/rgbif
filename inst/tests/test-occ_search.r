context("occ_search")

# Search by key
key <- 3119195
tt <- occ_search(taxonKey=key, limit=2)
uu <- occ_search(taxonKey=key, limit=20)
vv <- occ_search(taxonKey=key, return='meta')

test_that("returns the correct class", {
  expect_is(tt$meta, "list")
  expect_is(tt$data, "list")
  expect_is(tt$data[[1]], "list")
  expect_is(tt$data[[1]]$hierarch, "data.frame")
  
  expect_is(vv, "data.frame")
})

test_that("returns the correct value", {
  expect_equal(tt$meta$limit, 2)
  expect_equal(tt$data[[1]]$hierarch[1,2], 6)
  expect_equal(as.character(tt$data[[1]]$hierarch[1,1]), "Plantae")
  
  expect_equal(as.character(uu$data[[1]]$hierarch[1,1]), "Plantae")
  expect_equal(as.character(uu$data[[1]]$data[1,1]), "Helianthus annuus")
  expect_equal(uu$meta$limit, 20)
  expect_equal(vv$limit, 20)
})

test_that("returns the correct dimensions", {
  expect_equal(length(tt), 2)
  expect_equal(length(tt$meta), 4)
  expect_equal(dim(tt$data[[1]]$data), c(1,3))
  expect_equal(length(uu$data), 20)
  expect_equal(ncol(vv), 4)
})

# Search by dataset key
out <- occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')

test_that("returns the correct class", {
  expect_is(out, "data.frame")
})
test_that("returns the correct value", {
  expect_equal(as.character(out[1,1]), "Epistominella exigua")
})
test_that("returns the correct dimensions", {
  expect_equal(dim(out), c(20,3))
})

# Search by catalog number
out <- occ_search(catalogNumber='PlantAndMushroom.6845144', minimal=FALSE)

test_that("returns the correct class", {
  expect_is(out, "list")
  expect_is(out$meta, "list")
  expect_is(out$data, "list")
  expect_is(out$data[[1]], "list")
  expect_is(out$data[[1]]$data, "data.frame")
})
test_that("returns the correct value", {
  expect_true(out$meta$endOfRecords)
  expect_equal(as.character(out$data[[1]]$data[1,1]), "Helianthus annuus")
})
test_that("returns the correct dimensions", {
  expect_equal(length(out), 2)
  expect_equal(dim(out$data[[1]]$data), c(1,47))
})

# Occurrence data: lat/long data, and associated metadata with occurrences
out <- occ_search(taxonKey=key, return='data')

test_that("returns the correct class", {
  expect_is(out, "data.frame")
  expect_is(out[1,1], "factor")
  expect_is(out[1,2], "numeric")
})
test_that("returns the correct value", {
  expect_equal(as.character(out[1,1]), "Helianthus annuus")
})
test_that("returns the correct dimensions", {
  expect_equal(dim(out), c(20,3))
})

# Taxonomic hierarchy data
out <- occ_search(taxonKey=key, limit=20, return='hier')

test_that("returns the correct class", {
  expect_is(out, "list")
  expect_is(out[[1]], "data.frame")
})
test_that("returns the correct dimensions", {
  expect_equal(length(out), 20)
  expect_equal(dim(out[[1]]), c(7,3))
})