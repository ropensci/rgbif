context("occ_get")

test_that("returns the correct class", {
  vcr::use_cassette("occ_get", {

    tt <- occ_get(key=855998194, return='data')
    uu <- occ_get(key=855998194, 'hier')
    vv <- occ_get(key=855998194, 'all')

    aa <- occ_get(key=855998194, verbatim = TRUE)
    bb <- occ_get(key=855998194, verbatim = TRUE, fields = "all")
    cc <- occ_get(key=c(855998194,620594291),
                  fields=c('scientificName','decimalLatitude','basisOfRecord'), verbatim=TRUE)

    expect_is(tt, "data.frame")
    expect_is(tt[1,1], "character")
    expect_is(tt[1,2], "integer")

    expect_is(uu, "data.frame")
    expect_is(uu[1,1], "character")
    expect_is(uu[1,2], "integer")

    expect_is(vv, "list")
    expect_is(vv[[1]], "data.frame")
    expect_is(vv[[2]], "list")

    expect_is(aa, "data.frame")
    expect_is(aa[1,1], "character")
    expect_is(aa[1,2], "integer")

    expect_is(bb, "data.frame")
    expect_is(bb[1,10], "character")
    expect_is(bb[1,2], "character")

    # returns the correct dimensions
    expect_equal(dim(tt), c(1,5))
    expect_equal(dim(uu), c(7,3))
    expect_equal(dim(vv), NULL)
    expect_equal(dim(vv[[1]]), c(7,3))
    expect_equal(length(vv[[2]]), 0)

    expect_equal(dim(aa), c(1,4))
    expect_equal(dim(cc), c(2,3))

  })
})

test_that("name_usage fails correctly", {
  skip_on_cran()
  expect_error(occ_get(key=766766824, curlopts=list(timeout_ms = 1)))
})

test_that("works w/: verbatim=TRUE, fields all, & return extensions data", {
  vcr::use_cassette("occ_get_other", {

    keys <- c(1315970632, 1261282041, 1807810811, 1807914841)
    aa <- occ_get(keys[1], fields = "all", verbatim = TRUE, return = "data")
    bb <- occ_get(keys[2], fields = "all", verbatim = TRUE, return = "data")
    cc <- occ_get(keys[3], fields = "all", verbatim = TRUE, return = "data")
    dd <- occ_get(keys[4], fields = "all", verbatim = TRUE, return = "data")

    # extensions: Identification non-empty, Multimedia empty array
    expect_is(aa, "data.frame")
    expect_equal(NROW(aa), 1)
    expect_true(any(grepl("extensions", names(aa))))
    expect_false(any(grepl("Multimedia", names(aa))))

    # extensions: Identification missing, Multimedia empty array
    expect_is(bb, "data.frame")
    expect_equal(NROW(bb), 1)
    expect_false(any(grepl("extensions", names(bb))))
    expect_true(any(grepl("Multimedia", names(bb))))

    # extensions: Identification missing, Multimedia non-empty
    expect_is(cc, "data.frame")
    expect_equal(NROW(cc), 1)
    expect_true(any(grepl("extensions", names(cc))))
    expect_false(any(grepl("Multimedia", names(aa))))

    # extensions: empty hash
    expect_is(dd, "data.frame")
    expect_equal(NROW(dd), 1)
    expect_false(any(grepl("extensions", names(dd))))

  })
})
