## code to prepare `master21` dataset goes here
library(vroom)
library(dplyr)
library(lubridate)
master <- vroom::vroom("inst/extdata/csv/2020-baseballdatabank/People.csv")
master21 <- filter(master, debut < lubridate::as_date("2021-01-01"))
# max(master21$debut, na.rm = TRUE)
usethis::use_data(master21, overwrite = TRUE)
