context("dataset_suggest")

test_that("type query returns the correct class", {
  skip_on_cran()
  tt <- dataset_suggest(query="Amazon", type="OCCURRENCE")
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "character")
})


# Fulltext search for all datasets having the word "amsterdam" somewhere in
# its metadata (title, description, etc).
test_that("search query returns the correct class", {
  skip_on_cran()
  tt <- dataset_suggest(query="amsterdam")
  expect_is(tt, "data.frame")
  expect_is(tt$title, "character")
  expect_is(tt$title[[1]], "character")
})

# Limited search
test_that("limited search returns the correct class", {
  skip_on_cran()
  tt <- dataset_suggest(type="OCCURRENCE", limit=2)
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "character")
})

# Return just descriptions
test_that("limited fields query returns the correct class", {
  skip_on_cran()
  tt <- dataset_suggest(type="OCCURRENCE", description=TRUE)
  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
})
