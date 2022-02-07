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
  # data.frame
  tt <- name_backbone_checklist(name_data = name_data)
  vv <- name_backbone_checklist(name_data = name_data,verbose=TRUE)
  # vector
  ttt <- name_backbone_checklist(name_data = name_data$name) 
  vvv <- name_backbone_checklist(name_data = name_data$name,verbose=TRUE)
  # one column
  tttt <- name_backbone_checklist(name_data = name_data["name"]) 
  vvvv <- name_backbone_checklist(name_data = name_data["name"],verbose=TRUE)
  # one column not aliased
  ttttt <- name_backbone_checklist(name_data = name_data["Canonical_Name"]) 
  vvvvv <- name_backbone_checklist(name_data = name_data["Canonical_Name"],verbose=TRUE)
  # aliased name multiple columns
  tttttt <- name_backbone_checklist(name_data = name_data[c("scientificName","kingdom")]) 
  vvvvvv <- name_backbone_checklist(name_data = name_data[c("scientificName","kingdom")],verbose=TRUE)
  
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
  expect_true(nrow(vv) > nrow(tt))
  
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
  expect_true(nrow(vvv) > nrow(ttt))
  
  # one column data.frame
  expect_is(tttt, "tbl")
  expect_is(tttt, "tbl_df")
  expect_is(tttt, "data.frame")
  expect_is(tttt$usageKey, "integer")
  expect_is(tttt$verbatim_name, "character")
  expect_equal(nrow(tttt), 8)
  expect_true(all(tttt$status == "ACCEPTED" | is.na(tttt$status)))
  
  expect_is(vvvv, "tbl")
  expect_is(vvvv, "tbl_df")
  expect_is(vvvv, "data.frame")
  expect_is(vvvv$usageKey, "integer")
  expect_true(nrow(vvvv) > nrow(tttt))
  
  # one column that is not an alias 
  expect_is(ttttt, "tbl")
  expect_is(ttttt, "tbl_df")
  expect_is(ttttt, "data.frame")
  expect_is(ttttt$usageKey, "integer")
  expect_is(ttttt$verbatim_name, "character")
  expect_equal(nrow(ttttt), 8)
  expect_true(all(ttttt$status == "ACCEPTED" | is.na(ttttt$status)))
  
  expect_is(vvvvv, "tbl")
  expect_is(vvvvv, "tbl_df")
  expect_is(vvvvv, "data.frame")
  expect_is(vvvvv$usageKey, "integer")
  expect_true(nrow(vvvvv) > nrow(ttttt))
  
  # aliased name multiple columns
  expect_is(tttttt, "tbl")
  expect_is(tttttt, "tbl_df")
  expect_is(tttttt, "data.frame")
  expect_is(tttttt$usageKey, "integer")
  expect_is(tttttt$verbatim_name, "character")
  expect_equal(nrow(tttttt), 8)
  expect_true(all(tttttt$status == "ACCEPTED" | is.na(tttttt$status)))
  
  expect_is(vvvvvv, "tbl")
  expect_is(vvvvvv, "tbl_df")
  expect_is(vvvvvv, "data.frame")
  expect_is(vvvvvv$usageKey, "integer")
  expect_true(nrow(vvvvvv) > nrow(tttttt))
  })
  
test_that("name_backbone_checklist bad or weird data", {
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
    
  # bad data 
  expect_error(name_backbone_checklist(name_data = NULL),"You forgot to supply your checklist data.frame or vector to name_data.")
  expect_error(name_backbone_checklist(name_data = 1),"name_data should be class character.")
  expect_error(name_backbone_checklist(name_data = data.frame(1)),"The name column should be class character.")
  
  # name column is a factor
  name_data_factor = name_data
  name_data_factor$name<-as.factor(name_data_factor$name)
  expect_error(name_backbone_checklist(name_data = name_data_factor),"All taxonomic columns should be character.")
  name_data_factor$name<-as.numeric(name_data_factor$name)
  expect_error(name_backbone_checklist(name_data = name_data_factor),"All taxonomic columns should be character.")
  
  # just missing names
  ff <- name_backbone_checklist(name_data = c("fake name 1","fake name 2"))
  zz <- name_backbone_checklist(name_data = c("fake name 1","fake name 2"),verbose=TRUE)
  expect_equal(colnames(ff), c("confidence","matchType", "synonym", "verbatim_name","verbatim_index"))
  expect_equal(colnames(zz), c("confidence","matchType", "synonym", "verbatim_name","verbatim_index"))
  expect_true(nrow(ff) == nrow(zz))
  expect_equal(unique(ff$matchType), "NONE")
  expect_equal(unique(zz$matchType), "NONE")
  expect_equal(nrow(ff),2)
  expect_equal(nrow(zz),2)
  
  # just one missing name
  fff <- name_backbone_checklist(name_data = name_data[1,])
  zzz <- name_backbone_checklist(name_data = name_data[1,],verbose=TRUE)   
  expect_equal(colnames(fff), c("confidence","matchType", "synonym", "verbatim_name","verbatim_kingdom","verbatim_index"))
  expect_equal(colnames(zzz), c("confidence","matchType", "synonym", "verbatim_name","verbatim_kingdom","verbatim_index"))
  expect_true(nrow(fff) == nrow(zzz))
  expect_equal(unique(fff$matchType), "NONE")
  expect_equal(unique(zzz$matchType), "NONE")
  expect_equal(nrow(fff),1)
  expect_equal(nrow(zzz),1)
  
  })


test_that("test status codes", {
  skip_on_cran()
  skip_on_ci()
  
  urls_200 = c("https://httpbin.org/json","https://httpbin.org/json")
  expect_length(gbif_async_get(urls = urls_200),2)
  
  urls_204 = c("https://httpbin.org/status/204","https://httpbin.org/json")
  expect_error(gbif_async_get(urls = urls_204),"Status: 204 - not found")
               
  urls_500 = c("https://httpbin.org/json","https://httpbin.org/status/500")
  expect_error(gbif_async_get(urls = urls_500),"500 - Server error")
  
  urls_503 = c("https://httpbin.org/json","https://httpbin.org/status/503")
  expect_error(gbif_async_get(urls = urls_503),"503 - Service Unavailable")
  
})


