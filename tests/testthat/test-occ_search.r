context("occ_search")

key <- 3118771

# Search by key
test_that("returns the correct class", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search", {
    tt <- occ_search(taxonKey=key, limit=2)
    uu <- occ_search(taxonKey=key, limit=20)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(tt, "gbif")
  expect_is(tt$meta, "list")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data, "tbl_df")
  expect_is(tt$data, "tbl")
  expect_is(tt$data$name, "character")
  expect_is(uu, "gbif")

  expect_equal(tt$meta$limit, 2)
  expect_equal(tt$hierarchy[[1]][1,2], "6")
  expect_equal(as.character(tt$hierarchy[[1]][1,1]), "Plantae")

  expect_equal(as.character(uu$hierarchy[[1]][1,1]), "Plantae")
  expect_equal(uu$meta$limit, 20)

  expect_equal(length(tt), 5)
  expect_equal(length(tt$meta), 4)
})

# Search by dataset key
test_that("returns the correct dimensions", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_datasetkey", {
    out <- occ_search(datasetKey='7b5d6a48-f762-11e1-a439-00145eb45e9a')
  }, preserve_exact_body_bytes = TRUE)

  expect_is(out, "gbif")
  expect_is(out$data, "tbl_df")
  expect_is(out$data, "data.frame")
  expect_is(out$data$name, "character")
  expect_is(out$data$issues, "character")
})

## Search by catalog number
test_that("returns the correct class", {
  vcr::use_cassette("occ_search_catalognumber", {
    out <- occ_search(catalogNumber='PlantAndMushroom.6845144',
      fields='all')
  })

  expect_is(out, "gbif")
  expect_is(out$meta, "list")
  expect_null(out$data)

  # returns the correct value
  expect_true(out$meta$endOfRecords)

  # returns the correct dimensions
  expect_equal(length(out), 5)
})

# Occurrence data: lat/long data, and associated metadata with occurrences
test_that("returns the correct class", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_taxonkey", {
    out <- occ_search(taxonKey=key,limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(out, "gbif")
  expect_is(out$data, "tbl_df")
  expect_is(out$data, "tbl")
  expect_type(out$data$key, "character")
  expect_is(out$data$scientificName, "character")

  # returns the correct value
  expect_equal(out$data$scientificName[1], "Encelia californica Nutt.")
})

# Taxonomic hierarchy data
test_that("returns the correct class", {
  vcr::use_cassette("occ_search_hierarchy_data", {
    out <- occ_search(taxonKey=key, limit=2)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(out$hierarchy, "list")
  expect_is(out$hierarchy[[1]], "data.frame")
  # hier no longer has gbif class
  expect_equal(length(class(out$hierarchy)), 1)

  # returns the correct dimensions
  expect_equal(length(out$hierarchy), 1)
  expect_equal(dim(out$hierarchy[[1]]), c(7,3))
})


# Get occurrences for a particular eventDate
test_that("dates work correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_eventdate", {
    a <- occ_search(taxonKey=3189815, year="2013", fields=c('name','year'),limit=2)
    b <- occ_search(taxonKey=3189815, month="6", fields=c('name','month'),limit=2)
    expect_is(occ_search(taxonKey=key, year="1990,1991"), "gbif")
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(a$data$year[1], 2013)
  expect_equal(b$data$month[1], 6)
})

# Get occurrences for with a particular occurrenceStatus
test_that("occurrenceStatus works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_occurrencestatus", {
    pp <- occ_search(limit=2)
    aa <- occ_search(occurrenceStatus = 'ABSENT',limit=2)
    tt <- occ_search(taxonKey=212,occurrenceStatus = 'ABSENT',limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_equal(pp$data$occurrenceStatus[1], 'PRESENT')
  expect_equal(aa$data$occurrenceStatus[1], 'ABSENT')
  expect_equal(tt$data$classKey[1], 212)
})

# Get occurrences for with a particular gadmGid
test_that("gadmGid works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_gadmGid", {
    bwa <- occ_search(gadmGid='BWA.3_1',limit=2)
    twn <- occ_search(gadmGid='TWN',limit=2)
    usa <- occ_search(taxonKey=212,gadmGid="USA",limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_equal(bwa$data$countryCode[1], 'BW')
  expect_equal(twn$data$countryCode[1], 'TW')
  expect_equal(usa$data$countryCode[1], 'US')
  expect_equal(usa$data$classKey[1], 212)
})

# Get occurrences for with coordinateUncertaintyInMeters
test_that("coordinateUncertaintyInMeters works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_coordinateUncertaintyInMeters", {
    ss <- occ_search(coordinateUncertaintyInMeters=1000,limit=2)
    rr <- occ_search(coordinateUncertaintyInMeters="1000,10000",limit=2)
    
    tt <- occ_search(taxonKey=212,coordinateUncertaintyInMeters="1000,10000",limit=2)
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
  vcr::use_cassette("occ_search_organismQuantity", {
    ss <- occ_search(organismQuantity=5,limit=2)
    rr <- occ_search(organismQuantity="5,20",limit=2)
    tt <- occ_search(taxonKey=212,organismQuantity="5,20",limit=2)
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
  vcr::use_cassette("occ_search_organismQuantityType", {
    yy <- occ_search(organismQuantity=5,organismQuantityType="individuals",limit=2)
    tt <- occ_search(taxonKey=212,organismQuantity="5,20",
                     organismQuantityType="individuals",limit=2)
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
  vcr::use_cassette("occ_search_relativeOrganismQuantity", {
    rr <- occ_search(relativeOrganismQuantity=0.1,limit=2)
    vv <- occ_search(relativeOrganismQuantity="0.1,0.5",limit=2)
    tt <- occ_search(taxonKey=212,relativeOrganismQuantity="0.1,0.5",limit=2)
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
  vcr::use_cassette("occ_search_verbatimScientificName", {
    vv <- occ_search(verbatimScientificName="Calopteryx splendens",limit=2)
    ss <- occ_search(verbatimScientificName="Calopteryx splendens;Calopteryx virgo",limit=2)
    cc <- occ_search(verbatimScientificName=c("Calopteryx splendens","Calopteryx virgo"),limit=2)
    tt <- occ_search(country="DK",verbatimScientificName="Calopteryx splendens",limit=2)
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
  vcr::use_cassette("occ_search_eventId", {
    ii <- occ_search(eventId="1",limit=2)
    hh <- occ_search(eventId="1;2",limit=2)
    cc <- occ_search(eventId=c("1","2"),limit=2)
    tt <- occ_search(taxonKey=212,eventId="1",limit=2)
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
  vcr::use_cassette("occ_search_occurrenceId", {
    ii <- occ_search(occurrenceId="1",limit=2)
    hh <- occ_search(occurrenceId="1;2",limit=2)
    cc <- occ_search(occurrenceId=c("1","2"),limit=2)
    tt <- occ_search(taxonKey=212,occurrenceId="1",limit=2)
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
  vcr::use_cassette("occ_search_speciesKey", {
    kk <- occ_search(speciesKey=7412043,limit=2)
    qq <- occ_search(speciesKey="7412043;1427037",limit=2)
    cc <- occ_search(speciesKey=c(7412043,1427037),limit=2)
    ff <- occ_search(country="DK",speciesKey=7412043,limit=2)
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
  vcr::use_cassette("occ_search_identifiedBy", {
    ww <- occ_search(identifiedBy="John Waller",limit=2)
    bb <- occ_search(identifiedBy="John Waller;Matthew Blissett",limit=2)
    cc <- occ_search(identifiedBy=c("John Waller", "Matthew Blissett"),limit=2)
    dd <- occ_search(country="DK",identifiedBy="John Waller",limit=2)
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
  vcr::use_cassette("occ_search_iucnRedListCategory", {
    ll <- occ_search(iucnRedListCategory="LC",limit=2)
    yy <- occ_search(iucnRedListCategory="LC;EW",limit=2)
    ss <- occ_search(iucnRedListCategory=c("LC", "EW"),limit=2)
    tt <- occ_search(taxonKey=212,iucnRedListCategory="LC",limit=2)
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
  vcr::use_cassette("occ_search_lifeStage", {
    aa <- occ_search(lifeStage="Adult",limit=2)
    ee <- occ_search(lifeStage="Adult;Egg",limit=2)
    cc <- occ_search(lifeStage=c("Adult", "Egg"),limit=2)
    tt <- occ_search(taxonKey=212,lifeStage="Adult",limit=2)
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
  vcr::use_cassette("occ_search_degreeOfEstablishment", {
    ee <- occ_search(degreeOfEstablishment="Established",limit=2)
    ii <- occ_search(degreeOfEstablishment="Established;Invasive",limit=2)
    cc <- occ_search(degreeOfEstablishment=c("Established", "Invasive"),limit=2)
    tt <- occ_search(taxonKey=1,degreeOfEstablishment="Established",limit=2)
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
  vcr::use_cassette("occ_search_isInCluster", {
    ee <- occ_search(isInCluster=TRUE,limit=2)
    ff <- occ_search(isInCluster=FALSE,limit=2)
    tt <- occ_search(taxonKey = 212,isInCluster=TRUE,limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_true(ee$data$isInCluster[1])
  expect_false(ff$data$isInCluster[1])
  expect_true(tt$data$isInCluster[1])
  expect_equal(tt$data$classKey[1], 212)
})


# Get occurrences for with a particular networkKey
test_that("networkKey works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_networkKey", {
    nn <- occ_search(networkKey="4b0d8edb-7504-42c4-9349-63e86c01bf97",limit=2)
    ss <- occ_search(
    networkKey="4b0d8edb-7504-42c4-9349-63e86c01bf97;99d66b6c-9087-452f-a9d4-f15f2c2d0e7e",limit=2)
    cc <- occ_search(networkKey=c("4b0d8edb-7504-42c4-9349-63e86c01bf97",
                                  "99d66b6c-9087-452f-a9d4-f15f2c2d0e7e"),limit=2)
    vv <- occ_search(taxonKey=6,networkKey="4b0d8edb-7504-42c4-9349-63e86c01bf97",limit=2)
  }, preserve_exact_body_bytes = TRUE)
  
  expect_equal(nn$data$networkKeys[1],"4b0d8edb-7504-42c4-9349-63e86c01bf97")
  p <- c("4b0d8edb-7504-42c4-9349-63e86c01bf97|99d66b6c-9087-452f-a9d4-f15f2c2d0e7e")
  expect_true(all(grepl(p,ss$data$networkKeys)))
  expect_true(all(grepl(p,cc$data$networkKeys)))
  expect_equal(vv$data$networkKeys[1],"4b0d8edb-7504-42c4-9349-63e86c01bf97")
  expect_equal(vv$data$kingdomKey[1], 6)
})

test_that("make sure things that should throw errors do", {
  vcr::use_cassette("occ_search_fails_well", {
    # not allowed to do a range query on many variables, including contintent
    expect_error(occ_search(taxonKey=3189815, continent = 'asia,oceania'))
    # can't pass the wrong value to latitude
    expect_error(occ_search(decimalLatitude = 334))
  })
})

# Get occurrences based on depth
test_that("returns the correct stuff", {
  vcr::use_cassette("occ_search_depth", {
    key <- name_backbone(name='Salmo salar', kingdom='animals')$speciesKey
    expect_is(occ_search(taxonKey=key, depth="5",limit=2), "gbif")
    expect_is(occ_search(taxonKey=key, depth=5,limit=2), "gbif")
    # does range search correctly - THROWS ERROR NOW, BUT SHOULD WORK
    expect_error(occ_search(taxonKey=key, depth="5-10"))
  })
})

# Get occurrences based on elevation
test_that("returns the correct dimensions", {
  vcr::use_cassette("occ_search_elevation", {
    key <- name_backbone(name='Puma concolor', kingdom='animals')$speciesKey
    res <- occ_search(taxonKey=key, elevation=1000, hasCoordinate=TRUE,
      fields=c('scientificName', 'elevation'))
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(names(res$data), c('scientificName', 'elevation'))
})

# test that looping is working correctly
test_that("looping works correctly", {
  skip_on_cran() # because fixture in .Rbuildignore
  vcr::use_cassette("occ_search_looping_works", {
    it <- seq(from = 0, to = 500, by = 250)
    out <- list()
    for (i in seq_along(it)) {
      occdata <- occ_search(taxonKey = 3118771, limit = 250, start = it[[i]])
      out[[i]] <- occdata$data
    }
  }, preserve_exact_body_bytes = TRUE)
  expect_equal(unique(sapply(out, function(x) class(x)[1])), "tbl_df")
})

# scientificName usage works correctly
test_that("scientificName basic use works - no synonyms", {
  vcr::use_cassette("occ_search_scientificname", {
    # with synonyms
    bb <- suppressMessages(occ_search(scientificName = 'Pulsatilla nuttalliana (DC.) Spreng.', limit = 2))
    # Genus is a synonym - subspecies rank input
    cc <- suppressMessages(occ_search(scientificName = 'Corynorhinus townsendii ingens', limit = 2))
    # Genus is a synonym - species rank input
    dd <- suppressMessages(occ_search(scientificName = 'Corynorhinus townsendii', limit = 2))
    # specific epithet is the synonym - subspecies rank input
    ## FIXME: this eg no longer works, find new eg
    # ee <- suppressMessages(occ_search(scientificName = "Myotis septentrionalis septentrionalis", limit = 2))
    # above with subspecific name removed, gives result
    ff <- suppressMessages(occ_search(scientificName = "Myotis septentrionalis", limit = 2))
    # Genus is a synonym - species rank input - species not found, so Genus rank given back
    hh <- suppressMessages(occ_search(scientificName = 'Pipistrellus hesperus', limit = 2))
  }, preserve_exact_body_bytes = TRUE)

  expect_equal(attr(bb, "args")$scientificName, "Pulsatilla nuttalliana (DC.) Spreng.")
  expect_equal(bb$data$species[1], "Pulsatilla patens")
  expect_match(bb$data$scientificName[1], "Pulsatilla nuttalliana \\(DC\\.\\) Spreng\\.")

  expect_is(cc, "gbif")
  expect_is(cc$data, "data.frame")
  expect_equal(attr(cc, "args")$scientificName,
               "Corynorhinus townsendii ingens")
  expect_equal(cc$data$species[1], "Corynorhinus townsendii")
  expect_equal(cc$data$scientificName[1],
               "Corynorhinus townsendii ingens Handley, 1955")

  expect_is(dd, "gbif")
  expect_is(dd$data, "data.frame")
  expect_equal(NROW(dd$data), 2)
  expect_equal(attr(dd, "args")$scientificName, "Corynorhinus townsendii")
  expect_equal(dd$data$species[1], "Corynorhinus townsendii")
  expect_equal(dd$data$scientificName[1],
               "Corynorhinus townsendii (Cooper, 1837)")

  # expect_is(ee, "gbif")
  # expect_null(ee$data)
  # expect_equal(attr(ee, "args")$scientificName, "Myotis septentrionalis septentrionalis")

  expect_is(ff, "gbif")
  expect_equal(NROW(ff$data), 2)
  expect_equal(attr(ff, "args")$scientificName, "Myotis septentrionalis")
  expect_equal(ff$data$species[1], "Myotis septentrionalis")
  expect_equal(ff$data$scientificName[1],
               "Myotis septentrionalis (Trouessart, 1897)")

  expect_is(hh, "gbif")
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

  badwkt1 <- "POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 a))"

  # in well known text format
  vcr::use_cassette("occ_search_geometry_aa", {
    aa <- occ_search(geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))', limit=2)
  }, preserve_exact_body_bytes = TRUE)

  # with a taxon key
  vcr::use_cassette("occ_search_geometry_bb", {
    key <- 3189815
    bb <- occ_search(taxonKey=key, 
      geometry='POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))',
      limit=2)
  }, preserve_exact_body_bytes = TRUE)

  # using bounding box, converted to WKT internally
  vcr::use_cassette("occ_search_geometry_cc", {
    cc <- occ_search(geometry=c(-125.0,38.4,-121.8,40.9), limit=2)
  }, preserve_exact_body_bytes = TRUE)

  # if WKT too long, with 'geom_big=bbox': makes into bounding box
  vcr::use_cassette("occ_search_geometry_dd", {
    dd <- occ_search(geometry = wkt, geom_big = "bbox", limit = 30)
    expect_message(occ_search(geometry = wkt, geom_big = "bbox", limit = 1),
                   "geometry is big, querying BBOX, then pruning results to polygon")
  }, preserve_exact_body_bytes = TRUE)

  skip_if_not_installed("sf")
  vcr::use_cassette("occ_search_geometry_ee_gg", {
    # use 'geom_big=axe'
    ee <- occ_search(geometry = wkt, geom_big = "axe", limit = 30)
    ## more calls
    gg <- occ_search(geometry = wkt, geom_big = "axe", geom_size = 30, limit = 5)
  }, preserve_exact_body_bytes = TRUE)

  vcr::use_cassette("occ_search_geometry_errors", {
    # bad wkt is caught and handled appropriately
    expect_error(occ_search(geometry = badwkt1))

    # badwkt2 <- "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 '10.1'))"
    badwkt2 <- "POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 '10.1'))"
    expect_error(occ_search(geometry = badwkt2))

    # badwkt3 <- "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1)"
    badwkt3 <- "POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1)"
    expect_error(occ_search(geometry = badwkt3))

    badwkt4 <- "CIRCULARSTRING(1 5, 6 2, 7 3)"
    expect_error(
      occ_search(geometry = badwkt4),
      "WKT must be one of the types"
    )
  }, preserve_exact_body_bytes = TRUE)

  expect_is(aa, "gbif")
  expect_is(unclass(aa), "list")
  expect_named(attr(aa, "args"), c('occurrenceStatus','limit', 'offset', 'geometry', 'fields'))
  expect_gt(NROW(aa$data), 0)

  expect_is(bb, "gbif")
  expect_is(unclass(bb), "list")
  expect_named(attr(bb, "args"), c('occurrenceStatus','limit', 'offset', 'taxonKey', 'geometry', 'fields'))
  expect_gt(NROW(bb$data), 0)

  expect_is(cc, "gbif")
  expect_is(unclass(cc), "list")
  expect_named(attr(cc, "args"), c('occurrenceStatus','limit', 'offset', 'geometry', 'fields'))
  expect_gt(NROW(cc$data), 0)
  expect_equal(NROW(cc$data), NROW(aa$data))

  expect_lt(nchar(attr(dd, "args")$geometry), nchar(wkt))

  expect_gt(length(names(ee)), length(names(gg)))
})


# many args
test_that("works with parameters that allow many inputs", {
  vcr::use_cassette("occ_search_many_inputs", {
    ## separate requests: use a vector of strings
    aa <- occ_search(recordedBy=c("smith","BJ Stacey"), limit=3)
    ## one request, many instances of same parameter: use semi-colon sep. string
    bb <- occ_search(recordedBy="smith;BJ Stacey", limit=3)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(aa, "gbif")
  expect_is(bb, "gbif")

  expect_named(aa, c('smith', 'BJ Stacey'))
  expect_named(bb, c('meta', 'hierarchy', 'data', 'media', 'facets'))

  expect_equal(unique(tolower(aa[[1]]$data$recordedBy)), c("smith","long|peter|smith|rae"))
  expect_equal(unique(tolower(aa[[2]]$data$recordedBy)), "bj stacey")

  expect_true(unique(tolower(bb$data$recordedBy) %in% c('smith', 'bj stacey')))
})

# per issue #349
test_that("key and gbifID fields are character class", {
  vcr::use_cassette("occ_search_key_gbifid_character_class", {
    aa <- occ_search(taxonKey = 9206251, limit = 3)
  }, preserve_exact_body_bytes = TRUE)

  # top level
  expect_is(aa$data$key, "character")
  expect_is(aa$data$gbifID, "character")
  # within hierarchy
  expect_is(aa$hierarchy[[1]]$key, "character")
  # within media
  expect_is(aa$media[[1]][[1]]$key, "character")
})

test_that("test check_limit 1 million limit exceeded", {
  expect_error(occ_search(limit=1e6+1),"Maximum request size is 1 million.")
})

test_that("multiple values for parameters fails", {
  expect_error(occ_search(
    taxonKey=c(1,2),
    basisOfRecord=c("PRESERVED_SPECIMEN","HUMANA_OBSERVATION")),
    "You can have multiple values for only one of")
})


