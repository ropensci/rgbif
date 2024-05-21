context("dataset_uuid_funs")

test_that("dataset_uuid_funs work as expected", {
  vcr::use_cassette("dataset_uuid_funs", {
  g <- dataset_get("38b4c89f-584c-41bb-bd8f-cd1def33e92f")
  p <- dataset_process("38b4c89f-584c-41bb-bd8f-cd1def33e92f",limit=3)
  n <- dataset_networks("3dab037f-a520-4bc3-b888-508755c2eb52")
  c <- dataset_constituents("7ddf754f-d193-4cc9-b351-99906754a03b",limit=3)
  m <- dataset_comment("2e4cc37b-302e-4f1b-bbbb-1f674ff90e14")
  o <- dataset_contact("7ddf754f-d193-4cc9-b351-99906754a03b")
  e <- dataset_endpoint("7ddf754f-d193-4cc9-b351-99906754a03b")
  i <- dataset_identifier("7ddf754f-d193-4cc9-b351-99906754a03b")
  t <- dataset_machinetag("7ddf754f-d193-4cc9-b351-99906754a03b")
  a <- dataset_tag("c47f13c1-7427-45a0-9f12-237aad351040")
  r <- dataset_metrics("7ddf754f-d193-4cc9-b351-99906754a03b")
  })
  
  expect_is(g,"tbl_df")
  expect_is(g$key,"character")
  expect_is(g$title,"character")
  expect_equal(nrow(g), 1)
  
  expect_is(p,"list")
  expect_named(p,c("meta","data"))
  expect_is(p$data$datasetKey,"character")
  expect_lte(nrow(p$data),3)
  
  expect_is(n,"tbl_df")
  expect_is(n$key,"character")
  expect_is(n$title,"character")
  expect_equal(nrow(n), 1)
  
  expect_is(c,"list")
  expect_named(c,c("meta","data"))
  expect_is(c$data$key,"character")
  expect_lte(nrow(c$data),3)
  
  expect_is(m,"tbl_df")
  expect_is(m$key,"integer")
  expect_is(m$content,"character")
  expect_gte(nrow(m), 10)
  
  expect_is(o,"tbl_df")
  expect_is(o$key,"integer")
  expect_is(o$type,"character")
  expect_gte(nrow(o), 10)
  
  expect_is(e,"tbl_df")
  expect_is(e$key,"integer")
  expect_is(e$type,"character")
  expect_gte(nrow(e), 1)
  
  expect_is(i,"tbl_df")
  expect_is(i$key,"integer")
  expect_is(i$type,"character")
  expect_gte(nrow(i), 1)
  
  expect_is(t,"tbl_df")
  expect_is(t$key,"integer")
  expect_is(t$namespace,"character")
  expect_gte(nrow(t), 1)
  
  expect_is(a,"tbl_df")
  expect_is(a$key,"integer")
  expect_is(a$value,"character")
  expect_gte(nrow(a), 1)
  
  expect_is(r,"tbl_df")
  expect_is(r$key,"integer")
  expect_is(r$usagesCount,"integer")
  expect_gte(nrow(r), 1)
})

test_that("dataset_uuid_funs fail well", {
  skip_on_cran()
  
  expect_error(dataset_metrics("4fa7b334-ce0d-4e88-aaae-2e0c138d049e"),
               "Dataset should be a checklist.")

  expect_error(dataset_get(1),"'uuid' should be a GBIF datasetkey uuid.")
  expect_error(dataset_tag(1),"'uuid' should be a GBIF datasetkey uuid.")
  
})

