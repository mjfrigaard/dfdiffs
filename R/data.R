#' T1Data (simulated 'time-point 1' data for checking 'new data')
#'
#' Simulated patient-reported clinical observations recorded at the first
#' time point, used to demonstrate \code{create_new_data()}.
#'
#' @format A data frame with 6 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-6)}
#'   \item{start_date}{a beginning date (from 2022-01-25 to 2022-01-30)}
#'   \item{mid_date}{a middle date (from 2022-03-15 to 2022-03-20)}
#'   \item{end_date}{a last date (from 2022-03-25 to 2022-03-31)}
#'   \item{text_var}{a patient-reported clinical observation}
#'   \item{factor_var}{the observation's category (e.g. "headache", "fatigue")}
#' }
"T1Data"

#' T2Data (simulated 'time-point 2' data for checking new data)
#'
#' The same patient-reported observations as \code{T1Data}, plus three
#' additional rows recorded at a later time point, used to demonstrate
#' \code{create_new_data()}.
#'
#' @format A data frame with 9 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-6)}
#'   \item{start_date}{a beginning date (from 2022-01-25 to 2022-04-22)}
#'   \item{mid_date}{a middle date (from 2022-03-15 to 2022-04-15)}
#'   \item{end_date}{a last date (from 2022-03-25 to 2022-04-22)}
#'   \item{text_var}{a patient-reported clinical observation}
#'   \item{factor_var}{the observation's category (e.g. "headache", "fatigue")}
#' }
"T2Data"

#' NewData (difference between 'time-point 1' & 'time-point 2' data)
#'
#' The three observations present in \code{T2Data} but not \code{T1Data} —
#' the expected result of \code{create_new_data(compare = T2Data, base = T1Data)}.
#'
#' @format A data frame with 3 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "D")}
#'   \item{record}{A numeric record ID (2, 4, 5)}
#'   \item{start_date}{a beginning date (from 2022-04-02 to 2022-04-04)}
#'   \item{mid_date}{a middle date (from 2022-04-13 to 2022-04-15)}
#'   \item{end_date}{a last date (from 2022-04-20 to 2022-04-22)}
#'   \item{text_var}{a patient-reported clinical observation}
#'   \item{factor_var}{the observation's category (e.g. "cough", "insomnia")}
#' }
"NewData"

#' Complete Data (simulated data for checking 'deleted data')
#'
#' Simulated clinical visit records for four subjects, used to demonstrate
#' \code{create_deleted_data()}.
#'
#' @format A data frame with 9 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-3)}
#'   \item{start_date}{a beginning date (from 2021-12-26 to 2021-12-30)}
#'   \item{mid_date}{a middle date (from 2022-01-25 to 2022-01-29)}
#'   \item{end_date}{a last date (from 2022-02-24 to 2022-02-28)}
#'   \item{text_var}{a visit record description (e.g. "Vital signs recorded...")}
#'   \item{factor_var}{the record's category (e.g. "vitals", "labs", "exam")}
#' }
"CompleteData"

#' Incomplete Data (simulated data for checking deleted data)
#'
#' \code{CompleteData} with four records removed, used to demonstrate
#' \code{create_deleted_data()}.
#'
#' @format A data frame with 5 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-3)}
#'   \item{start_date}{a beginning date (from 2021-12-26 to 2021-12-28)}
#'   \item{mid_date}{a middle date (from 2022-01-25 to 2022-01-27)}
#'   \item{end_date}{a last date (from 2022-02-24 to 2022-02-26)}
#'   \item{text_var}{a visit record description (e.g. "Vital signs recorded...")}
#'   \item{factor_var}{the record's category (e.g. "vitals", "labs")}
#' }
"IncompleteData"

#' Deleted Data (simulated data for checking deleted data)
#'
#' The four records present in \code{CompleteData} but not
#' \code{IncompleteData} — the expected result of
#' \code{create_deleted_data(compare = IncompleteData, base = CompleteData)}.
#'
#' @format A data frame with 4 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-3)}
#'   \item{start_date}{a beginning date (from 2021-12-26 to 2021-12-30)}
#'   \item{mid_date}{a middle date (from 2022-01-25 to 2022-01-29)}
#'   \item{end_date}{a last date (from 2022-02-24 to 2022-02-28)}
#'   \item{text_var}{a visit record description (e.g. "Concomitant medication...")}
#'   \item{factor_var}{the record's category (e.g. "conmed", "exam", "history")}
#' }
"DeletedData"

#' Changed/Modified Initial Data (simulated data for checking modified data)
#'
#' Simulated adverse-event records for three subjects, taken before query
#' resolution, used to demonstrate \code{create_changed_data()} and
#' \code{create_modified_data()}.
#'
#' @format A data frame with 5 rows and 7 variables:
#' \describe{
#'   \item{subject_id}{A character ID variable ("A", "B", "C")}
#'   \item{record}{A numeric record ID (1-5)}
#'   \item{text_value_a}{the adverse event's resolution status ("Issue resolved"/"Issue unresolved")}
#'   \item{text_value_b}{the adverse event term (e.g. "Fatigue", "Fever", "Joint pain")}
#'   \item{created_date}{a beginning date (from 2021-07-16  to 2021-08-24)}
#'   \item{updated_date}{a middle date (from 2021-09-02 to 2021-10-03)}
#'   \item{entered_date}{a last date (from 2021-08-18 to 2021-10-29)}
#' }
"InitialData"

#' Changed/Modified Current Data (simulated data for checking modified data)
#'
#' \code{InitialData}'s adverse-event records after query resolution — some
#' values have changed, used to demonstrate \code{create_changed_data()} and
#' \code{create_modified_data()}.
#'
#' @format A data frame with 5 rows and 7 variables:
#' \describe{
#'   \item{subject_id}{A character ID variable ("A", "B", "C")}
#'   \item{record}{A numeric record ID (1-5)}
#'   \item{text_value_a}{the adverse event's resolution status ("Issue resolved"/"Issue unresolved")}
#'   \item{text_value_b}{the adverse event term (e.g. "Fatigue", "Fever", "Joint pain")}
#'   \item{created_date}{a beginning date (from 2021-07-16  to 2021-08-24)}
#'   \item{updated_date}{a middle date (from 2021-10-03 to 2021-11-27)}
#'   \item{entered_date}{a last date (from 2021-11-11 to 2021-11-30)}
#' }
"ChangedData"

#' Roster2021 (synthetic site roster, year one)
#'
#' A synthetic (not real) clinical site roster, used to demonstrate
#' \code{dfdiffs} at a larger scale than the small toy datasets above.
#' \code{Roster2021}/\code{Roster2022}/\code{Roster2023}/\code{Roster2024}
#' are four yearly pulls of the same growing roster: most subjects present
#' in one year's pull are still present the next, a few new subjects enroll
#' each year, and a handful withdraw and stop appearing. The same data is
#' also shipped as CSV files under
#' \code{system.file("extdata/csv/site-roster", package = "dfdiffs")}.
#'
#' @format A data frame with 200 rows and 11 variables:
#' \describe{
#'   \item{subject_id}{A unique character ID ("SUBJ-0001", ...)}
#'   \item{first_name}{First name}
#'   \item{last_name}{Last name}
#'   \item{site_id}{The enrolling site ("SITE-01".."SITE-08")}
#'   \item{enroll_year}{Year first enrolled (fixed per subject, not the pull year)}
#'   \item{enroll_month}{Month enrolled (1-12)}
#'   \item{enroll_day}{Day enrolled (1-28)}
#'   \item{height_cm}{Height in centimeters}
#'   \item{full_name}{\code{first_name} and \code{last_name} combined}
#'   \item{first_visit_date}{\code{enroll_year}/\code{enroll_month}/\code{enroll_day} as a date}
#'   \item{status}{Enrollment status ("Active" for every subject in every pull)}
#' }
"Roster2021"

#' Roster2022 (synthetic site roster, year two)
#'
#' \code{Roster2021} plus 40 newly enrolled subjects, minus 3 who withdrew.
#' See \code{\link{Roster2021}} for column details.
#'
#' @format A data frame with 237 rows and 11 variables (see \code{\link{Roster2021}})
"Roster2022"

#' Roster2023 (synthetic site roster, year three)
#'
#' \code{Roster2022} plus 20 newly enrolled subjects, minus 2 who withdrew.
#' See \code{\link{Roster2021}} for column details.
#'
#' @format A data frame with 255 rows and 11 variables (see \code{\link{Roster2021}})
"Roster2023"

#' Roster2024 (synthetic site roster, year four)
#'
#' \code{Roster2023} plus 20 newly enrolled subjects, no withdrawals.
#' See \code{\link{Roster2021}} for column details.
#'
#' @format A data frame with 275 rows and 11 variables (see \code{\link{Roster2021}})
"Roster2024"
