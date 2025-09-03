context("installation_uuid_funs")

test_that("installation_uuid_funs work as expected", {
  vcr::use_cassette("installation_uuid_funs", {
  d <- installation_dataset("d209e552-7e6e-4840-b13c-c0596ef36e55", limit=1)  
  c <- installation_comment("a0e05292-3d09-4eae-9f83-02ae3516283c")
  t <- installation_contact("896898e8-c0ac-47a0-8f38-0f792fbe3343")
  e <- installation_endpoint("896898e8-c0ac-47a0-8f38-0f792fbe3343")
  i <- installation_identifier("896898e8-c0ac-47a0-8f38-0f792fbe3343")
  m <- installation_machinetag("896898e8-c0ac-47a0-8f38-0f792fbe3343")
  g <- installation_tag("896898e8-c0ac-47a0-8f38-0f792fbe3343")
  })
  
  expect_is(d, "list")
  expect_is(d$data, "tbl_df")
  expect_is(d$meta, "data.frame")
  expect_gte(ncol(d$data), 30)
  
  expect_is(c, "tbl_df")
  expect_gte(ncol(c), 4)
  
  expect_is(t, "tbl_df")
  expect_gte(ncol(t), 10)
  
  expect_is(e, "tbl_df")
  expect_gte(ncol(e), 5)
  
  expect_is(i, "tbl_df")
  expect_is(m, "tbl_df")
  expect_is(g, "tbl_df")
})


