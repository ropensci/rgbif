context("dataset_doi")

test_that("dataset_doi work as expected", {
  vcr::use_cassette("dataset_doi",{
   xx <- dataset_doi("10.15468/igasai")    
  })
  expect_is(xx, "list")
  expect_length(xx, 2)
  expect_equal(names(xx), c("meta","data"))
  expect_is(xx$data, "tbl_df")
  expect_equal(xx$data$key, "8575f23e-f762-11e1-a439-00145eb45e9a")
  expect_is(xx$meta, "data.frame")
  })

test_that("dataset_doi fails well", {
  expect_warning(expect_error(dataset_doi("dog")))
  })

