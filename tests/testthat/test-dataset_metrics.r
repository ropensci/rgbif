context("dataset_metrics")

test_that("dataset_metrics returns the correct class", {
  skip_on_cran()

  tt <- dataset_metrics('3f8a1297-3259-4700-91fc-acc4170b27ce')
  ss <- dataset_metrics(uuid=c('3f8a1297-3259-4700-91fc-acc4170b27ce',
    '66dd0960-2d7d-46ee-a491-87b9adcfe7b1'))
  expect_is(tt, "list")
  expect_is(tt$key, "integer")
  expect_is(tt$datasetKey, "character")
  
  expect_is(ss, "list")
  expect_is(ss[[1]]$key, "integer")
  expect_is(ss[[2]]$datasetKey, "character")
})

test_that("dataset_metrics fails well", {
  skip_on_cran()
  
  expect_error(dataset_metrics(), "argument \"uuid\" is missing")
  expect_error(dataset_metrics(""))
  expect_error(dataset_metrics(c('3f8a1297-3259-4700-91fc-acc4170b27ce', 4)))
})
