context("map_fetch")

skip_on_cran()
skip_if_not_installed("png")
skip_if_not_installed("terra")
skip_if_not_installed("magick")

test_that("map_fetch png", {
  vcr::use_cassette("map_fetch_png",{
  pp <- map_fetch(taxonKey = 212, year = 2010)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_is(pp, "magick-image")
})

test_that("map_fetch terra", {
  vcr::use_cassette("map_fetch_terra",{
    tt <- map_fetch(taxonKey = 212, year = 2010,return="terra",plot_terra=FALSE)
    ttt <- map_fetch(return="terra",x=0)
    tttt <- map_fetch(return="terra",x=0,y=0,z=1)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_is(tt, "SpatRaster")
  expect_is(ttt, "SpatRaster")
  expect_is(tttt, "SpatRaster")
  
  # check that extents are correct for terra object 
  expect_equal(as.character(terra::ext(tt)),"ext(-180, 180, -90, 90)")
  expect_equal(as.character(terra::ext(ttt)),"ext(-180, 0, -90, 90)")
  expect_equal(as.character(terra::ext(tttt)),"ext(-180, -90, 0, 90)")
  
})

test_that("map_fetch warnings and errors", {
  
  expect_message(map_fetch(style="green.poly"), 
  "You are using a map style that works better with arg 'bin' set to 'hex'. Setting bin='hex'. You can also try bin='square'.")
  expect_message(map_fetch(srs = 'EPSG:3857'),
  "EPSG:3857 only has one tile at z=0, so setting x=0 and y=0.")
  expect_message(map_fetch(recorded_by="John Waller"), 
   "Un-named args, setting source='adhoc'.")
  expect_message(map_fetch(source="adhoc",style="classic.point"),
  "The adhoc interface doesn't work well with 'point styles'. Try one of these :")
  
  # simple errors 
  expect_error(map_fetch(srs = "dog"))
  expect_error(map_fetch(srs = 1))
  expect_error(map_fetch(srs = "dog"))
  expect_error(map_fetch(format = "dog"))
  expect_error(map_fetch(source = 1))
  expect_error(map_fetch(source = "dog"))
  expect_error(map_fetch(x = "1"))
  expect_error(map_fetch(y = "1"))
  expect_error(map_fetch(z = "1"))
  expect_error(map_fetch(bin = 1))
  expect_error(map_fetch(bin = "dog"))
  expect_error(map_fetch(hexPerTile = "20000"))
  expect_error(map_fetch(squareSize = "20000"))
  expect_error(map_fetch(squareSize = 20000))
  expect_error(map_fetch(style = "dog"))
  expect_error(map_fetch(style = 2))
  expect_error(map_fetch(taxonKey = TRUE))
  expect_error(map_fetch(datasetKey = TRUE))
  expect_error(map_fetch(country = 2))
  expect_error(map_fetch(publishingOrg = 2))
  expect_error(map_fetch(publishingCountry = 2))
  expect_error(map_fetch(year = "2000"))
  expect_error(map_fetch(basisOfRecord = FALSE))
  expect_error(map_fetch(base_style="dog"))
  
  # complex errors 
  expect_error(map_fetch(srs = 'EPSG:3575', return = "terra"),
  "return='terra' is only supported for 'EPSG:4326'.")
  expect_message(map_fetch(taxonKey=212,country="US"),
  "Supply only one of taxonKey, datasetKey, country, publishingOrg, or publishingCountry. Switching to source='adhoc'.")
  expect_message(map_fetch(taxonKey = 212, year = 2010, country= "US"),
  "Supply only one of taxonKey, datasetKey, country, publishingOrg, or publishingCountry. Switching to source='adhoc'.")    
  })
  
