context("map_fetch")

test_that("map_fetch", {
  skip_on_cran()

  x <- map_fetch(search = "taxonKey", id = 3118771, year = 2010)
  expect_is(x, "RasterLayer")
})


test_that("map_fetch fails well", {
  skip_on_cran()

  expect_error(map_fetch(source = "stuff"), "'arg' should be one of")
  expect_error(map_fetch(source = 5), "source must be of class character")
  expect_error(map_fetch(format = 'bears'), "'arg' should be one of")
})
