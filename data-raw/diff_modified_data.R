## code to prepare `diff_modified_data` dataset goes here
library(tibble)
library(dplyr)

# diffs -------------------------------------------------------------------
diff_current_raw <- readr::read_csv(file = "./inst/extdata/csv/diffs/diff_current.csv")
# change subject
diff_current_modified <- mutate(diff_current_raw,
  subject_id = case_when(
    SUBJECT == "1732-6009" ~ "A",
    SUBJECT == "1732-6007" ~ "B",
    SUBJECT == "0146-6002" ~ "C",
  ),
  # change recordid
  record = case_when(
    RECORDID == 85798943 ~ 1,
    RECORDID == 88770670 ~ 2,
    RECORDID == 85690761 ~ 3,
    RECORDID == 87951525 ~ 4,
    RECORDID == 90924312 ~ 5,
  ),
  # change aeout
  text_value_a = case_when(
    AEOUT == "Recovered/Resolved" ~ "Issue resolved"
  ),
  # change AETERM
  text_value_b = case_when(
    AETERM == "Acne" ~ "Fatigue",
    AETERM == "Rash maculo-papular" ~ "Fatigue",
    AETERM == "acneiform rash" ~ "Fever",
    AETERM == "AST Elevation" ~ "Joint pain",
    AETERM == "ALT Elevation" ~ "Joint pain, stiffness and swelling"),
  # change dates
  created_date = MINCREATED + lubridate::days(2),
  updated_date = MAXUPDATED + lubridate::days(2),
  entered_date = LASTDATAENTRY + lubridate::days(2),
  # convert to text
  created_date = as.character(created_date),
  updated_date = as.character(updated_date),
  entered_date = as.character(entered_date)) %>%
  tidyr::separate(col = created_date, into = c("created_date", "created_time"), sep = " ") %>%
  tidyr::separate(col = updated_date, into = c("updated_date", "updated_time"), sep = " ") %>%
  tidyr::separate(col = entered_date, into = c("entered_date", "entered_time"), sep = " ") %>%
  select(subject_id, SUBJECT,
    record, RECORDID,
    text_value_a, AEOUT,
    text_value_b, AETERM,
    created_date,
    created_time,
    MINCREATED,
    updated_date,
    updated_time,
    MAXUPDATED,
    entered_date,
    entered_time,
    LASTDATAENTRY)

diff_previous_raw <- readr::read_csv(file = "./inst/extdata/csv/diffs/diff_previous.csv")
diff_previous_modified <- mutate(diff_previous_raw,
  subject_id = case_when(
    SUBJECT == "1732-6009" ~ "A",
    SUBJECT == "1732-6007" ~ "B",
    SUBJECT == "0146-6002" ~ "C",
  ),
  # change recordid
  record = case_when(
    RECORDID == 85798943 ~ 1,
    RECORDID == 88770670 ~ 2,
    RECORDID == 85690761 ~ 3,
    RECORDID == 87951525 ~ 4,
    RECORDID == 90924312 ~ 5,
  ),
  # change aeout
  text_value_a = case_when(
    AEOUT == "Recovering/Resolving" ~ "Issue unresolved",
    AEOUT == "Not recovered/Not resolved" ~ "Issue resolved"
  ),
  # change AETERM
  text_value_b = case_when(
    AETERM == "Acne" ~ "Fatigue",
    AETERM == "Rash maculo-papular" ~ "Fatigue",
    AETERM == "acneiform rash" ~ "Fever",
    AETERM == "AST Elevation" ~ "Joint pain",
    AETERM == "ALT Elevation" ~ "Joint pain"),
  # change dates
  created_date = MINCREATED + lubridate::days(2),
  updated_date = MAXUPDATED + lubridate::days(2),
  entered_date = LASTDATAENTRY + lubridate::days(2),
  # convert to text
  created_date = as.character(created_date),
  updated_date = as.character(updated_date),
  entered_date = as.character(entered_date)) %>%
  tidyr::separate(col = created_date, into = c("created_date", "created_time"), sep = " ") %>%
  tidyr::separate(col = updated_date, into = c("updated_date", "updated_time"), sep = " ") %>%
  tidyr::separate(col = entered_date, into = c("entered_date", "entered_time"), sep = " ") %>%
  select(subject_id, SUBJECT,
    record, RECORDID,
    text_value_a, AEOUT,
    text_value_b, AETERM,
    created_date,
    created_time,
    MINCREATED,
    updated_date,
    updated_time,
    MAXUPDATED,
    entered_date,
    entered_time,
    LASTDATAENTRY)


# diff_modified_all_raw ------------------------------------------------------------
diff_modified_all_raw <- bind_rows(
  diff_current_modified,
  diff_previous_modified,
    .id = "source") %>%
  mutate(source = case_when(
    source == 1 ~ "current",
    source == 2 ~ "previous"
  ))


# export to inst/extdata --------------------------------------------------
write.csv(diff_modified_all_raw, file = "./inst/extdata/csv/diffs/diff_modified_all_raw.csv")


# diff_modified_data --------------------------------------------------
diff_current_modified <- select(
  diff_current_modified,
  subject_id,
  record,
  text_value_a,
  text_value_b,
  created_date,
  updated_date,
  entered_date
)

diff_previous_modified <- select(
  diff_previous_modified,
  subject_id,
  record,
  text_value_a,
  text_value_b,
  created_date,
  updated_date,
  entered_date
)

diff_modified_data <- list(
  diff_current_modified = diff_current_modified,
  diff_previous_modified = diff_previous_modified)

usethis::use_data(diff_modified_data, overwrite = TRUE)
