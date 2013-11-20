context("stylegeojson")

splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
out <- occurrencelist_many(splist, coordinatestatus = TRUE, maxresults = 50)
dat <- gbifdata(out)
names(dat)[names(dat) %in% c("decimalLatitude","decimalLongitude")] <- c("latitude","longitude")
dat2 <- stylegeojson(input=dat, var="taxonName", color=c("#976AAE","#6B944D","#BD5945"), size=c("small","medium","large"))

test_that("returns the correct class", {
  expect_is(dat, "data.frame")
  expect_is(dat2, "data.frame")
})

test_that("returns the correct value", {
  expect_equal(names(dat2)[1], "taxonName")
})

test_that("returns the correct dimensions", {
  expect_equal(dim(dat2), c(110,10))
})