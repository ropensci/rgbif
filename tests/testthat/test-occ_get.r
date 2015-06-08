context("occ_get")

test_that("returns the correct class", {
  skip_on_cran()
  
  tt <- occ_get(key=766766824, return='data')
  uu <- occ_get(key=766766824, 'hier')
  vv <- occ_get(key=766766824, 'all')
  
  aa <- occ_get(key=766766824, verbatim = TRUE)
  bb <- occ_get(key=766766824, verbatim = TRUE, fields = "all")
  cc <- occ_get(key=c(766766824,620594291,766420684), 
                fields=c('scientificName','decimalLatitude','basisOfRecord'), verbatim=TRUE)
  
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "character")
  expect_is(tt[1,2], "integer")
  
  expect_is(uu, "data.frame")
  expect_is(uu[1,1], "character")
  expect_is(uu[1,2], "integer")
  
  expect_is(vv, "list")
  expect_is(vv[[1]], "data.frame")
  expect_is(vv[[2]], "list")
  
  expect_is(aa, "data.frame")
  expect_is(aa[1,1], "character")
  expect_is(aa[1,2], "integer")
  
  expect_is(bb, "data.frame")
  expect_is(bb[1,10], "character")
  expect_is(bb[1,2], "character")

  # returns the correct dimensions
  expect_equal(dim(tt), c(1,5))
  expect_equal(dim(uu), c(7,3))
  expect_equal(dim(vv), NULL)
  expect_equal(dim(vv[[1]]), c(7,3))
  expect_equal(length(vv[[2]]), 0)
  
  expect_equal(dim(aa), c(1,4))
  expect_equal(dim(cc), c(3,3))
})

test_that("name_usage fails correctly", {
  skip_on_cran()
  expect_error(occ_get(key=766766824, config=timeout(0.001)))
})
