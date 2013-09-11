context("name_lookup")

tt <- name_lookup(class='mammalia')

test_that("returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$meta, "list")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data[[1]]$extinct, "logical")
  expect_is(tt$data[[1]]$kingdom, "character")
})

test_that("returns the correct value", {
  expect_equal(tt$data[[1]]$kingdom, "Animalia")
})

test_that("returns the correct dimensions", {
  expect_equal(length(tt$data), 20)
})