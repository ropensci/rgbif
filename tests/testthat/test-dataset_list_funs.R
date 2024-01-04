context("dataset_list_funs")

test_that("dataset_list_funs work as expected.", {
  vcr::use_cassette("dataset_list_funs", {
  # d <- dataset_duplicate() # not currently working
  e <- dataset_noendpoint(limit=3)
  })
  
  expect_is(e,"list")
  expect_named(e,c("meta","data"))
  expect_is(e$data$key,"character")
  expect_lte(nrow(e$data), 3)
  
})
