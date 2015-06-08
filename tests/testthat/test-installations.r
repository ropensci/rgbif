context("installations")

test_that("query all installations returns the correct class", {
  skip_on_cran()
  tt <- installations()
  expect_is(tt, "list")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$organizationKey, "character")
})

test_that("single dataset query returns the correct", {
  skip_on_cran()
  
  # class
  tt <- installations(uuid="b77901f9-d9b0-47fa-94e0-dd96450aa2b4")
  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$modifiedBy, "character")
  
  # value
  expect_equal(tt$data$type, "IPT_INSTALLATION")
  expect_is(tt$data$contacts, "data.frame")
  expect_is(tt$data$endpoints, "data.frame")
})

test_that("contact returns the correct", {
  skip_on_cran()
  
  # class
  tt <- installations(data='contact', uuid="2e029a0c-87af-42e6-87d7-f38a50b78201")
  expect_is(tt, "list")
  expect_null(tt$meta)
  expect_is(tt$data$firstName, "character")
  
  # value
  expect_equal(tt$data$type, "TECHNICAL_POINT_OF_CONTACT")
})

test_that("search for deleted and nonPublishing installations returns the correct", {
  skip_on_cran()
  
  tt <- installations(data='deleted', limit=2)
  
  # class
  expect_is(tt, "list")

  # value
  expect_equal(tt$data$type[1], "IPT_INSTALLATION")
  expect_equal(length(tt), 2)
  expect_equal(length(tt$data), 17)
})
