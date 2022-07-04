## code to prepare `master20` dataset goes here
library(readxl)
master20 <- readxl::read_excel(
  path = "inst/extdata/xlsx/lahman_compare.xlsx",
  sheet = "master-2020")
usethis::use_data(master20, overwrite = TRUE)
