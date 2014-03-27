context("name_suggest")

a <- name_suggest(q='Puma concolor')
b <- name_suggest(q='Puma')
c <- name_suggest(q='Puma', limit=2)
d <- name_suggest(q='Puma', fields=c('key','canonicalName'))

test_that("name_suggest returns the correct class", {
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(a$key, "numeric")
  expect_is(c$scientificName, "character")
  expect_is(d$canonicalName, "character")
})

test_that("name_suggest returns the correct dimensions", {
  expect_equal(dim(a), c(20,3))
  expect_equal(dim(b), c(20,3))
  expect_equal(dim(c), c(2,3))
  expect_equal(dim(d), c(20,2))
  expect_equal(names(d), c("key","canonicalName"))
})

test_that("name_suggest returns the correct value", {
  expect_equal(a$key[[1]], 2435099)
  expect_equal(as.character(b$scientificName[[1]]), "Puma Jardine, 1834")
  expect_equal(as.character(c$rank[[1]]), "GENUS")
})