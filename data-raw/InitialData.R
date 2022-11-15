## code to prepare `InitialData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

InitialData <- tibble::tribble(
     ~subject_id, ~record,      ~text_value_a, ~text_value_b, ~created_date, ~updated_date, ~entered_date,
             "A",       1, "Issue unresolved",     "Fatigue",  "2021-07-29",  "2021-09-29",  "2021-09-29",
             "A",       2, "Issue unresolved",     "Fatigue",  "2021-07-29",  "2021-10-03",  "2021-10-29",
             "B",       3,   "Issue resolved",       "Fever",  "2021-07-16",  "2021-09-02",  "2021-08-18",
             "C",       4,   "Issue resolved",  "Joint pain",  "2021-08-24",  "2021-10-03",  "2021-10-03",
             "C",       5,   "Issue resolved",  "Joint pain",  "2021-08-24",  "2021-09-20",  "2021-10-20"
  ) %>%
  # convert to date
  dplyr::mutate(dplyr::across(.cols = contains("date"), .fns = lubridate::ymd))

InitialData <- tibble::as_tibble(InitialData)

usethis::use_data(InitialData, overwrite = TRUE)
