# Create a table of new records

Create a table of new records

## Usage

``` r
create_new_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
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

new_data

## Examples

``` r
# using local data
T2Data <- dfdiffs::T2Data
T1Data <- dfdiffs::T1Data
create_new_data(compare = T2Data, base = T1Data,
                by = c('subject', 'record'))
#>   join subject record start_date   mid_date   end_date
#> 3  D-5       D      5 2022-04-04 2022-04-13 2022-04-22
#> 6  B-4       B      4 2022-04-02 2022-04-14 2022-04-20
#> 9  A-2       A      2 2022-04-04 2022-04-15 2022-04-21
#>                                                 text_var factor_var
#> 3        Patient reports lower back pain after activity.  back pain
#> 6 Patient reports difficulty sleeping through the night.   insomnia
#> 9        Patient reports dry cough lasting several days.      cough
create_new_data(compare = T2Data, base = T1Data,
                by = c('subject', 'record'),
                cols = c("text_var", "factor_var"))
#>   join                                               text_var factor_var
#> 3  D-5        Patient reports lower back pain after activity.  back pain
#> 6  B-4 Patient reports difficulty sleeping through the night.   insomnia
#> 9  A-2        Patient reports dry cough lasting several days.      cough
```
