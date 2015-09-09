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

  it <- seq(from = 0, to = 750, by = 250)
  out <- list()
  for (i in seq_along(it)) {
    occdata <- occ_search(taxonKey = 3119195, limit = 250, start = it[[i]])
    out[[i]] <- occdata$data
  }
  allkeys <- unlist(lapply(out, "[[", "key"))

  expect_equal(length(allkeys), length(unique(allkeys)))
  expect_equal(unique(sapply(out, class)), "data.frame")
})

######### scientificName usage works correctly
test_that("scientificName basic use works - no synonyms", {
  skip_on_cran()

  # with synonyms
  bb <- suppressMessages(occ_search(scientificName = 'Pulsatilla patens', limit = 2))
  expect_equal(attr(bb, "args")$scientificName, "Pulsatilla patens")
  expect_equal(bb$data$name[1], "Anemone patens")

  # Genus is a synonym - subspecies rank input
  cc <- suppressMessages(occ_search(scientificName = 'Corynorhinus townsendii ingens', limit = 2))
  expect_is(cc, "gbif")
  expect_is(cc$data, "data.frame")
  expect_equal(attr(cc, "args")$scientificName, "Corynorhinus townsendii ingens")
  expect_equal(cc$data$name[1], "Plecotus townsendii")

  # Genus is a synonym - species rank input
  dd <- suppressMessages(occ_search(scientificName = 'Corynorhinus townsendii', limit = 2))
  expect_is(dd, "gbif")
  expect_is(dd$data, "data.frame")
  expect_equal(NROW(dd$data), 2)
  expect_equal(attr(dd, "args")$scientificName, "Corynorhinus townsendii")
  expect_equal(dd$data$name[1], "Plecotus townsendii")

  # specific epithet is the synonym - subspecies rank input
  ee <- suppressMessages(occ_search(scientificName = "Myotis septentrionalis septentrionalis", limit = 2))
  expect_is(ee, "gbif")
  expect_is(ee$data, "character")
  expect_equal(attr(ee, "args")$scientificName, "Myotis septentrionalis septentrionalis")

  # above with subspecific name removed, gives result
  ff <- suppressMessages(occ_search(scientificName = "Myotis septentrionalis", limit = 2))
  expect_is(ff, "gbif")
  expect_equal(NROW(ff$data), 2)
  expect_equal(attr(ff, "args")$scientificName, "Myotis septentrionalis")
  expect_equal(ff$data$name[1], "Myotis keenii")

  # Genus is a synonym - species rank input - species not found, so Genus rank given back
  gg <- suppressMessages(occ_search(scientificName = 'Parastrellus hesperus', limit = 2))
  expect_is(gg, "gbif")
  expect_is(gg$data, "character")
  ## above not found, but found after using name_lookup to find a match, genus wrong in this case
  # name_lookup(query = 'Parastrellus hesperus')
  hh <- suppressMessages(occ_search(scientificName = 'Pipistrellus hesperus', limit = 2))
  expect_is(hh, "gbif")
  expect_is(hh$data, "data.frame")
  expect_equal(attr(hh, "args")$scientificName, "Pipistrellus hesperus")
  expect_equal(hh$data$name[1], "Pipistrellus hesperus")
})
