context("stylegeojson")

library("plyr")
splist <- c('Accipiter erythronemius', 'Junco hyemalis', 'Aix sponsa')
keys <- sapply(splist, function(x) name_suggest(x)$key[1], USE.NAMES=FALSE)
dat <- occ_search(keys, hasCoordinate = TRUE, limit = 50)
dat <- ldply(dat, "[[", "data")
dat2 <- stylegeojson(input=dat, var=".id", color=c("#976AAE","#6B944D","#BD5945"), size=c("small","medium","large"))

test_that("returns the correct class", {
  expect_is(dat, "data.frame")
  expect_is(dat2, "data.frame")
})

test_that("returns the correct value", {
  expect_equal(names(dat2)[1], ".id")
})