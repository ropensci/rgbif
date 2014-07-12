context("dataset_suggest")

tt <- dataset_suggest(query="Amazon", type="OCCURRENCE")
test_that("type query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "character")
})


# Fulltext search for all datasets having the word "amsterdam" somewhere in 
# its metadata (title, description, etc).
tt <- dataset_suggest(query="amsterdam")
test_that("search query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt$title, "character")
  expect_is(tt$title[[1]], "character")
})

# Limited search
tt <- dataset_suggest(type="OCCURRENCE", limit=2)
test_that("limited search returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "character")
})

# Return just descriptions
tt <- dataset_suggest(type="OCCURRENCE", description=TRUE)
test_that("limited fields query returns the correct class", {
  expect_is(tt, "character")
  expect_is(tt[[1]], "character")
})