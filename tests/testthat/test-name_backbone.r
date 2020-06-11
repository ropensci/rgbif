context("name_backbone")

test_that("name_backbone returns the correct class", {
  vcr::use_cassette("name_backbone", {
    tt <- name_backbone(name = 'Helianthus annuus', rank = 'species')
    uu <- name_backbone_verbose(name = 'Helianthus annuus', rank = 'species')
  })

  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
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

test_that("name_backbone verbose parameter", {
  skip_on_cran()
  
  vcr::use_cassette("name_backbone_verbose_param_removed", {
    # the 1st time does throw a warning
    expect_warning((z = name_backbone(name = 'Helianthus', verbose = TRUE)),
      "`verbose` param in `name_backbone` function is defunct"
    )
    # the 2nd time does not throw any warnings
    expect_warning((z = name_backbone(name = 'Helianthus', verbose = TRUE)),
      NA
    )
  })
  # still returns data
  expect_is(z, "data.frame")
})
