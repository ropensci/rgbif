context("dataset_suggest")

tt <- dataset_suggest(query="Amazon", type="OCCURRENCE")
test_that("type query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})


# Fulltext search for all datasets having the word "amsterdam" somewhere in 
# its metadata (title, description, etc).
tt <- dataset_suggest(query="amsterdam")
test_that("search query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt$hostingOrganization, "factor")
  expect_is(tt$hostingOrganization[[1]], "factor")
})

# Limited search
tt <- dataset_suggest(type="OCCURRENCE", limit=2)
test_that("limited search returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})
test_that("limited search returns the correct dims", {
  expect_equal(dim(tt), c(2,8))
})

# Return just descriptions
tt <- dataset_suggest(type="OCCURRENCE", description=TRUE)
test_that("limited fields query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
})