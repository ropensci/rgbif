context("name_lookup")

tt <- name_lookup(query='mammalia')
uu <- name_lookup(query='Cnaemidophorus', rank="genus", return="data")

test_that("returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data$canonicalName, "character")
  expect_is(tt$data$classKey, "numeric")
  
  expect_is(uu, "data.frame")
})

test_that("returns the correct value", {
  expect_equal(as.character(tt$data$kingdom[[2]]), "Animalia")
})

test_that("returns the correct dimensions", {
  expect_equal(nrow(tt$data), 20)
  
  expect_equal(dim(uu), c(20,20))
})