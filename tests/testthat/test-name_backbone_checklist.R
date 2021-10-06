context("name_backbone_checklist")

test_that("name_backbone_checklist with data.frame", {

  name_data <- data.frame(
    sci_name = c(
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)" # a fake species  
    ), description = c(
      "a plant",
      "an insect",
      "a big cat",
      "newly discovered insect",
      "a mis-spelled big cat",
      "a fake species"
    ), 
    kingdom = c(
      "Plantae",
      "Animalia",
      "Animalia",
      "Animalia",
      "Animalia",
      "Johnlia"
    ), Canonical_Name = c(
      "Cirsium arvense", 
      "Calopteryx splendens", 
      "Puma concolor", 
      "Ceylonosticta alwisi", 
      "Puma concuolor", 
      "Fake species"  
    ))
  
    
  vcr::use_cassette("name_backbone_checklist", {
    tt <- name_backbone_checklist(name_data = name_data)
    })
  
  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
  expect_is(tt$usageKey, "integer")
  expect_is(tt$verbatim_name, "character")
  expect_equal(nrow(tt), 6)
  expect_true(all(tt$status == "ACCEPTED" | is.na(tt$status)))

  })

