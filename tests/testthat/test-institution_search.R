test_that("institution search works as expected", {
  vcr::use_cassette("institution_search", {
  q <- institution_search(query="Kansas",limit=1)
  s <- institution_search(numberSpecimens = "1000,*",limit=2)
  o <- institution_search(numberSpecimens = "1000,*", occurrenceCount = "10,*"
                          ,limit=2)
  e <- institution_search(source = "IH_IRN", limit=1)
  c <- institution_search(country = "US;GB", limit=1)
  t <- institution_search(typeSpecimenCount = "10,100",limit=1)
  })
  
  expect_is(q, "list")
  expect_is(q$data, "tbl_df")
  expect_is(q$meta, "data.frame")
  expect_true(nrow(q$data) > 0)
  expect_gte(q$meta$count, 10)
  expect_gte(ncol(q$data), 30) 
  
  expect_is(s, "list")
  expect_is(s$data, "tbl_df")
  expect_is(s$meta, "data.frame")
  expect_true(nrow(s$data) > 0)
  expect_gte(s$meta$count, 1000)
  expect_gte(ncol(s$data), 30)
  
  expect_is(o, "list")
  expect_is(o$data, "tbl_df")
  expect_is(o$meta, "data.frame")
  expect_true(nrow(o$data) > 0)
  expect_gte(o$meta$count, 1000)
  expect_gte(ncol(o$data), 30)
  
  expect_is(e, "list")
  expect_is(e$data, "tbl_df")
  expect_is(e$meta, "data.frame")
  expect_true(nrow(e$data) > 0)
  expect_gte(e$meta$count, 3000)
  expect_gte(ncol(e$data), 20)
  
  expect_is(c, "list")
  expect_is(c$data, "tbl_df")
  expect_is(c$meta, "data.frame")
  expect_true(nrow(c$data) > 0)
  expect_gte(c$meta$count, 2000)
  expect_gte(ncol(c$data), 30)
  
  expect_is(t, "list")
  expect_is(t$data, "tbl_df")
  expect_is(t$meta, "data.frame")
  expect_true(nrow(t$data) > 0)
  expect_gte(t$meta$count, 500)
  expect_gte(ncol(t$data), 30)
  
  })

test_that("institution_export works as expected", {
  skip_on_cran()
  skip_on_ci()
  
  q <- institution_export(query = "Kansas")
  s <- institution_export(numberSpecimens = "1000,*")
  o <- institution_export(numberSpecimens = "1000,*", occurrenceCount = "10,*")
  
  expect_is(q, "tbl_df")
  expect_gte(nrow(q), 10)
  expect_gte(ncol(q), 10)
  expect_true("key" %in% names(q))
  
  expect_is(s, "tbl_df")
  expect_gte(nrow(s), 1000)
  expect_gte(ncol(s), 10)
  expect_true("key" %in% names(s))
  
  expect_is(o, "tbl_df")
  expect_gte(nrow(o), 1000)
  expect_gte(ncol(o), 10)
  expect_true("key" %in% names(o))
  
})
