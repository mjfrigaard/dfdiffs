## code to prepare `NewData` dataset goes here
library(tibble)
library(dplyr)
library(lubridate)
NewData <- data.frame(
  stringsAsFactors = FALSE,
           subject = c("D", "B", "A"),
            record = c("5", "4", "2"),
        start_date = c("2022-04-04", "2022-04-02", "2022-04-04"),
          mid_date = c("2022-04-13", "2022-04-14", "2022-04-15"),
          end_date = c("2022-04-22", "2022-04-20", "2022-04-21"),
             text_var = c("Four hours of steady work faced us.",
                          "The hogs were fed chopped corn and garbage.",
               "The box was thrown beside the parked truck."),
        factor_var = c("associate", "encourage", "pension")
   ) %>%
  mutate(across(.cols = contains("date"), .fns = lubridate::ymd))

NewData <- tibble::as_tibble(NewData)

usethis::use_data(NewData, overwrite = TRUE)
