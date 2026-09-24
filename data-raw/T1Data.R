## code to prepare `T1Data` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)
T1Data <- data.frame(
  stringsAsFactors = FALSE,
           subject = c("A", "A", "B", "C", "D", "D"),
            record = c(1L, 2L, 3L, 4L, 5L, 6L),
           start_date = c("2022-01-28",
                          "2022-01-25","2022-01-26","2022-01-29","2022-01-30",
                          "2022-01-27"),
             mid_date = c("2022-03-20",
                          "2022-03-15","2022-03-19","2022-03-18","2022-03-16",
                          "2022-03-17"),
             end_date = c("2022-03-30",
                          "2022-03-29","2022-03-25","2022-03-27","2022-03-26",
                          "2022-03-31"),
             text_var = c("Patient reports mild headache after morning dose.",
                          "Patient reports occasional nausea following meals.",
                          "Patient reports persistent fatigue throughout the day.",
                          "Patient reports brief dizziness upon standing.",
                          "Patient reports mild rash on the left forearm.",
                          "Patient reports low-grade fever in the evening."),
        factor_var = c("headache", "nausea", "fatigue", "dizziness", "rash", "fever")
   ) %>%
  # convert to date
  mutate(across(.cols = contains("date"), .fns = lubridate::ymd))

T1Data <- tibble::as_tibble(T1Data)

usethis::use_data(T1Data, overwrite = TRUE)
