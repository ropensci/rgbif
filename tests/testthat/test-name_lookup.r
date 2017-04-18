context("name_lookup")


test_that("returns the correct class", {
  skip_on_cran()

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

test_that("works with habitat parameter", {
  skip_on_cran()

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
})


# many args
test_that("works with parameters that allow many inputs", {
  skip_on_cran()

  aa <- name_lookup(status = c("misapplied", "synonym"), limit = 200)
  expect_is(aa, "list")
  expect_is(aa$meta, "data.frame")
  expect_is(aa$meta$endOfRecords, "logical")
  expect_is(aa$data$canonicalName, "character")
  expect_is(aa$data$classKey, "integer")
  expect_true(all(
    unique(tolower(aa$data$taxonomicStatus)) %in% c("misapplied", "synonym")))

  aa <- name_lookup(nameType = c("cultivar", "doubtful"))
  expect_is(aa, "list")
  expect_is(aa$meta, "data.frame")
  expect_is(aa$meta$endOfRecords, "logical")
  expect_is(aa$data$canonicalName, "character")
  expect_is(aa$data$key, "integer")
  expect_true(all(
    unique(tolower(aa$data$nameType)) %in% c("cultivar", "doubtful")))
})
