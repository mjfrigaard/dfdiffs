## code to prepare `teams10_15` dataset goes here
library(openxlsx)
library(readr)
library(dplyr)
T10 <- readr::read_csv("inst/extdata/csv/Teams2010.csv")
T15 <- readr::read_csv("inst/extdata/csv/Teams2015.csv")
T10 <- select(T10, yearID, lgID, teamID, franchID, Rank, W, L, name, park)
T15 <- select(T15, yearID, lgID, teamID, franchID, Rank, W, L, name, park)
# T10 <- dplyr::mutate(T10, across(where(is.logical), as.character))
# T15 <- dplyr::mutate(T15, across(where(is.logical), as.character))
# glimpse(T10)
# glimpse(T15)
wb <- createWorkbook()
addWorksheet(wb,
    sheetName = "teams-2010", gridLines = FALSE)
addWorksheet(wb,
    sheetName = "teams-2015", gridLines = FALSE)
writeDataTable(wb,
    sheet = "teams-2010", x = T10, colNames = TRUE)
writeDataTable(wb,
    sheet = "teams-2015", x = T15, colNames = TRUE)
saveWorkbook(wb, "inst/extdata/app-testing/teams10-15.xlsx",
             overwrite = TRUE)
teams10_15 <- list(
  'teams-10' = T10,
  'teams-15' = T15
)
usethis::use_data(teams10_15, overwrite = TRUE)
