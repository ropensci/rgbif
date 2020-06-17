test_that("occ_download_import", {
  skip_on_cran()

  file <- 
    system.file("examples/0000066-140928181241064.zip", package = "rgbif")

  dl <- as.download(file)
  expect_is(dl, "occ_download_get")
  z <- occ_download_import(dl, path = tempdir())
  expect_is(z, "tbl_df")
  expect_is(z, "data.frame")
  expect_equal(attr(z, "type"), "single")
  expect_gt(NROW(z), 10)
})

test_that("occ_download_import encoding param", {
  skip_on_cran()

  file <- 
    system.file("examples/0000066-140928181241064.zip", package = "rgbif")
  dl <- as.download(file)

  expect_is(occ_download_import(dl, path = tempdir(), encoding = "UTF-8"),
    "tbl")
  expect_is(occ_download_import(dl, path = tempdir(), encoding = "Latin-1"),
    "tbl")
  expect_is(occ_download_import(dl, path = tempdir(), encoding = "unknown"),
    "tbl")
  expect_error(
    occ_download_import(dl, path = tempdir(), encoding = "foobar"),
    class = "error"
  )
  expect_error(
    occ_download_import(dl, path = tempdir(), encoding = 555),
    class = "error"
  )
})
