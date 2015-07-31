context("dataset_metrics")

test_that("dataset_metrics returns the correct class", {
  skip_on_cran()

  tt <- dataset_metrics('863e6d6b-f602-4495-ac30-881482b6f799')
  ss <- dataset_metrics(uuid = c('863e6d6b-f602-4495-ac30-881482b6f799',
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

  # datasets not of type checklist dont work
  expect_error(dataset_metrics('82ceb6ba-f762-11e1-a439-00145eb45e9a'), "204 - not found")
})
