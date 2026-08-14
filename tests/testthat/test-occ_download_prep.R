# Run tests in this file: 
# testthat::test_file("tests/testthat/test-occ_download_prep.R")

test_that("occ_download_prep", {
  skip_on_cran()

  z <- occ_download_prep(
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred("hasGeospatialIssue", FALSE),
    pred("year", 1993),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$url, "character")
  expect_is(z$user, "character")
  expect_equal(z$user, "foo")
  expect_is(z$pwd, "character")
  expect_equal(z$pwd, "bar")
  expect_is(z$email, "character")
  expect_equal(z$email, "foo@bar.com")
  expect_is(z$format, "character")
  expect_equal(z$format, "DWCA")
  expect_is(z$curlopts, "list")
  
  # request list
  expect_is(z$request, "list")
  expect_is(z$request$creator, "scalar")
  expect_equal(z$request$creator[1], "foo")
  expect_is(z$request$predicate, "list")
  expect_is(z$request$predicate$type, "scalar")
  expect_is(z$request$predicate$predicates, "list")
  expect_is(z$request$predicate$predicates[[1]], "list")
  expect_named(z$request$predicate$predicates[[1]],
    c("type", "key", "values"))
  expect_equal(z$request$predicate$predicates[[1]]$type[1], "in")
  expect_equal(z$request$predicate$predicates[[1]]$key[1], "BASIS_OF_RECORD")
  expect_equal(z$request$predicate$predicates[[1]]$values, c("HUMAN_OBSERVATION", "OBSERVATION"))
  expect_equal(z$request$predicate$predicates[[2]]$type[1], "equals")
  expect_equal(z$request$predicate$predicates[[2]]$key[1], "HAS_COORDINATE")
  expect_equal(z$request$predicate$predicates[[2]]$value[1], "true")

  # checklistKey should default to COL XR
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")

  
})

test_that("occ_download_prep print method", {
  skip_on_cran()

  wkt <- "POLYGON ((1.1956196 31.6685274, 1.3014544 24.6501195, 2.5809994 25.4794093, 7.7447434 28.8910764, 7.0164007 26.8049712, 6.3937614 24.6883661, 10.6658621 23.0559085, 8.2558841 23.0358775, 5.8351769 22.5865697, 10.4505920 20.2873468, 1.5327929 23.8831332, 8.1689468 19.2218276, 1.5273958 23.7558439, 2.5291622 22.5315021, 3.6335872 21.2935462, 3.5394433 21.3562142, 4.0220814 16.8647554, 2.2146242 18.4152832, 0.3259253 14.7660454, 0.5718516 21.6252550, -0.7310904 21.5560907, -0.4340908 22.3753377, -1.1388369 21.7340427, 0.2977394 23.4751048, 0.8964301 24.1903765, 0.5309763 24.4781934, -0.6874591 25.3129101, -0.008445779 25.546685347, -1.5111521 29.2516804, 0.6816945 26.9554070, 1.1956196 31.6685274))"
  
  z <- occ_download_prep(
    pred_in(key="basisOfRecord", value=c("HUMAN_OBSERVATION", "OBSERVATION")),
    pred("hasCoordinate", TRUE),
    pred_within(wkt),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  w <- capture.output(print(z))
  w <- w[length(w)]
  expect_true(nchar(w) < 150)
})

test_that("occ_download_prep long print", {
  skip_on_cran()
  
  long_taxonkey_list <- rep(22222222,200)
  
  pp <- occ_download_prep(
    pred_in("taxonKey", long_taxonkey_list),
    pred("hasCoordinate", TRUE),
    user = "foo", 
    pwd = "bar", 
    email = "foo@bar.com"
  )
  
  expect_output(print(pp),"OK. But too large to print.")
})

test_that("occ_download_prep with explicit checklistKey but no taxonKey", {
  skip_on_cran()

  col_xr_uuid <- "7ddf754f-d193-4cc9-b351-99906754a03b"
  
  z <- occ_download_prep(
    pred("basisOfRecord", "PRESERVED_SPECIMEN"),
    pred_in("country", c("VC", "GD")),
    checklistKey = col_xr_uuid,
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$request, "list")
  # Explicit checklistKey should be included even without taxonomic predicates
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], col_xr_uuid)
})

test_that("occ_download_prep uses COL XR as default checklistKey", {
  skip_on_cran()

  # Test with taxonKey predicate - should include default checklistKey
  z <- occ_download_prep(
    pred("taxonKey", "Q2M4"),
    pred("hasCoordinate", TRUE),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$request, "list")
  expect_is(z$request$checklistKey, "character")
  # COL Extended Release UUID should be the default when taxonKey is used
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep includes COL XR default even without taxonomic predicates", {
  skip_on_cran()

  # Test without taxonKey predicate - checklistKey should default to COL XR
  z <- occ_download_prep(
    pred("basisOfRecord", "PRESERVED_SPECIMEN"),
    pred_in("country", c("US", "CA")),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$request, "list")
  # checklistKey should default to COL XR even without taxonomic predicates
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep defaults to COL XR with explicit NULL", {
  skip_on_cran()

  # Test that setting checklistKey = NULL uses the COL XR default
  z <- occ_download_prep(
    pred("basisOfRecord", "PRESERVED_SPECIMEN"),
    pred_in("country", c("US", "CA")),
    checklistKey = NULL,
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$request, "list")
  # When checklistKey is null it should be the COL XR default
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep omits checklistKey with empty string", {
  skip_on_cran()

  # Test that setting checklistKey = "" explicitly omits it (for cache matching)
  z <- occ_download_prep(
    pred("basisOfRecord", "PRESERVED_SPECIMEN"),
    pred_in("country", c("US", "CA")),
    checklistKey = "",
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$request, "list")
  # When checklistKey is empty string, it should be omitted entirely
  expect_null(z$request$checklistKey)
})

test_that("occ_download_prep uses COL XR for classKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("classKey", "B8V3Z"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z, "occ_download_prep")
  expect_is(z$request, "list")
  
  # Check top-level checklistKey
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$predicate$type[1], "equals")
  expect_equal(z$request$predicate$key[1], "CLASS_KEY")
  expect_equal(z$request$predicate$value[1], "B8V3Z")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  
  # With single predicate, it's unwrapped to predicate level (not predicates[[1]])
  expect_is(z$request$predicate$checklistKey, "character")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for phylumKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("phylumKey", "C4PL"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for orderKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("orderKey", "XYZ123"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for familyKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("familyKey", "ABC789"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for genusKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("genusKey", "DEF456"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for subgenusKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("subgenusKey", "GHI012"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for speciesKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("speciesKey", "JKL345"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for acceptedTaxonKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("acceptedTaxonKey", "MNO678"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR for kingdomKey predicate", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("kingdomKey", "PQR901"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep uses COL XR with pred_in for taxonomic keys", {
  skip_on_cran()

  z <- occ_download_prep(
    pred_in("classKey", c("B8V3Z", "XYZ", "ABC")),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  # Single predicate is unwrapped
  expect_equal(z$request$predicate$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$type[1], "in")
})

test_that("occ_download_prep uses COL XR with pred_or for taxonomic keys", {
  skip_on_cran()

  z <- occ_download_prep(
    pred_or(
      pred("classKey", "B8V3Z"),
      pred("classKey", "XYZ")
    ),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  
  # Single pred_or is unwrapped - check predicates within the OR have checklistKey
  expect_equal(z$request$predicate$type[1], "or")
  expect_equal(z$request$predicate$predicates[[1]]$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
  expect_equal(z$request$predicate$predicates[[2]]$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
})

test_that("occ_download_prep allows GBIF Backbone override at predicate level", {
  skip_on_cran()

  backbone_uuid <- "d7dddbf4-2cf0-4f39-9b2a-bb099caae36c"
  col_xr_uuid <- "7ddf754f-d193-4cc9-b351-99906754a03b"
  
  z <- occ_download_prep(
    pred("classKey", "220", checklistKey = backbone_uuid),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  # Top-level checklistKey defaults to COL XR (predicate-level doesn't propagate up)
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], col_xr_uuid)
  
  # Predicate-level checklistKey uses the explicit Backbone override
  expect_equal(z$request$predicate$checklistKey[1], backbone_uuid)
})

test_that("occ_download_prep allows top-level checklistKey override via parameter", {
  skip_on_cran()

  backbone_uuid <- "d7dddbf4-2cf0-4f39-9b2a-bb099caae36c"
  col_xr_uuid <- "7ddf754f-d193-4cc9-b351-99906754a03b"
  
  z <- occ_download_prep(
    pred("classKey", "B8V3Z"),
    checklistKey = backbone_uuid,  # Override top-level with parameter
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  # Top-level checklistKey uses the parameter override
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], backbone_uuid)
  
  # Predicate-level checklistKey still defaults to COL XR (independent of top-level)
  expect_equal(z$request$predicate$checklistKey[1], col_xr_uuid)
})

test_that("occ_download_prep mixed predicates - only taxonomic get checklistKey", {
  skip_on_cran()

  z <- occ_download_prep(
    pred("classKey", "B8V3Z"),
    pred("basisOfRecord", "PRESERVED_SPECIMEN"),
    pred("country", "US"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  
  # With multiple predicates, they're in predicates array
  # First predicate (classKey) should have checklistKey
  expect_equal(z$request$predicate$predicates[[1]]$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
  
  # Second predicate (basisOfRecord) should not have checklistKey
  expect_null(z$request$predicate$predicates[[2]]$checklistKey)
  
  # Third predicate (country) should not have checklistKey
  expect_null(z$request$predicate$predicates[[3]]$checklistKey)
})

test_that("occ_download_prep works with pred_default and taxonomic keys", {
  skip_on_cran()

  z <- occ_download_prep(
    pred_default(),
    pred("taxonKey", "V2"),
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  # Top-level checklistKey should be present
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], "7ddf754f-d193-4cc9-b351-99906754a03b")
  
  # Should have an AND with two predicates at top level
  expect_equal(z$request$predicate$type[1], "and")
  expect_equal(length(z$request$predicate$predicates), 2)
  
  # First predicate is the nested AND from pred_default
  expect_equal(z$request$predicate$predicates[[1]]$type[1], "and")
  expect_equal(length(z$request$predicate$predicates[[1]]$predicates), 4)
  
  # Second predicate is the taxonKey with checklistKey
  expect_equal(z$request$predicate$predicates[[2]]$type[1], "equals")
  expect_equal(z$request$predicate$predicates[[2]]$key[1], "TAXON_KEY")
  expect_equal(z$request$predicate$predicates[[2]]$value[1], "V2")
  expect_equal(z$request$predicate$predicates[[2]]$checklistKey[1], 
    "7ddf754f-d193-4cc9-b351-99906754a03b")
  
  # Predicates within pred_default should NOT have checklistKey
  expect_null(z$request$predicate$predicates[[1]]$predicates[[1]]$checklistKey)
  expect_null(z$request$predicate$predicates[[1]]$predicates[[2]]$checklistKey)
})

test_that("occ_download_prep handles mixed GBIF Backbone and COL XR predicates", {
  skip_on_cran()

  backbone_uuid <- "d7dddbf4-2cf0-4f39-9b2a-bb099caae36c"
  col_xr_uuid <- "7ddf754f-d193-4cc9-b351-99906754a03b"
  
  z <- occ_download_prep(
    pred("classKey", "212", checklistKey = backbone_uuid),  # Aves in GBIF Backbone
    pred("genusKey", "B8V3Z"),  # COL XR key (default)
    pred("country", "US"),  # Non-taxonomic
    pred("basisOfRecord", "PRESERVED_SPECIMEN"),  # Non-taxonomic
    user = "foo", pwd = "bar", email = "foo@bar.com"
  )

  # Top-level checklistKey defaults to COL XR (predicate-level doesn't propagate)
  expect_is(z$request$checklistKey, "character")
  expect_equal(z$request$checklistKey[1], col_xr_uuid)
  
  # Should have an AND with multiple predicates
  expect_equal(z$request$predicate$type[1], "and")
  expect_equal(length(z$request$predicate$predicates), 4)
  
  # First predicate: classKey with GBIF Backbone
  expect_equal(z$request$predicate$predicates[[1]]$type[1], "equals")
  expect_equal(z$request$predicate$predicates[[1]]$key[1], "CLASS_KEY")
  expect_equal(z$request$predicate$predicates[[1]]$value[1], "212")
  expect_equal(z$request$predicate$predicates[[1]]$checklistKey[1], backbone_uuid)
  
  # Second predicate: genusKey with COL XR (default)
  expect_equal(z$request$predicate$predicates[[2]]$type[1], "equals")
  expect_equal(z$request$predicate$predicates[[2]]$key[1], "GENUS_KEY")
  expect_equal(z$request$predicate$predicates[[2]]$value[1], "B8V3Z")
  expect_equal(z$request$predicate$predicates[[2]]$checklistKey[1], col_xr_uuid)
  
  # Third predicate: country (non-taxonomic, no checklistKey)
  expect_equal(z$request$predicate$predicates[[3]]$type[1], "equals")
  expect_equal(z$request$predicate$predicates[[3]]$key[1], "COUNTRY")
  expect_null(z$request$predicate$predicates[[3]]$checklistKey)
  
  # Fourth predicate: basisOfRecord (non-taxonomic, no checklistKey)
  expect_equal(z$request$predicate$predicates[[4]]$type[1], "equals")
  expect_equal(z$request$predicate$predicates[[4]]$key[1], "BASIS_OF_RECORD")
  expect_null(z$request$predicate$predicates[[4]]$checklistKey)
})


