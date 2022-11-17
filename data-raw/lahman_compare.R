## code to prepare `lahman_compare` dataset goes here
# create Lahman workbook --------------------------------------------------
library(purrr)
library(vroom)
library(dplyr)
library(openxlsx)
library(lubridate)
library(readxl)

lahman_compare_wb <- openxlsx::createWorkbook()
# fs::dir_tree("inst/extdata/csv/2015-baseballdatabank")
master_2015_raw <- vroom::vroom(file = "inst/extdata/csv/2015-baseballdatabank/Master.csv")
master_2015 <- mutate(master_2015_raw,
  debut = lubridate::as_date(debut),
  finalGame = lubridate::as_date(finalGame),
  debut = as.character(debut),
  finalGame = as.character(finalGame)
  )
# glimpse(master_2015)
# fs::dir_tree("inst/extdata/csv/2020-baseballdatabank")
master_2020_raw <- vroom::vroom(file = "inst/extdata/csv/2020-baseballdatabank/People.csv")
master_2020 <- dplyr::mutate(master_2020_raw,
  debut = lubridate::as_date(debut),
  finalGame = lubridate::as_date(finalGame),
  debut = base::as.character(debut),
  finalGame = base::as.character(finalGame)
  )
# glimpse(master_2020)
intersecting_names <- dplyr::intersect(x = colnames(master_2015),
                                y = colnames(master_2020))
master_match_2015 <- dplyr::select(master_2015, all_of(intersecting_names))
master_match_2020 <- dplyr::select(master_2020, all_of(intersecting_names))




lahman_compare <- list("master-2015" = master_match_2015,
                       "master-2020" = master_match_2020)

usethis::use_data(lahman_compare, overwrite = TRUE)

# openxlsx::addWorksheet(lahman_compare_wb,
#                        sheetName = "master-2015",
#                        gridLines = FALSE)
# openxlsx::addWorksheet(lahman_compare_wb,
#                        sheetName = "master-2020",
#                        gridLines = FALSE)
# openxlsx::writeDataTable(lahman_compare_wb,
#                          sheet = "master-2015",
#                          x = master_match_2015,
#                          colNames = TRUE,
#                          rowNames = FALSE,
#                          withFilter = FALSE)
# openxlsx::writeDataTable(lahman_compare_wb,
#                          sheet = "master-2020",
#                          x = master_match_2020,
#                          colNames = TRUE,
#                          rowNames = FALSE,
#                          withFilter = FALSE)
# openxlsx::saveWorkbook(wb = lahman_compare_wb,
#                        file = "inst/extdata/xlsx/lahman_compare.xlsx",
#                        overwrite = TRUE)
