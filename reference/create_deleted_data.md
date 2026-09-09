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

  the joining bs4Dash::column between the two datasets

- by_col:

  name of the new joining bs4Dash::column

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
#> # A tibble: 4 × 7
#>   subject record start_date mid_date   end_date   text_var            factor_var
#>   <chr>   <chr>  <chr>      <chr>      <chr>      <chr>               <chr>     
#> 1 A       2      2021-12-28 2022-01-27 2022-02-26 Mark the spot with… state     
#> 2 C       1      2021-12-30 2022-01-29 2022-02-28 It's easy to tell … grant     
#> 3 D       1      2021-12-27 2022-01-26 2022-02-25 The sky that morni… tape      
#> 4 B       3      2021-12-26 2022-01-25 2022-02-24 A blue crane is a … shut      
```
