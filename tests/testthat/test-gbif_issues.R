context("gbif_issues")

test_that("gbif_issues", {
  aa <- gbif_issues()

  expect_is(aa, "data.frame")
  expect_named(aa, c('code', 'issue', 'description', "type"))
  expect_is(aa$code, 'character')
  expect_is(aa$issue, 'character')
  expect_is(aa$description, 'character')
  expect_is(aa$type, 'character')
})

test_that("fails correctly", {
  expect_error(gbif_issues(5), "unused argument")
})

fetch_gbif_issues <- function(type = 'occ') {
  urls=list(
    occ="https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/OccurrenceIssue.html",
    name="https://gbif.github.io/gbif-api/apidocs/org/gbif/api/vocabulary/NameUsageIssue.html"
  )
  con <- crul::HttpClient$new(urls[[type]])
  res <- con$get()
  res$raise_for_status()
  html <- xml2::read_html(res$parse("UTF-8"))
  tabl <- xml2::xml_find_first(html, "//table[@class='memberSummary']")
  # xml2::xml_text(xml2::xml_find_all(tabl, ".//code"))
  nodes <- xml2::xml_find_all(tabl, ".//td")
  nodes <- Filter(function(z) {
    length(xml2::xml_find_first(z, ".//span[contains(@class, 'deprecatedLabel')]")) == 0
  }, nodes)
  xml2::xml_text(xml2::xml_find_all(nodes, ".//code"))
}

test_that("gbif_issues issues match what GBIF has", {
  our_iss <- gbif_issues()

  # occurrence issues
  iss_occ <- fetch_gbif_issues("occ")
  our_iss_occ <- our_iss[our_iss$type == "occurrence", ]
  expect_true(all(sort(iss_occ) %in% sort(our_iss_occ$issue)))

  # name issues
  iss_name <- fetch_gbif_issues("name")
  our_iss_name <- our_iss[our_iss$type == "name", ]
  expect_true(all(sort(iss_name) %in% sort(our_iss_name$issue)))
})
