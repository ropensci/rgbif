context("occ_download_organizations")

test_that("occ_download_organizations", {
  skip_on_cran()

  vcr::use_cassette("occ_download_organizations", {
    tt <- occ_download_organizations("0024953-260519110011954")
  })

  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_equal(sort(names(tt$meta)),
    c("count", "endofrecords", "limit", "offset"))
  expect_is(tt$results$downloadKey, "character")
  expect_is(tt$results$organizationKey, "character")
  expect_is(tt$results$organizationTitle, "character")
  expect_type(tt$results$numberRecords, "integer")
  expect_is(tt$results$publishingCountryCode, "character")
  expect_equal(NROW(tt$meta), 1)
  expect_gt(NROW(tt$results), 0)

  vcr::use_cassette("occ_download_organizations_error", {
    expect_error(occ_download_organizations("foo-bar"))
  })
})

test_that("occ_download_organizations fails well", {
  skip_on_cran()

  # no key given
  expect_error(occ_download_organizations(), "is missing")

  # type checking
  expect_error(occ_download_organizations(5),
    "key must be of class character")
  expect_error(occ_download_organizations("x", organizationTitle = 1),
    "organizationTitle must be of class character")
  expect_error(occ_download_organizations("x", sortBy = 1),
    "sortBy must be of class character")
  expect_error(occ_download_organizations("x", sortOrder = 1),
    "sortOrder must be of class character")
  expect_error(occ_download_organizations("x", limit = "x"),
    "limit must be of class integer, numeric")
  expect_error(occ_download_organizations("x", start = "x"),
    "start must be of class integer, numeric")
})
