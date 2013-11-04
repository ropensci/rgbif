context("occ_get")

tt <- occ_get(key=773433533, return='data')
uu <- occ_get(key=773433533, 'hier')
vv <- occ_get(key=773433533, 'all')

test_that("returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
  expect_is(tt[1,2], "numeric")
  
  expect_is(uu, "data.frame")
  expect_is(uu[1,1], "factor")
  expect_is(uu[1,2], "numeric")
  
  expect_is(vv, "list")
  expect_is(vv[[1]], "data.frame")
  expect_is(vv[[2]], "data.frame")
})

test_that("returns the correct value", {
  expect_equal(as.character(tt$name), "Helianthus annuus L.")
  expect_equal(as.character(uu[1,'name']), "Plantae")
  expect_equal(vv[[1]][1,'key'], 6)
  expect_equal(as.character(vv[[2]]$name), "Helianthus annuus L.")
})

test_that("returns the correct dimensions", {
  expect_equal(dim(tt), c(1,4))
  expect_equal(dim(uu), c(7,3))
  expect_equal(dim(vv), NULL)
  expect_equal(dim(vv[[1]]), c(7,3))
  expect_equal(dim(vv[[2]]), c(1,4))
})