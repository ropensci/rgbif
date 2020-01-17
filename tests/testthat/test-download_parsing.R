# not testing the actual HTTP request
context("occ_download parsing")

user <- "sckott"
email <- 'foo@bar.com'
type <- 'and'

test_that("occ_download input parsing", {
  aa <- parse_predicates(user, email, type, "DWCA", pred("taxonKey", 7228682))
  expect_is(aa, "list")
  expect_named(aa, c("creator", "notification_address", "format", "predicate"))
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_equal(aa$predicate$type[1], "and")
  expect_equal(unclass(aa$predicate$predicates[[1]]$type), "equals")
  expect_equal(unclass(aa$predicate$predicates[[1]]$key), "TAXON_KEY")
  expect_equal(unclass(aa$predicate$predicates[[1]]$value), "7228682")

  bb <- parse_predicates(user, email, type, "DWCA", pred("hasCoordinate", TRUE))
  expect_is(bb, "list")
  expect_is(bb$predicate$type, "character")
  expect_is(bb$predicate$type, "scalar")
  expect_equal(unclass(bb$predicate$type[1]), "and")
  expect_equal(unclass(bb$predicate$predicates[[1]]$type), "equals")
  expect_equal(unclass(bb$predicate$predicates[[1]]$key), "HAS_COORDINATE")
  expect_equal(unclass(bb$predicate$predicates[[1]]$value), "true")

  cc <- parse_predicates(user, email, type, "DWCA",
    pred_within("POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))"))
  expect_is(cc, "list")
  expect_is(cc$predicate$type, "character")
  expect_is(cc$predicate$type, "scalar")
  expect_equal(unclass(cc$predicate$predicates[[1]]$type[1]), "within")
  expect_null(cc$predicate$predicates[[1]]$key)
  expect_null(cc$predicate$predicates[[1]]$value)
  expect_equal(unclass(cc$predicate$predicates[[1]]$geometry),
    "POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))")

  aa <- parse_predicates(user, email, type, "DWCA",
    pred('taxonKey', 7228682),
    pred('hasCoordinate', TRUE),
    pred('hasGeospatialIssue', FALSE),
    pred_within('POLYGON((30.1 10.1,40 40,20 40,10 20,30.1 10.1))')
  )
  expect_is(aa, "list")
  expect_named(aa, c("creator", "notification_address", "format", "predicate"))
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_named(aa$predicate, c("type", "predicates"))
  expect_is(aa$predicate$predicates, "list")
  expect_equal(aa$predicate$predicates[[1]]$type[1], "equals")
  expect_is(aa$predicate$predicates[[4]]$geometry[1], "character")

  # format=SIMPLE_CSV
  aa <- parse_predicates(user, email, type, "SIMPLE_CSV",
    pred_gte('decimalLatitude', 82))
  expect_is(aa, "list")
  expect_named(aa, c("creator", "notification_address", "format", "predicate"))
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_equal(aa$predicate$type[1], "and")
  expect_equal(aa$predicate$predicates[[1]]$type[1], "greaterThanOrEquals")
  expect_equal(aa$predicate$predicates[[1]]$key[1], "DECIMAL_LATITUDE")
  expect_equal(aa$predicate$predicates[[1]]$value[1], "82")
  expect_equal(unclass(aa$format), "SIMPLE_CSV")

  # format=SPECIES_LIST
  aa <- parse_predicates(user, email, "not", "SPECIES_LIST",
    pred_lt('decimalLatitude', 2000))
  expect_is(aa, "list")
  expect_named(aa, c("creator", "notification_address", "format", "predicate"))
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_equal(aa$predicate$predicates[[1]]$type[1], "lessThan")
  expect_equal(aa$predicate$predicates[[1]]$key[1], "DECIMAL_LATITUDE")
  expect_equal(aa$predicate$predicates[[1]]$value[1], "2000")
  expect_equal(unclass(aa$format), "SPECIES_LIST")
})

test_that("parse_predicates fails well", {
  expect_error(
    parse_predicates(user, email, type, "DWCA", 'hasCoordinate = TRUE'),
    "all inputs must be"
  )
})
