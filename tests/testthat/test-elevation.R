context("elevation")

test_that("elevation", {
  skip_on_cran()

  apikey <- Sys.getenv("G_ELEVATION_API")

  # returns the correct class
  key <- name_suggest('Puma concolor')$key[1]
	dat <- occ_search(taxonKey=key, return='data', limit=20, hasCoordinate=TRUE)
	aa <- elevation(dat, key = apikey)

	# Pass in a vector of lat's and a vector of long's
	bb <- elevation(latitude=dat$decimalLatitude, longitude=dat$decimalLongitude, key = apikey)

	# Pass in lat/long pairs in a single vector
	pairs <- list(c(31.8496, -110.576060), c(29.15503, -103.59828))
	cc <- elevation(latlong = pairs, key = apikey)

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  expect_is(aa$elevation, "numeric")

  expect_equal(NROW(bb), 20)
  expect_equal(NCOL(bb), 3)
  expect_equal(NROW(cc), 2)
  expect_equal(NCOL(cc), 3)
})

test_that("fails correctly", {
  skip_on_cran()

  expect_error(elevation("aa"), "input must be left as default")

  pairs <- list(c(31.8496, -110.576060), c(29.15503, -103.59828))
  expect_error(elevation(latlong = pairs), "argument \"key\" is missing")

  # no input returns empty data.frame
  expect_equal(NROW(elevation()), 0)
})
