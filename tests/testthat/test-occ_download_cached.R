context("occ_download_cached: utilities")

# get original env vars/R options
keys <- c("GBIF_USER", "GBIF_PWD", "GBIF_EMAIL")
lkeys <- tolower(keys)
env_vars <- as.list(Sys.getenv(keys))
r_opts <- stats::setNames(lapply(lkeys, getOption), lkeys)

test_that("occ_download_cached utils", {
  skip_on_cran()
  skip_on_ci()

  # dl_user
  vcr::use_cassette("dl_user", {
    user <- dl_user()
  })

  expect_is(user, "tbl")
  expect_gt(NROW(user), 100)
  expect_is(user$key, "character")
  expect_equal(unique(user$request.creator), "sckott")

  # dl_predicates
  preds <- dl_predicates(user_df = user)

  expect_is(preds, "tbl")
  expect_gt(NROW(preds), 100)
  expect_is(preds$pred_str, "character")
  # each predicate is a json string
  expect_is(preds$pred_str[1], "character")
  json = jsonlite::fromJSON(preds$pred_str[1])
  expect_is(json, "list")
  expect_named(json, c('creator', 'notification_address', 'format', 'predicate'))
  # outputs of the two functions should have same number of rows
  expect_equal(NROW(preds), NROW(user))
  # dl_predicates adds 1 column
  expect_equal(NCOL(preds), NCOL(user) + 1)

  # dl_match
  ## not matched
  dprep1 <- occ_download_prep(pred("catalogNumber", "Bird.27847588"),
    pred("year", 1978))
  aa <- dl_match(pred = dprep1, preds)
  expect_is(aa, "DownloadMatch")
  expect_false(aa$matched)
  
  ## matched but expired
  dprep2 <- occ_download_prep(pred("catalogNumber", "Bird.27847588"))
  bb <- dl_match(pred = dprep2, preds)
  expect_is(bb, "DownloadMatch")
  expect_true(bb$matched)
  expect_true(bb$expired)
  
  ## matched and not expired
  # created: 2020-04-02, so set `age=(Sys.Date()-as.Date("2020-04-02"))+1`
  dprep3 <- occ_download_prep(pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
    pred_gte("elevation", 5000))
  age <- as.numeric((Sys.Date()-as.Date("2020-04-02"))+1)
  cc <- dl_match(pred = dprep3, preds, age = age)
  expect_is(cc, "DownloadMatch")
  expect_true(cc$matched)
  expect_false(cc$expired)
})

context("occ_download_cached")
test_that("occ_download_cached itself", {
  skip_on_cran()

  # not matched
  expect_message(
    (aa <- occ_download_cached(pred("catalogNumber", "Bird.27847588"),
      pred("year", 1978))),
    "no match found"
  )
  # returns an NA
  expect_true(is.na(aa))
  # NA of type character
  expect_is(aa, "character")
  # length 1
  expect_equal(length(aa), 1)
  
  # match but expired
  expect_message((bb <- occ_download_cached(pred_gte("elevation", 12000L))),
    "match found, but expired")
  # returns an NA
  expect_true(is.na(bb))
  # NA of type character
  expect_is(bb, "character")
  # length 1
  expect_equal(length(bb), 1)

  # match but expired
  age <- as.numeric((Sys.Date()-as.Date("2020-04-02"))+1)
  expect_message((cc <- occ_download_cached(
      pred_within("POLYGON((-14 42, 9 38, -7 26, -14 42))"),
      pred_gte("elevation", 5000), age = age)),
    "match found \\(key"
  )
  # returns an object of class occ_download
  expect_is(cc, "occ_download")
  # length 1
  expect_equal(length(cc), 1)
})

test_that("occ_download_cached fails well", {
  skip_on_cran()

  # no requests submitted
  expect_error(occ_download_cached(), "pass in at least")
  # wrong type passed in
  expect_error(occ_download_cached(5), "all inputs must be")
  # # wrong type passed in
  # expect_error(occ_download_cached(5), "")
})

# set env vars/R options back to original
invisible(do.call(Sys.setenv, env_vars))
invisible(do.call(options, r_opts))
