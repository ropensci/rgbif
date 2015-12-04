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

  # returns the correct dimensions
  expect_equal(nrow(tt$data), 100)

  expect_equal(NCOL(uu), 35)
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
  expect_true(grepl("MARINE", facet_terr$data$habitats[1]))
  expect_true(grepl("MARINE", facet_mar$data$habitats[1]))
  expect_true(grepl("MARINE", facet_fresh$data$habitats[1]))

  # another test
  out <- name_lookup(query="Vulpes lagopus", rank="species",
                     higherTaxonKey=5219234, habitat="terrestrial", return="data")
  expect_equal(out$habitats, "MARINE, TERRESTRIAL")
})
