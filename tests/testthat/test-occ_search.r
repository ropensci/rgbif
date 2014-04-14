context("occ_search")

# Search by key
key <- 3119195
tt <- occ_search(taxonKey=key, limit=2)
uu <- occ_search(taxonKey=key, limit=20)
vv <- occ_search(taxonKey=key, return='meta')

test_that("returns the correct class", {
  expect_is(tt$meta, "list")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$name, "character")
  expect_is(vv, "data.frame")
})

test_that("returns the correct value", {
  expect_equal(tt$meta$limit, 2)
  expect_equal(tt$hierarchy[[1]][1,2], 6)
  expect_equal(as.character(tt$hierarchy[[1]][1,1]), "Plantae")
  
  expect_equal(as.character(uu$hierarchy[[1]][1,1]), "Plantae")
  expect_equal(as.character(uu$data[1,1]), "Helianthus annuus")
  expect_equal(uu$meta$limit, 20)
  expect_equal(vv$limit, 20)
})

test_that("returns the correct dimensions", {
  expect_equal(length(tt), 3)
  expect_equal(length(tt$meta), 4)
  expect_equal(dim(tt$data), c(2,4))
  expect_equal(length(uu$data), 4)
  expect_equal(nrow(uu$data), 20)
  expect_equal(ncol(vv), 4)
})

# Search by dataset key
out <- occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a', return='data')

test_that("returns the correct class", {
  expect_is(out, "data.frame")
})
test_that("returns the correct dimensions", {
  expect_equal(dim(out), c(20,4))
})

## Search by catalog number
out <- occ_search(catalogNumber='PlantAndMushroom.6845144', fields='all')

test_that("returns the correct class", {
  expect_is(out, "list")
  expect_is(out$meta, "list")
  expect_is(out$data, "character")
})
test_that("returns the correct value", {
  expect_true(out$meta$endOfRecords)
})
test_that("returns the correct dimensions", {
  expect_equal(length(out), 3)
})

# Occurrence data: lat/long data, and associated metadata with occurrences
out <- occ_search(taxonKey=key, return='data')

test_that("returns the correct class", {
  expect_is(out, "data.frame")
  expect_is(out[1,1], "character")
  expect_is(out[1,2], "numeric")
})
test_that("returns the correct value", {
  expect_equal(as.character(out[1,1]), "Helianthus annuus")
})
test_that("returns the correct dimensions", {
  expect_equal(dim(out), c(20,4))
})

# Taxonomic hierarchy data
out <- occ_search(taxonKey=key, limit=20, return='hier')

test_that("returns the correct class", {
  expect_is(out, "list")
  expect_is(out[[1]], "data.frame")
})
test_that("returns the correct dimensions", {
  expect_equal(length(out), 1)
  expect_equal(dim(out[[1]]), c(7,3))
})


######### Get occurrences for a particular eventDate
key <- name_suggest(q='Aesculus hippocastanum')$key[1]

test_that("dates work correctly", {
  a <- occ_search(taxonKey=key, year="2013", fields=c('name','year'))
  b <- occ_search(taxonKey=key, month="6", fields=c('name','month'))
  
  expect_equal(a$data$year[1], 2013)
  expect_equal(b$data$month[1], 6)
  
  expect_is(occ_search(taxonKey=key, year="1990,1991"), "list")
})

test_that("make sure things that should throw errors do", {
  # not allowed to do a range query on many variables, including contintent
  expect_error(occ_search(taxonKey=key, continent = 'asia,oceania'))
  # can't pass the wrong value to latitude
  expect_error(occ_search(decimalLatitude = 334))
})

######### Get occurrences based on depth
test_that("returns the correct stuff", {
  key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
  expect_is(occ_search(taxonKey=key, depth="5"), "list")
  expect_is(occ_search(taxonKey=key, depth=5), "list")
  # does range search correctly - THROWS ERROR NOW, BUT SHOULD WORK
  expect_error(occ_search(taxonKey=key, depth="5-10"))  
})

######### Get occurrences based on elevation
test_that("returns the correct dimensions", {
  key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
  res <- occ_search(taxonKey=key, elevation=1000, hasCoordinate=TRUE, fields=c('name','elevation'))
  expect_equal(names(res$data), c('name','elevation'))
})