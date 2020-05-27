test_that("occ_download_meta", {
  skip_on_cran()

  vcr::use_cassette("occ_download_meta", {
    aa <- occ_download_meta("0068181-200221144449610")
  })

  expect_is(aa, "occ_download_meta")
  expect_is(aa$key, "character")
  expect_is(aa$doi, "character")
  expect_is(aa$license, "character")
  expect_is(aa$status, "character")
  expect_equal(aa$status, "CANCELLED")
  expect_is(aa$downloadLink, "character")
  expect_match(aa$downloadLink, "api.gbif.org")
  expect_is(aa$totalRecords, "integer")
  expect_is(aa$numberDatasets, "integer")

  # request part
  expect_is(aa$request, "list")
  expect_named(aa$request, c("predicate", "sendNotification", "format"))
  expect_false(aa$request$sendNotification)
  expect_equal(aa$request$format, "SIMPLE_CSV")
  expect_is(aa$request$predicate, "list")
  expect_is(aa$request$predicate$type, "character")
  expect_equal(aa$request$predicate$type, "and")
  expect_is(aa$request$predicate$predicates, "list")
  expect_is(aa$request$predicate$predicates[[1]], "list")
  expect_named(aa$request$predicate$predicates[[1]],
    c("type", "key", "value"))

  # print
  res <- capture.output(aa)
  expect_true(all(vapply(res, nchar, 1) < 150))
})
