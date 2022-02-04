context("name_backbone")

test_that("name_backbone returns the correct class", {
  vcr::use_cassette("name_backbone", {
    tt <- name_backbone(name = 'Helianthus annuus', rank = 'species')
    uu <- name_backbone_verbose(name = 'Helianthus annuus', rank = 'species')
  })

  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
  expect_true(all(tt$verbatim_name == "Helianthus annuus"))
  expect_true(rev(names(tt))[1] =="verbatim_rank")
  expect_equal(tt$verbatim_name[1], "Helianthus annuus")
  expect_equal(tt$verbatim_rank[1], "species")
  expect_gte(nrow(tt),1)
  expect_is(uu, "list")
  expect_is(uu$data, "tbl")
  expect_is(uu$data, "tbl_df")
  expect_is(uu$data, "data.frame")
  expect_is(uu$alternatives, "tbl")
  expect_is(uu$alternatives, "tbl_df")
  expect_is(uu$alternatives, "data.frame")
  expect_is(uu$alternatives$phylumKey, "integer")
  expect_is(uu$alternatives$canonicalName, "character")
})

test_that("Throws error because a name is required in the function call", {
  skip_on_cran()
  expect_error(name_backbone(kingdom = 'plants'), "argument \"name\" is missing")
})

test_that("name_backbone verbose=TRUE", {
  vcr::use_cassette("name_backbone_verbose_true", {
    tt <- name_backbone(name = "Calopteryx", rank = 'species')
    vv <- name_backbone(name = "Calopteryx", rank = 'species',verbose=TRUE)
  })
  expect_is(vv, "tbl")
  expect_is(vv, "tbl_df")
  expect_is(vv, "data.frame")
  expect_equal(vv$verbatim_name[1], "Calopteryx")
  expect_equal(vv$verbatim_rank[1], "species")
  expect_true(all(vv$verbatim_name == "Calopteryx"))
  expect_true(rev(names(vv))[1] =="verbatim_rank")
  expect_true(nrow(vv) > nrow(tt))
  expect_true(tt$status == "ACCEPTED")
  expect_true(all(vv$status %in% c("ACCEPTED","DOUBTFUL","SYNONYM")))
})
