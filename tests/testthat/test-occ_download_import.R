test_that("occ_download_import", {
  skip_on_cran()

  dl <- as.download("0000066-140928181241064.zip")
  expect_is(dl, "occ_download_get")
  z <- occ_download_import(dl, path = tempdir())
  expect_is(z, "tbl_df")
  expect_is(z, "data.frame")
  expect_equal(attr(z, "type"), "single")
  expect_gt(NROW(z), 10)
})
