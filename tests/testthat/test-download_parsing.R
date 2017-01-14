context("occ_download parsing")

user <- "sckott"
email <- 'foo@bar.com'
type <- 'and'

test_that("occ_download input parsing", {
  # not testing the actual HTTP request

  aa <- parse_occd(user, email, type, 'taxonKey = 7228682')
  expect_is(aa, "list")
  expect_named(aa, c("creator", "notification_address", "predicate"))
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_equal(aa$predicate$type[1], "equals")
  expect_equal(aa$predicate$key[1], "TAXON_KEY")
  expect_equal(aa$predicate$value[1], "7228682")

  aa <- parse_occd(user, email, type, 'hasCoordinate = TRUE')
  expect_is(aa, "list")
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_equal(aa$predicate$type[1], "equals")
  expect_equal(aa$predicate$key[1], "HAS_COORDINATE")
  expect_equal(aa$predicate$value[1], "TRUE")

  aa <- parse_occd(user, email, type, 'geometry = POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
  expect_is(aa, "list")
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_equal(aa$predicate$type[1], "equals")
  expect_equal(aa$predicate$key[1], "GEOMETRY")
  expect_equal(aa$predicate$value[1], "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))")

  aa <- parse_occd(user, email, type,
               'taxonKey = 7228682',
               'hasCoordinate = TRUE',
               'hasGeospatialIssue = FALSE',
               'geometry=POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))')
  expect_is(aa, "list")
  expect_named(aa, c("creator", "notification_address", "predicate"))
  expect_is(aa$predicate$type, "character")
  expect_is(aa$predicate$type, "scalar")
  expect_named(aa$predicate, c("type", "predicates"))
  expect_is(aa$predicate$predicates, "list")
  expect_equal(aa$predicate$predicates[[1]]$type[1], "equals")
  expect_equal(aa$predicate$predicates[[4]]$key[1], "GEOMETRY")
  expect_equal(aa$predicate$predicates[[3]]$value[1], "FALSE")
})
