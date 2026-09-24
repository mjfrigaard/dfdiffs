# compare-data

``` r

library(dfdiffs)
library(openxlsx)
library(janitor) 
library(arsenal) # comparedf
library(diffdf)  # diffdf
library(stringr)
library(lubridate)
library(glue)
library(purrr)
library(reactable)
library(haven)
library(readxl)
```

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

### Test data

`Roster2021` and `Roster2022` are two yearly pulls of a synthetic (not
real) clinical site roster, used here to demonstrate `dfdiffs` at a
larger scale than the small toy datasets in the other vignettes. See
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md)
for details.

``` r

r21 <- dfdiffs::Roster2021
nrow(r21)
#> [1] 200
r22 <- dfdiffs::Roster2022
nrow(r22)
#> [1] 237
```

### The `compare_data()` function

Below are the arguments for
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md):

``` r

compare_data(compare = , base = , by = , by_col = , cols = )
```

``` r

comparisons <- compare_data(
  compare = r22, base = r21,
  by = "subject_id",
  cols = c("first_name", "last_name", "full_name", "height_cm"))
names(comparisons)
#> [1] "new_data"          "deleted_data"      "changed_num_diffs"
#> [4] "changed_var_diffs"
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
    │ ├─anti_join_base
    │ ├─select_cols
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_deleted_data
    │ ├─anti_join_base
    │ ├─select_cols
    │ ├─rename_join_col
    │ └─create_new_column
    └─█─create_changed_data
      ├─select_cols
      ├─█─diff_values_by_key
      │ ├─compare_values
      │ └─class_diffs
      ├─rename_join_col
      └─create_new_column

The Shiny app’s compare module
([`mod_compare_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_server.md))
orchestrates three comparison functions
([`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md);
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
is used by
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
instead), and uses the `%nin%` helper to drop `join_column`,
`data_source`, and `join_source` from the list of compared columns:

``` r

stackcallr::call_tree_dir("R", root = "mod_compare_server")
```

    █─mod_compare_server
    ├─%nin%
    ├─info_react_theme
    ├─█─create_new_data
    │ ├─anti_join_base
    │ ├─select_cols
    │ ├─rename_join_col
    │ └─create_new_column
    ├─new_react_theme
    ├─█─create_deleted_data
    │ ├─anti_join_base
    │ ├─select_cols
    │ ├─rename_join_col
    │ └─create_new_column
    ├─deleted_react_theme
    ├─█─create_modified_data
    │ ├─select_cols
    │ ├─█─diff_values_by_key
    │ │ ├─compare_values
    │ │ └─class_diffs
    │ ├─rename_join_col
    │ └─create_new_column
    ├─select_cols
    ├─changed_react_theme
    └─left_join_base

### `$new_data`

``` r

comparisons$new_data
```

|     | subject_id | first_name | last_name | full_name    | height_cm |
|:----|:-----------|:-----------|:----------|:-------------|:----------|
| 198 | SUBJ-0201  | Riley      | Jensen    | Riley Jensen | 178.7     |
| 199 | SUBJ-0202  | Casey      | Hayes     | Casey Hayes  | 181.4     |
| 200 | SUBJ-0203  | Skyler     | Grant     | Skyler Grant | 165.3     |
| 201 | SUBJ-0204  | Skyler     | Kim       | Skyler Kim   | 165.1     |
| 202 | SUBJ-0205  | Riley      | Irwin     | Riley Irwin  | 181.4     |
| 203 | SUBJ-0206  | Casey      | Kim       | Casey Kim    | 155.4     |

head(comparisons\$new_data) {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `$deleted_data`

``` r

comparisons$deleted_data
```

|     | subject_id | first_name | last_name | full_name   | height_cm |
|:----|:-----------|:-----------|:----------|:------------|:----------|
| 5   | SUBJ-0005  | Jamie      | Singh     | Jamie Singh | 179.5     |
| 50  | SUBJ-0050  | Riley      | Patel     | Riley Patel | 184.5     |
| 150 | SUBJ-0150  | Skyler     | Kim       | Skyler Kim  | 157.4     |

head(comparisons\$deleted_data) {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `$changed_num_diffs`

``` r

comparisons$changed_num_diffs
```

| Variable name | Modified Values |
|:--------------|----------------:|
| first_name    |               0 |
| last_name     |               0 |
| full_name     |               0 |
| height_cm     |               0 |

comparisons\$changed_num_diffs {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `$changed_var_diffs`

``` r

comparisons$changed_var_diffs
```

| Variable name | Current Value | Previous Value | subject_id |
|:---|:---|:---|:---|
| character(0) | c(“:————-”, “:————-”, “:————–”, “:———-”) | character(0) | c(“:————-”, “:————-”, “:————–”, “:———-”) |

comparisons\$changed_var_diffs {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}
