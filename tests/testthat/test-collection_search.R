
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


test_that("collection_export works as expected", {
  skip_on_cran()
  skip_on_ci()
  
  q <- collection_export(query = "insect")
  i <- collection_export(name="Insects;Entomology")
  s <- collection_export(numberSpecimens = "0,100")
  c <- collection_export(query = "insect", country = "US;GB")
  
  expect_is(q, "tbl_df")
  expect_gte(nrow(q), 400)
  expect_gte(ncol(q), 30)
  expect_true("key" %in% names(q))
  
  expect_is(i, "tbl_df")
  expect_gte(nrow(i), 100)
  expect_gte(ncol(i), 30)
  expect_true("key" %in% names(i))
  
  expect_is(s, "tbl_df")
  expect_gte(nrow(s), 1000)
  expect_gte(ncol(s), 30)
  expect_true("key" %in% names(s))
  
  expect_is(c, "tbl_df")
  expect_gte(nrow(c), 100)
  expect_gte(ncol(c), 30)
  expect_true("key" %in% names(c))
  
})

