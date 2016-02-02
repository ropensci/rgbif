context("occ_data")

key <- 3119195

test_that("returns the correct class", {
  skip_on_cran()

  # Search by key
  tt <- occ_data(taxonKey=key, limit=2)
  uu <- occ_data(taxonKey=key, limit=20)
  vv <- occ_data(taxonKey=key)

  expect_is(tt$meta, "list")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data$name, "character")
  expect_is(vv, "gbif_data")
  # meta no longer has gbif class
  expect_equal(length(class(vv)), 1)

  expect_equal(tt$meta$limit, 2)
  # occ_data doesn't have hierarchy slot
  expect_null(tt$hierarchy)
  # occ_data doesn't have media slot
  expect_null(tt$media)

  expect_equal(uu$data[1,1], "Helianthus annuus")
  expect_equal(uu$meta$limit, 20)
  expect_null(vv$limit)

  expect_equal(length(tt), 2)
  expect_equal(length(tt$meta), 4)
})

# Search by dataset key
test_that("returns the correct dimensions", {
  skip_on_cran()

  out <- occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a')

  # returns the correct class
  expect_is(out, "gbif_data")
  expect_is(out$meta, "list")
  expect_is(out$data, "data.frame")
  # dimensions
  expect_gt(NROW(out$data), 10)
})

## Search by catalog number
test_that("returns the correct class", {
  skip_on_cran()

  out <- occ_data(catalogNumber = '6845144')

  expect_is(out, "gbif_data")
  expect_is(out$meta, "list")
  expect_is(out$data, "data.frame")

  # returns the correct value
  expect_true(out$meta$endOfRecords)

  # returns the correct dimensions
  expect_equal(length(out), 2)
})

######### Get occurrences for a particular eventDate
test_that("dates work correctly", {
  skip_on_cran()

  a <- occ_data(taxonKey=3189815, year="2013")
  b <- occ_data(taxonKey=3189815, month="6")

  expect_equal(a$data$year[1], 2013)
  expect_equal(b$data$month[1], 6)

  expect_is(occ_data(taxonKey=key, year="1990,1991"), "gbif_data")
})

test_that("make sure things that should throw errors do", {
  skip_on_cran()

  # not allowed to do a range query on many variables, including contintent
  expect_error(occ_data(taxonKey=3189815, continent = 'asia,oceania'))
  # can't pass the wrong value to latitude
  expect_error(occ_data(decimalLatitude = 334))
})

######### Get occurrences based on depth
test_that("returns the correct stuff", {
  skip_on_cran()

  key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
  expect_is(occ_data(taxonKey=key, depth="5"), "gbif_data")
  expect_is(occ_data(taxonKey=key, depth=5), "gbif_data")
  # does range search correctly - THROWS ERROR NOW, BUT SHOULD WORK
  expect_error(occ_data(taxonKey=key, depth="5-10"))
})

######### Get occurrences based on elevation
test_that("returns the correct dimensions", {
  skip_on_cran()

  key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
  res <- occ_data(taxonKey=key, elevation=1000, hasCoordinate=TRUE)
  expect_equal(res$data$elevation[1], 1000)
})

# test that looping is working correctly
test_that("looping works correctly", {
  skip_on_cran()

  it <- seq(from = 0, to = 750, by = 250)
  out <- list()
  for (i in seq_along(it)) {
    occdata <- occ_data(taxonKey = 3119195, limit = 250, start = it[[i]])
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
  bb <- suppressMessages(occ_data(scientificName = 'Pulsatilla patens', limit = 2))
  expect_equal(attr(bb, "args")$scientificName, "Pulsatilla patens")
  expect_equal(bb$data$name[1], "Anemone patens")

  # Genus is a synonym - subspecies rank input
  cc <- suppressMessages(occ_data(scientificName = 'Corynorhinus townsendii ingens', limit = 2))
  expect_is(cc, "gbif_data")
  expect_is(cc$data, "data.frame")
  expect_equal(attr(cc, "args")$scientificName, "Corynorhinus townsendii ingens")
  expect_equal(cc$data$name[1], "Plecotus townsendii")

  # Genus is a synonym - species rank input
  dd <- suppressMessages(occ_data(scientificName = 'Corynorhinus townsendii', limit = 2))
  expect_is(dd, "gbif_data")
  expect_is(dd$data, "data.frame")
  expect_equal(NROW(dd$data), 2)
  expect_equal(attr(dd, "args")$scientificName, "Corynorhinus townsendii")
  expect_equal(dd$data$name[1], "Plecotus townsendii")

  # specific epithet is the synonym - subspecies rank input
  ee <- suppressMessages(occ_data(scientificName = "Myotis septentrionalis septentrionalis", limit = 2))
  expect_is(ee, "gbif_data")
  expect_is(ee$data, "character")
  expect_equal(attr(ee, "args")$scientificName, "Myotis septentrionalis septentrionalis")

  # above with subspecific name removed, gives result
  ff <- suppressMessages(occ_data(scientificName = "Myotis septentrionalis", limit = 2))
  expect_is(ff, "gbif_data")
  expect_equal(NROW(ff$data), 2)
  expect_equal(attr(ff, "args")$scientificName, "Myotis septentrionalis")
  expect_equal(ff$data$name[1], "Myotis keenii")

  # Genus is a synonym - species rank input - species not found, so Genus rank given back
  gg <- suppressMessages(occ_data(scientificName = 'Parastrellus hesperus', limit = 2))
  expect_is(gg, "gbif_data")
  expect_is(gg$data, "character")
  ## above not found, but found after using name_lookup to find a match, genus wrong in this case
  # name_lookup(query = 'Parastrellus hesperus')
  hh <- suppressMessages(occ_data(scientificName = 'Pipistrellus hesperus', limit = 2))
  expect_is(hh, "gbif_data")
  expect_is(hh$data, "data.frame")
  expect_equal(attr(hh, "args")$scientificName, "Pipistrellus hesperus")
  expect_equal(hh$data$name[1], "Pipistrellus hesperus")
})
