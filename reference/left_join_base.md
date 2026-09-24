# Left-join two data frames (base R)

Base-R replacement for `dplyr::left_join(x, y, by)`, used to join
review-changes data back to its source row.

## Usage

``` r
left_join_base(x, y, by)
```

## Arguments

- x:

  a data.frame or tibble

- y:

  a data.frame or tibble

- by:

  character vector of shared key column(s)

## Value

`x` with `y`'s non-key columns attached where `by` matches
