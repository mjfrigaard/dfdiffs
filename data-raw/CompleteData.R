## code to prepare `CompleteData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

CompleteData <- tibble::tribble(
     ~subject, ~record,  ~start_date,    ~mid_date,    ~end_date,                                          ~text_var, ~factor_var,
          "A",      1L, "2021-12-28", "2022-01-27", "2022-02-26",         "The copper bowl shone in the sun's rays.",  "interest",
          "A",      2L, "2021-12-28", "2022-01-27", "2022-02-26",           "Mark the spot with a sign painted red.",     "state",
          "B",      1L, "2021-12-26", "2022-01-25", "2022-02-24",              "Take a chance and win a china doll.",      "sure",
          "B",      2L, "2021-12-26", "2022-01-25", "2022-02-24",            "A cramp is no small danger on a swim.",     "white",
          "C",      1L, "2021-12-30", "2022-01-29", "2022-02-28",           "It's easy to tell the depth of a well.",     "grant",
          "D",      1L, "2021-12-27", "2022-01-26", "2022-02-25",  "The sky that morning was clear and bright blue.",      "tape",
          "A",      3L, "2021-12-28", "2022-01-27", "2022-02-26", "Wake and rise, and step into the green outdoors.",   "situate",
          "B",      3L, "2021-12-26", "2022-01-25", "2022-02-24",              "A blue crane is a tall wading bird.",      "shut",
          "D",      2L, "2021-12-27", "2022-01-26", "2022-02-25",            "Say it slow!y but make it ring clear.",  "document"
  ) %>%
  # convert to date
  dplyr::mutate(across(.cols = contains("date"), .fns = lubridate::ymd))

CompleteData <- tibble::as_tibble(CompleteData)

usethis::use_data(CompleteData, overwrite = TRUE)
