context("rgbif utils")

test_that("last", {
  expect_equal(last(letters), "z")
  expect_equal(last(LETTERS), "Z")
  expect_error(last())
})

test_that("asl", {
  expect_null(asl(NULL))
  expect_equal(asl("foobar"), "foobar")
  expect_equal(asl(TRUE), "true")
  expect_equal(asl("true"), "true")
  expect_equal(asl(FALSE), "false")
  expect_equal(asl("false"), "false")
  expect_error(asl())
})

test_that("setdfrbind", {
  expect_is(setdfrbind(list(mtcars, mtcars)), "data.frame")
  expect_error(setdfrbind())
})

test_that("assert", {
  expect_null(assert(4, "numeric"))
  expect_null(assert(TRUE, "logical"))
  expect_null(assert("af", "character"))
  expect_null(assert(mtcars, "data.frame"))

  expect_error(assert(TRUE, "character"))
  expect_error(assert(5, "data.frame"), "must be")
  
  expect_error(assert())
  expect_error(assert(2))
})

test_that("%||%", {
  expect_equal(5 %||% 6, 5)
  expect_equal(NULL %||% 6, 6)
})

test_that("gbif_base", {
  # by default gbif_base() returns api.gbif.org
  expect_equal(gbif_base(), "https://api.gbif.org/v1")
  # after setting other url
  Sys.setenv(RGBIF_BASE_URL = "https://api.gbif-uat.org/v1")
  expect_equal(gbif_base(), "https://api.gbif-uat.org/v1")
  # set back to main url
  Sys.setenv(RGBIF_BASE_URL = "https://api.gbif.org/v1")
  expect_equal(gbif_base(), "https://api.gbif.org/v1")
  # cannot set to anything else
  Sys.setenv(RGBIF_BASE_URL = "https://foo.bar")
  expect_error(gbif_base())

  # cleanup url change
  Sys.unsetenv("RGBIF_BASE_URL")
})
