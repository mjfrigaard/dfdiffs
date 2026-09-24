# Compare matched rows of two data frames by key (base R)

Base-R replacement for
[`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html).
Matches `base` and `compare` rows on `by`, then compares every other
shared column row-by-row with
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md).
With `by = NULL`, rows are matched by position instead (matching
[`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)'s
own behavior when `keys` is unset).

## Usage

``` r
diff_values_by_key(
  base,
  compare,
  by = NULL,
  tolerance = sqrt(.Machine$double.eps),
  scale = NULL,
  strict_factor = FALSE
)
```

## Arguments

- base:

  a data.frame or tibble

- compare:

  a data.frame or tibble

- by:

  character vector of shared key column(s), or `NULL` to match rows by
  position (base row 1 vs. compare row 1, etc.)

- tolerance, scale, strict_factor:

  passed to
  [`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)

## Value

a list with `diffs` (long format: `Variable name`, `by` key column(s),
`Current Value`, `Previous Value`), `diffs_byvar` (count of differing
values per variable), and `class_diffs` (class mismatches by shared
column)
