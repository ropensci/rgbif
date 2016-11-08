
context("map_fetch")

# Test get_colours -------------------------------------------------------------
test_that("get_colours generates correct output classes", {
    map_values <- get_colours(
      type = 'TAXON',
      key = 1,
      colour_nbreaks = 50)

    # Test output format:
    # Should be a list
    expect_is(map_values, 'list')
    # of length 2
    expect_length(map_values, 2)
    # containing a character object and a matrix class
    expect_is(map_values[[1]], 'character')
    expect_is(map_values[[2]], 'matrix')

    # returns the correct dimensions
    expect_length(map_values[[1]], 1)
    expect_equal(dim(map_values[[2]]), c(50,3))
})

test_that("get_colours gives appropriate warnings", {

  map_values <- get_colours(
    type = 'TAXON',
    key = 1,
    colour_nbreaks = 50)

  # Test warning messages
  # for get_colours without specifying breaks or nbreaks
  expect_warning(
    get_colours(
      type = 'TAXON',
      key = 1)
    )
  # for get_colours without breaks but with nbreaks
  expect_warning(
    get_colours(
      type = 'TAXON',
      key = 1,
      colour_nbreaks = NULL)
  )
})

test_that("layer arguments are generated correctly", {

  layers <- get_layers(
    layers = c('OBS','SP','OTH'),
    decades = c('NO_YEAR','PRE_1900','1900_1910','1910_1920','1920_1930'),
    living = TRUE,
    fossil = FALSE
  )

  # Test that it's character vector
  expect_is(layers, 'character')
  # Test that length is as expected
  expect_length(layers, 16)
})

test_that("function works for different types of queries", {

  skip_if_not_installed('raster')

  require(raster)

  # Get Dataset query
  # Natural History Museum (London) Collection of Specimen
  map_dataset <- map_fetch(
    type = 'DATASET',
    key = '7e380070-f762-11e1-a439-00145eb45e9a',
    breaks = c(1,3,5,10,15,20,50,100,200,500,1000,1500,2000,5000,10000)
  )

  # Get Country query
  # China, China, China China, China...
  map_country <- map_fetch(
    type = 'COUNTRY',
    key = 'CN',
    breaks = c(1,3,5,10,15,20,50,100,200,500,1000,1500,2000,5000,10000)
  )

  # Get Publisher query
  # (State Museum of Natural History, Braunschweig (Germany))
  map_publisher <- map_fetch(
    type = 'PUBLISHER',
    key = '6fb0bba4-3610-4c8b-a177-6e6c4ed575a5',
    breaks = c(1,3,5,10,15,20,50,100,200,500,1000,1500,2000,5000,10000)
  )

  expect_is(map_dataset, 'RasterLayer')
  expect_is(map_country, 'RasterLayer')
  expect_is(map_publisher, 'RasterLayer')
})


test_that("function produces alternative output with warning when raster package is missing", {

  # Check function returns raster without warnings
  expect_silent(output <- map_fetch(nbreaks = 50))

  # Unload raster package
  if('raster' %in% loadedNamespaces()){
    unloadNamespace("raster")

    # Check function produces warning about missing raster package
    expect_warning(raw_response <- map_fetch(nbreaks = 50))
    # Check function returns raw response instead
    expect_is(raw_response, 'response')
  }
})





