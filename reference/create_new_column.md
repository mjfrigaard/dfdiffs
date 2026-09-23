# Create new (joining) column

Create new (joining) column

## Usage

``` r
create_new_column(data, cols, new_name, sep)
```

## Arguments

- data:

  a tibble or data.frame

- cols:

  cols to create new column from (they will be pasted together with "-")

- new_name:

  new column name

## Value

new_col_data data with new column

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
library(tidyr)
CompleteData <- dfdiffs::CompleteData
IncompleteData <- dfdiffs::IncompleteData
CompleteDataJoin <- create_new_column(data = CompleteData,
                                       cols = c("subject", "record"),
                                       new_name = "join_var")
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
IncompleteDataJoin <- create_new_column(data = IncompleteData,
                                       cols = c("subject", "record"),
                                       new_name = "join_var")
#> Error in tidyr::unite(data, {    {        new_name    }}, {    {        cols    }}, remove = FALSE, sep = sep): `sep` must be a single string, not absent.
```
