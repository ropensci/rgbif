context("parsenames")

tt <- parsenames(scientificname='x Agropogon littoralis')
uu <- parsenames(c('Arrhenatherum elatius var. elatius',
                   'Secale cereale subsp. cereale', 'Secale cereale ssp. cereale',
                   'Vanessa atalanta (Linnaeus, 1758)')) 

test_that("returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(uu, "data.frame")
  expect_is(uu$scientificName, "factor")
  expect_is(uu$bracketYear, "factor")
})

test_that("returns the correct value", {
  expect_equal(as.character(tt$scientificName[[1]]), "x Agropogon littoralis")
  expect_equal(as.character(uu$specificEpithet[[1]]), "elatius")
})

test_that("returns the correct dimensions", {
  expect_equal(dim(tt), c(1,9))
  expect_equal(dim(uu), c(4,12))
})