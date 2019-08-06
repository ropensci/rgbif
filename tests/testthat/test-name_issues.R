context("name_issues")

test_that("name_issues", {
  vcr::use_cassette("name_issues", {

    out <- name_usage(name = "Lupus")

    # Parsing output by issue
    aa <- out %>% name_issues(clasna)

    ### remove data rows with certain issue classes
    bb <- out %>% name_issues(-bbmn, -clasna)

    ### split issues into separate columns
    cc <- out %>% name_issues(mutate = "split")
    dd <- out %>% name_issues(-scina, -clasna, mutate = "split")
    ee <- out %>% name_issues(bbmn, mutate = "split")

    ### expand issues to more descriptive names
    ff <- out %>% name_issues(mutate = "expand")

    ### split and expand
    gg <- out %>% name_issues(mutate = "split_expand")
  }, preserve_exact_body_bytes = TRUE)

  # correct class
  expect_is(aa, "gbif")
  expect_is(bb, "gbif")
  expect_is(cc, "gbif")
  expect_is(dd, "gbif")
  expect_is(ee, "gbif")
  expect_is(ff, "gbif")
  expect_is(gg, "gbif")

  # returns the correct dimensions
  expect_true(all(vapply(aa$data$issues, function(x) grepl("clasna", x),
                         logical(1))))
  expect_true(all(vapply(bb$data$issues, function(x) !grepl("clasna", x),
                         logical(1))))
  expect_true(all(vapply(bb$data$issues, function(x) !grepl("bbmn", x),
                         logical(1))))
  expect_false(any(grepl("issues", names(cc$data))))
  expect_true(any(grepl("bbmn", names(cc$data))))
  expect_false(any(grepl("issues", names(dd$data))))
  expect_false(any(grepl("scina", names(dd$data))))
  expect_false(any(grepl("issues", names(ee$data))))
  expect_true(any(grepl("bbmn", names(ee$data))))
  expect_true(any(grepl("issues", names(ff$data))))
  expect_true(any(vapply(ff$data$issues,
                         function(x) grepl("BACKBONE_MATCH_NONE", x),
                         logical(1))))
  expect_false(any(grepl("issues", names(gg$data))))
  expect_true(any(grepl("CLASSIFICATION_NOT_APPLIED", names(gg$data))))

})
