context("enumeration")

test_that("enumeration", {
  skip_on_cran()

  vcr::use_cassette("enumeration", {
    a <- enumeration()
    b <- enumeration("NameType")
    c <- enumeration("MetadataType")
    d <- enumeration("TypeStatus")
    e <- enumeration_country()
  }, preserve_exact_body_bytes = TRUE)

  expect_is(a, "character")
  expect_is(b, "character")
  expect_is(c, "character")
  expect_is(d, "character")
  expect_is(e, "data.frame")
  expect_is(e$enumName, "character")
})

test_that("fails correctly", {
  skip_on_cran()
  skip_on_ci()
  
  vcr::use_cassette("enumeration_fails_well", {
    expect_error(enumeration("asdfadsf"))
  })

  expect_error(enumeration_country(list(timeout_ms = 1)),
    "Timeout was reached")
})
