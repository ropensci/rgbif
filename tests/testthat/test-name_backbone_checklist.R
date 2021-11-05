context("name_backbone_checklist")



test_that("name_backbone_checklist good data", {
  skip_on_cran()
  skip_on_ci()
  
  name_data <- data.frame(
    name = c(
      NA, # missing value
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)", # a fake species
      "Calopteryx" # Just a Genus   
    ), description = c(
      "missing",
      "a plant",
      "an insect",
      "a big cat",
      "newly discovered insect",
      "a mis-spelled big cat",
      "a fake species",
      "just a GENUS"
    ), 
    kingdom = c(
      "missing",
      "Plantae",
      "Animalia",
      "Animalia",
      "Animalia",
      "Animalia",
      "Johnlia",
      "Animalia"
    ), Canonical_Name = c(
      "not known",
      "Cirsium arvense", 
      "Calopteryx splendens", 
      "Puma concolor", 
      "Ceylonosticta alwisi", 
      "Puma concuolor", 
      "Fake species",
      "Calopteryx"
    ), scientificName = c(
      NA,
      "Cirsium arvense (L.) Scop.", # a plant
      "Calopteryx splendens (Harris, 1780)", # an insect
      "Puma concolor (Linnaeus, 1771)", # a big cat
      "Ceylonosticta alwisi (Priyadarshana & Wijewardhane, 2016)", # newly discovered insect 
      "Puma concuolor (Linnaeus, 1771)", # a mis-spelled big cat
      "Fake species (John Waller 2021)", # a fake species
      "Calopteryx" # Just a Genus   
    ))

    # vcr does not seem to work with async requests  
    # with data.frame
    tt <- name_backbone_checklist(name_data = name_data)
    vv <- name_backbone_checklist(name_data = name_data,verbose=TRUE)
    # vector
    ttt <- name_backbone_checklist(name_data = name_data$name) 
    vvv <- name_backbone_checklist(name_data = name_data$name,verbose=TRUE)
    # one column
    cc <- name_backbone_checklist(name_data = name_data["name"]) 
    dd <- name_backbone_checklist(name_data = name_data["name"],verbose=TRUE)
    ccc <- name_backbone_checklist(name_data = name_data["Canonical_Name"]) 
    ddd <- name_backbone_checklist(name_data = name_data["Canonical_Name"],verbose=TRUE)

  # data.frame
  expect_is(tt, "tbl")
  expect_is(tt, "tbl_df")
  expect_is(tt, "data.frame")
  expect_is(tt$usageKey, "integer")
  expect_is(tt$verbatim_name, "character")
  expect_equal(nrow(tt), 8)
  expect_true(all(tt$status == "ACCEPTED" | is.na(tt$status)))
  
  expect_is(vv, "tbl")
  expect_is(vv, "tbl_df")
  expect_is(vv, "data.frame")
  expect_is(vv$usageKey, "integer")

  # vector
  expect_is(ttt, "tbl")
  expect_is(ttt, "tbl_df")
  expect_is(ttt, "data.frame")
  expect_is(ttt$usageKey, "integer")
  expect_is(ttt$verbatim_name, "character")
  expect_equal(nrow(ttt), 8)
  expect_true(all(ttt$status == "ACCEPTED" | is.na(ttt$status)))
  
  expect_is(vvv, "tbl")
  expect_is(vvv, "tbl_df")
  expect_is(vvv, "data.frame")
  expect_is(vvv$usageKey, "integer")

  # one column data.frame
  expect_is(cc, "tbl")
  expect_is(cc, "tbl_df")
  expect_is(cc, "data.frame")
  expect_is(cc$usageKey, "integer")
  expect_is(cc$verbatim_name, "character")
  expect_equal(nrow(cc), 8)
  expect_true(all(cc$status == "ACCEPTED" | is.na(cc$status)))
  
  expect_is(dd, "tbl")
  expect_is(dd, "tbl_df")
  expect_is(dd, "data.frame")
  expect_is(dd$usageKey, "integer")

  # one column that is not an alias 
  expect_is(ccc, "tbl")
  expect_is(ccc, "tbl_df")
  expect_is(ccc, "data.frame")
  expect_is(ccc$usageKey, "integer")
  expect_is(ccc$verbatim_name, "character")
  expect_equal(nrow(ccc), 8)
  expect_true(all(ccc$status == "ACCEPTED" | is.na(ccc$status)))
  
  expect_is(ddd, "tbl")
  expect_is(ddd, "tbl_df")
  expect_is(ddd, "data.frame")
  expect_is(ddd$usageKey, "integer")

  # bad data 
  expect_error(name_backbone_checklist(name_data = NULL),"You forgot to supply your checklist data.frame or vector to name_data.")
  expect_error(name_backbone_checklist(name_data = 1),"name_data should be class character.")
  
  name_data_factor = name_data
  name_data_factor$name<-as.factor(name_data_factor$name)
  expect_error(name_backbone_checklist(name_data = name_data_factor),"All taxonomic columns should be character.")
  name_data_factor$name<-as.numeric(name_data_factor$name)
  expect_error(name_backbone_checklist(name_data = name_data_factor),"All taxonomic columns should be character.")
  
  })

