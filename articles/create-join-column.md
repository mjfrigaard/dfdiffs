# create-join-column

## Motivation

This vignette walks through the
[`create_join_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_join_column.md)
function, which creates new columns in the `dfdiffs` Shiny application.

``` r

library(dfdiffs)
library(shiny)
library(data.table)
library(stringr)
library(lubridate)
library(glue)
library(purrr)
library(reactable)
library(haven)
library(readxl)
library(janitor) # compare_df_cols
library(arsenal) # comparedf
library(diffdf)  # diffdf
library(testthat) # expect_equal
library(vetr) # alike
```

### create_join_column()

This function allows us to create a new ‘join’ column from any number of
column inputs.

``` r

create_join_column(df, by_colums, new_by_column_name)
```

### Call structure

[`create_join_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_join_column.md)
doesn’t call any other `dfdiffs` functions. Inside the Shiny app, it’s
called by the select module
([`mod_select_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_select_server.md))
to build the `join_column` from the columns chosen in the *Select Join
Columns* panel. The call tree below was generated from the package
source with [stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "mod_select_server")
```

    █─mod_select_server
    └─create_join_column

### Test data

We’ll load some test data from the synthetic (not real) `dfdiffs` site
roster (see
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md))
to demonstrate how this function works.

#### Roster pull (2021)

Below is the 2021 roster pull.

``` r

roster2021_files <- "../inst/extdata/csv/site-roster/2021/"
fs::dir_tree(roster2021_files)
#> ../inst/extdata/csv/site-roster/2021/
#> ├── Enroll.csv
#> ├── Name.csv
#> ├── Roster.csv
#> └── Visit.csv
```

``` r

roster2021_csv_paths <- list.files(
  path = roster2021_files,
  full.names = TRUE,
  pattern = ".csv$")
roster2021_path <- roster2021_csv_paths[grepl(pattern = "Roster", roster2021_csv_paths)]
roster_2021 <- data.table::fread(input = roster2021_path)
str(roster_2021)
#> Classes 'data.table' and 'data.frame':   200 obs. of  11 variables:
#> $ subject_id : chr "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#> $ first_name : chr "Jamie" "Riley" "Rowan" "Reese" ...
#> $ last_name : chr "Nguyen" "Jensen" "Singh" "Diaz" ...
#> $ site_id : chr "SITE-07" "SITE-01" "SITE-07" "SITE-04" ...
#> $ enroll_year : int 2021 2021 2021 2021 2021 2021 2021 2021 2021 2021 ...
#> $ enroll_month : int 5 10 10 6 2 1 4 11 7 7 ...
#> $ enroll_day : int 15 5 28 9 19 18 16 13 14 15 ...
#> $ height_cm : num 170 166 174 165 180 ...
#> $ full_name : chr "Jamie Nguyen" "Riley Jensen" "Rowan Singh" "Reese Diaz"
#>    ...
#> $ first_visit_date: IDate, format: "2021-05-15" "2021-10-05" ...
#> $ status : chr "Active" "Active" "Active" "Active" ...
#> - attr(*, ".internal.selfref")=<pointer: 0x559396bfdf00>
```

#### Roster pull (2022)

Below is the 2022 roster pull.

``` r

roster2022_files <- "../inst/extdata/csv/site-roster/2022/"
fs::dir_tree(roster2022_files)
#> ../inst/extdata/csv/site-roster/2022/
#> ├── Enroll.csv
#> ├── Name.csv
#> ├── Roster.csv
#> └── Visit.csv
```

``` r

roster2022_csv_paths <- list.files(path = roster2022_files,
                                    full.names = TRUE,
                                    pattern = ".csv$")
roster2022_path <- roster2022_csv_paths[grepl(pattern = "Roster", roster2022_csv_paths)]
roster_2022 <- data.table::fread(input = roster2022_path)
str(roster_2022)
#> Classes 'data.table' and 'data.frame':   237 obs. of  11 variables:
#> $ subject_id : chr "SUBJ-0001" "SUBJ-0002" "SUBJ-0003" "SUBJ-0004" ...
#> $ first_name : chr "Jamie" "Riley" "Rowan" "Reese" ...
#> $ last_name : chr "Nguyen" "Jensen" "Singh" "Diaz" ...
#> $ site_id : chr "SITE-07" "SITE-01" "SITE-07" "SITE-04" ...
#> $ enroll_year : int 2021 2021 2021 2021 2021 2021 2021 2021 2021 2021 ...
#> $ enroll_month : int 5 10 10 6 1 4 11 7 7 10 ...
#> $ enroll_day : int 15 5 28 9 18 16 13 14 15 23 ...
#> $ height_cm : num 170 166 174 165 171 ...
#> $ full_name : chr "Jamie Nguyen" "Riley Jensen" "Rowan Singh" "Reese Diaz"
#>    ...
#> $ first_visit_date: IDate, format: "2021-05-15" "2021-10-05" ...
#> $ status : chr "Active" "Active" "Active" "Active" ...
#> - attr(*, ".internal.selfref")=<pointer: 0x559396bfdf00>
```

Assume we want to create a new join column that identifies unique rows
by `first_name`, `last_name`, and `enroll_year`.

``` r

join_roster_2021 <- create_join_column(df = roster_2021,
  by_colums = c("first_name", "last_name", "enroll_year"),
  new_by_column_name = "name_year_id")

join_roster_2022 <- create_join_column(df = roster_2022,
  by_colums = c("first_name", "last_name", "enroll_year"),
  new_by_column_name = "name_year_id")

anti_join_base(
  # return all rows from join_roster_2021 WITHOUT a match in join_roster_2022
  x = join_roster_2021,
  y = join_roster_2022,
  by = "name_year_id") |> str()
#> 'data.frame':    2 obs. of  12 variables:
#> $ name_year_id : chr "Jamie-Singh-2021" "Skyler-Kim-2021"
#> $ subject_id : chr "SUBJ-0005" "SUBJ-0150"
#> $ first_name : chr "Jamie" "Skyler"
#> $ last_name : chr "Singh" "Kim"
#> $ site_id : chr "SITE-03" "SITE-02"
#> $ enroll_year : int 2021 2021
#> $ enroll_month : int 2 11
#> $ enroll_day : int 19 16
#> $ height_cm : num 180 157
#> $ full_name : chr "Jamie Singh" "Skyler Kim"
#> $ first_visit_date: IDate, format: "2021-02-19" "2021-11-16"
#> $ status : chr "Active" "Active"
```

These are the rows in `join_roster_2021` that aren’t in
`join_roster_2022`.
