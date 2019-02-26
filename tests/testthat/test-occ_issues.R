context("occ_issues")

test_that("occ_issues", {
  vcr::use_cassette("occ_issues", {
    out <- occ_search(limit = 100)

    # Parsing output by issue
    res <- occ_search(
      geometry = "POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))",
      limit = 50)

    bb <- res %>% occ_issues(gass84)

    ### remove data rows with certain issue classes
    cc <- res %>% occ_issues(-cudc, -cdreps)

    ### split issues into separate columns
    dd <- res %>% occ_issues(mutate = "split")
    ee <- res %>% occ_issues(-cudc, -mdatunl, -cdreps, mutate = "split")
    ff <- res %>% occ_issues(gass84, mutate = "split")

    ### expand issues to more descriptive names
    gg <- res %>% occ_issues(mutate = "expand")

    ### split and expand
    hh <- res %>% occ_issues(mutate = "split_expand")
  }, preserve_exact_body_bytes = TRUE)

  # correct class
  expect_is(bb, "gbif")
  expect_is(cc, "gbif")
  expect_is(dd, "gbif")
  expect_is(ee, "gbif")
  expect_is(ff, "gbif")
  expect_is(gg, "gbif")
  expect_is(hh, "gbif")

  # returns the correct dimensions
  expect_true(all(vapply(bb$data$issues, function(x)
    grepl("gass84", x), logical(1))))
  expect_true(all(vapply(cc$data$issues, function(x)
    grepl("gass84", x), logical(1))))
  expect_false(all(vapply(cc$data$issues, function(x)
    grepl("cudc", x), logical(1))))
  expect_false(any(grepl("issues", names(dd$data))))
  expect_true(any(grepl("gass84", names(dd$data))))
  expect_false(any(grepl("issues", names(ee$data))))
  expect_false(any(grepl("cdreps", names(ee$data))))
  expect_true(any(grepl("gass84", names(ff$data))))
  expect_false(any(grepl("issues", names(ff$data))))
  expect_false(any(grepl("issues", names(hh$data))))
  expect_true(any(grepl("COORDINATE_ROUNDED", names(hh$data))))
})

test_that("occ_issues: occ_data type=many", {
  vcr::use_cassette("occ_issues_type_many", {
    dat <- occ_data(taxonKey = c(2482598, 9362842, 2498387), limit = 30)
  })

  expect_is(dat, "gbif_data")
  expect_equal(attr(dat, "type"), "many")

  # remove issues
  expect_is(occ_issues(dat, -cdround), "gbif_data")

  # keep issues
  expect_is(occ_issues(dat, cdround), "gbif_data")

  # keep and mutate=expand
  expect_is(occ_issues(dat, cdround, mutate = "expand"), "gbif_data")

  # keep and mutate=split_expand
  expect_is(occ_issues(dat, cdround, mutate = "split_expand"),
    "gbif_data")

  # works when parsing internally results in some empty data.frames
  expect_is(occ_issues(dat, -gass84), "gbif_data")

  # internal parsing maintains data table association with original
  res <- occ_issues(dat, -cdround)
  expect_equal(names(dat)[1], as.character(unique(res[[1]]$data$taxonKey)))
  expect_equal(names(dat)[2], as.character(unique(res[[2]]$data$taxonKey)))
  expect_equal(names(dat)[3], as.character(unique(res[[3]]$data$taxonKey)))
})
