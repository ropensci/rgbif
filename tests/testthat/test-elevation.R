context("elevation")

apikey <- Sys.getenv("G_ELEVATION_API")

test_that("elevation", {
  skip_on_cran()

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
})

test_that("fails correctly", {
  skip_on_cran()

  # input must be a data.frame
  expect_error(elevation("aa"), "input must be a data.frame")

  # key is missing
  pairs <- list(c(31.8496, -110.576060), c(29.15503, -103.59828))
  expect_error(elevation(latlong = pairs), "argument \"key\" is missing")

  # no input returns empty data.frame
  expect_error(elevation(), "one of input, lat & long, or latlong must be given")

  # not complete cases
  dat <- data.frame(decimalLatitude = c(6, NA), decimalLongitude = c(120, -120))
  expect_error(elevation(dat, key = apikey), "Input data has some missing values")

  # impossible values
  dat <- data.frame(decimalLatitude = c(6, 600), decimalLongitude = c(120, -120))
  expect_error(elevation(dat, key = apikey), "Input data has some impossible values")

  # points at zero,zero
  dat <- data.frame(decimalLatitude = c(0, 45), decimalLongitude = c(0, -120))
  expect_warning(elevation(dat, key = apikey), "Input data has some points at 0,0")
})
