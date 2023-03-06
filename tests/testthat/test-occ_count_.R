context("occ_count_")

test_that("occ_count_ custom functions work", {
  vcr::use_cassette("occ_count_", {
    aa <- occ_count_country()
    bb <- occ_count_country(publishingCountry="DK")
    cc <- occ_count_pub_country(country="DK")
    dd <- occ_count_year()
    ee <- occ_count_year(year="1990,2000")
    ff <- occ_count_basis_of_record()
  })
  
  # returns the correct class
  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  expect_is(dd, "data.frame")
  expect_is(ee, "data.frame")
  expect_is(ff, "data.frame")
  
  expect_equal(ncol(aa),7)
  expect_equal(ncol(bb),7)
  expect_equal(ncol(cc),7)
  expect_equal(ncol(dd),2)
  expect_equal(ncol(ee),2)
  expect_equal(ncol(ff),2)
  
  expect_gt(nrow(aa),200)
  expect_gt(nrow(bb),200)
  expect_gt(nrow(cc),30) 
  expect_gt(nrow(dd),420)
  expect_equal(nrow(ee),11)
  expect_gt(nrow(ff),8)

})

test_that("occ_count_ fails well", {
  
  expect_error(occ_count_pub_country(), 
    "Supply a iso2 countrycode.")           
  expect_error(occ_count_pub_country(1),
    "country must be of class character")
  expect_error(occ_count_country(1),
    "publishingCountry must be of class character")
  
})


