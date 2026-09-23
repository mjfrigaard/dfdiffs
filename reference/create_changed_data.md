# Create changed data

Create changed data

## Usage

``` r
create_changed_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
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

## Value

modified data

## Examples

``` r
# with local data
ChangedData <- dfdiffs::ChangedData
InitialData <- dfdiffs::InitialData
create_changed_data(
  compare = ChangedData,
  base = InitialData,
  by = c("subject_id", "record"),
  cols = c("text_value_a", "text_value_b", "updated_date")
)
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
create_changed_data(
  compare = ChangedData,
  base = InitialData,
  by = c("subject_id", "record")
)
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
```
