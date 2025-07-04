
test_that("collection_search works as expected", {
  vcr::use_cassette("collection_search",{
  q <- collection_search(query="insect",limit=2)
  n <- collection_search(name="Insects;Entomology", limit=2)
  s <- collection_search(numberSpecimens = "0,100", limit=1)
  i <- collection_search(institutionKey = "6a6ac6c5-1b8a-48db-91a2-f8661274ff80"
                         , limit = 1)
  c <- collection_search(query = "insect", country = "US;GB", limit=1)
  })
  
  expect_is(q, "list")
  expect_is(q$data, "tbl_df")
  expect_is(q$meta, "data.frame")
  expect_true(nrow(q$data) > 0)
  expect_gte(q$meta$count, 400)
  expect_gte(ncol(q$data), 30) 
  
  expect_is(n, "list")
  expect_is(n$data, "tbl_df")
  expect_is(n$meta, "data.frame")
  expect_true(nrow(n$data) > 0)
  expect_gte(n$meta$count, 100)
  expect_gte(ncol(n$data), 30)

  expect_is(s, "list")
  expect_is(s$data, "tbl_df")
  expect_is(s$meta, "data.frame")
  expect_true(nrow(s$data) > 0)
  expect_gte(s$meta$count, 1000)
  expect_gte(ncol(s$data), 30)
  
  expect_is(i, "list")
  expect_is(i$data, "tbl_df")
  expect_is(i$meta, "data.frame")
  expect_true(nrow(i$data) > 0)
  expect_gte(i$meta$count, 20)
  expect_gte(ncol(i$data), 30)
  
  expect_is(c, "list")
  expect_is(c$data, "tbl_df")
  expect_is(c$meta, "data.frame")
  expect_true(nrow(c$data) > 0)
  expect_gte(c$meta$count, 100)
  expect_gte(ncol(c$data), 30)
  
})
