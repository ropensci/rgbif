context("name_lookup")


test_that("returns the correct class", {
  vcr::use_cassette("name_lookup", {

    tt <- name_lookup(query='mammalia')
    uu <- name_lookup(query='Cnaemidophorus', rank="genus", return="data")

    expect_is(tt, "list")
    expect_is(tt$meta, "data.frame")
    expect_is(tt$meta$endOfRecords, "logical")
    expect_is(tt$data$canonicalName, "character")
    expect_is(tt$data$classKey, "integer")

    expect_is(uu, "data.frame")

    # returns the correct value
    expect_equal(na.omit(tt$data$kingdom)[[2]], "Animalia")

  })
})

test_that("works with habitat parameter", {
  vcr::use_cassette("name_lookup_habitat", {

    # with facet
    fachab <- name_lookup(facet='habitat', limit=0)
    expect_equal(fachab$facets$habitat$name, c("MARINE", "TERRESTRIAL", "FRESHWATER"))

    # with habitat parameter used
    facet_terr <- name_lookup(habitat = "terrestrial", limit=2)
    facet_mar <- name_lookup(habitat = "marine", limit=2)
    facet_fresh <- name_lookup(habitat = "freshwater", limit=2)
    expect_true(grepl("TERRESTRIAL", facet_terr$data$habitats[1]))
    expect_true(grepl("MARINE", facet_mar$data$habitats[1]))
    expect_true(grepl("FRESH", facet_fresh$data$habitats[1]))

    # another test
    out <- name_lookup(habitat = "terrestrial", return = "data")
    expect_equal(sort(na.omit(out$habitats))[1], "FRESHWATER, MARINE, TERRESTRIAL")
  }, preserve_exact_body_bytes = TRUE)
})


# many args
test_that("works with parameters that allow many inputs", {
  vcr::use_cassette("name_lookup_many_inputs", {

    aa <- name_lookup(status = c("misapplied", "synonym"), limit = 200)
    expect_is(aa, "list")
    expect_is(aa$meta, "data.frame")
    expect_is(aa$meta$endOfRecords, "logical")
    expect_is(aa$data$canonicalName, "character")
    expect_is(aa$data$classKey, "integer")
    expect_true(all(
      unique(tolower(aa$data$taxonomicStatus)) %in% c("misapplied", "synonym")))

    aa <- name_lookup(nameType = c("cultivar", "doubtful"), limit = 200)
    expect_is(aa, "list")
    expect_is(aa$meta, "data.frame")
    expect_is(aa$meta$endOfRecords, "logical")
    expect_is(aa$data$canonicalName, "character")
    expect_is(aa$data$key, "integer")
    expect_true(all(
      unique(tolower(aa$data$nameType)) %in% c("cultivar", "doubtful")))

    aa <- name_lookup(origin = c("implicit_name", "proparte"), limit = 250)
    expect_is(aa, "list")
    expect_is(aa$meta, "data.frame")
    expect_is(aa$meta$endOfRecords, "logical")
    expect_is(aa$data$canonicalName, "character")
    expect_is(aa$data$key, "integer")
    expect_true(all(
      unique(tolower(aa$data$origin)) %in% c("implicit_name", "proparte")))
  }, preserve_exact_body_bytes = TRUE)
})

#paging (limit higher than 1000 records; maximum API: 99999)
test_that("paging: name_usage returns as many records as asked, limit > 1000", {
    vcr::use_cassette("name_lookup_paging1", {

    # https://www.gbif.org/dataset/a5224e5b-6379-4d33-a29d-14b56015893d
    # 1051 total records (any origin, i.e. SOURCE and DENORMED_CLASSIFICATION)
    aa <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                                          limit = 1001)
    expect_equal(aa$meta$offset, 1000)
    expect_equal(aa$meta$limit, 1)
    expect_equal(nrow(aa$data), 1001)
  })
})

test_that("paging: class data and meta not modified by paging", {
  vcr::use_cassette("name_lookup_paging2", {

    bb1 <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                     limit = 1)
    bb2 <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                      limit = 1002)
    expect_true(all(class(bb1) == class(bb2)))
    expect_true(all(class(bb1$meta) == class(bb2$meta)))
    expect_true(all(class(bb1$data) == class(bb2$data)))
  })
})

test_that("paging: name_usage returns all records from dataset: limit > n_records", {
  skip_on_cran()

  vcr::use_cassette("name_lookup_paging3", {
    #https://www.gbif.org/dataset/a5224e5b-6379-4d33-a29d-14b56015893d
    # 1051 total records (any origin, i.e. SOURCE and DENORMED_CLASSIFICATION)
    cc <- name_lookup(datasetKey = "a5224e5b-6379-4d33-a29d-14b56015893d",
                      limit = 5000)
    expect_gte(cc$meta$offset, 1000)
    expect_gte(cc$meta$limit, 51)
    expect_equal(cc$meta$endOfRecords, TRUE)
    expect_gte(cc$meta$count, 1051)
    expect_gte(nrow(cc$data), 1051)
  })
})
