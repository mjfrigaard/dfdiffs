## code to prepare `IncompleteData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

IncompleteData <- tibble::tribble(
     ~subject, ~record,  ~start_date,    ~mid_date,    ~end_date,                                          ~text_var, ~factor_var,
          "A",      1L, "2021-12-28", "2022-01-27", "2022-02-26",         "The copper bowl shone in the sun's rays.",  "interest",
          "B",      1L, "2021-12-26", "2022-01-25", "2022-02-24",              "Take a chance and win a china doll.",      "sure",
          "B",      2L, "2021-12-26", "2022-01-25", "2022-02-24",            "A cramp is no small danger on a swim.",     "white",
          "A",      3L, "2021-12-28", "2022-01-27", "2022-02-26", "Wake and rise, and step into the green outdoors.",   "situate",
          "D",      2L, "2021-12-27", "2022-01-26", "2022-02-25",            "Say it slow!y but make it ring clear.",  "document"
  ) %>%
  # convert to date
  dplyr::mutate(across(.cols = contains("date"), .fns = lubridate::ymd))

IncompleteData <- tibble::as_tibble(IncompleteData)

usethis::use_data(IncompleteData, overwrite = TRUE)
