## code to prepare `CompleteData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

CompleteData <- tibble::tribble(
     ~subject, ~record,  ~start_date,    ~mid_date,    ~end_date,                                          ~text_var, ~factor_var,
          "A",      1L, "2021-12-28", "2022-01-27", "2022-02-26",           "Vital signs recorded at screening visit.",  "vitals",
          "A",      2L, "2021-12-28", "2022-01-27", "2022-02-26",       "Concomitant medication reported at baseline.",     "conmed",
          "B",      1L, "2021-12-26", "2022-01-25", "2022-02-24",     "Laboratory sample collected for hematology panel.",      "labs",
          "B",      2L, "2021-12-26", "2022-01-25", "2022-02-24",              "ECG performed during screening assessment.",     "ecg",
          "C",      1L, "2021-12-30", "2022-01-29", "2022-02-28",  "Physical exam completed with no abnormalities noted.",     "exam",
          "D",      1L, "2021-12-27", "2022-01-26", "2022-02-25",       "Medical history reviewed and confirmed complete.",      "history",
          "A",      3L, "2021-12-28", "2022-01-27", "2022-02-26",            "Vital signs recorded at follow-up visit.",   "vitals",
          "B",      3L, "2021-12-26", "2022-01-25", "2022-02-24",         "Concomitant medication updated at visit two.",      "conmed",
          "D",      2L, "2021-12-27", "2022-01-26", "2022-02-25",   "Laboratory sample collected for chemistry panel.",  "labs",
  ) %>%
  # convert to date
  dplyr::mutate(across(.cols = contains("date"), .fns = lubridate::ymd))

CompleteData <- tibble::as_tibble(CompleteData)

usethis::use_data(CompleteData, overwrite = TRUE)
