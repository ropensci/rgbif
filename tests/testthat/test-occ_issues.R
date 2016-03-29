context("occ_issues")

test_that("occ_issues", {
  skip_on_cran()

  out <- occ_search(limit = 100)
  aa <- out %>% occ_issues(cudc)

  # Parsing output by issue
  res <- occ_search(geometry = 'POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))', limit = 50)

  bb <- res %>% occ_issues(gass84)

  ### remove data rows with certain issue classes
  cc <- res %>% occ_issues(-cdround, -cudc)

  ### split issues into separate columns
  dd <- res %>% occ_issues(mutate = "split")
  ee <- res %>% occ_issues(-cudc, -mdatunl, mutate = "split")
  ff <- res %>% occ_issues(gass84, mutate = "split")

  ### expand issues to more descriptive names
  gg <- res %>% occ_issues(mutate = "expand")

  ### split and expand
  hh <- res %>% occ_issues(mutate = "split_expand")

  # correct class
  expect_is(aa, "gbif")
  expect_is(bb, "gbif")
  expect_is(cc, "gbif")
  expect_is(dd, "gbif")
  expect_is(ee, "gbif")
  expect_is(ff, "gbif")
  expect_is(gg, "gbif")
  expect_is(hh, "gbif")

  # returns the correct dimensions
  expect_true(all(vapply(aa$data$issues, function(x) grepl("cudc", x), logical(1))))
  expect_true(all(vapply(bb$data$issues, function(x) grepl("gass84", x), logical(1))))
  expect_false(all(vapply(cc$data$issues, function(x) grepl("cudc", x), logical(1))))
  expect_false(all(vapply(cc$data$issues, function(x) grepl("cdround", x), logical(1))))
  expect_false(any(grepl("issues", names(dd$data))))
  expect_true(any(grepl("gass84", names(dd$data))))
  expect_false(any(grepl("issues", names(ee$data))))
  expect_true(any(grepl("cdreps", names(ee$data))))
  expect_true(any(grepl("gass84", names(ff$data))))
  expect_false(any(grepl("issues", names(ff$data))))
  expect_false(any(grepl("issues", names(hh$data))))
  expect_true(any(grepl("COORDINATE_ROUNDED", names(hh$data))))
})
