context("name_suggest")

test_that("name_suggest returns the correct", {
  skip_on_cran()

  a <- name_suggest(q='Puma concolor')
  b <- name_suggest(q='Puma')
  c <- name_suggest(q='Puma', limit=2)
  d <- name_suggest(q='Puma', fields=c('key','canonicalName'))

  # class
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(a$key, "integer")
  expect_is(c$canonicalName, "character")
  expect_is(d$canonicalName, "character")

  # name_suggest returns the correct dimensions
  expect_equal(dim(a), c(100,3))
  expect_equal(dim(b), c(100,3))
  expect_equal(dim(c), c(2,3))
  expect_equal(dim(d), c(100,2))
  expect_equal(names(d), c("key","canonicalName"))

  # value
  expect_equal(as.character(b$canonicalName[[1]]), "Puma")
  expect_equal(as.character(c$rank[[1]]), "GENUS")
})
