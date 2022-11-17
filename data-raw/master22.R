## code to prepare `master22` dataset goes here
library(vroom)
master22 <- vroom::vroom("inst/extdata/csv/2020-baseballdatabank/People.csv")
max(master22$debut, na.rm = TRUE)
usethis::use_data(master22, overwrite = TRUE)
