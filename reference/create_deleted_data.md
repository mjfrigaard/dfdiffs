# Create a dataset of deleted records

Create a dataset of deleted records

## Usage

``` r
create_deleted_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

## Arguments

- compare:

  a 'new' or 'current' dataset

- base:

  an 'old' or 'previous' dataset

- by:

  the joining column between the two datasets

- by_col:

  name of the new joining column

- cols:

  names of columns to compare

## Value

deleted_data

## Examples

``` r
# using local data
CompleteData <- dfdiffs::CompleteData
IncompleteData <- dfdiffs::IncompleteData
create_deleted_data(compare = IncompleteData,
                    base = CompleteData)
#>   subject record start_date   mid_date   end_date
#> 2       A      2 2021-12-28 2022-01-27 2022-02-26
#> 5       C      1 2021-12-30 2022-01-29 2022-02-28
#> 6       D      1 2021-12-27 2022-01-26 2022-02-25
#> 8       B      3 2021-12-26 2022-01-25 2022-02-24
#>                                               text_var factor_var
#> 2         Concomitant medication reported at baseline.     conmed
#> 5 Physical exam completed with no abnormalities noted.       exam
#> 6     Medical history reviewed and confirmed complete.    history
#> 8         Concomitant medication updated at visit two.     conmed
```
