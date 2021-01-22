context("predicate builders: supported keys")
test_that("pred keys", {
  # allowed keys, i.e., anything in key_lkup
  for (i in seq_along(key_lkup))
    expect_is(pred(names(key_lkup)[i], 5), "occ_predicate")

  # not allowed keys, i.e., anything not in key_lkup
  keys_bad <- c("foo", "bar", "stuff")
  for (i in keys_bad) expect_error(pred(i, 5))
})

context("predicate builders: pred")
test_that("pred", {
  aa <- pred("taxonKey", 7228682)
  expect_is(aa, "occ_predicate")
  expect_is(unclass(aa), "list")
  expect_named(aa, c("type", "key", "value"))
  expect_is(aa$type, "character")
  expect_equal(unclass(aa$type), "equals")
  expect_equal(unclass(aa$key), "TAXON_KEY")
  expect_equal(unclass(aa$value), "7228682")

  bb <- pred_gt("elevation", 5000)
  expect_is(bb, "occ_predicate")
  expect_is(unclass(bb), "list")
  expect_named(bb, c("type", "key", "value"))
  expect_is(bb$type, "character")
  expect_equal(unclass(bb$type), "greaterThan")

  # establishmentMeans works
  bb <- pred("establishmentMeans", "NATIVE")
  expect_is(bb, "occ_predicate")
  expect_is(unclass(bb), "list")
  expect_named(bb, c("type", "key", "value"))
  expect_is(bb$type, "character")
  expect_equal(unclass(bb$type), "equals")

  # booleans are downcased
  cct <- pred("hasCoordinate", TRUE)
  ccf <- pred("hasCoordinate", FALSE)
  expect_equal(unclass(cct$value), "true")
  expect_equal(unclass(ccf$value), "false")
})
test_that("pred fails well", {
  expect_error(pred(), "argument \"key\" is missing")
  expect_error(pred(key = "taxonKey"), "argument \"value\" is missing")
  expect_error(pred("a", "b"), "'a' not in acceptable set")
  expect_error(pred(5, "b"), "key must be of class character")
  # expect_error(pred("a", 5), "type must be of class character")
  # should fail well when more than one thing passed to `value`
  expect_error(
    pred("basisOfRecord", c("HUMAN_OBSERVATION","OBSERVATION")),
    "'value' must be length 1"
  )
})

context("predicate builders: pred_and/pred_or")
test_that("pred_and/pred_or", {
  taxon_ids <- c(2977832, 2977901, 2977966, 2977835)
  
  # or
  aa <- pred_or(.list = lapply(taxon_ids, function(z) pred("taxonKey", z)))
  aa_sep <- pred_or(pred("taxonKey", 2977832), pred("taxonKey", 2977901),
    pred("taxonKey", 2977966), pred("taxonKey", 2977835))
  expect_is(aa, "occ_predicate_list")
  expect_is(unclass(aa), "list")
  expect_named(aa, NULL)
  expect_named(aa[[1]], c("type", "key", "value"))
  expect_equal(unclass(aa[[1]]$type), "equals")
  expect_equal(unclass(aa[[1]]$key), "TAXON_KEY")
  expect_equal(unclass(aa[[1]]$value), "2977832")
  # pred_or outputs equivalent, using ... or .list
  expect_identical(aa, aa_sep)

  # and
  aa <- pred_and(.list = lapply(taxon_ids, function(z) pred("taxonKey", z)))
  aa_sep <- pred_and(pred("taxonKey", 2977832), pred("taxonKey", 2977901),
    pred("taxonKey", 2977966), pred("taxonKey", 2977835))
  expect_is(aa, "occ_predicate_list")
  expect_is(unclass(aa), "list")
  expect_named(aa, NULL)
  expect_named(aa[[1]], c("type", "key", "value"))
  expect_equal(unclass(aa[[1]]$type), "equals")
  expect_equal(unclass(aa[[1]]$key), "TAXON_KEY")
  expect_equal(unclass(aa[[1]]$value), "2977832")
  # pred_and outputs equivalent, using ... or .list
  expect_identical(aa, aa_sep)
})
test_that("pred_and/pred_or fails well", {
  expect_error(pred_or(), "nothing passed")
  expect_error(pred_and(), "nothing passed")
  expect_error(pred_and(pred("taxonKey", 2977832)), "must pass more than 1")
  expect_error(pred_or(4, 5), "not of class 'occ_predicate'")
  expect_error(pred_and(4, 5), "not of class 'occ_predicate'")
})

context("predicate builders: pred_not")
test_that("pred_not", {
  z <- pred("taxonKey", 1)
  aa <- pred_not(z)
  expect_is(aa, "occ_predicate_list")
  expect_is(unclass(aa), "list")
  expect_named(aa, NULL)
  expect_named(aa[[1]], c("type", "key", "value"))
  expect_equal(unclass(aa[[1]]$type), "equals")
  expect_equal(unclass(aa[[1]]$key), "TAXON_KEY")
  expect_equal(unclass(aa[[1]]$value), "1")
  expect_equal(attr(aa, "type"), jsonlite::unbox("not"))
})
test_that("pred_not fails well", {
  z <- pred("taxonKey", 1)
  expect_error(pred_not(), "Supply one")
  expect_error(pred_not(z, z), "Supply one")
  expect_error(pred_not(4), "not of class 'occ_predicate'")
})

context("predicate builders: pred_in")
test_that("pred_in", {
  taxon_ids <- c(2977832, 2977901, 2977966, 2977835)
  
  aa <- pred_in("taxonKey", taxon_ids)
  expect_is(aa, "occ_predicate")
  expect_is(unclass(aa), "list")
  expect_named(aa, c("type", "key", "values"))
  expect_equal(unclass(aa$type), "in")
  expect_equal(unclass(aa$key), "TAXON_KEY")
  expect_is(unclass(aa$values), "character")
  expect_equal(length(aa$values), 4)
})
test_that("pred_in fails well", {
  expect_error(pred_in(), "argument \"key\" is missing")
  expect_error(pred_in(key = "taxonKey"), "argument \"value\" is missing")
  expect_error(pred_in("a", "b"), "'a' not in acceptable set")
  expect_error(pred_in(5, "b"), "key must be of class character")
})

context("predicate builders: pred_within")
test_that("pred_within", {
  wkt <- randgeo::wkt_polygon(num_vertices = 30)
  
  aa <- pred_within(wkt)
  expect_is(aa, "occ_predicate")
  expect_is(unclass(aa), "list")
  expect_named(aa, c("type", "geometry"))
  expect_equal(unclass(aa$type), "within")
  expect_is(unclass(aa$geometry), "character")
  expect_equal(length(aa$geometry), 1)
  z <- capture.output(print(aa))[2]
  expect_true(nchar(z) < 130)
})
test_that("pred_within fails well", {
  expect_error(pred_within(), "argument \"value\" is missing")
  expect_error(pred_within(NULL), "'value' must be length 1")
})

