context("read_wkt")

test_that("read_wkt", {
  wkt1 <- 'LINESTRING (30 10, 10 30, 40 40)'
  wkt2 <- "POLYGON((38.4 -125,40.9 -125,40.9 -121.8,38.4 -121.8,38.4 -125))"
  
  expect_is(read_wkt(wkt1), "list")
  expect_is(read_wkt(wkt2), "list")
  expect_is(read_wkt(wkt1)$type, "character")
  expect_is(read_wkt(wkt1)$type, "character")
  expect_is(read_wkt(wkt1)$coordinates, "matrix")
  expect_is(read_wkt(wkt2)$coordinates, "array")
  
  # returns the correct value
  expect_equal(read_wkt(wkt1)$type, "LineString")
  expect_equal(read_wkt(wkt2)$type, "Polygon")
  
  # errors well
  expect_error(read_wkt("LINESTRING (30 10, 10 30, 40 a)"), "Expecting 'DOUBLE_TOK', got 'INVALID'")
  expect_error(read_wkt("LINESTRING (30 10,  30, 40 40)"), "Expecting 'DOUBLE_TOK', got 'COMMA'")
  expect_error(read_wkt("LINESTRING (3010, 10 30, 40 40)"), "Expecting 'DOUBLE_TOK', got 'COMMA'")
  expect_error(read_wkt("LINESTRING ((30 10, 10 30, 40 40)"), "Expecting ')', got 'COMMA'")
  expect_error(read_wkt("linestring (30 10, 10 30, 40 40)"), "Expecting 'POINT'")
  expect_error(read_wkt("LINESTRING [30 10, 10 30, 40 40]"), "Expecting '\\('")
})
