context("elevation: geonames_srtm3 internal fxn")
test_that("geonames_srtm3 internal fxn works", {
  latitude <- c(50.01, 51.01)
  longitude <- c(10.2, 11.2)
  vcr::use_cassette("elevation_geonames_srtm3", {
    aa <- geonames_srtm3(latitude, longitude)
  })
  expect_is(aa, "numeric")
  expect_equal(length(aa), 2)
})

test_that("geonames_srtm3 fails well", {
  expect_error(geonames_srtm3(), "argument \"latitude\" is missing")
  expect_error(geonames_srtm3(4), "argument \"longitude\" is missing")
  expect_error(geonames_srtm3("a", "a"), "invalid number")

  vcr::use_cassette("elevation_geonames_srtm3_unauthorized", {
    expect_error(geonames_srtm3(4, 5, "cheesemonkey"), "Unauthorized")
  })
})

context("elevation")
test_that("elevation", {
  load("elevation_test_data.rda")
  vcr::use_cassette("elevation", {
    # returns the correct class
  	aa <- elevation(elevation_test_data)

  	# Pass in a vector of lat's and a vector of long's
  	bb <- elevation(latitude = elevation_test_data$decimalLatitude,
      longitude = elevation_test_data$decimalLongitude)

  	# Pass in lat/long pairs in a single vector
  	pairs <- list(c(31.8496, -110.576060), c(29.15503, -103.59828))
  	cc <- elevation(latlong = pairs)
  })

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  expect_is(aa$elevation, "numeric")
  expect_is(bb$elevation, "numeric")
  expect_is(cc$elevation, "numeric")
})

test_that("fails correctly", {
  skip_on_cran()

  # input must be a data.frame
  expect_error(elevation("aa"), "input must be a data.frame")

  # no input returns empty data.frame
  expect_error(elevation(), "one of input, lat & long, or latlong must be given")

  # not complete cases
  dat <- data.frame(decimalLatitude = c(6, NA),
    decimalLongitude = c(120, -120))
  expect_error(elevation(dat), "Input data has some missing values")

  # impossible values
  dat <- data.frame(decimalLatitude = c(6, 600),
    decimalLongitude = c(120, -120))
  expect_error(elevation(dat), "Input data has some impossible values")

  # points at zero,zero
  dat <- data.frame(decimalLatitude = c(0, 45), decimalLongitude = c(0, -120))
  expect_warning(elevation(dat), "Input data has some points at 0,0")

  # invalid key
  pairs <- list(c(31.8496, -110.576060), c(29.15503, -103.59828))
  vcr::use_cassette("elevation_unauthorized", {
    expect_error(elevation(latlong = pairs, username = "bad_user"),
      "Unauthorized")
  })
})
