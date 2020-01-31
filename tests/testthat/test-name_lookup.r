context("name_lookup")

test_that("returns the correct class", {
  skip_on_cran() # because fixture in .Rbuildignore

  vcr::use_cassette("name_lookup", {
    tt <- name_lookup(query='mammalia')
    uu <- name_lookup(query='Cnaemidophorus', rank="genus", return="data")
  }, preserve_exact_body_bytes = TRUE)

  expect_is(tt, "gbif")
  expect_is(tt$meta, "data.frame")
  expect_is(tt$meta$endOfRecords, "logical")
  expect_is(tt$data, "data.frame")
  expect_is(tt$data, "tbl_df")
  expect_is(tt$data, "tbl")
  expect_is(tt$data$canonicalName, "character")
  expect_is(tt$data$classKey, "integer")

  expect_is(uu, "data.frame")
  expect_is(uu, "tbl_df")
  expect_is(uu, "tbl")
  expect_is(uu, "gbif")

  # returns the correct value
  expect_equal(na.omit(tt$data$kingdom)[[2]], "Animalia")
})

test_that("works with habitat parameter", {
  vcr::use_cassette("name_lookup_habitat", {
    # with facet
    fachab <- name_lookup(facet='habitat', limit=0)
    expect_is(fachab, "gbif")
    expect_equal(fachab$facets$habitat$name, c("MARINE", "TERRESTRIAL", "FRESHWATER"))

    # with habitat parameter used
    facet_terr <- name_lookup(habitat = "terrestrial", limit=2)
    facet_mar <- name_lookup(habitat = "marine", limit=2)
    facet_fresh <- name_lookup(habitat = "freshwater", limit=2)

    # another test
    out <- name_lookup(habitat = "terrestrial", return = "data")
  }, preserve_exact_body_bytes = TRUE)

  expect_is(facet_terr, "gbif")
  expect_is(facet_mar, "gbif")
  expect_is(facet_fresh, "gbif")
  expect_true(grepl("TERRESTRIAL", facet_terr$data$habitats[1]))
  expect_true(grepl("MARINE", facet_mar$data$habitats[1]))
  expect_true(grepl("FRESH", facet_fresh$data$habitats[1]))
  expect_true(grepl("TERRESTRIAL", facet_terr$data$habitats[1]))
  expect_true(grepl("MARINE", facet_mar$data$habitats[1]))
  expect_true(grepl("FRESH", facet_fresh$data$habitats[1]))

  expect_equal(sort(na.omit(out$habitats))[1], "FRESHWATER, MARINE, TERRESTRIAL")
})

# many args
test_that("works with parameters that allow many inputs", {
  skip_on_cran() # because fixture in .Rbuildignore

  vcr::use_cassette("name_lookup_many_inputs", {
    aa <- name_lookup(status = c("misapplied", "synonym"), limit = 200)
    bb <- name_lookup(nameType = c("cultivar", "doubtful"), limit = 200)
    cc <- name_lookup(origin = c("implicit_name", "proparte"), limit = 250)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(aa, "gbif")
  expect_is(aa$meta, "data.frame")
  expect_is(aa$meta$endOfRecords, "logical")
  expect_is(aa$data$canonicalName, "character")
  expect_is(aa$data$classKey, "integer")
  expect_true(all(
    unique(tolower(aa$data$taxonomicStatus)) %in% c("misapplied", "synonym")))

  expect_is(bb, "gbif")
  expect_is(bb$meta, "data.frame")
  expect_is(bb$meta$endOfRecords, "logical")
  expect_is(bb$data$canonicalName, "character")
  expect_is(bb$data$key, "integer")
  expect_true(all(
    unique(tolower(bb$data$nameType)) %in% c("cultivar", "doubtful")))

  expect_is(cc, "gbif")
  expect_is(cc$meta, "data.frame")
  expect_is(cc$meta$endOfRecords, "logical")
  expect_is(cc$data$canonicalName, "character")
  expect_is(cc$data$key, "integer")
  expect_true(all(
    unique(tolower(cc$data$origin)) %in% c("implicit_name", "proparte")))
})

#paging (limit higher than 1000 records; maximum API: 99999)
test_that("paging: name_usage returns as many records as asked, limit > 1000", {
  skip_on_cran() # because fixture in .Rbuildignore

  vcr::use_cassette("name_lookup_paging1", {
    # https://www.gbif.org/dataset/a5224e5b-6379-4d33-a29d-14b56015893d
    # 1051 total records (any origin, i.e. SOURCE and DENORMED_CLASSIFICATION)
    aa <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                                          limit = 1001)
  }, preserve_exact_body_bytes = TRUE)

  expect_is(aa, "gbif")
  expect_equal(aa$meta$offset, 1000)
  expect_equal(aa$meta$limit, 1)
  expect_is(aa$data, "data.frame")
  expect_is(aa$data, "tbl_df")
  expect_is(aa$data, "tbl")
  expect_equal(nrow(aa$data), 1001)
})

test_that("paging: class data and meta not modified by paging", {
  skip_on_cran() # because fixture in .Rbuildignore
  
  vcr::use_cassette("name_lookup_paging2", {
    bb1 <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                     limit = 1)
    bb2 <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                      limit = 1002)
  }, preserve_exact_body_bytes = TRUE)

  expect_true(all(class(bb1) == class(bb2)))
  expect_true(all(class(bb1$meta) == class(bb2$meta)))
  expect_true(all(class(bb1$data) == class(bb2$data)))
})

test_that("paging: name_usage returns all records from dataset: limit > n_records", {
  skip_on_cran() # because fixture in .Rbuildignore

  vcr::use_cassette("name_lookup_paging3", {
    #https://www.gbif.org/dataset/a5224e5b-6379-4d33-a29d-14b56015893d
    # 1051 total records (any origin, i.e. SOURCE and DENORMED_CLASSIFICATION)
    cc <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                      limit = 5000)
  }, preserve_exact_body_bytes = TRUE)

  expect_gte(cc$meta$offset, 1000)
  expect_gte(cc$meta$limit, 51)
  expect_equal(cc$meta$endOfRecords, TRUE)
  expect_gte(cc$meta$count, 1051)
  expect_is(cc$data, "data.frame")
  expect_is(cc$data, "tbl_df")
  expect_is(cc$data, "tbl")
  expect_gte(nrow(cc$data), 1051)
})
