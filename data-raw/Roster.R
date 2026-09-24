## code to prepare `Roster2021`/`Roster2022`/`Roster2023`/`Roster2024` and
## their inst/extdata/csv/site-roster/<year>/ exports.
##
## These four datasets are a synthetic (not real) "clinical site roster"
## that grows across four yearly pulls, replacing the real Sean Lahman
## baseball-archive data previously used for the large-scale/multi-file
## comparison demos (compare-data, create-comparison-report,
## create-join-column, upload-data, multiple-comparisons vignettes).
library(tibble)
library(dplyr)
library(readr)
library(fs)

set.seed(2021)

first_names <- c(
  "Alex", "Jordan", "Taylor", "Morgan", "Casey", "Riley", "Jamie", "Drew",
  "Cameron", "Reese", "Avery", "Quinn", "Skyler", "Rowan", "Emerson", "Hayden"
)
last_names <- c(
  "Bennett", "Carter", "Diaz", "Foster", "Grant", "Hayes", "Irwin", "Jensen",
  "Kim", "Lopez", "Moore", "Nguyen", "Ortiz", "Patel", "Reyes", "Singh"
)
sites <- sprintf("SITE-%02d", 1:8)

# one fixed attribute pool for every subject_id that will ever appear, so a
# subject's name/site/enrollment date stay the SAME in every snapshot they
# appear in (enroll_year is when they first enrolled, not the pull year)
n_pool <- 280
enroll_year_for_id <- function(id) {
  dplyr::case_when(
    id <= 200 ~ 2021L,
    id <= 240 ~ 2022L,
    id <= 260 ~ 2023L,
    TRUE ~ 2024L
  )
}
pool <- tibble::tibble(
  subject_id = sprintf("SUBJ-%04d", seq_len(n_pool)),
  first_name = sample(first_names, n_pool, replace = TRUE),
  last_name = sample(last_names, n_pool, replace = TRUE),
  site_id = sample(sites, n_pool, replace = TRUE),
  enroll_year = enroll_year_for_id(seq_len(n_pool)),
  enroll_month = sample(1:12, n_pool, replace = TRUE),
  enroll_day = sample(1:28, n_pool, replace = TRUE),
  height_cm = round(rnorm(n_pool, mean = 170, sd = 10), 1)
) |>
  dplyr::mutate(
    full_name = paste(first_name, last_name),
    first_visit_date = as.Date(sprintf(
      "%d-%02d-%02d", enroll_year, enroll_month, enroll_day
    ))
  )

# ids present in each snapshot: grows each year, with a few withdrawals
ids_2021 <- 1:200
ids_2022 <- setdiff(c(ids_2021, 201:240), c(5, 50, 150))
ids_2023 <- setdiff(c(ids_2022, 241:260), c(80, 175))
ids_2024 <- c(ids_2023, 261:280)

snapshot <- function(ids) {
  out <- pool[ids, ]
  out$status <- "Active"
  tibble::as_tibble(out)
}

Roster2021 <- snapshot(ids_2021)
Roster2022 <- snapshot(ids_2022)
Roster2023 <- snapshot(ids_2023)
Roster2024 <- snapshot(ids_2024)

usethis::use_data(Roster2021, overwrite = TRUE)
usethis::use_data(Roster2022, overwrite = TRUE)
usethis::use_data(Roster2023, overwrite = TRUE)
usethis::use_data(Roster2024, overwrite = TRUE)

# ---- CSV exports for the vignettes that read files directly ----
write_year_files <- function(roster, year) {
  dir <- file.path("inst/extdata/csv/site-roster", year)
  fs::dir_create(dir)
  readr::write_csv(roster, file.path(dir, "Roster.csv"))
  readr::write_csv(
    dplyr::select(roster, subject_id, enroll_year, enroll_month, enroll_day),
    file.path(dir, "Enroll.csv")
  )
  readr::write_csv(
    dplyr::select(roster, subject_id, first_visit_date),
    file.path(dir, "Visit.csv")
  )
  readr::write_csv(
    dplyr::select(roster, subject_id, full_name),
    file.path(dir, "Name.csv")
  )
}

write_year_files(Roster2021, "2021")
write_year_files(Roster2022, "2022")
write_year_files(Roster2023, "2023")
write_year_files(Roster2024, "2024")

# small tsv/txt fixtures (replaces the old Batting/Fielding/People Lahman copies)
readr::write_tsv(Roster2021[1:10, ], "inst/extdata/tsv/Enroll.tsv")
readr::write_delim(Roster2021[1:10, ], "inst/extdata/txt/Enroll.txt", delim = "\t")
