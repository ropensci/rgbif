context("mvt_fetch")

test_that("mvt_fetch", {
  skip_on_cran()
  skip_if_not_installed("protolite")
  skip_if_not_installed("sf")

  # Use GBIF Backbone numeric key for backward compatibility with VCR cassettes
  x <- mvt_fetch(taxonKey = 2480498, checklistKey = NULL, year = 2002)
  expect_is(x, "sf")
  expect_is(x$total, "numeric")
  expect_is(x$geometry, "sfc")
})

test_that("mvt_fetch fails well", {
  skip_on_cran()
  skip_if_not_installed("protolite")
  skip_if_not_installed("sf")

  expect_error(mvt_fetch(source = "stuff"), "is not TRUE")
  expect_error(mvt_fetch(source = 5), "source must be of class character")
})
