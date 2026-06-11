test_that("institution search works as expected", {
  vcr::use_cassette("institution_search", {
  q <- institution_search(query="Kansas",limit=1)
  s <- institution_search(numberSpecimens = "1000,*",limit=2)
  o <- institution_search(numberSpecimens = "1000,*", occurrenceCount = "10,*"
                          ,limit=2)
  e <- institution_search(source = "IH_IRN", limit=1)
  c <- institution_search(country = "US;GB", limit=1)
  t <- institution_search(typeSpecimenCount = "10,100",limit=1)
  d <- institution_search(discipline = "Paleontology", limit = 1)
  u <- institution_search(contactUserId = 1, limit = 1)
  m <- institution_search(contactEmail = "info@ynhm.org", limit = 1)
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

  expect_is(d, "list")
  expect_is(d$data, "tbl_df")
  expect_is(d$meta, "data.frame")
  expect_gte(d$meta$count, 1)

  expect_is(u, "list")
  expect_is(u$data, "tbl_df")
  expect_is(u$meta, "data.frame")

  expect_is(m, "list")
  expect_is(m$data, "tbl_df")
  expect_is(m$meta, "data.frame")
  
  })

test_that("institution_search validates discipline, contactEmail, contactUserId parameter types", {
  expect_error(institution_search(discipline = 1), "discipline must be of class")
  expect_error(institution_search(contactUserId = "1"), "contactUserId must be of class")
  expect_error(institution_search(contactEmail = 1), "contactEmail must be of class")
})

test_that("institution_export validates new parameter types", {
  expect_error(institution_export(institution = 1), "institution must be of class")
  expect_error(institution_export(contentType = 1), "contentType must be of class")
  expect_error(institution_export(preservationType = 1), "preservationType must be of class")
  expect_error(institution_export(accessionStatus = 1), "accessionStatus must be of class")
  expect_error(institution_export(personalCollection = "yes"), "personalCollection must be of class")
  expect_error(institution_export(contactUserId = "1"), "contactUserId must be of class")
  expect_error(institution_export(contactEmail = 1), "contactEmail must be of class")
})

test_that("institution_export works as expected", {
  skip_on_cran()
  
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

test_that("institution_export filters by active status, source, gbifRegion, contactEmail, and contactUserId", {
  skip_on_cran()
  
  a <- institution_export(active = TRUE)
  src <- institution_export(source = "IH_IRN")
  r <- institution_export(gbifRegion = "NORTH_AMERICA")
  m <- institution_export(contactEmail = "info@ynhm.org")
  u <- institution_export(contactUserId = 1)
  
  expect_is(a, "tbl_df")
  expect_gte(nrow(a), 1)
  expect_gte(ncol(a), 10)
  expect_true("key" %in% names(a))
  
  expect_is(src, "tbl_df")
  expect_gte(nrow(src), 1)
  expect_gte(ncol(src), 10)
  expect_true("key" %in% names(src))
  
  expect_is(r, "tbl_df")
  expect_gte(nrow(r), 1)
  expect_gte(ncol(r), 10)
  expect_true("key" %in% names(r))
  
  expect_is(m, "tbl_df")
  expect_true("key" %in% names(m))
  
  expect_is(u, "tbl_df")
  expect_true("key" %in% names(u))
})
