context("occ_spellcheck")

test_that("spell check param works", {
  vcr::use_cassette("occ_spellcheck", {
    # spelling good - returns TRUE
    expect_true(occ_spellcheck(search = "kingfisher"))
    expect_true(occ_spellcheck(search = "helianthus"))
    expect_true(occ_spellcheck(search = "asteraceae"))
    expect_true(occ_spellcheck(search = "sparrow"))

    # spelled incorrectly - returns FALSE
    expect_false(occ_spellcheck(search = "asdfadfasdf"))

    # spelled incorrectly - stops with many suggested spellings and number of results for each
    aa <- occ_spellcheck(search = "helir")
  })

  expect_is(aa, "list")
  expect_named(aa, c('correctlySpelled', 'suggestions'))
  expect_false(aa$correctlySpelled)
  expect_is(aa$suggestions, "list")
  expect_is(aa$suggestions[[1]]$alternatives, "character")
})
