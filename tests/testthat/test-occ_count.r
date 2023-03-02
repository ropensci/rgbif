context("occ_count")

test_that("occ_count", {
  vcr::use_cassette("occ_count", {
    aa <- occ_count()
    bb <- occ_count(taxonKey=212, year="2000,2011")
    cc <- occ_count(year=2012)
    dd <- occ_count(occurrenceStatus = "ABSENT")
    ee <- occ_count(basisOfRecord="MATERIAL_SAMPLE",organismQuantity=5)
    ff <- occ_count(verbatimScientificName="Calopteryx splendens;Calopteryx virgo")
  }, preserve_exact_body_bytes = TRUE)
  
  # returns the correct class
  expect_is(aa, "numeric")
  expect_is(bb, "numeric")
  expect_is(cc, "numeric")
  expect_is(dd, "numeric")
  expect_is(ee, "numeric")
  expect_is(ff, "numeric")
  
  # any with filter should be less than aa
  expect_lt(bb,aa)
  expect_lt(cc,aa)
  expect_lt(dd,aa)
  expect_lt(ee,aa)
  expect_lt(ff,aa)
  
  # returns the correct dimensions
  expect_equal(length(aa), 1)
  expect_equal(length(bb), 1)
  expect_equal(length(cc), 1)
  expect_equal(length(dd), 1)
  expect_equal(length(ee), 1)
  expect_equal(length(ff), 1)
})


test_that("occ_count fails well", {
    expect_error(
     occ_count(basisOfRecord=c('OBSERVATION','PRESERVED_SPECIMEN'), year=2012),
     "Multiple values of the form c\\('a','b'\\) are not supported. Use 'a;b' instead."
    )
})

test_that("occ_count legacy params", {
  vcr::use_cassette("occ_count_legacy_params", {
  expect_warning(occ_count(georeferenced = TRUE),  
  "arg 'georeferenced' is deprecated since rgbif 3.7.6, use 'hasCoordinate' and 'hasGeospatialIssue' instead."  
  )
  expect_warning(occ_count(date = "2010"),  
  "arg 'date' is deprecated since rgbif 3.7.6"  
  )
  expect_warning(occ_count(type="count"),  
  "arg 'type' is deprecated since rgbif 3.7.6, use 'occ_counts_\\*' functions instead."  
  )
  expect_warning(occ_count(from="2000",to="20001"),  
  "args 'to' and 'from' are deprecated since rgbif 3.7.6, use 'year' instead."  
  )
  }, preserve_exact_body_bytes = TRUE)
  
})
    
  