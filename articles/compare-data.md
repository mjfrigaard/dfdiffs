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

The other vignettes answer each `dfdiffs` question with its own
function. In this vignette I’ll cover
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md),
which answers all three questions in a single call:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  What values have been changed?

### Test data

`Roster2021` and `Roster2022` are two yearly pulls of a synthetic (not
real) clinical site roster. They’re larger than the toy datasets in the
other vignettes, so they show how `dfdiffs` works at a more realistic
scale (see
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md)
for details). The code below loads both rosters and prints their row
counts:

``` r

r21 <- dfdiffs::Roster2021
nrow(r21)
#> [1] 200
r22 <- dfdiffs::Roster2022
nrow(r22)
#> [1] 237
```

### The `compare_data()` function

[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
takes the following arguments:

``` r

compare_data(compare = , base = , by = , by_col = , cols = , ignore_case = , trim_ws = )
```

The code below compares the 2022 roster against the 2021 roster, matches
rows on `subject_id`, and limits the comparison to four columns.
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
returns a named list:

``` r

comparisons <- compare_data(
  compare = r22, base = r21,
  by = "subject_id",
  cols = c("first_name", "last_name", "full_name", "height_cm"))
names(comparisons)
#> [1] "new_data"            "deleted_data"        "changed_num_diffs"  
#> [4] "changed_var_diffs"   "changed_class_diffs" "column_diffs"
```

### Call structure

[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
runs
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md),
adds the column-structure diff from
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md),
and returns everything in a single list. I generated the call tree below
from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`), and it only shows functions
defined in `dfdiffs`.

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
    ├─█─create_changed_data
    │ ├─select_cols
    │ ├─█─diff_values_by_key
    │ │ ├─compare_values
    │ │ └─class_diffs
    │ ├─rename_join_col
    │ ├─create_new_column
    │ └─class_diffs
    ├─class_diffs
    └─compare_columns

The Shiny app’s compare module
([`mod_compare_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_server.md))
orchestrates three comparison functions:
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
([`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
uses
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
instead). The module uses
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md)
for its column-intersection reactive, and it uses the `%nin%` helper to
drop `join_column`, `data_source`, and `join_source` from the list of
compared columns. Its download handler calls
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
directly, so the module has no report-building logic of its own:

``` r

stackcallr::call_tree_dir("R", root = "mod_compare_server")
```

    █─mod_compare_server
    ├─compare_columns
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
    │ ├─create_new_column
    │ └─class_diffs
    ├─select_cols
    ├─changed_react_theme
    ├─left_join_base
    └─█─create_comparison_report
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
      ├─█─create_modified_data
      │ ├─select_cols
      │ ├─█─diff_values_by_key
      │ │ ├─compare_values
      │ │ └─class_diffs
      │ ├─rename_join_col
      │ ├─create_new_column
      │ └─class_diffs
      ├─create_empty_tbl
      ├─compare_columns
      ├─class_diffs
      └─█─compare_summary
        └─█─compare_data
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
          ├─█─create_changed_data
          │ ├─select_cols
          │ ├─█─diff_values_by_key
          │ │ ├─compare_values
          │ │ └─class_diffs
          │ ├─rename_join_col
          │ ├─create_new_column
          │ └─class_diffs
          ├─class_diffs
          └─compare_columns

### `$new_data`

`$new_data` holds the rows in `r22` that aren’t in `r21`. The table
below shows the first six:

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

`$deleted_data` holds the rows in `r21` that are missing from `r22`. The
table below shows the first six:

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

`$changed_num_diffs` stores the number of changed values for each
compared column:

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

`$changed_var_diffs` lists the changed values row by row:

``` r

comparisons$changed_var_diffs
```

| Variable name | Current Value | Previous Value | subject_id |
|:---|:---|:---|:---|
| character(0) | c(“:————-”, “:————-”, “:————–”, “:———-”) | character(0) | c(“:————-”, “:————-”, “:————–”, “:———-”) |

comparisons\$changed_var_diffs {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `$changed_class_diffs`

`$changed_class_diffs` lists class mismatches on shared columns, and
it’s empty when every shared column has a matching class.
`Date`/`POSIXct` pairs and factor/character pairs are unified before the
check, so they aren’t reported as mismatches:

``` r

comparisons$changed_class_diffs
```

    #> Warning in matrix(body_rows, ncol = n_cols, byrow = TRUE): data length [2] is
    #> not a sub-multiple or multiple of the number of columns [3]

| variable     | class_base                   | class_compare |
|:-------------|:-----------------------------|:--------------|
| character(0) | c(“:——–”, “:———-”, “:————-”) | character(0)  |

comparisons\$changed_class_diffs {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `$column_diffs`

`$column_diffs` is a
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md)
object that lists the columns found only in `base`, only in `compare`,
and in both. It prints readably at the console:

``` r

comparisons$column_diffs
#> <dfdiffs column diff>
#>   common to both: 11
#>     subject_id, first_name, last_name, site_id, enroll_year, enroll_month, enroll_day, height_cm, full_name, first_visit_date, status 
#>   base only: 0
#>   compare only: 0
```
