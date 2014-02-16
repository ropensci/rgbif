context("installations")

tt <- installations()
test_that("query all installations returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$results[[1]], "list")
  expect_is(tt$results[[1]]$organizationKey, "character")
})

tt <- installations(uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
test_that("single dataset query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
  expect_is(tt$modifiedBy, "character")
})
test_that("single dataset query returns the correct value", {
  expect_equal(tt$type, "IPT_INSTALLATION")
  expect_is(tt$contacts, "list")
  expect_is(tt$endpoints, "list")
})

tt <- installations(data='contact', uuid="2e029a0c-87af-42e6-87d7-f38a50b78201")
test_that("contact returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "list")
  expect_is(tt[[1]]$firstName, "character")
})
test_that("contact query returns the correct value", {
  expect_equal(tt[[1]]$type, "TECHNICAL_POINT_OF_CONTACT")
})

tt <- installations(data='deleted', limit=2)
test_that("search for deleted and nonPublishing installations returns the correct class", {
  expect_is(tt, "list")
})
test_that("search for deleted and nonPublishing installations returns the dimensions", {
  expect_equal(tt$results[[1]]$type, "IPT_INSTALLATION")
  expect_equal(length(tt), 5)
  expect_equal(length(tt[[1]]), 1)
})