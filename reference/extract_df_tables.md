# Extract tables from `diffdf::diffdf` list

This is a sub-function for create_changed_data()

## Usage

``` r
extract_df_tables(diffdf_list, by_keys)
```

## Arguments

- diffdf_list:

  output from
  [`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)
  function

- by_keys:

  `keys` argument from
  [`diffdf::diffdf()`](https://gowerc.github.io/diffdf/latest-tag/reference/diffdf.html)/`by`
  argument from
  [`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)

## Value

diff_tbls list of diff tables
