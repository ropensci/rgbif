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

test_that("occ_download_import key arg works as expected", {
  skip_on_cran()
  
  system_file <- system.file("examples/0000066-140928181241064.zip", package = "rgbif")
  temp_path <- file.path(tempdir(), basename(system_file))

  file.copy(system_file, temp_path)
  setwd(tempdir())
  ii <- occ_download_import(key = "0000066-140928181241064")
  expect_is(ii, "tbl_df")
  expect_is(ii, "data.frame")
  expect_equal(attr(ii, "type"), "single")
  expect_gt(NROW(ii), 10)
  
})

test_that("occ_download_import double import works", {
  # https://github.com/ropensci/rgbif/issues/765
  skip_on_cran()
  
  system_file_1 <- system.file("examples/0000066-140928181241064.zip", package = "rgbif")
  temp_path_1 <- file.path(tempdir(), basename(system_file_1))
  file.copy(system_file_1, temp_path_1)
  
  system_file_2 <- system.file("examples/0009886-250127130748423.zip", package = "rgbif")
  temp_path_2 <- file.path(tempdir(), basename(system_file_2))
  file.copy(system_file_2, temp_path_2)
  
  setwd(tempdir())
  ii <- occ_download_import(as.download("0000066-140928181241064.zip"))
  expect_is(ii, "tbl_df")
  expect_is(ii, "data.frame")
  expect_equal(attr(ii, "type"), "single")
  expect_gt(NROW(ii), 10)
  
  ii2 <- occ_download_import(as.download("0009886-250127130748423.zip"))
  expect_is(ii2, "tbl_df")
  expect_is(ii2, "data.frame")
  expect_equal(attr(ii2, "type"), "single")
  expect_gt(NROW(ii2), 10)

})

test_that("occ_download_import works with occ_download_get", {
  skip_on_cran()
  
  bb <- occ_download_get("0108986-200613084148143", overwrite = TRUE) %>%
    occ_download_import()
  
  expect_is(bb, "tbl_df")
  expect_is(bb, "data.frame")
  expect_equal(attr(bb, "type"), "single")
  expect_equal(NROW(bb), 21)
})
