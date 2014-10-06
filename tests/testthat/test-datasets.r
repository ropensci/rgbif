context("datasets")

tt <- datasets()
test_that("query all datasets returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$publishingOrganizationKey, "character")
})

tt <- datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
test_that("single dataset query returns the correct class", {
  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$installationKey, 'character')
})
test_that("single dataset query returns the correct value", {
  expect_equal(tt$data$type, "OCCURRENCE")
  expect_equal(tt$data$rights, "not-for-profit use only")
  expect_equal(tt$data$identifiers$key, 13537)
})

tt <- datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
test_that("contact returns the correct class", {
  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$lastName, "character")
})
test_that("contact query returns the correct value", {
  expect_equal(tt$data$lastName[1], "Fisher")
})

tt <- datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
test_that("metadata returns the correct class", {
  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$key, "integer")
})
test_that("metadata returns the correct value", {
  expect_equal(tt$data$type, "EML")
})

tt <- datasets(data=c('deleted','duplicate'))
test_that("search for deleted and duplicate datasets returns the correct class", {
  expect_is(tt, "list")
})
test_that("search for deleted and duplicate datasets returns the dimensions", {
  expect_equal(length(tt), 2)
  expect_equal(length(tt[[1]]), 2)
})
