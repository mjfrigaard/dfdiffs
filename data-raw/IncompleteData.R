## code to prepare `IncompleteData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

IncompleteData <- tibble::tribble(
     ~subject, ~record,  ~start_date,    ~mid_date,    ~end_date,                                          ~text_var, ~factor_var,
          "A",      1L, "2021-12-28", "2022-01-27", "2022-02-26",           "Vital signs recorded at screening visit.",  "vitals",
          "B",      1L, "2021-12-26", "2022-01-25", "2022-02-24",     "Laboratory sample collected for hematology panel.",      "labs",
          "B",      2L, "2021-12-26", "2022-01-25", "2022-02-24",              "ECG performed during screening assessment.",     "ecg",
          "A",      3L, "2021-12-28", "2022-01-27", "2022-02-26",            "Vital signs recorded at follow-up visit.",   "vitals",
          "D",      2L, "2021-12-27", "2022-01-26", "2022-02-25",   "Laboratory sample collected for chemistry panel.",  "labs",
  ) %>%
  # convert to date
  dplyr::mutate(across(.cols = contains("date"), .fns = lubridate::ymd))

IncompleteData <- tibble::as_tibble(IncompleteData)

usethis::use_data(IncompleteData, overwrite = TRUE)
