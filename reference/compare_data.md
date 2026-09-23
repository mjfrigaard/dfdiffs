# Compare data (create new, deleted, and changed data)

Compare data (create new, deleted, and changed data)

## Usage

``` r
compare_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

## Arguments

- compare:

  comparison data table

- base:

  base data table

- by:

  join column

- by_col:

  new join column name

- cols:

  columns to compare

## Value

list of comparison tables

## Examples

``` r
# not run
m15 <- dfdiffs::master15
m22 <- dfdiffs::master22
compare_data(compare = m22, base = m15,
    by = "playerID",
    by_col = "join",
    cols = c("nameFirst", "nameLast", "nameGiven"))
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
```
