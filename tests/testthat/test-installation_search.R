
test_that("installation_search works as expected", {
  vcr::use_cassette("installation_search", {
  i <- installation_search(limit=1) 
  q <- installation_search(query="Estonia", limit=2)
  t <- installation_search(type="IPT_INSTALLATION",limit=2)
  m <- installation_search(modified="2023-04-01,*",limit=2)
  })
  
  expect_type(i, "list")
  expect_is(i$meta, "data.frame")
  expect_is(i$data, "tbl_df")
  expect_gt(nrow(i$data), 0)
  expect_gte(ncol(i$data),10)
  expect_gte(i$meta$count, 600)
  
  expect_type(q, "list")
  expect_is(q$meta, "data.frame")
  expect_is(q$data, "tbl_df")
  expect_gt(nrow(q$data), 0)
  expect_gte(ncol(q$data),10)
  
  expect_type(t, "list")
  expect_is(t$meta, "data.frame")
  expect_is(t$data, "tbl_df")
  expect_gt(nrow(t$data), 0)
  expect_gte(ncol(t$data),10)
  
  expect_type(m, "list")
  expect_is(m$meta, "data.frame")
  expect_is(m$data, "tbl_df")
  expect_gt(nrow(m$data), 0)
  expect_gte(ncol(m$data),10)
  
  })


test_that("installation_search fails well", {
  skip_on_cran()
  skip_on_ci()
  
  expect_error(installation_search(query=1),
               "query must be of class character")
  expect_error(installation_search(type="not_a_type"))
  
  expect_error(installation_search(identifierType="UUID"))
  
})



