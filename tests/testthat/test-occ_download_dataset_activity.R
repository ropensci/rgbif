context("occ_download_dataset_activity")

test_that("occ_download_dataset_activity", {
  skip_on_cran()
  skip_on_ci()

  vcr::use_cassette("occ_download_dataset_activity", {
    tt <- occ_download_dataset_activity("7f2edc10-f762-11e1-a439-00145eb45e9a")
  })

  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_equal(sort(names(tt$meta)), 
    c("count", "endofrecords", "limit", "offset"))
  expect_is(tt$results$downloadKey, "character")
  expect_type(tt$results$numberRecords, "integer")
  expect_equal(NROW(tt$meta), 1)
  expect_gt(NROW(tt$result), 3)

  vcr::use_cassette("occ_download_dataset_activity_error", {
    expect_error(occ_download_dataset_activity("foo-bar"))
  })
})

test_that("occ_download_dataset_activity fails well", {
  skip_on_cran()

  # no dataset key given
  expect_error(occ_download_dataset_activity(), "is missing")

  # type checking
  expect_error(occ_download_dataset_activity(5),
    "dataset must be of class character")
  expect_error(occ_download_dataset_activity("x", "x"),
    "limit must be of class integer, numeric")
  expect_error(occ_download_dataset_activity("x", 5, "x"),
    "start must be of class integer, numeric")
})
