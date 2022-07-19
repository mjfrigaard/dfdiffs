## code to prepare `master15` dataset goes here
library(readxl)

master15 <- readxl::read_excel(
  path = "inst/extdata/xlsx/lahman_compare.xlsx",
  sheet = "master-2015")

usethis::use_data(master15, overwrite = TRUE)
