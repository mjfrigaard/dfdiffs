# Compare the column structure of two data frames

Base-R column/variable structure diff, similar to the variable summary
PROC COMPARE reports before comparing any values. Works on its own,
independent of the Shiny app.

## Usage

``` r
compare_columns(base, compare)
```

## Arguments

- base:

  a data.frame or tibble

- compare:

  a data.frame or tibble

## Value

a `dfdiffs_column_diff` object: a list with `base_only` (columns only in
`base`), `compare_only` (columns only in `compare`), and `common`
(columns in both), each a character vector

## Examples

``` r
Roster2021 <- dfdiffs::Roster2021
Roster2022 <- dfdiffs::Roster2022
compare_columns(base = Roster2021, compare = Roster2022)
#> <dfdiffs column diff>
#>   common to both: 11
#>     subject_id, first_name, last_name, site_id, enroll_year, enroll_month, enroll_day, height_cm, full_name, first_visit_date, status 
#>   base only: 0
#>   compare only: 0
```
