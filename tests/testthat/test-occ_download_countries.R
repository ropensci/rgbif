context("occ_download_countries")

test_that("occ_download_countries", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_countries", {
    tt <- occ_download_countries("0003983-140910143529206")
  })

  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_equal(sort(names(tt$meta)), 
    c("count", "endofrecords", "limit", "offset"))
  expect_is(tt$results$downloadKey, "character")
  expect_is(tt$results$countryCode, "character")
  expect_type(tt$results$numberRecords, "integer")
  expect_equal(NROW(tt$meta), 1)
  expect_gt(NROW(tt$results), 3)

  vcr::use_cassette("occ_download_countries_error", {
    expect_error(occ_download_countries("foo-bar"))
  })
})

test_that("occ_download_countries fails well", {
  skip_on_cran()

  # no key given
  expect_error(occ_download_countries(), "is missing")

  # type checking
  expect_error(occ_download_countries(5),
    "key must be of class character")
  expect_error(occ_download_countries("x", "x"),
    "limit must be of class integer, numeric")
  expect_error(occ_download_countries("x", 5, "x"),
    "start must be of class integer, numeric")
})
