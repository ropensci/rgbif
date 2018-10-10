context("networks")

test_that("returns the correct", {
  vcr::use_cassette("networks", {
    tt <- networks()
    expect_is(tt, "list")
    expect_is(tt$meta, "data.frame")
    expect_is(tt$meta$limit, "integer")
    expect_is(tt$meta$endOfRecords, "logical")
    expect_is(tt$data, "data.frame")
  })
})
