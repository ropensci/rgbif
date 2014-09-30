context("dataset_metrics")

tt <- dataset_metrics(uuid='3f8a1297-3259-4700-91fc-acc4170b27ce')

test_that("returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$key, "integer")
  expect_is(tt$datasetKey, "character")
})

test_that("returns the correct value", {
  expect_equal(tt$key, 4341)
  expect_equal(tt$datasetKey, "3f8a1297-3259-4700-91fc-acc4170b27ce")
})
