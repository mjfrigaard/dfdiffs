#' T1Data (simulated 'time-point 1' data for checking 'new data')
#'
#' A dataset containing six rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 6 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-6)}
#'   \item{start_date}{a beginning date (from 2022-01-25 to 2022-01-30)}
#'   \item{mid_date}{a middle date (from 2022-03-15 to 2022-03-20)}
#'   \item{end_date}{a last date (from 2022-03-25 to 2022-03-31)}
#'   \item{text_var}{a variable containing random text}
#'   \item{factor_var}{a categorical variable formatted as a factor}
#' }
"T1Data"

#' T2Data (simulated 'time-point 2' data for checking new data)
#'
#' A dataset containing nine rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 9 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-6)}
#'   \item{start_date}{a beginning date (from 2022-01-25 to 2022-04-22)}
#'   \item{mid_date}{a middle date (from 2022-03-15 to 2022-04-15)}
#'   \item{end_date}{a last date (from 2022-03-25 to 2022-04-22)}
#'   \item{text_var}{a variable containing random text}
#'   \item{factor_var}{a categorical variable formatted as a factor}
#' }
"T2Data"

#' NewData (difference between 'time-point 1' & 'time-point 2' data)
#'
#' A dataset containing three rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 3 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "D")}
#'   \item{record}{A numeric record ID (2, 4, 5)}
#'   \item{start_date}{a beginning date (from 2022-04-02 to 2022-04-04)}
#'   \item{mid_date}{a middle date (from 2022-04-13 to 2022-04-15)}
#'   \item{end_date}{a last date (from 2022-04-20 to 2022-04-22)}
#'   \item{text_var}{a variable containing random text}
#'   \item{factor_var}{a categorical variable formatted as a factor}
#' }
"NewData"

#' Complete Data (simulated data for checking 'deleted data')
#'
#' A dataset containing nine rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 9 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-3)}
#'   \item{start_date}{a beginning date (from 2021-12-26 to 2021-12-30)}
#'   \item{mid_date}{a middle date (from 2022-01-25 to 2022-01-29)}
#'   \item{end_date}{a last date (from 2022-02-24 to 2022-02-28)}
#'   \item{text_var}{a variable containing random text}
#'   \item{factor_var}{a categorical variable formatted as a factor}
#' }
"CompleteData"

#' Incomplete Data (simulated data for checking deleted data)
#'
#' A dataset containing five rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 9 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-3)}
#'   \item{start_date}{a beginning date (from 2021-12-26 to 2021-12-28)}
#'   \item{mid_date}{a middle date (from 2022-01-25 to 2022-01-27)}
#'   \item{end_date}{a last date (from 2022-02-24 to 2022-02-26)}
#'   \item{text_var}{a variable containing random text}
#'   \item{factor_var}{a categorical variable formatted as a factor}
#' }
"IncompleteData"

#' Deleted Data (simulated data for checking deleted data)
#'
#' A dataset containing four rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 9 rows and 7 variables:
#' \describe{
#'   \item{subject}{A character ID variable ("A", "B", "C", "D")}
#'   \item{record}{A numeric record ID (1-3)}
#'   \item{start_date}{a beginning date (from 2021-12-26 to 2021-12-30)}
#'   \item{mid_date}{a middle date (from 2022-01-25 to 2022-01-29)}
#'   \item{end_date}{a last date (from 2022-02-24 to 2022-02-28)}
#'   \item{text_var}{a variable containing random text}
#'   \item{factor_var}{a categorical variable formatted as a factor}
#' }
"DeletedData"

#' Changed/Modified Initial Data (simulated data for checking modified data)
#'
#' A dataset containing five rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 5 rows and 7 variables:
#' \describe{
#'   \item{subject_id}{A character ID variable ("A", "B", "C")}
#'   \item{record}{A numeric record ID (1-5)}
#'   \item{text_value_a}{a variable containing random text}
#'   \item{text_value_b}{a variable containing random text}
#'   \item{created_date}{a beginning date (from 2021-07-16  to 2021-08-24)}
#'   \item{updated_date}{a middle date (from 2021-09-02 to 2021-10-03)}
#'   \item{entered_date}{a last date (from 2021-08-18 to 2021-10-29)}
#' }
"InitialData"

#' Changed/Modified Current Data (simulated data for checking modified data)
#'
#' A dataset containing five rows and seven columns. The variables are as
#' follows:
#'
#' @format A data frame with 5 rows and 7 variables:
#' \describe{
#'   \item{subject_id}{A character ID variable ("A", "B", "C")}
#'   \item{record}{A numeric record ID (1-5)}
#'   \item{text_value_a}{a variable containing random text}
#'   \item{text_value_b}{a variable containing random text}
#'   \item{created_date}{a beginning date (from 2021-07-16  to 2021-08-24)}
#'   \item{updated_date}{a middle date (from 2021-10-03 to 2021-11-27)}
#'   \item{entered_date}{a last date (from 2021-11-11 to 2021-11-30)}
#' }
"ChangedData"
