context("check_wkt")

test_that("regular wkt works", {
  aa <- check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
  bb <- check_wkt('POINT(30.1 10.1)')
  cc <- check_wkt('LINESTRING(3 4,10 50,20 25)')

  expect_is(aa, "character")
  expect_equal(aa, 'POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')

  expect_is(bb, "character")
  expect_equal(bb, 'POINT(30.1 10.1)')

  expect_is(cc, "character")
  expect_equal(cc, 'LINESTRING(3 4,10 50,20 25)')
})


test_that("check many passed in at once", {
  aa <- check_wkt(c('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))',
                    'POINT(30.1 10.1)'))

  expect_is(aa, "character")
  expect_equal(length(aa), 2)
})


test_that("many wkt's, semi-colon separated, for many repeated geometry args", {
  wkt <- "POLYGON((-102.2 46.0,-93.9 46.0,-93.9 43.7,-102.2 43.7,-102.2 46.0));POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))"
  aa <- check_wkt(wkt)

  expect_is(wkt, "character")
  expect_is(aa, "character")
  expect_equal(length(wkt), 1)
  expect_equal(length(aa), 2)
  expect_true(grepl(";", wkt))
  expect_false(any(grepl(";", aa)))
})



test_that("bad WKT fails well", {
  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 a))'),
    "bad lexical cast: source type value could not be"
  )

  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 a))'),
    "bad lexical cast: source type value could not be"
  )
})

