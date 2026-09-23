# compare-data

``` r

library(dfdiffs)
library(openxlsx)
library(janitor) 
library(arsenal) # comparedf
library(diffdf)  # diffdf
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(forcats)
library(glue)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)
```

## Motivation

The goal of the `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

### Test data

These are two Masters tables from the [Lahman baseball
database.](https://www.seanlahman.com/baseball-archive/statistics/)

``` r

m15 <- dfdiffs::master15 |> 
  dplyr::slice_sample(n = 3000, replace = FALSE)
max(m15$debut, na.rm = TRUE)
#> [1] "2015-09-13"
m20 <- dfdiffs::master20 |> 
  dplyr::slice_sample(n = 3000, replace = FALSE)
max(m20$debut, na.rm = TRUE)
#> [1] "2019-09-14"
```

### The `compare_data()` function

``` r

compare_data(compare = , base = , by = , by_col = , cols = )
```

``` r

comparisons <- compare_data(
  compare = m20, base = m15, 
  by = "playerID", by_col = "join", 
  cols = c("nameFirst", "nameLast", "nameGiven", "height"))
#> Error in `tidyr::unite()`:
#> ! `sep` must be a single string, not absent.
names(comparisons)
#> Error:
#> ! object 'comparisons' not found
```

### Call structure

[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
runs
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md),
and returns their results in a single list. The call tree below was
generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "compare_data")
```

    █─compare_data
    ├─█─create_new_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_deleted_data
    │ ├─rename_join_col
    │ └─create_new_column
    └─█─create_changed_data
      ├─extract_df_tables
      ├─rename_join_col
      └─create_new_column

The Shiny app’s compare module
([`mod_compare_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_server.md))
orchestrates the four comparison functions
([`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md),
and
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)),
and uses the `%nin%` helper to drop `join_column`, `data_source`, and
`join_source` from the list of compared columns:

``` r

stackcallr::call_tree_dir("R", root = "mod_compare_server")
```

    █─mod_compare_server
    ├─%nin%
    ├─█─create_new_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_deleted_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_modified_data
    │ ├─rename_join_col
    │ └─create_new_column
    └─█─create_changed_data
      ├─extract_df_tables
      ├─rename_join_col
      └─create_new_column

### `$new_data`

``` r

comparisons$new_data
```

    #> Error:
    #> ! object 'comparisons' not found

### `$deleted_data`

``` r

comparisons$deleted_data
```

    #> Error:
    #> ! object 'comparisons' not found

### `$changed_num_diffs`

``` r

comparisons$changed_num_diffs
```

    #> Error:
    #> ! object 'comparisons' not found

### `$changed_var_diffs`

``` r

comparisons$changed_var_diffs
```

    #> Error:
    #> ! object 'comparisons' not found
