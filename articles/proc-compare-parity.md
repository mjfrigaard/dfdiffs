# proc-compare-parity

## Motivation

SAS’s `PROC COMPARE` is the reference point for `dfdiffs`. Both tools
answer the same questions about two versions of a dataset: which rows
are new, which rows are gone, and which values changed? This vignette
maps `PROC COMPARE`’s options and output to the matching `dfdiffs`
functions. It also shows that each function produces readable output at
the console on its own, independent of the Shiny app. The app
([`launch_app()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_app.md))
is a thin layer on top of these functions, and it doesn’t compute
anything they don’t.

The only package we need is `dfdiffs`:

``` r

library(dfdiffs)
```

## Mapping `PROC COMPARE` to `dfdiffs`

The table below pairs each `PROC COMPARE` concept with the `dfdiffs`
function or argument that handles it.

| `PROC COMPARE` concept | `dfdiffs` function |
|:---|:---|
| `BASE=`/`COMPARE=` datasets | `base`/`compare` arguments, every comparison function |
| `ID`/`BY` statement (row matching key) | `by` argument |
| Variable Summary (vars only in one dataset) | [`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md) |
| `METHOD=ABSOLUTE`/`CRITERION=` (numeric tolerance) | `tolerance`/`scale` arguments to [`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md) |
| case-sensitive text compare (`PROC COMPARE`’s default) | `ignore_case`/`trim_ws` (a `dfdiffs` addition, off by default) |
| duplicate `ID` note | a [`warning()`](https://rdrr.io/r/base/warning.html) from [`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md) |
| Observation Summary / Values Comparison Summary | [`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md) |
| the full printed comparison listing | [`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)’s xlsx output |

## Roster data

We’ll compare two snapshots of the synthetic clinical site roster, taken
a year apart:

``` r

Roster2021 <- dfdiffs::Roster2021
Roster2022 <- dfdiffs::Roster2022
nrow(Roster2021)
#> [1] 200
nrow(Roster2022)
#> [1] 237
```

## Variable Summary: `compare_columns()`

Before comparing any values, `PROC COMPARE` lists the variables that
exist in only one dataset.
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md)
answers the same question and prints readable output at the console:

``` r

compare_columns(base = Roster2021, compare = Roster2022)
#> <dfdiffs column diff>
#>   common to both: 11
#>     subject_id, first_name, last_name, site_id, enroll_year, enroll_month, enroll_day, height_cm, full_name, first_visit_date, status 
#>   base only: 0
#>   compare only: 0
```

## Observation Summary / Values Comparison Summary: `compare_summary()`

`PROC COMPARE` prints a headline summary of row, column, and value
differences before its detailed diff tables.
[`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md)
gives the same headline by building on
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
and
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md),
and it adds no comparison logic of its own:

``` r

compare_summary(compare = Roster2022, base = Roster2021, by = "subject_id")
#> <dfdiffs comparison summary>
#>   Observations: base = 200, compare = 237
#>     common: 197 | new: 40 | deleted: 3
#>   Variables: base = 11, compare = 11 (11 common, 0 base only, 0 compare only)
#>   No unequal values found.
```

A small example makes the value-level counts easier to follow. In the
two data frames below, `note` differs in two of the three rows:

``` r

base <- data.frame(
  id = 1:3, note = c("ok", "ok", "ok"), val = c(1, 2, 3), stringsAsFactors = FALSE
)
compare <- data.frame(
  id = 1:3, note = c("OK", "ok", "changed"), val = c(1, 2, 3), stringsAsFactors = FALSE
)
compare_summary(compare = compare, base = base, by = "id")
#> <dfdiffs comparison summary>
#>   Observations: base = 3, compare = 3
#>     common: 3 | new: 0 | deleted: 0
#>   Variables: base = 3, compare = 3 (3 common, 0 base only, 0 compare only)
#>   Values: 2 differing value(s) across 1 variable(s); 0 class mismatch(es)
```

`PROC COMPARE` compares character values case-sensitively with no option
to change that. Setting `ignore_case = TRUE` treats `"ok"` and `"OK"` as
equal, an option `dfdiffs` offers beyond `PROC COMPARE` parity:

``` r

compare_summary(compare = compare, base = base, by = "id", ignore_case = TRUE)
#> <dfdiffs comparison summary>
#>   Observations: base = 3, compare = 3
#>     common: 3 | new: 0 | deleted: 0
#>   Variables: base = 3, compare = 3 (3 common, 0 base only, 0 compare only)
#>   Values: 1 differing value(s) across 1 variable(s); 0 class mismatch(es)
```

## Duplicate keys

When the `BY`/`ID` variables don’t uniquely identify rows,
`PROC COMPARE` prints a note instead of stopping with an error.
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
does the same by issuing a warning:

``` r

base_dupe <- data.frame(id = c(1, 1, 2), val = c("a", "z", "b"), stringsAsFactors = FALSE)
compare_dupe <- data.frame(id = c(1, 2), val = c("A", "b"), stringsAsFactors = FALSE)
diff_values_by_key(base = base_dupe, compare = compare_dupe, by = "id")
#> Warning: 'by' does not uniquely identify rows in base (1 duplicate key(s));
#> only the first match per key is used.
#> $diffs
#> # A tibble: 1 × 4
#>   `Variable name`    id `Current Value` `Previous Value`
#>   <chr>           <dbl> <chr>           <chr>           
#> 1 val                 1 A               a               
#> 
#> $diffs_byvar
#> # A tibble: 1 × 2
#>   `Variable name` `Modified Values`
#>   <chr>                       <int>
#> 1 val                             1
#> 
#> $class_diffs
#> # A tibble: 0 × 3
#> # ℹ 3 variables: variable <chr>, class_base <chr>, class_compare <chr>
```

## Numeric tolerance

[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
covers `PROC COMPARE`’s `CRITERION=` with its `tolerance` argument. The
first call below relies on the default tolerance
(`sqrt(.Machine$double.eps)`), and the second sets a wider one:

``` r

compare_values(5.0, 5.00000001)
#> [1] FALSE
compare_values(5.0, 5.1, tolerance = 0.2)
#> [1] FALSE
```

## The full report: `create_comparison_report()`

`PROC COMPARE` ends with a full printed listing of the comparison.
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
plays that role by writing every table shown above, plus the row-level
and value-level diff tables, to a single xlsx file. The workbook has
nine sheets: New Data, Deleted Data, Changed Data, Review Changes, Base
Data, Compare Data, Column Diffs, Class Diffs, and Summary.

``` r

create_comparison_report(
  compare = Roster2022,
  base = Roster2021,
  by = "subject_id",
  file = "roster-comparison.xlsx"
)
```

The download button in the Shiny app calls this same function, so the
app supplies no additional comparison logic of its own.
