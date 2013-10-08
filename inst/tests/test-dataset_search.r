context("dataset_search")

tt <- dataset_search(type="OCCURRENCE")
test_that("type query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})
test_that("type query returns the correct value", {
  expect_equal(as.character(tt[1,1]), "WAHerb")
})

# Gets all datasets tagged with keyword "france".
tt <- dataset_search(keyword="france")
test_that("keyword query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})
test_that("keyword query returns the correct value", {
  expect_equal(as.character(tt[2,1]), "Carnet en Ligne")
  expect_equal(as.character(tt[1,4]), "OCCURRENCE")
})
 
# Gets all datasets owned by the organization with key 
# "07f617d0-c688-11d8-bf62-b8a03c50a862" (UK NBN).
tt <- dataset_search(owningOrg="07f617d0-c688-11d8-bf62-b8a03c50a862")
test_that("owningOrg query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})

# Fulltext search for all datasets having the word "amsterdam" somewhere in 
# its metadata (title, description, etc).
tt <- dataset_search(query="amsterdam")
test_that("search query returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})

# Limited search
tt <- dataset_search(type="OCCURRENCE", limit=2)
test_that("limited search returns the correct class", {
  expect_is(tt, "data.frame")
  expect_is(tt[1,1], "factor")
})
test_that("limited search returns the correct value", {
  expect_equal(as.character(tt[1,"owningOrganization"]), "Western Australian Herbarium")
})
test_that("limited search returns the correct dims", {
  expect_equal(dim(tt), c(2,8))
})
 
# Return just descriptions
tt <- dataset_search(type="OCCURRENCE", description=TRUE)
test_that("limited fields query returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt[[1]], "character")
})
test_that("limited fields query returns the correct value", {
  expect_equal(tt$`Vermes ZMK`, "Vermes")
})