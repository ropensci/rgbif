test_that("occ_download_prep", {
  skip_on_cran()

  z <- occ_download_prep(
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred("hasGeospatialIssue", FALSE),
    pred("year", 1993),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$url, "character")
  expect_is(z$user, "character")
  expect_equal(z$user, "foo")
  expect_is(z$pwd, "character")
  expect_equal(z$pwd, "bar")
  expect_is(z$email, "character")
  expect_equal(z$email, "foo@bar.com")
  expect_is(z$format, "character")
  expect_equal(z$format, "DWCA")
  expect_is(z$curlopts, "list")
  
  # request list
  expect_is(z$request, "list")
  expect_is(z$request$creator, "scalar")
  expect_equal(z$request$creator[1], "foo")
  expect_is(z$request$predicate, "list")
  expect_is(z$request$predicate$type, "scalar")
  expect_is(z$request$predicate$predicates, "list")
  expect_is(z$request$predicate$predicates[[1]], "list")
  expect_named(z$request$predicate$predicates[[1]],
    c("type", "key", "values"))
})

test_that("occ_download_prep print method", {
  skip_on_cran()

  wkt <- "POLYGON ((1.1956196 31.6685274, 1.3014544 24.6501195, 2.5809994 25.4794093, 7.7447434 28.8910764, 7.0164007 26.8049712, 6.3937614 24.6883661, 10.6658621 23.0559085, 8.2558841 23.0358775, 5.8351769 22.5865697, 10.4505920 20.2873468, 1.5327929 23.8831332, 8.1689468 19.2218276, 1.5273958 23.7558439, 2.5291622 22.5315021, 3.6335872 21.2935462, 3.5394433 21.3562142, 4.0220814 16.8647554, 2.2146242 18.4152832, 0.3259253 14.7660454, 0.5718516 21.6252550, -0.7310904 21.5560907, -0.4340908 22.3753377, -1.1388369 21.7340427, 0.2977394 23.4751048, 0.8964301 24.1903765, 0.5309763 24.4781934, -0.6874591 25.3129101, -0.008445779 25.546685347, -1.5111521 29.2516804, 0.6816945 26.9554070, 1.1956196 31.6685274))"
  
  z <- occ_download_prep(
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred_within(wkt),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  w <- capture.output(print(z))
  w <- w[length(w)]
  expect_true(nchar(w) < 150)
})

test_that("occ_download_prep long print", {
  skip_on_cran()
  
  long_taxonkey_list <- rep(22222222,200)
  
  pp <- occ_download_prep(
    pred_in("taxonKey", long_taxonkey_list),
    pred("hasCoordinate", TRUE),
    user = "foo", 
    pwd = "bar", 
    email = "foo@bar.com"
  )
  
  expect_output(print(pp),"OK. But too large to print.")
})

