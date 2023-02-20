context("occ_data")

key <- 3118771

# Search by key
test_that("returns the correct class", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data", {
    tt <- occ_data(taxonKey = key, limit=2)
    uu <- occ_data(taxonKey = key, limit=20)
    vv <- occ_data(taxonKey = key)
  }, preserve_exact_body_bytes = TRUE)

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

  expect_equal(uu$data$species[1], "Encelia californica")
  expect_equal(uu$meta$limit, 20)
  expect_null(vv$limit)

  expect_equal(length(tt), 2)
  expect_equal(length(tt$meta), 4)
})

# Search by dataset key
test_that("returns the correct dimensions", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_datasetkey", {
    out <- occ_data(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a',limit=20)
  }, preserve_exact_body_bytes = TRUE)

  # returns the correct class
  expect_is(out, "gbif_data")
  expect_is(out$meta, "list")
  expect_is(out$data, "data.frame")
  # dimensions
  expect_gt(NROW(out$data), 10)
})

## Search by catalog number
test_that("returns the correct class", {
  vcr::use_cassette("occ_data_catalog_number", {
    out <- occ_data(catalogNumber = '6845144')
  }, preserve_exact_body_bytes = TRUE,
     match_requests_on = c("path", "query"))

  expect_is(out, "gbif_data")
  expect_is(out$meta, "list")
  expect_is(out$data, "data.frame")

  # returns the correct value
  expect_true(out$meta$endOfRecords)

  # returns the correct dimensions
  expect_equal(length(out), 2)
})

# Get occurrences for a particular eventDate
test_that("dates work correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_event_date", {
    a <- occ_data(taxonKey = 3189815, year="2013",limit=2)
    b <- occ_data(taxonKey = 3189815, month="6",limit=2)
    expect_is(occ_data(taxonKey = key, year="1990,1991",limit=2), "gbif_data")
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(a$data$year[1], 2013)
  expect_equal(b$data$month[1], 6)

})

test_that("make sure things that should throw errors do", {
  vcr::use_cassette("occ_data_fails_well", {
    # not allowed to do a range query on many variables, including contintent
    expect_error(occ_data(taxonKey = 3189815, continent = 'asia,oceania', limit=2))
    # can't pass the wrong value to latitude
    expect_error(occ_data(decimalLatitude = 334))
  })
})

# Get occurrences based on depth
test_that("returns the correct stuff", {
  key <- 7595433
  vcr::use_cassette("occ_data_depth", {
    expect_is(occ_data(taxonKey = key, depth="5",limit=2), "gbif_data")
    expect_is(occ_data(taxonKey = key, depth=5,limit=2), "gbif_data")
    # does range search correctly - THROWS ERROR NOW, BUT SHOULD WORK
    expect_error(occ_data(taxonKey = key, depth="5-10", limit=2))
  })
})

# Get occurrences based on elevation
test_that("returns the correct dimensions", {
  key <- 2435099
  vcr::use_cassette("occ_data_elevation", {
    res <- occ_data(taxonKey = key, elevation=1000, hasCoordinate=TRUE,limit=2)
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(res$data$elevation[1], 1000)
})

# test that looping is working correctly
test_that("looping works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_looping", {
    it <- seq(from = 0, to = 500, by = 250)
    out <- list()
    for (i in seq_along(it)) {
      occdata <- occ_data(taxonKey = 3118771, limit = 250, start = it[[i]])
      out[[i]] <- occdata$data
    }
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(unique(sapply(out, function(x) class(x)[1])), "tbl_df")
})

# scientificName usage works correctly
test_that("scientificName basic use works - no synonyms", {
  vcr::use_cassette("occ_data_scientificname", {
    # with synonyms
    bb <- suppressMessages(occ_data(scientificName = 'Pulsatilla patens', limit = 2))
    # Genus is a synonym - subspecies rank input
    cc <- suppressMessages(occ_data(scientificName = 'Corynorhinus townsendii ingens', limit = 2))
    # Genus is a synonym - species rank input
    dd <- suppressMessages(occ_data(scientificName = 'Corynorhinus townsendii', limit = 2))
    # specific epithet is the synonym - subspecies rank input
    # ee <- suppressMessages(occ_data(scientificName = "Myotis septentrionalis septentrionalis", limit = 2))
    # above with subspecific name removed, gives result
    ff <- suppressMessages(occ_data(scientificName = "Myotis septentrionalis", limit = 2))
    # Genus is a synonym - species rank input - species not found, so Genus rank given back
    hh <- suppressMessages(occ_data(scientificName = 'Pipistrellus hesperus', limit = 2))
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(attr(bb, "args")$scientificName, "Pulsatilla patens")
  expect_equal(bb$data$species[1], "Pulsatilla patens")
  expect_match(bb$data$scientificName[1], "Pulsatilla patens \\(L\\.\\) Mill\\.")

  expect_is(cc, "gbif_data")
  expect_is(cc$data, "data.frame")
  expect_equal(attr(cc, "args")$scientificName,
    "Corynorhinus townsendii ingens")
  expect_equal(cc$data$species[1], "Corynorhinus townsendii")
  expect_equal(cc$data$scientificName[1],
    "Corynorhinus townsendii ingens Handley, 1955")

  expect_is(dd, "gbif_data")
  expect_is(dd$data, "data.frame")
  expect_equal(NROW(dd$data), 2)
  expect_equal(attr(dd, "args")$scientificName, "Corynorhinus townsendii")
  expect_equal(dd$data$species[1], "Corynorhinus townsendii")
  expect_equal(dd$data$scientificName[1],
    "Corynorhinus townsendii (Cooper, 1837)")

  # expect_is(ee, "gbif_data")
  # expect_null(suppressWarnings(ee$data))
  # expect_equal(attr(ee, "args")$scientificName, "Myotis septentrionalis septentrionalis")

  expect_is(ff, "gbif_data")
  expect_equal(NROW(ff$data), 2)
  expect_equal(attr(ff, "args")$scientificName, "Myotis septentrionalis")
  expect_equal(ff$data$species[1], "Myotis septentrionalis")
  expect_equal(ff$data$scientificName[1],
    "Myotis septentrionalis (Trouessart, 1897)")

  expect_is(hh, "gbif_data")
  expect_is(hh$data, "data.frame")
  expect_equal(attr(hh, "args")$scientificName, "Pipistrellus hesperus")
  expect_equal(hh$data$species[1], "Parastrellus hesperus")
  expect_equal(hh$data$scientificName[1],
    "Pipistrellus hesperus (H.Allen, 1864)")
  expect_equal(hh$data$acceptedScientificName[1],
    "Parastrellus hesperus (H.Allen, 1864)")
})

# geometry inputs work as expected
test_that("geometry inputs work as expected", {
  skip_on_cran() # because fixture in .Rbuildignore
  
  # in well known text format
  vcr::use_cassette("occ_data_geometry_aa", {
    aa <- occ_data(geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))', limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_is(aa, "gbif_data")
  expect_is(unclass(aa), "list")
  expect_named(attr(aa, "args"), c('occurrenceStatus', 'limit', 'offset', 'geometry'))
  expect_gt(NROW(aa$data), 0)
  
  # with a taxon key
  vcr::use_cassette("occ_data_geometry_bb", {
    key <- 3189815
    bb <- occ_data(taxonKey = key, 
      geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))',
      limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(bb, "gbif_data")
  expect_is(unclass(bb), "list")
  expect_named(attr(bb, "args"), c('occurrenceStatus', 'limit', 'offset', 'taxonKey', 'geometry'))
  expect_gt(NROW(bb$data), 0)
    
  # using bounding box, converted to WKT internally
  vcr::use_cassette("occ_data_geometry_cc", {
    cc <- occ_data(geometry=c(-125.0,38.4,-121.8,40.9), limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(cc, "gbif_data")
  expect_is(unclass(cc), "list")
  expect_named(attr(cc, "args"), c('occurrenceStatus', 'limit', 'offset', 'geometry'))
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

  skip_if_not_installed("sf")
  
  # if WKT too long, with 'geom_big=bbox': makes into bounding box
  vcr::use_cassette("occ_data_geometry_dd", {
    dd <- occ_data(geometry = wkt, geom_big = "bbox", limit = 30)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_lt(nchar(attr(dd, "args")$geometry), nchar(wkt))
  expect_message(occ_data(geometry = wkt, geom_big = "bbox", limit = 1),
                 "geometry is big, querying BBOX, then pruning results to polygon")

  # use 'geom_big=axe'
  vcr::use_cassette("occ_data_geometry_ee_gg", {
    ee <- occ_data(geometry = wkt, geom_big = "axe", limit = 30)
    ## more calls
    gg <- occ_data(geometry = wkt, geom_big = "axe", geom_size = 30, limit = 5)

    expect_gt(length(names(ee)), length(names(gg)))
  }, preserve_exact_body_bytes = TRUE)

  # bad wkt is caught and handled appropriately
  vcr::use_cassette("occ_data_geometry_errors", {
    badwkt1 <- "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 a))"
    expect_error(occ_data(geometry = badwkt1))

    badwkt2 <- "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 '10.1'))"
    expect_error(occ_data(geometry = badwkt2))

    badwkt3 <- "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1)"
    expect_error(occ_data(geometry = badwkt3))

    badwkt4 <- "CIRCULARSTRING(1 5, 6 2, 7 3)"
    expect_error(occ_data(geometry = badwkt4))
  }, preserve_exact_body_bytes = TRUE)
})

# many args
test_that("works with parameters that allow many inputs", {
  vcr::use_cassette("occ_data_args_with_many_inputs", {
    ## separate requests: use a vector of strings
    aa <- occ_data(recordedBy=c("smith","BJ Stacey"), limit=3)
    ## one request, many instances of same parameter: use semi-colon sep. string
    bb <- occ_data(recordedBy="smith;BJ Stacey", limit=3)
  }, preserve_exact_body_bytes = TRUE, match_requests_on = c("path", "query"))

  expect_is(aa, "gbif_data")
  expect_is(bb, "gbif_data")

  expect_named(aa, c('smith', 'BJ Stacey'))
  expect_named(bb, c('meta', 'data'))

  expect_equal(unique(tolower(aa[[1]]$data$recordedBy)), c("smith","long|peter|smith|rae"))
  expect_equal(unique(tolower(aa[[2]]$data$recordedBy)), "bj stacey")

  expect_true(unique(tolower(bb$data$recordedBy) %in% c('smith', 'bj stacey')))
})

# per issue #349
test_that("key and gbifID fields are character class", {
  vcr::use_cassette("occ_data_key_gbifid_character_class", {
    aa <- occ_data(taxonKey = 9206251, limit = 3)
  }, preserve_exact_body_bytes = TRUE)
  expect_is(aa$data$key, "character")
  expect_is(aa$data$gbifID, "character")
})

# per issue #427
test_that("various fields are dropped - so should be absent", {
  vcr::use_cassette("occ_data_dropped_fields", {
    aa <- occ_data(limit = 3)
  }, preserve_exact_body_bytes = TRUE)
  df <- data.frame(aa$data)
  expect_null(df$media)
  expect_null(df$facts)
  expect_null(df$relations)
  expect_null(df$identifiers)
  expect_null(df$extensions)
  expect_null(df$gadm)
  expect_null(df$recordedByIDs)
  expect_null(df$identifiedByIDs)
})

# Get occurrences for with a particular occurrenceStatus
test_that("occurrenceStatus works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_occurrencestatus", {
    pp <- occ_data(limit=2)
    aa <- occ_data(occurrenceStatus = 'ABSENT', limit=2)
    tt <- occ_data(taxonKey=212,occurrenceStatus = 'ABSENT', limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(pp$data$occurrenceStatus[1], 'PRESENT')
  expect_equal(aa$data$occurrenceStatus[1], 'ABSENT')
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with a particular gadmGid
test_that("gadmGid works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_gadmGid", {
    bwa <- occ_data(gadmGid='BWA.3_1', limit=2)
    twn <- occ_data(gadmGid='TWN', limit=2)
    usa <- occ_data(taxonKey=212,gadmGid="USA", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(bwa$data$countryCode[1], 'BW')
  expect_equal(twn$data$countryCode[1], 'TW')
  expect_equal(usa$data$countryCode[1], 'US')
  expect_equal(usa$data$classKey[1], 212)
})

# Get occurrences for with coordinateUncertaintyInMeters
test_that("coordinateUncertaintyInMeters works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_coordinateUncertaintyInMeters", {
    ss <- occ_data(coordinateUncertaintyInMeters=1000, limit=2)
    rr <- occ_data(coordinateUncertaintyInMeters="1000,10000", limit=2)

    tt <- occ_data(taxonKey=212,coordinateUncertaintyInMeters="1000,10000", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ss$data$coordinateUncertaintyInMeters[1], 1000)
  expect_true(all(rr$data$coordinateUncertaintyInMeters <= 10000 &
                    rr$data$coordinateUncertaintyInMeters >= 1000))
  expect_true(all(tt$data$coordinateUncertaintyInMeters <= 10000 &
                    tt$data$coordinateUncertaintyInMeters >= 1000))
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with organismQuantity
test_that("organismQuantity works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_organismQuantity", {
    ss <- occ_data(organismQuantity=5, limit=2)
    rr <- occ_data(organismQuantity="5,20", limit=2)
    tt <- occ_data(taxonKey=212,organismQuantity="5,20", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ss$data$organismQuantity[1], 5)
  expect_true(all(rr$data$organismQuantity <= 20 &
                    rr$data$organismQuantity >= 5))
  expect_true(all(tt$data$organismQuantity <= 20 &
                    tt$data$organismQuantity >= 5))
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with organismQuantityType
test_that("organismQuantityType works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_organismQuantityType", {
    yy <- occ_data(organismQuantity=5,organismQuantityType="individuals", limit=2)
    tt <- occ_data(taxonKey=212,organismQuantity="5,20",
                     organismQuantityType="individuals", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(yy$data$organismQuantityType[1], "individuals")
  expect_equal(yy$data$organismQuantity[1], 5)
  expect_equal(tt$data$organismQuantityType[1], "individuals")
  expect_true(all(tt$data$organismQuantity <= 20 &
                    tt$data$organismQuantity >= 5))
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with relativeOrganismQuantity
test_that("relativeOrganismQuantity works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_relativeOrganismQuantity", {
    rr <- occ_data(relativeOrganismQuantity=0.1, limit=2)
    vv <- occ_data(relativeOrganismQuantity="0.1,0.5", limit=2)
    tt <- occ_data(taxonKey=212,relativeOrganismQuantity="0.1,0.5", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(rr$data$relativeOrganismQuantity[1], 0.1)
  expect_true(all(vv$data$relativeOrganismQuantity <= 0.5 &
                    vv$data$relativeOrganismQuantity >= 0.1))
  expect_true(all(tt$data$relativeOrganismQuantity <= 0.5 &
                    tt$data$relativeOrganismQuantity >= 0.1))
  expect_equal(tt$data$classKey[1], 212)
})



# Get occurrences for with a particular verbatimScientificName
test_that("verbatimScientificName works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_verbatimScientificName", {
    vv <- occ_data(verbatimScientificName="Calopteryx splendens", limit=2)
    ss <- occ_data(verbatimScientificName="Calopteryx splendens;Calopteryx virgo", limit=2)
    cc <- occ_data(verbatimScientificName=c("Calopteryx splendens","Calopteryx virgo"), limit=2)
    tt <- occ_data(country="DK",verbatimScientificName="Calopteryx splendens", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(vv$data$species[1], "Calopteryx splendens")
  expect_true(all(ss$data$species %in% c("Calopteryx splendens","Calopteryx virgo")))
  expect_true(all(cc$data$species %in% c("Calopteryx splendens","Calopteryx virgo")))
  expect_equal(tt$data$species[1], "Calopteryx splendens")
  expect_equal(tt$data$countryCode[1], "DK")
})

# Get occurrences for with a particular eventId
test_that("eventId works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_eventId", {
    ii <- occ_data(eventId="1", limit=2)
    hh <- occ_data(eventId="1;2", limit=2)
    cc <- occ_data(eventId=c("1","2"), limit=2)
    tt <- occ_data(taxonKey=212,eventId="1", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ii$data$eventID[1], "1")
  expect_true(all(hh$data$eventID %in% c("1","2")))
  expect_true(all(cc$data$eventID %in% c("1","2")))
  expect_equal(tt$data$eventID[1], "1")
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with a particular occurrenceId
test_that("occurrenceId works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_occurrenceId", {
    ii <- occ_data(occurrenceId="1", limit=2)
    hh <- occ_data(occurrenceId="1;2", limit=2)
    cc <- occ_data(occurrenceId=c("1","2"), limit=2)
    tt <- occ_data(taxonKey=212,occurrenceId="1", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ii$data$occurrenceID[1], "1")
  expect_true(all(hh$data$occurrenceID %in% c("1","2")))
  expect_true(all(cc$data$occurrenceID %in% c("1","2")))
  expect_equal(tt$data$occurrenceID[1], "1")
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with a particular speciesKey
test_that("speciesKey works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_speciesKey", {
    kk <- occ_data(speciesKey=7412043, limit=2)
    qq <- occ_data(speciesKey="7412043;1427037", limit=2)
    cc <- occ_data(speciesKey=c(7412043,1427037), limit=2)
    ff <- occ_data(country="DK",speciesKey=7412043, limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(kk$data$speciesKey[1],7412043)
  expect_true(all(qq$data$speciesKey %in% c(7412043,1427037)))
  expect_true(all(cc$data$speciesKey %in% c(7412043,1427037)))
  expect_equal(kk$data$speciesKey[1],7412043)
  expect_equal(ff$data$countryCode[1], "DK")
})

# Get occurrences for with a particular identifiedBy
test_that("identifiedBy works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_identifiedBy", {
    ww <- occ_data(identifiedBy="John Waller", limit=2)
    bb <- occ_data(identifiedBy="John Waller;Matthew Blissett", limit=2)
    cc <- occ_data(identifiedBy=c("John Waller", "Matthew Blissett"), limit=2)
    dd <- occ_data(country="DK",identifiedBy="John Waller", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ww$data$identifiedBy[1],"John Waller")
  expect_true(all(bb$data$identifiedBy %in% c("John Waller", "Matthew Blissett")))
  expect_true(all(cc$data$identifiedBy %in% c("John Waller", "Matthew Blissett")))
  expect_equal(dd$data$identifiedBy[1],"John Waller")
  expect_equal(dd$data$countryCode[1], "DK")
})

# Get occurrences for with a particular iucnRedListCategory
test_that("iucnRedListCategory works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_iucnRedListCategory", {
    ll <- occ_data(iucnRedListCategory="LC", limit=2)
    yy <- occ_data(iucnRedListCategory="LC;EW", limit=2)
    ss <- occ_data(iucnRedListCategory=c("LC", "EW"), limit=2)
    tt <- occ_data(taxonKey=212,iucnRedListCategory="LC", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ll$data$iucnRedListCategory[1],"LC")
  expect_true(all(yy$data$iucnRedListCategory %in% c("LC", "EW")))
  expect_equal(ss[[1]]$data$iucnRedListCategory[1],"LC")
  expect_equal(ss[[2]]$data$iucnRedListCategory[1],"EW")
  expect_equal(tt$data$iucnRedListCategory[1],"LC")
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with a particular lifeStage
test_that("lifeStage works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_lifeStage", {
    aa <- occ_data(lifeStage="Adult", limit=2)
    ee <- occ_data(lifeStage="Adult;Egg", limit=2)
    cc <- occ_data(lifeStage=c("Adult", "Egg"), limit=2)
    tt <- occ_data(taxonKey=212,lifeStage="Adult", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(aa$data$lifeStage[1],"Adult")
  expect_true(all(ee$data$lifeStage %in% c("Adult", "Egg")))
  expect_equal(cc[[1]]$data$lifeStage[1],"Adult")
  expect_equal(cc[[2]]$data$lifeStage[1],"Egg")
  expect_equal(tt$data$lifeStage[1],"Adult")
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with a particular degreeOfEstablishment
test_that("degreeOfEstablishment works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_degreeOfEstablishment", {
    ee <- occ_data(degreeOfEstablishment="Established", limit=2)
    ii <- occ_data(degreeOfEstablishment="Established;Invasive", limit=2)
    cc <- occ_data(degreeOfEstablishment=c("Established", "Invasive"), limit=2)
    tt <- occ_data(taxonKey=1,degreeOfEstablishment="Established", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(ee$data$degreeOfEstablishment[1],"Established")
  expect_true(all(ii$data$degreeOfEstablishment %in% c("Established", "Invasive")))
  expect_true(all(cc$data$degreeOfEstablishment %in% c("Established", "Invasive")))
  expect_equal(tt$data$degreeOfEstablishment[1],"Established")
  expect_equal(tt$data$kingdomKey[1], 1)
})


# Test argument isInCluster
test_that("isInCluster works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_isInCluster", {
    ee <- occ_data(isInCluster=TRUE, limit=2)
    ff <- occ_data(isInCluster=FALSE, limit=2)
    tt <- occ_data(taxonKey = 212,isInCluster=TRUE, limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_true(ee$data$isInCluster[1])
  expect_false(ff$data$isInCluster[1])
  expect_true(tt$data$isInCluster[1])
  expect_equal(tt$data$classKey[1], 212)
})

# Test argument distanceFromCentroidInMeters
test_that("distanceFromCentroidInMeters works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_distanceFromCentroidInMeters", {
    ee <- occ_data(distanceFromCentroidInMeters=0,limit=2)
    rr <- occ_data(distanceFromCentroidInMeters="2000,*",limit=2)
    dd <- occ_data(distanceFromCentroidInMeters="0,2000",limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_equal(nrow(ee$data),2)
  expect_equal(nrow(rr$data),2)
  expect_equal(nrow(dd$data),2)
  expect_true(rr$meta$count > dd$meta$count)
})


# Get occurrences for with a particular networkKey
test_that("networkKey works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_data_networkKey", {
    nn <- occ_data(networkKey="4b0d8edb-7504-42c4-9349-63e86c01bf97", limit=2)
    ss <- occ_data(
      networkKey="4b0d8edb-7504-42c4-9349-63e86c01bf97;99d66b6c-9087-452f-a9d4-f15f2c2d0e7e", limit=2)
    cc <- occ_data(networkKey=c("4b0d8edb-7504-42c4-9349-63e86c01bf97",
                                  "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e"), limit=2)
    vv <- occ_data(taxonKey=6,networkKey="4b0d8edb-7504-42c4-9349-63e86c01bf97", limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(nn$data$networkKeys[[1]],"4b0d8edb-7504-42c4-9349-63e86c01bf97")
  p <- c("4b0d8edb-7504-42c4-9349-63e86c01bf97|99d66b6c-9087-452f-a9d4-f15f2c2d0e7e")
  expect_true(all(grepl(p,ss$data$networkKeys)))
  expect_true(all(grepl(p,cc$data$networkKeys)))
  expect_equal(vv$data$networkKeys[[1]],"4b0d8edb-7504-42c4-9349-63e86c01bf97")
  expect_equal(vv$data$kingdomKey[[1]], 6)
})

