context("organizations")

test_that("returns the correct class", {
  skip_on_cran()
  
  tt <- organizations()
  uu <- organizations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
  vv <- organizations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")

  expect_is(tt, "list")
  expect_is(tt$meta$limit, "integer")
  expect_is(tt$meta$endOfRecords, "logical")
  
  expect_is(uu, "list")
  expect_is(uu$data$country, "character")
  
  expect_is(vv, "list")
  expect_is(vv$data$createdBy, "character")

  # returns the correct dimensions
  expect_equal(length(tt), 2)
  expect_equal(NROW(tt$data), 100)
  expect_equal(length(uu), 2)
  expect_equal(length(vv$data), 14)
})
