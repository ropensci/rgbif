context("gbif_photos")

test_that("gbif_photos", {
  skip_on_cran()

  res <- occ_search(mediatype = 'StillImage', return = "media")
  a <- gbif_photos(res, browse = FALSE)
  b <- gbif_photos(res, which = 'map', browse = FALSE)

  # correct class
  expect_is(a, "character")
  expect_is(b, "character")

  # returns the correct dimensions
  expect_equal(length(a), 1)
  expect_equal(length(b), 1)
})

test_that("fails correctly", {
  skip_on_cran()

  res <- occ_search(mediatype = 'StillImage', return = "media", limit = 1)

  # input fails well
  expect_error(gbif_photos("asdf", browse = FALSE), "input should be of class gbif")
  # output fails well
  expect_error(gbif_photos(res, output = 4, browse = FALSE), "invalid 'file' argument")
  # which fails well
  expect_error(gbif_photos(res, which = "blue", browse = FALSE), "'arg' should be one of")
})
