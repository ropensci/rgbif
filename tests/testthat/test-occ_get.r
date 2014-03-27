context("occ_get")

tt <- occ_get(key=766766824, return='data')
uu <- occ_get(key=766766824, 'hier')
vv <- occ_get(key=766766824, 'all')

test_that("returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "character")
  expect_is(tt[1,2], "numeric")
  
  expect_is(uu, "data.frame")
  expect_is(uu[1,1], "character")
  expect_is(uu[1,2], "numeric")
  
  expect_is(vv, "list")
  expect_is(vv[[1]], "data.frame")
  expect_is(vv[[2]], "data.frame")
})

test_that("returns the correct dimensions", {
  expect_equal(dim(tt), c(1,4))
  expect_equal(dim(uu), c(7,3))
  expect_equal(dim(vv), NULL)
  expect_equal(dim(vv[[1]]), c(7,3))
  expect_equal(dim(vv[[2]]), c(1,4))
})