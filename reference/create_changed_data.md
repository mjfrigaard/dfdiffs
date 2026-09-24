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

a list with `num_diffs` (count of differing values per variable) and
`var_diffs` (long format: `Variable name`, key column(s),
`Current Value`, `Previous Value`)

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
#> $num_diffs
#> # A tibble: 3 × 2
#>   `Variable name` `Modified Values`
#>   <chr>                       <int>
#> 1 text_value_a                    2
#> 2 text_value_b                    1
#> 3 updated_date                    5
#> 
#> $var_diffs
#> # A tibble: 8 × 4
#>   `Variable name` join  `Current Value`                    `Previous Value`
#>   <chr>           <chr> <chr>                              <chr>           
#> 1 text_value_a    A-1   Issue resolved                     Issue unresolved
#> 2 text_value_a    A-2   Issue resolved                     Issue unresolved
#> 3 text_value_b    C-4   Joint pain, stiffness and swelling Joint pain      
#> 4 updated_date    A-1   2021-10-03                         2021-09-29      
#> 5 updated_date    A-2   2021-11-27                         2021-10-03      
#> 6 updated_date    B-3   2021-10-20                         2021-09-02      
#> 7 updated_date    C-4   2021-10-13                         2021-10-03      
#> 8 updated_date    C-5   2021-10-14                         2021-09-20      
#> 
create_changed_data(
  compare = ChangedData,
  base = InitialData,
  by = c("subject_id", "record")
)
#> $num_diffs
#> # A tibble: 7 × 2
#>   `Variable name` `Modified Values`
#>   <chr>                       <int>
#> 1 subject_id                      0
#> 2 record                          0
#> 3 text_value_a                    2
#> 4 text_value_b                    1
#> 5 created_date                    0
#> 6 updated_date                    5
#> 7 entered_date                    5
#> 
#> $var_diffs
#> # A tibble: 13 × 4
#>    `Variable name` join  `Current Value`                    `Previous Value`
#>    <chr>           <chr> <chr>                              <chr>           
#>  1 text_value_a    A-1   Issue resolved                     Issue unresolved
#>  2 text_value_a    A-2   Issue resolved                     Issue unresolved
#>  3 text_value_b    C-4   Joint pain, stiffness and swelling Joint pain      
#>  4 updated_date    A-1   2021-10-03                         2021-09-29      
#>  5 updated_date    A-2   2021-11-27                         2021-10-03      
#>  6 updated_date    B-3   2021-10-20                         2021-09-02      
#>  7 updated_date    C-4   2021-10-13                         2021-10-03      
#>  8 updated_date    C-5   2021-10-14                         2021-09-20      
#>  9 entered_date    A-1   2021-11-30                         2021-09-29      
#> 10 entered_date    A-2   2021-11-30                         2021-10-29      
#> 11 entered_date    B-3   2021-11-21                         2021-08-18      
#> 12 entered_date    C-4   2021-11-11                         2021-10-03      
#> 13 entered_date    C-5   2021-11-16                         2021-10-20      
#> 
```
