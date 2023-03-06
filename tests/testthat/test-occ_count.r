context("occ_count")

test_that("occ_count", {
  vcr::use_cassette("occ_count", {
    aa <- occ_count()
    aaa <- occ_search(limit=0)$meta$count
    bb <- occ_count(taxonKey=212, year="2000,2011")
    bbb <- occ_search(taxonKey=212, year="2000,2011",limit=0)$meta$count
    cc <- occ_count(year=2012)
    ccc <- occ_search(year=2012,limit=0)$meta$count
    dd <- occ_count(occurrenceStatus = "ABSENT")
    ddd <- occ_search(occurrenceStatus = "ABSENT",limit=0)$meta$count
    ee <- occ_count(basisOfRecord="MATERIAL_SAMPLE",organismQuantity=5)
    eee <- occ_search(basisOfRecord="MATERIAL_SAMPLE",organismQuantity=5,limit=0)$meta$count
    ff <- occ_count(verbatimScientificName="Calopteryx splendens;Calopteryx virgo")
    fff <- occ_search(verbatimScientificName="Calopteryx splendens;Calopteryx virgo",limit=0)$meta$count
  }, preserve_exact_body_bytes = TRUE)
  
  # results should be the same for occ_search(limit=0)$meta$count and occ_count()$
  expect_equal(aaa,aa)
  expect_equal(bbb,bb)
  expect_equal(ccc,cc)
  expect_equal(ddd,dd)
  expect_equal(eee,ee)
  expect_equal(fff,ff)
  
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

test_that("occ_count facets work", {
  vcr::use_cassette("occ_count_facet", {
    aa <- occ_count(facet="year",occurrenceStatus = NULL)
    aaa <- occ_search(facet="year",occurrenceStatus = NULL,limit=0)$facet$year
    bb <- occ_count(facet="year",taxonKey=212, year="2000,2003")
    bbb <- occ_search(facet="year",taxonKey=212, year="2000,2003",limit=0)$facet$year
    cc <- occ_count(facet="country",facetLimit=2)
    ccc <- occ_search(facet="country",facetLimit=2,limit=0)$facet$country
    dd <- occ_count(facet="occurrenceStatus",occurrenceStatus=NULL)
    ddd <- occ_search(facet="occurrenceStatus",occurrenceStatus=NULL,limit=0)$facet$occurrenceStatus
    ee <- occ_count(facet="basisOfRecord",basisOfRecord="MATERIAL_SAMPLE",organismQuantity=5)
    eee <- occ_search(facet="basisOfRecord",basisOfRecord="MATERIAL_SAMPLE",organismQuantity=5,limit=0)$facet$basisOfRecord
    ff <- occ_count(facet="coordinateUncertaintyInMeters",facetverbatimScientificName="Calopteryx splendens;Calopteryx virgo")
    fff <- occ_search(facet="coordinateUncertaintyInMeters",facetverbatimScientificName="Calopteryx splendens;Calopteryx virgo",limit=0)$facet$coordinateUncertaintyInMeters
  }, preserve_exact_body_bytes = TRUE)
  
  # occ_search(facet="x",limit=0)$facet$x should return the same
  expect_equal(aaa$count[1],aa$count[1])
  expect_equal(bbb$count[1],bb$count[1])
  expect_equal(ccc$count[1],cc$count[1])
  expect_equal(ddd$count[1],dd$count[1])
  expect_equal(eee$count[1],ee$count[1])
  expect_equal(fff$count[1],ff$count[1])
  
  # returns the correct class
  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  expect_is(dd, "data.frame")
  expect_is(ee, "data.frame")
  expect_is(ff, "data.frame")
  
  # colnames are correct 
  expect_equal(colnames(aa),c("year","count"))
  expect_equal(colnames(bb),c("year","count"))
  expect_equal(colnames(cc),c("country","count"))
  expect_equal(colnames(dd),c("occurrenceStatus","count"))
  expect_equal(colnames(ee),c("basisOfRecord","count"))
  expect_equal(colnames(ff),c("coordinateUncertaintyInMeters","count"))
  
  # returns reasonable amounts of rows
  expect_equal(nrow(aa), 10)
  expect_equal(nrow(bb), 4)
  expect_equal(nrow(cc), 2)
  expect_equal(nrow(dd), 2)
  expect_equal(nrow(ee), 1)
  expect_lte(nrow(ff), 10)
  
  # returns the correct dimensions
  expect_equal(ncol(aa), 2)
  expect_equal(ncol(bb), 2)
  expect_equal(ncol(cc), 2)
  expect_equal(ncol(dd), 2)
  expect_equal(ncol(ee), 2)
  expect_equal(ncol(ff), 2)
  
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
  expect_warning(occ_count(from="2000",to="2001"),  
  "args 'to' and 'from' are deprecated since rgbif 3.7.6, use 'year' instead."  
  )
  }, preserve_exact_body_bytes = TRUE)
  
})
    
  