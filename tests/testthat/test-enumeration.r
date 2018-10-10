context("enumeration")

test_that("enumeration", {
  vcr::use_cassette("enumeration", {
    a <- enumeration()
    b <- enumeration("NameType")
    c <- enumeration("MetadataType")
    d <- enumeration("TypeStatus")
    e <- enumeration_country()

    expect_is(a, "character")
    expect_is(b, "character")
    expect_is(c, "character")
    expect_is(d, "character")
    expect_is(e, "data.frame")
    expect_is(e$enumName, "character")
  })
})

test_that("fails correctly", {
  vcr::use_cassette("datasets_fails_well", {

    expect_error(enumeration("asdfadsf"), "Status: 204 - not found")
    expect_error(enumeration_country(list(timeout_ms = 1)),
                 "Timeout was reached")

  })
})
