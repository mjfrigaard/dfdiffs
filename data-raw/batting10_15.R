## code to prepare `teams10_15` dataset goes here
library(openxlsx)
library(readr)
library(dplyr)
B10 <- readr::read_csv("inst/extdata/csv/2010-lahman/Batting.csv")
B15 <- readr::read_csv("inst/extdata/csv/2015-baseballdatabank/Batting.csv")
B10 <- dplyr::mutate(B10, across(where(is.logical), as.character))
B15 <- dplyr::mutate(B15, across(where(is.logical), as.character))
# glimpse(T10)
# glimpse(T15)
batting10_15 <- list(
  'batting-10' = B10,
  'batting-15' = B15
)
usethis::use_data(batting10_15, overwrite = TRUE)
# wb <- createWorkbook()
# addWorksheet(wb,
#     sheetName = "batting-2010", gridLines = FALSE)
# addWorksheet(wb,
#     sheetName = "batting-2015", gridLines = FALSE)
# writeDataTable(wb,
#     sheet = "batting-2010", x = B10, colNames = TRUE)
# writeDataTable(wb,
#     sheet = "batting-2015", x = B15, colNames = TRUE)
# saveWorkbook(wb, "inst/extdata/xlsx/batting10-15.xlsx",
#              overwrite = TRUE)
