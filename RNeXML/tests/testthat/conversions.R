## Note: these tests do not run in the typical test suite process as the file name
## doesn't start with "test-"

# nms <- c("S100","S1000","S10000","S10001","S10005","S10006","S10007","S10009","S10014","S10018","S10301","S1044","S10500","S10636","S1064","S1073","S10774","S1207","S13135","S1452","S938","S9981","S999")
# nexml_files <- lapply(nms, function(x) content(GET(sprintf("https://raw.github.com/rvosa/supertreebase/master/data/treebase/%s.xml",x)), as="text"))
# save(nexml_files, file="~/github/ropensci/RNeXML_testfiles/nexml_files.rda")
load("~/github/ropensci/RNeXML_testfiles/nexml_files.rda")

context("nexml files parse correctly")
test_that("nexml files parse correctly", {
  expect_is(nexml_read(nexml_files[[1]]), "multiPhylo")
  expect_is(nexml_read(nexml_files[[2]]), "phylo")
  expect_is(nexml_read(nexml_files[[3]]), "list")
  expect_is(nexml_read(nexml_files[[4]]), "phylo")
  expect_is(nexml_read(nexml_files[[5]]), "list")
  expect_is(nexml_read(nexml_files[[6]]), "list")
  expect_is(nexml_read(nexml_files[[7]]), "phylo")
  expect_is(nexml_read(nexml_files[[8]]), "list")
  expect_is(nexml_read(nexml_files[[9]]), "list")
  expect_is(nexml_read(nexml_files[[10]]), "phylo")
  expect_is(nexml_read(nexml_files[[11]]), "list")
  expect_is(nexml_read(nexml_files[[12]]), "list")
  expect_is(nexml_read(nexml_files[[13]]), "phylo")
  expect_is(nexml_read(nexml_files[[14]]), "phylo")
  expect_is(nexml_read(nexml_files[[15]]), "phylo")
  expect_is(nexml_read(nexml_files[[16]]), "list")
  expect_is(nexml_read(nexml_files[[17]]), "list")
  expect_is(nexml_read(nexml_files[[18]]), "phylo")
  expect_is(nexml_read(nexml_files[[19]]), "phylo")
  expect_is(nexml_read(nexml_files[[20]]), "list")
  expect_is(nexml_read(nexml_files[[21]]), "phylo")
  expect_is(nexml_read(nexml_files[[22]]), "list")
  expect_is(nexml_read(nexml_files[[23]]), "multiPhylo")
})

# puma <- search_treebase('"Puma"', by="taxon")
# save(puma, file="~/github/ropensci/RNeXML_testfiles/puma.rda")
# ursus <- search_treebase('"Ursus"', by="taxon")
# save(ursus, file="~/github/ropensci/RNeXML_testfiles/ursus.rda")
# quercus <- search_treebase('"Quercus"', by="taxon")
# save(quercus, file="~/github/ropensci/RNeXML_testfiles/quercus.rda")

load(file="~/github/ropensci/RNeXML_testfiles/puma.rda")
load(file="~/github/ropensci/RNeXML_testfiles/ursus.rda")
load(file="~/github/ropensci/RNeXML_testfiles/quercus.rda")

context("ape files convert to class nexml correctly")
test_that("ape files convert to class nexml correctly", {
  expect_that(as(puma[[1]], "nexml"), is_a("nexml"))
  expect_that(as(puma[[2]], "nexml"), is_a("nexml"))
  expect_that(as(puma[[3]], "nexml"), is_a("nexml"))
  expect_that(as(puma[[5]], "nexml"), is_a("nexml"))
  expect_that(as(puma[[7]], "nexml"), is_a("nexml"))
  expect_that(as(puma[[9]], "nexml"), is_a("nexml"))
  expect_that(as(puma[[11]], "nexml"), is_a("nexml"))
  
  expect_that(as(ursus[[1]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[2]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[3]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[5]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[7]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[9]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[11]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[13]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[15]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[18]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[22]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[27]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[30]], "nexml"), is_a("nexml"))
  expect_that(as(ursus[[33]], "nexml"), is_a("nexml"))
  
  expect_that(as(quercus[[1]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[2]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[3]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[5]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[7]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[9]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[11]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[20]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[30]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[40]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[50]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[70]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[90]], "nexml"), is_a("nexml"))
  expect_that(as(quercus[[92]], "nexml"), is_a("nexml"))
})

context("ape files write to nexml files correctly")
test_that("ape files write to nexml files correctly, set 1", {
  nexml_write(puma[[1]], "one.xml")
  nexml_write(puma[[5]], "two.xml")
  nexml_write(puma[[9]], "three.xml")
  
  expect_is(nexml_read("~/one.xml"), "phylo")
  expect_is(nexml_read("~/two.xml"), "phylo")
  expect_is(nexml_read("~/three.xml"), "phylo")
})

test_that("ape files write to nexml files correctly, set 2", {
  nexml_write(ursus[[1]], "one_u.xml")
  nexml_write(ursus[[5]], "two_u.xml")
  nexml_write(ursus[[9]], "three_u.xml")
  nexml_write(ursus[[1]], "four_u.xml")
  nexml_write(ursus[[5]], "five_u.xml")
  nexml_write(ursus[[9]], "six_u.xml")
  
  expect_is(nexml_read("~/one_u.xml"), "phylo")
  expect_is(nexml_read("~/two_u.xml"), "phylo")
  expect_is(nexml_read("~/three_u.xml"), "phylo")
  expect_is(nexml_read("~/four_u.xml"), "phylo")
  expect_is(nexml_read("~/five_u.xml"), "phylo")
  expect_is(nexml_read("~/six_u.xml"), "phylo")
})

test_that("ape files write to nexml files correctly, set 3", {
  nexml_write(quercus[[1]], "one_q.xml")
  nexml_write(quercus[[5]], "two_q.xml")
  nexml_write(quercus[[9]], "three_q.xml")
  nexml_write(quercus[[1]], "four_q.xml")
  nexml_write(quercus[[5]], "five_q.xml")
  nexml_write(quercus[[9]], "six_q.xml")
  
  expect_is(as(nexml_read("~/one_q.xml"), "phylo"), "phylo")
  expect_is(as(nexml_read("~/two_q.xml"), "phylo"), "phylo")
  expect_is(as(nexml_read("~/three_q.xml"), "phylo"), "phylo")
  expect_is(as(nexml_read("~/four_q.xml"), "phylo"), "phylo")
  expect_is(as(nexml_read("~/five_q.xml"), "phylo"), "phylo")
  expect_is(as(nexml_read("~/six_q.xml"), "phylo"), "phylo")
})
