context("organizations")

tt <- organizations()
uu <- organizations(uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")
vv <- organizations(data='contact', uuid="4b4b2111-ee51-45f5-bf5e-f535f4a1c9dc")

test_that("returns the correct class", {
  expect_is(tt, "list")
  expect_is(tt$limit, "numeric")
  expect_is(tt$endOfRecords, "logical")
  
  expect_is(uu, "list")
  expect_is(uu$country, "character")
  
  expect_is(vv, "list")
  expect_is(vv[[1]]$createdBy, "character")
})

test_that("returns the correct value", {
  expect_identical(tt$results[[1]]$tags, list())
  expect_equal(uu$endorsingNodeKey, "1f94b3ca-9345-4d65-afe2-4bace93aa0fe")
  expect_equal(vv[[1]]$key, 20006)
  expect_equal(vv[[1]]$modifiedBy, "registry-migration.gbif.org")
})

test_that("returns the correct dimensions", {
  expect_equal(length(tt), 5)
  expect_equal(length(tt$results), 20)
  expect_equal(length(uu), 23)
  expect_equal(length(vv), 3)
  expect_equal(length(vv[[1]]), 10)
})