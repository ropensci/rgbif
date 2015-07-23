context("networks")

test_that("returns the correct", {
  skip_on_cran()

  tt <- networks()
  uu <- networks(uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')
  vv <- networks(data='endpoint', uuid='16ab5405-6c94-4189-ac71-16ca3b753df7')

  # class
  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$meta$limit, "integer")
  expect_is(tt$meta$endOfRecords, "logical")

  expect_is(uu, "list")
  expect_is(uu$data$language, "character")

  # values
  expect_identical(tt$data$tags[[1]], list())
  expect_equal(uu$data$title, "Dryad")
  expect_equal(vv$data$key, 15428)
  expect_equal(vv$data$modifiedBy, "registry-migration.gbif.org")

  # dimensions
  expect_equal(length(tt), 2)
  expect_equal(length(vv), 2)
  expect_equal(length(vv$meta), 0)
})
