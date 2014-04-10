context("nodes")

tt <- nodes()
uu <- nodes(uuid="1193638d-32d1-43f0-a855-8727c94299d8")
vv <- nodes(data='identifier', uuid="1193638d-32d1-43f0-a855-8727c94299d8")

test_that("returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$limit, "numeric")
  expect_is(tt$endOfRecords, "logical")
  
  expect_is(uu, "list")
  expect_is(uu$country, "character")
  
  expect_is(vv, "list")
  expect_is(vv[[1]]$createdBy, "character")
})

test_that("returns the correct value", {
  expect_true(typeof(tt$results[[1]]$tags)=="list")
  expect_equal(uu$title, "Republic of Congo")
  expect_equal(vv[[1]]$key, 13587)
  expect_equal(vv[[1]]$modifiedBy, NULL)
})

test_that("returns the correct dimensions", {
  expect_equal(length(tt), 5)
  expect_equal(length(tt$results), 20)
  expect_equal(length(uu), 29)
  expect_equal(length(vv), 1)
  expect_equal(length(vv[[1]]), 5)
})