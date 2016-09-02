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

  expect_equal(uu$data[1,1]$name, "Helianthus annuus")
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
  expect_equal(unique(sapply(out, function(x) class(x)[1])), "tbl_df")
})

######### scientificName usage works correctly
test_that("scientificName basic use works - no synonyms", {
  skip_on_cran()

  # with synonyms
  bb <- suppressMessages(occ_data(scientificName = 'Pulsatilla patens', limit = 2))
  expect_equal(attr(bb, "args")$scientificName, "Pulsatilla patens")
  expect_equal(bb$data$name[1], "Pulsatilla patens")

  # Genus is a synonym - subspecies rank input
  cc <- suppressMessages(occ_data(scientificName = 'Corynorhinus townsendii ingens', limit = 2))
  expect_is(cc, "gbif_data")
  expect_is(cc$data, "data.frame")
  expect_equal(attr(cc, "args")$scientificName, "Corynorhinus townsendii ingens")
  expect_equal(cc$data$name[1], "Corynorhinus townsendii")

  # Genus is a synonym - species rank input
  dd <- suppressMessages(occ_data(scientificName = 'Corynorhinus townsendii', limit = 2))
  expect_is(dd, "gbif_data")
  expect_is(dd$data, "data.frame")
  expect_equal(NROW(dd$data), 2)
  expect_equal(attr(dd, "args")$scientificName, "Corynorhinus townsendii")
  expect_equal(dd$data$name[1], "Corynorhinus townsendii")

  # specific epithet is the synonym - subspecies rank input
  ee <- suppressMessages(occ_data(scientificName = "Myotis septentrionalis septentrionalis", limit = 2))
  expect_is(ee, "gbif_data")
  expect_null(suppressWarnings(ee$data))
  expect_equal(attr(ee, "args")$scientificName, "Myotis septentrionalis septentrionalis")

  # above with subspecific name removed, gives result
  ff <- suppressMessages(occ_data(scientificName = "Myotis septentrionalis", limit = 2))
  expect_is(ff, "gbif_data")
  expect_equal(NROW(ff$data), 2)
  expect_equal(attr(ff, "args")$scientificName, "Myotis septentrionalis")
  expect_equal(ff$data$name[1], "Myotis septentrionalis")

  # Genus is a synonym - species rank input - species not found, so Genus rank given back
  gg <- suppressMessages(occ_data(scientificName = 'Parastrellus hesperus', limit = 2))
  expect_is(gg, "gbif_data")
  expect_is(gg$data, "data.frame")
  ## above not found, but found after using name_lookup to find a match, genus wrong in this case
  # name_lookup(query = 'Parastrellus hesperus')
  hh <- suppressMessages(occ_data(scientificName = 'Pipistrellus hesperus', limit = 2))
  expect_is(hh, "gbif_data")
  expect_is(hh$data, "data.frame")
  expect_equal(attr(hh, "args")$scientificName, "Pipistrellus hesperus")
  expect_equal(hh$data$name[1], "Parastrellus hesperus")
})

######### geometry inputs work as expected
test_that("geometry inputs work as expected", {
  skip_on_cran()

  # in well known text format
  aa <- occ_data(geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit=20)
  expect_is(aa, "gbif_data")
  expect_is(unclass(aa), "list")
  expect_named(attr(aa, "args"), c('geometry', 'limit', 'offset'))
  expect_gt(NROW(aa$data), 0)

  # with a taxon key
  key <- 3189815
  bb <- occ_data(taxonKey=key, geometry='POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))',
                   limit=20)
  expect_is(bb, "gbif_data")
  expect_is(unclass(bb), "list")
  expect_named(attr(bb, "args"), c('taxonKey', 'geometry', 'limit', 'offset'))
  expect_gt(NROW(bb$data), 0)
  expect_lt(NROW(bb$data), NROW(aa$data))

  # using bounding box, converted to WKT internally
  cc <- occ_data(geometry=c(-125.0,38.4,-121.8,40.9), limit=20)
  expect_is(cc, "gbif_data")
  expect_is(unclass(cc), "list")
  expect_named(attr(cc, "args"), c('geometry', 'limit', 'offset'))
  expect_gt(NROW(cc$data), 0)
  expect_equal(NROW(cc$data), NROW(aa$data))

  # Search on a long WKT string - too long for a GBIF search API request
  ## internally convert WKT string to a bounding box
  wkt <- "POLYGON((13.26349675655365 52.53991761181831,18.36115300655365 54.11445544219924,
  21.87677800655365 53.80418956368524,24.68927800655365 54.217364774722455,28.20490300655365
  54.320018299365124,30.49005925655365 52.85948216284084,34.70880925655365 52.753220564427814,
  35.93927800655365 50.46131871049754,39.63068425655365 49.55761261299145,40.86115300655365
  46.381388009130845,34.00568425655365 45.279102926537,33.30255925655365 48.636868465271846,
  30.13849675655365 49.78513301801265,28.38068425655365 47.2236377039631,29.78693425655365
  44.6572866068524,27.67755925655365 42.62220075124676,23.10724675655365 43.77542058000212,
  24.51349675655365 47.10412345120368,26.79865300655365 49.55761261299145,23.98615300655365
  52.00209943876426,23.63459050655365 49.44345313705238,19.41584050655365 47.580567827212114,
  19.59162175655365 44.90682206053508,20.11896550655365 42.36297154876359,22.93146550655365
  40.651849782081555,25.56818425655365 39.98171166226459,29.61115300655365 40.78507856230178,
  32.95099675655365 40.38459278067577,32.95099675655365 37.37491910393631,26.27130925655365
  33.65619609886799,22.05255925655365 36.814081996401605,18.71271550655365 36.1072176729021,
  18.53693425655365 39.16878677351903,15.37287175655365 38.346355762190846,15.19709050655365
  41.578843777436326,12.56037175655365 41.050735748143424,12.56037175655365 44.02872991212046,
  15.19709050655365 45.52594200494078,16.42755925655365 48.05271546733352,17.48224675655365
  48.86865641518059,10.62677800655365 47.817178329053135,9.57209050655365 44.154980365192,
  8.16584050655365 40.51835445724746,6.05646550655365 36.53210972067291,0.9588092565536499
  31.583640057148145,-5.54509699344635 35.68001485298146,-6.77556574344635 40.51835445724746,
  -9.41228449344635 38.346355762190846,-12.40056574344635 35.10683619158607,-15.74040949344635
  38.07010978950028,-14.68572199344635 41.31532459432774,-11.69744074344635 43.64836179231387,
  -8.88494074344635 42.88035509418534,-4.31462824344635 43.52103366008421,-8.35759699344635
  47.2236377039631,-8.18181574344635 50.12441989397795,-5.01775324344635 49.55761261299145,
  -2.73259699344635 46.25998980446569,-1.67790949344635 44.154980365192,-1.32634699344635
  39.30493590580802,2.18927800655365 41.44721797271696,4.47443425655365 43.26556960420879,
  2.18927800655365 46.7439668697322,1.83771550655365 50.3492841273576,6.93537175655365
  49.671505849335254,5.00177800655365 52.32557322466785,7.81427800655365 51.67627099802223,
  7.81427800655365 54.5245591562317,10.97834050655365 51.89375191441792,10.97834050655365
  55.43241335888528,13.26349675655365 52.53991761181831))"
  wkt <- gsub("\n", " ", wkt)

  # Default option with large WKT string fails
  # expect_error(occ_data(geometry = wkt, limit = 1),
  #              "Client error: \\(413\\) Request Entity Too Large")

  # if WKT too long, with 'geom_big=bbox': makes into bounding box
  dd <- occ_data(geometry = wkt, geom_big = "bbox", limit = 30)
  expect_lt(nchar(attr(dd, "args")$geometry), nchar(wkt))
  expect_message(occ_data(geometry = wkt, geom_big = "bbox", limit = 1),
                 "geometry is big, querying BBOX, then pruning results to polygon")

  # use 'geom_big=axe'
  ee <- occ_data(geometry = wkt, geom_big = "axe", limit = 30)
  ## more calls
  gg <- occ_data(geometry = wkt, geom_big = "axe", geom_size = 30, limit = 5)

  expect_gt(length(names(gg)), length(names(ee)))
})

######### spell check works
test_that("spell check param works", {
  skip_on_cran()

  # as normal
  expect_is(
    occ_data(search = "kingfisher", limit=1, spellCheck = TRUE),
    "gbif_data"
  )

  # spelled incorrectly - stops with suggested spelling
  expect_error(
    occ_data(search = "kajsdkla", limit=20, spellCheck = TRUE),
    "spelling bad - suggestions"
  )

  # spelled incorrectly - stops with many suggested spellings and number of results for each
  expect_error(
    occ_data(search = "helir", limit=20, spellCheck = TRUE),
    "spelling bad - suggestions"
  )
})
