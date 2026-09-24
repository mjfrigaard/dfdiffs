# Anti-join two data frames (base R)

Base-R replacement for `dplyr::anti_join(x, y, by)`. Builds a pasted
composite key from `by` (treating `NA` as the literal string `"NA"`,
matching `dplyr`'s NA-as-equal join semantics) and keeps rows of `x`
whose key isn't present in `y`.

## Usage

``` r
anti_join_base(x, y, by)
```

## Arguments

- x:

  a data.frame or tibble

- y:

  a data.frame or tibble

- by:

  character vector of shared key column(s)

## Value

rows of `x` with no matching `by`-key combination in `y`, keeping only
`x`'s columns
