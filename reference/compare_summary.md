# Summarize a data frame comparison (PROC-COMPARE-style headline stats)

Builds a row/column/value headline summary on top of
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
and
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md)
(no comparison logic of its own), similar to the summary PROC COMPARE
prints before its detailed diff tables. Works on its own, independent of
the Shiny app.

## Usage

``` r
compare_summary(
  compare,
  base,
  by = NULL,
  by_col = NULL,
  cols = NULL,
  ignore_case = FALSE,
  trim_ws = FALSE
)
```

## Arguments

- compare:

  A 'current' or 'new' dataset (tibble or data.frame)

- base:

  A 'previous' or 'old' dataset (tibble or data.frame)

- by:

  A join column between the two datasets, or any combination of columns
  that constitute a unique row.

- by_col:

  A new name for the joining column.

- cols:

  Columns to be compared.

- ignore_case, trim_ws:

  passed to
  [`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
  for character comparisons.

## Value

a `dfdiffs_summary` object (a list of counts) with a
[`print.dfdiffs_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/print.dfdiffs_summary.md)
method for console output

## Examples

``` r
Roster2021 <- dfdiffs::Roster2021
Roster2022 <- dfdiffs::Roster2022
compare_summary(compare = Roster2022, base = Roster2021, by = "subject_id")
#> <dfdiffs comparison summary>
#>   Observations: base = 200, compare = 237
#>     common: 197 | new: 40 | deleted: 3
#>   Variables: base = 11, compare = 11 (11 common, 0 base only, 0 compare only)
#>   No unequal values found.
```
