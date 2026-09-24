## code to prepare `DeletedData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

DeletedData <- tibble::tribble(
     ~subject, ~record,  ~start_date,    ~mid_date,    ~end_date,                                          ~text_var, ~factor_var,
          "A",      2L, "2021-12-28", "2022-01-27", "2022-02-26",       "Concomitant medication reported at baseline.",     "conmed",
          "C",      1L, "2021-12-30", "2022-01-29", "2022-02-28",  "Physical exam completed with no abnormalities noted.",     "exam",
          "B",      3L, "2021-12-26", "2022-01-25", "2022-02-24",         "Concomitant medication updated at visit two.",      "conmed",
          "D",      1L, "2021-12-27", "2022-01-26", "2022-02-25",       "Medical history reviewed and confirmed complete.",      "history",
  ) %>%
  # convert to date
  mutate(across(.cols = contains("date"), .fns = lubridate::ymd)) %>%
  dplyr::arrange(subject)

DeletedData <- as_tibble(DeletedData)

usethis::use_data(DeletedData, overwrite = TRUE)
