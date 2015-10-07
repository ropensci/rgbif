context("gbifmap")

test_that("gbifmap", {
  skip_on_cran()

  key <- name_backbone(name='Puma concolor')$speciesKey
  dat <- occ_search(taxonKey=key, return='data', limit=100)
  tt <- suppressMessages(gbifmap(input=dat))

  library("plyr")
  splist <- c('Cyanocitta stelleri', 'Junco hyemalis', 'Aix sponsa')
  keys <- sapply(splist, function(x) name_backbone(name=x)$speciesKey, USE.NAMES=FALSE)
  dat <- occ_search(taxonKey=keys, return='data', limit=50)
  uu <- suppressMessages(gbifmap(ldply(dat)))

  expect_is(tt, "ggplot")
  expect_is(uu, "ggplot")

  # returns the correct attributes
  expect_match(uu$labels$group, c("group"))
  expect_match(uu$labels$colour, c("name"))
})
