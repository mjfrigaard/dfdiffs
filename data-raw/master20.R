## code to prepare `master20` dataset goes here
library(vroom)
library(dplyr)
library(lubridate)
master <- vroom::vroom("inst/extdata/csv/2020-baseballdatabank/People.csv")
master20 <- filter(master, debut < lubridate::as_date("2020-01-01"))
# max(master20$debut, na.rm = TRUE)
usethis::use_data(master20, overwrite = TRUE)
