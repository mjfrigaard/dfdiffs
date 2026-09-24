# Create new (joining) column

Create new (joining) column

## Usage

``` r
create_new_column(data, cols, new_name, sep = "-")
```

## Arguments

- data:

  a tibble or data.frame

- cols:

  cols to create new column from (they will be pasted together with "-")

- new_name:

  new column name

- sep:

  separator pasted between `cols` values (default `"-"`)

## Value

new_col_data data with new column

## Examples

``` r
CompleteData <- dfdiffs::CompleteData
IncompleteData <- dfdiffs::IncompleteData
CompleteDataJoin <- create_new_column(data = CompleteData,
                                       cols = c("subject", "record"),
                                       new_name = "join_var")
IncompleteDataJoin <- create_new_column(data = IncompleteData,
                                       cols = c("subject", "record"),
                                       new_name = "join_var")
```
