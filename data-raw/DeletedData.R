## code to prepare `DeletedData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

DeletedData <- tibble::tribble(
     ~subject, ~record,  ~start_date,    ~mid_date,    ~end_date,                                          ~text_var, ~factor_var,
          "A",      2L, "2021-12-28", "2022-01-27", "2022-02-26",           "Mark the spot with a sign painted red.",     "state",
          "C",      1L, "2021-12-30", "2022-01-29", "2022-02-28",           "It's easy to tell the depth of a well.",     "grant",
          "B",      3L, "2021-12-26", "2022-01-25", "2022-02-24",              "A blue crane is a tall wading bird.",      "shut",
          "D",      1L, "2021-12-27", "2022-01-26", "2022-02-25",  "The sky that morning was clear and bright blue.",      "tape",
  ) %>%
  # convert to date
  mutate(across(.cols = contains("date"), .fns = lubridate::ymd)) %>%
  dplyr::arrange(subject)

DeletedData <- as_tibble(DeletedData)

usethis::use_data(DeletedData, overwrite = TRUE)
