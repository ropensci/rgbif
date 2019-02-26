context("elevation: geonames_conn internal fxn")
test_that("geonames_conn internal fxn works", {
  skip_on_cran()
  
  latitude <- c(50.01, 51.01)
  longitude <- c(10.2, 11.2)
  vcr::use_cassette("elevation_geonames_conn", {
    aa <- geonames_conn("srtm3", latitude, longitude)
  })
  expect_is(aa, "numeric")
  expect_equal(length(aa), 2)
})

test_that("geonames_conn fails well", {
  skip_on_cran()

  expect_error(geonames_conn(), "argument \"elevation_model\" is missing")
  expect_error(geonames_conn("foobar"), "argument \"latitude\" is missing")
  expect_error(geonames_conn("foobar", 4), "argument \"longitude\" is missing")

  vcr::use_cassette("elevation_geonames_conn_unauthorized", {
    expect_error(geonames_conn("srtm3", 4, 5, "cheesemonkey"),
      "Unauthorized")
    expect_error(geonames_conn("srtm3", "a", "a"), "invalid number")
  })
})

context("elevation")
test_that("elevation", {
  skip_on_cran()

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

context("elevation: different elevation models work")
test_that("elevation models work", {
  skip_on_cran()

  load("elevation_test_data.rda")
  eltest_small <- elevation_test_data[1:5, ]
  vcr::use_cassette("elevation_models", {
    # srtm3, srtm1, astergdem, or gtopo30
    srtm3 <- elevation(eltest_small, elevation_model = "srtm3")
    srtm1 <- elevation(eltest_small, elevation_model = "srtm1")
    astergdem <- elevation(eltest_small, elevation_model = "astergdem")
    gtopo30 <- elevation(eltest_small, elevation_model = "gtopo30")
  })

  expect_is(srtm3, "data.frame")
  expect_is(srtm3$elevation_geonames, "numeric")
  expect_is(srtm1, "data.frame")
  expect_is(srtm1$elevation_geonames, "numeric")
  expect_is(astergdem, "data.frame")
  expect_is(astergdem$elevation_geonames, "numeric")
  expect_is(gtopo30, "data.frame")
  expect_is(gtopo30$elevation_geonames, "numeric")
})

context("elevation: fails well")
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
