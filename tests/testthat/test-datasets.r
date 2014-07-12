context("datasets")

tt <- datasets()
test_that("query all datasets returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$results[[1]], "list")
  expect_is(tt$results[[1]]$publishingOrganizationKey, "character")
})

tt <- datasets(uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
test_that("single dataset query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
  expect_true(typeof(tt$keywordCollections)=='list')
})
test_that("single dataset query returns the correct value", {
  expect_equal(tt$type, "OCCURRENCE")
  expect_equal(tt$rights, "not-for-profit use only")
  expect_equal(tt$identifiers[[1]]$key, 13537)
})

tt <- datasets(data='contact', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
test_that("contact returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "list")
  expect_is(tt[[1]]$lastName, "character")
})
test_that("contact query returns the correct value", {
  expect_equal(tt[[1]]$lastName, "Fisher")
})

tt <- datasets(data='metadata', uuid="a6998220-7e3a-485d-9cd6-73076bd85657")
test_that("metadata returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "list")
  expect_is(tt[[1]]$key, "numeric")
})
test_that("metadata returns the correct value", {
  expect_equal(tt[[1]]$type, "EML")
})

tt <- datasets(data=c('deleted','duplicate'))
test_that("search for deleted and duplicate datasets returns the correct class", {
  expect_is(tt, "list")
})
test_that("search for deleted and duplicate datasets returns the dimensions", {
  expect_equal(length(tt), 2)
  expect_equal(length(tt[[1]]), 5)
})