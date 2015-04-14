context("enumeration")

a <- enumeration()
b <- enumeration("NameType")
c <- enumeration("MetadataType")
d <- enumeration("TypeStatus")
e <- enumeration_country()

test_that("returns the correct class", {
  expect_is(a, "character")
  expect_is(b, "character")
  expect_is(c, "character")
  expect_is(d, "character")
  expect_is(e, "data.frame")
  expect_is(e$enumName, "character")
})

test_that("fails correctly", {
  expect_error(enumeration("asdfadsf"), "Status: 204 - not found")
  expect_error(enumeration_country("asdfadsf"), "is not TRUE")
})
