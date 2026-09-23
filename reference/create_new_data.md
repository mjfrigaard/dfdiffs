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
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
create_new_data(compare = T2Data, base = T1Data,
                by = c('subject', 'record'),
                cols = c("text_var", "factor_var"))
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
```
