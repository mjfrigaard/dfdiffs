## code to prepare `lahman500` dataset goes here

# packages ------------------------------------------
library(shiny)
library(dfdiffs)
library(purrr)
library(vroom)
library(reactable)
library(tidyverse)
library(openxlsx)
library(haven)
library(readxl)
library(Lahman)
library(fivethirtyeight)


# create Lahman workbook --------------------------------------------------
lahman_wb <- createWorkbook()

# create lahman datasets
# People ------------------------------------------------------------------
People <- Lahman::People
People500 <- dplyr::slice_sample(
  .data = People,
  n = 500,
  replace = FALSE
)
addWorksheet(lahman_wb,
  sheetName = "People500",
  gridLines = FALSE
)
writeDataTable(lahman_wb,
  sheet = "People500",
  x = People500, colNames = TRUE,
  rowNames = FALSE, withFilter = FALSE
)


# Pitching ----------------------------------------------------------------
Pitching <- Lahman::Pitching
Pitching500 <- dplyr::slice_sample(
  .data = Pitching,
  n = 500,
  replace = FALSE
)
addWorksheet(lahman_wb,
  sheetName = "Pitching500",
  gridLines = FALSE
)
writeDataTable(lahman_wb,
  sheet = "Pitching500",
  x = Pitching500, colNames = TRUE,
  rowNames = FALSE, withFilter = FALSE
)


# Batting -----------------------------------------------------------------
Batting <- Lahman::Batting
Batting500 <- dplyr::slice_sample(
  .data = Pitching,
  n = 500,
  replace = FALSE
)
addWorksheet(lahman_wb, sheetName = "Batting500", gridLines = FALSE)
writeDataTable(lahman_wb,
  sheet = "Batting500", x = Batting500, colNames = TRUE,
  rowNames = FALSE, withFilter = FALSE
)



# Teams -------------------------------------------------------------------
Teams <- Lahman::Teams
Teams500 <- dplyr::slice_sample(.data = Teams,
                                n = 500,
                                replace = FALSE)
addWorksheet(
        lahman_wb,
        sheetName = "Teams500",
        gridLines = FALSE)

writeDataTable(lahman_wb,
  sheet = "Teams500", x = Teams500,
  colNames = TRUE, rowNames = FALSE,
  withFilter = FALSE)



# Salaries ----------------------------------------------------------------
Salaries <- Lahman::Salaries
Salaries500 <- dplyr::slice_sample(
  .data = Salaries,
  n = 500,
  replace = FALSE
)
addWorksheet(
  lahman_wb,
  sheetName = "Salaries500",
  gridLines = FALSE)
writeDataTable(lahman_wb,
  sheet = "Salaries500",
  x = Salaries500, colNames = TRUE,
  rowNames = FALSE, withFilter = FALSE
)
# export xlsx -------------------------------------------------------------
saveWorkbook(lahman_wb, "./inst/extdata/xlsx/lahman500.xlsx", overwrite = TRUE)

lahman500 <- list(
  'People500' = People500,
  'Pitching' = Pitching,
  'Batting500' = Batting500,
  'Teams500' = Teams500,
  'Salaries500' = Salaries500
)
usethis::use_data(lahman500, overwrite = TRUE)





