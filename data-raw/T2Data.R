## code to prepare `T2Data` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)

T2Data <- data.frame(
  stringsAsFactors = FALSE,
           subject = c("A", "A", "B", "C", "D", "D", "A", "B", "D"),
            record = c(1L, 2L, 3L, 4L, 5L, 6L, 2L, 4L, 5L),
        start_date = c("2022-01-28","2022-01-25",
                       "2022-01-26","2022-01-29","2022-01-30","2022-01-27",
                       "2022-04-04","2022-04-02","2022-04-04"),
          mid_date = c("2022-03-20","2022-03-15",
                       "2022-03-19","2022-03-18","2022-03-16","2022-03-17",
                       "2022-04-15","2022-04-14","2022-04-13"),
          end_date = c("2022-03-30","2022-03-29",
                       "2022-03-25","2022-03-27","2022-03-26","2022-03-31",
                       "2022-04-21","2022-04-20","2022-04-22"),
          text_var = c("Patient reports mild headache after morning dose.",
                       "Patient reports occasional nausea following meals.",
                       "Patient reports persistent fatigue throughout the day.",
                       "Patient reports brief dizziness upon standing.",
                       "Patient reports mild rash on the left forearm.",
                       "Patient reports low-grade fever in the evening.",
                       "Patient reports dry cough lasting several days.",
                       "Patient reports difficulty sleeping through the night.",
                       "Patient reports lower back pain after activity."),
        factor_var = c("headache","nausea","fatigue",
                       "dizziness","rash","fever","cough",
                       "insomnia","back pain")) %>%
  # convert to date
  dplyr::mutate(dplyr::across(.cols = contains("date"), .fns = lubridate::ymd)) %>%
  dplyr::arrange(desc(subject))
T2Data <- tibble::as_tibble(T2Data)
usethis::use_data(T2Data, overwrite = TRUE)
