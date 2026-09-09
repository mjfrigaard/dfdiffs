# Create modified data

Create modified data

## Usage

``` r
create_modified_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

## Arguments

- compare:

  A 'current' or 'new' dataset (tibble or data.frame)

- base:

  A 'previous' or 'old' dataset (tibble or data.frame)

- by:

  A join bs4Dash::column between the two datasets, or any combination of
  columns that constitute a unique row.

- by_col:

  A new name for the joining bs4Dash::column.

- cols:

  Columns to be compared.

## Value

modified data

## Examples

``` r
# with local data
CurrentData <- dfdiffs::ChangedData
PreviousData <- dfdiffs::InitialData
create_modified_data(
           compare = CurrentData,
           base = PreviousData,
           by = c("subject_id", "record"),
           cols = c("text_value_a", "text_value_b", "updated_date"))
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
create_modified_data(
           compare = CurrentData,
           base = PreviousData,
           by = c("subject_id", "record"))
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
```
