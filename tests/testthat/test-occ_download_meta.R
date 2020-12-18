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
  expect_named(aa$request$predicate$predicates[[1]])

  # print
  res <- capture.output(aa)
  expect_true(all(vapply(res, nchar, 1) < 150))
})

test_that("occ_download_meta print method", {
  skip_on_cran()
  skip_on_ci()

  # ## Query:
  # occ_download(
  #   pred_and(
  #     pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
  #     pred_gte("elevation", 5400)))
  vcr::use_cassette("occ_download_meta_na_results", {
    aa <- occ_download_meta("0108986-200613084148143")
  })
  # re-recorded cassette for same request after results ready
  vcr::use_cassette("occ_download_meta_with_results", {
    bb <- occ_download_meta("0108986-200613084148143")
  })

  expect_is(aa, "occ_download_meta")
  expect_output(print(aa), "Total records: <NA>")

  expect_is(bb, "occ_download_meta")
  expect_output(print(bb), "Total records: 21")
})
