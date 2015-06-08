context("occ_search")

key <- 3119195

test_that("returns the correct class", {
  skip_on_cran()

  # Search by key
  tt <- occ_search(taxonKey=key, limit=2)
  uu <- occ_search(taxonKey=key, limit=20)
  vv <- occ_search(taxonKey=key, return='meta')
  
  expect_is(tt$meta, "list")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$name, "character")
  expect_is(vv, "data.frame")

  expect_equal(tt$meta$limit, 2)
  expect_equal(tt$hierarchy[[1]][1,2], 6)
  expect_equal(as.character(tt$hierarchy[[1]][1,1]), "Plantae")
  
  expect_equal(as.character(uu$hierarchy[[1]][1,1]), "Plantae")
  expect_equal(as.character(uu$data[1,1]), "Helianthus annuus")
  expect_equal(uu$meta$limit, 20)
  expect_equal(vv$limit, 200)

  expect_equal(length(tt), 4)
  expect_equal(length(tt$meta), 4)
})

# Search by dataset key
test_that("returns the correct dimensions", {
  skip_on_cran()
  
  out <- occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')

  # returns the correct class
  expect_is(out, "data.frame")
  # dimensions
  expect_equal(dim(out), c(177,42))
})

## Search by catalog number
test_that("returns the correct class", {
  skip_on_cran()
  
  out <- occ_search(catalogNumber='PlantAndMushroom.6845144', fields='all')
  
  expect_is(out, "gbif")
  expect_is(out$meta, "list")
  expect_is(out$data, "character")

  # returns the correct value
  expect_true(out$meta$endOfRecords)
  
  # returns the correct dimensions
  expect_equal(length(out), 4)
})

# Occurrence data: lat/long data, and associated metadata with occurrences
test_that("returns the correct class", {
  skip_on_cran()

  out <- occ_search(taxonKey=key, return='data')
  expect_is(out, "data.frame")
  expect_is(out[1,1], "character")
  expect_is(out[1,2], "integer")

  # returns the correct value
  expect_equal(as.character(out[1,1]), "Helianthus annuus")
})

# Taxonomic hierarchy data
test_that("returns the correct class", {
  skip_on_cran()

  out <- occ_search(taxonKey=key, limit=20, return='hier')
  expect_is(out, "gbif")
  expect_is(out[[1]], "data.frame")

  # returns the correct dimensions
  expect_equal(length(out), 1)
  expect_equal(dim(out[[1]]), c(7,3))
})


######### Get occurrences for a particular eventDate
test_that("dates work correctly", {
  skip_on_cran()

  a <- occ_search(taxonKey=3189815, year="2013", fields=c('name','year'))
  b <- occ_search(taxonKey=3189815, month="6", fields=c('name','month'))
  
  expect_equal(a$data$year[1], 2013)
  expect_equal(b$data$month[1], 6)
  
  expect_is(occ_search(taxonKey=key, year="1990,1991"), "gbif")
})

test_that("make sure things that should throw errors do", {
  skip_on_cran()
  
  # not allowed to do a range query on many variables, including contintent
  expect_error(occ_search(taxonKey=3189815, continent = 'asia,oceania'))
  # can't pass the wrong value to latitude
  expect_error(occ_search(decimalLatitude = 334))
})

######### Get occurrences based on depth
test_that("returns the correct stuff", {
  skip_on_cran()
  
  key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
  expect_is(occ_search(taxonKey=key, depth="5"), "gbif")
  expect_is(occ_search(taxonKey=key, depth=5), "gbif")
  # does range search correctly - THROWS ERROR NOW, BUT SHOULD WORK
  expect_error(occ_search(taxonKey=key, depth="5-10"))  
})

######### Get occurrences based on elevation
test_that("returns the correct dimensions", {
  skip_on_cran()
  
  key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
  res <- occ_search(taxonKey=key, elevation=1000, hasCoordinate=TRUE, fields=c('name','elevation'))
  expect_equal(names(res$data), c('name','elevation'))
})

# test that looping is working correctly
test_that("looping works correctly", {
  skip_on_cran()
  
  it <- seq(from=0, to=750, by=250)
  out <- list()
  for (i in seq_along(it)) {
    occdata <- occ_search(taxonKey=3119195, limit=250, start=it[[i]])
    out[[i]] <- occdata$data
  }
  allkeys <- unlist(lapply(out, "[[", "key"))
  
  expect_equal(length(allkeys), length(unique(allkeys)))
  expect_equal(unique(sapply(out, class)), "data.frame")
})
