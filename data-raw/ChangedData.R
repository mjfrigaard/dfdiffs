## code to prepare `ChangedData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

ChangedData <- tibble::tribble(
    ~subject_id, ~record,    ~text_value_a,                        ~text_value_b, ~created_date, ~updated_date, ~entered_date,
            "A",       1, "Issue resolved",                            "Fatigue",  "2021-07-29",  "2021-10-03",  "2021-11-30",
            "A",       2, "Issue resolved",                            "Fatigue",  "2021-07-29",  "2021-11-27",  "2021-11-30",
            "B",       3, "Issue resolved",                              "Fever",  "2021-07-16",  "2021-10-20",  "2021-11-21",
            "C",       4, "Issue resolved", "Joint pain, stiffness and swelling",  "2021-08-24",  "2021-10-13",  "2021-11-11",
            "C",       5, "Issue resolved",                         "Joint pain",  "2021-08-24",  "2021-10-14",  "2021-11-16"
  ) %>%
  # convert to date
  dplyr::mutate(dplyr::across(.cols = contains("date"), .fns = lubridate::ymd))

ChangedData <- tibble::as_tibble(ChangedData)

usethis::use_data(ChangedData, overwrite = TRUE)
