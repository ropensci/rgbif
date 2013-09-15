context("name_lookup")

tt <- name_lookup(class='mammalia')

test_that("returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data$canonicalName, "factor")
  expect_is(tt$data$classKey, "numeric")
})

test_that("returns the correct value", {
  expect_equal(as.character(tt$data$kingdom[[1]]), "Animalia")
})

test_that("returns the correct dimensions", {
  expect_equal(nrow(tt$data), 20)
})