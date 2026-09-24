# Select columns by name (base R)

Base-R replacement for `dplyr::select(df, tidyselect::all_of(cols))`.
Errors clearly when a requested column doesn't exist, matching
[`tidyselect::all_of()`](https://tidyselect.r-lib.org/reference/all_of.html)'s
safety net.

## Usage

``` r
select_cols(df, cols)
```

## Arguments

- df:

  a data.frame or tibble

- cols:

  character vector of column names to select

## Value

df subset to `cols`, in the order given
