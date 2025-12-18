context("check_wkt")

test_that("regular wkt works", {
  aa <- check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
  bb <- check_wkt('POINT(30.1 10.1)')
  cc <- check_wkt('LINESTRING(3 4,10 50,20 25)')
  mm <- check_wkt('MULTIPOLYGON (((-86.1328125 59.459488841393735, -56.953125 59.459488841393735, -27.7734375 59.459488841393735, -27.7734375 34.38154915808676, -27.7734375 9.303609474779796, -56.953125 9.303609474779796, -86.1328125 9.303609474779796, -86.1328125 34.38154915808676, -86.1328125 59.459488841393735)), ((78.3984375 54.690225821818856, 56.42578125 45.86648167444278, 34.453125 37.04273752706671, 15.8203125 6.671845441515563, -2.8125 -23.699046644035587, 41.484375 -27.589246771779514, 85.78125 -31.47944689952344, 101.953125 -8.508652190421842, 118.125 14.462142518679757, 112.32421875 36.59973091797452, 106.5234375 58.737319317269275, 106.5234375 58.737319317269275, 106.5234375 58.737319317269275, 92.4609375 56.71377256954406, 78.3984375 54.690225821818856)))')
  
  expect_is(mm, "character")
  expect_equal(mm, 'MULTIPOLYGON (((-86.1328125 59.459488841393735, -56.953125 59.459488841393735, -27.7734375 59.459488841393735, -27.7734375 34.38154915808676, -27.7734375 9.303609474779796, -56.953125 9.303609474779796, -86.1328125 9.303609474779796, -86.1328125 34.38154915808676, -86.1328125 59.459488841393735)), ((78.3984375 54.690225821818856, 56.42578125 45.86648167444278, 34.453125 37.04273752706671, 15.8203125 6.671845441515563, -2.8125 -23.699046644035587, 41.484375 -27.589246771779514, 85.78125 -31.47944689952344, 101.953125 -8.508652190421842, 118.125 14.462142518679757, 112.32421875 36.59973091797452, 106.5234375 58.737319317269275, 106.5234375 58.737319317269275, 106.5234375 58.737319317269275, 92.4609375 56.71377256954406, 78.3984375 54.690225821818856)))')

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
  # Non-numeric coordinates
  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 a))'),
    "non_numeric_coordinates; odd_number_of_coordinates"
  )
  
  # Unbalanced parentheses - missing closing
  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1)'),
    "unbalanced_parentheses"
  )
  
  # Unbalanced parentheses - extra closing
  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1)))'),
    "unbalanced_parentheses"
  )
  
  # Odd number of coordinates
  expect_error(
    check_wkt('LINESTRING(10 20, 30 40, 50)'),
    "odd_number_of_coordinates"
  )
  
  # Empty coordinate list
  expect_error(
    check_wkt('POLYGON(())'),
    "empty_coordinate_list"
  )
  
  # Double comma
  expect_error(
    check_wkt('LINESTRING(10 20,, 30 40)'),
    "double_comma"
  )
  
  # Dangling comma
  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10 20, 20 60,))'),
    "dangling_comma"
  )
  
  # Invalid geometry type
  expect_error(
    check_wkt('INVALIDTYPE((30.1 10.1))'),
    "WKT must be one of the types"
  )

  # Multiple issues - non-numeric and unbalanced
  expect_error(
    check_wkt('POLYGON((30.1 10.1, abc def, 20 60)'),
    "unbalanced_parentheses; non_numeric_coordinates"
  )
  
  # Point with multiple coordinates (should be single coordinate pair)
  expect_error(
    check_wkt('POINT(30.1 10.1, 20 40, )'),
    "dangling_comma"
  )
  
  # Coordinates with letters mixed in
  expect_error(
    check_wkt('POLYGON((30.1 10.1, 10x 20, 20 60, 60 60, 30.1 10.1))'),
    "non_numeric_coordinates"
  )
  
})

