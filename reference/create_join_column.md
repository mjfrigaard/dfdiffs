# Create unique row identifier

Create unique row identifier

## Usage

``` r
create_join_column(df, by_colums, new_by_column_name)
```

## Arguments

- df:

  a data.frame or tibble

- by_colums:

  columns to uniquely identify a row

- new_by_column_name:

  the new column name

## Value

join_col_data

## Examples

``` r
# using dfdiffs::InitialData
InitialData <- dfdiffs::InitialData
create_join_column(df = InitialData,
                    by_colums = c('subject_id', 'record'),
                    new_by_column_name = 'join_var')
#>   join_var subject_id record     text_value_a text_value_b created_date
#> 1      A-1          A      1 Issue unresolved      Fatigue   2021-07-29
#> 2      A-2          A      2 Issue unresolved      Fatigue   2021-07-29
#> 3      B-3          B      3   Issue resolved        Fever   2021-07-16
#> 4      C-4          C      4   Issue resolved   Joint pain   2021-08-24
#> 5      C-5          C      5   Issue resolved   Joint pain   2021-08-24
#>   updated_date entered_date
#> 1   2021-09-29   2021-09-29
#> 2   2021-10-03   2021-10-29
#> 3   2021-09-02   2021-08-18
#> 4   2021-10-03   2021-10-03
#> 5   2021-09-20   2021-10-20
```
