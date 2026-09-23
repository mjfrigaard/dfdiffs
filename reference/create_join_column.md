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
#> # A tibble: 5 × 8
#>   join_var subject_id record text_value_a text_value_b created_date updated_date
#>   <chr>    <chr>       <dbl> <chr>        <chr>        <date>       <date>      
#> 1 A-1      A               1 Issue unres… Fatigue      2021-07-29   2021-09-29  
#> 2 A-2      A               2 Issue unres… Fatigue      2021-07-29   2021-10-03  
#> 3 B-3      B               3 Issue resol… Fever        2021-07-16   2021-09-02  
#> 4 C-4      C               4 Issue resol… Joint pain   2021-08-24   2021-10-03  
#> 5 C-5      C               5 Issue resol… Joint pain   2021-08-24   2021-09-20  
#> # ℹ 1 more variable: entered_date <date>
```
