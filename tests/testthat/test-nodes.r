context("nodes")

test_that("nodes", {
  skip_on_cran()

  # returns the correct class
  tt <- nodes()
  uu <- nodes(uuid="1193638d-32d1-43f0-a855-8727c94299d8")
  vv <- nodes(data='identifier', uuid="1193638d-32d1-43f0-a855-8727c94299d8")

  expect_is(tt, "list")
  expect_is(tt$meta$limit, "integer")
  expect_is(tt$meta$endOfRecords, "logical")

  expect_is(uu, "list")
  expect_is(uu$data$country, "character")

  expect_is(vv, "list")
  expect_is(vv$data$createdBy, "character")

  # returns the correct value
  expect_equal(length(tt$data$tags[[1]]), 0)
  expect_equal(uu$data$title, "Republic of Congo")
  expect_equal(vv$data$key, 13587)
  expect_equal(vv$data$modifiedBy, NULL)

  # returns the correct dimensions
  expect_equal(length(tt), 2)
  expect_equal(NROW(tt$data), 100)
  expect_gt(length(uu$data), 3)
  expect_equal(length(vv), 2)
  expect_equal(length(vv$data), 5)
})
