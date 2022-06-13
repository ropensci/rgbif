
context("network")

test_that("returns the correct", {
  vcr::use_cassette("network", {
    tt <- network()
  })
  expect_is(tt, "list")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$meta$limit, "integer")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data, "data.frame")
})

test_that("network_constituents", {
  vcr::use_cassette("network_constituents", {
    cc <- network_constituents("4b0d8edb-7504-42c4-9349-63e86c01bf97")
  }, preserve_exact_body_bytes = TRUE)
  expect_is(cc, "data.frame")
  expect_is(cc$datasetKey, "character")
})


