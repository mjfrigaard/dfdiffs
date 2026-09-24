# Compare two vectors of values (base R)

Element-wise value comparison used by
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
in place of
[`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html).
NA-safe (`NA` vs `NA` is never "different"; `NA` vs a value always is).
Numeric values (including a mix of integer/double) are compared with
tolerance, matching `diffdf:::compare_vectors.numeric()`'s formula.
`Date`/`POSIXct` values are compared as epoch seconds with the same
tolerance, so a `Date` and a `POSIXct` representing the same instant
compare as equal. Factors are cast to character before comparing (label
comparison), unless `strict_factor = TRUE`, in which case a
factor/non-factor class mismatch is always flagged as different.

## Usage

``` r
compare_values(
  base_val,
  compare_val,
  tolerance = sqrt(.Machine$double.eps),
  scale = NULL,
  strict_factor = FALSE
)
```

## Arguments

- base_val:

  vector of base/previous values

- compare_val:

  vector of compare/current values

- tolerance:

  numeric tolerance for numeric/date-time comparisons (default
  `sqrt(.Machine$double.eps)`, matching
  [`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html))

- scale:

  optional scale applied before the tolerance check (default `NULL`,
  i.e. no scaling)

- strict_factor:

  if `TRUE`, a factor compared against a non-factor is always flagged as
  different, regardless of label (default `FALSE`, which compares
  factor/character pairs by label)

## Value

logical vector, `TRUE` where `base_val`/`compare_val` differ
