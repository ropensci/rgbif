context("occ_download_datasets")

test_that("occ_download_datasets", {
  skip_on_cran()
  skip_on_travis()

  vcr::use_cassette("occ_download_datasets", {
    tt <- occ_download_datasets("0003983-140910143529206")
  })

  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_equal(sort(names(tt$meta)), 
    c("count", "endofrecords", "limit", "offset"))
  expect_is(tt$results$downloadKey, "character")
  expect_is(tt$results$datasetKey, "character")
  expect_type(tt$results$numberRecords, "integer")
  expect_equal(NROW(tt$meta), 1)
  expect_gt(NROW(tt$result), 3)

  vcr::use_cassette("occ_download_datasets_error", {
    expect_error(occ_download_datasets("foo-bar"))
  })
})

test_that("occ_download_datasets fails well", {
  skip_on_cran()

  # no key given
  expect_error(occ_download_datasets(), "is missing")

  # type checking
  expect_error(occ_download_datasets(5),
    "key must be of class character")
  expect_error(occ_download_datasets("x", "x"),
    "limit must be of class integer, numeric")
  expect_error(occ_download_datasets("x", 5, "x"),
    "start must be of class integer, numeric")
})
