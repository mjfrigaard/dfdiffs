# modified-data

## Motivation

The goal of the `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  **What values have been changed?**

This vignette takes us through the
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
function, which answers the “*What values have been changed?*”. We also
have another function that detects modified data,
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md).

### Packages

``` r

library(dplyr)
library(stringr)
library(forcats)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(vroom)
library(haven)
library(readxl)
library(dfdiffs)
library(kableExtra)
```

### Changed data

We have two datasets to test what’s been modified:

#### Initial Data

``` r

InitialData <- dfdiffs::InitialData
```

| subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|---:|:---|:---|:---|:---|:---|
| A | 1 | Issue unresolved | Fatigue | 2021-07-29 | 2021-09-29 | 2021-09-29 |
| A | 2 | Issue unresolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-10-29 |
| B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-09-02 | 2021-08-18 |
| C | 4 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-03 | 2021-10-03 |
| C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-09-20 | 2021-10-20 |

InitialData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

#### Changed Data

``` r

ChangedData <- dfdiffs::ChangedData
```

| subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|---:|:---|:---|:---|:---|:---|
| A | 1 | Issue resolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-11-30 |
| A | 2 | Issue resolved | Fatigue | 2021-07-29 | 2021-11-27 | 2021-11-30 |
| B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-10-20 | 2021-11-21 |
| C | 4 | Issue resolved | Joint pain, stiffness and swelling | 2021-08-24 | 2021-10-13 | 2021-11-11 |
| C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-14 | 2021-11-16 |

ChangedData {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### Add join column

These data do not have a unique identifier, but we can create one with
the
[`create_join_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_join_column.md)
function.

#### InitialDataID

We create a join column using the `subject_id` and `record` columns.

``` r

InitialDataID <- create_join_column(df = InitialData, 
  by_colums = c('subject_id', 'record'), 
  new_by_column_name = 'subrecid')
```

| subrecid | subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|:---|---:|:---|:---|:---|:---|:---|
| A-1 | A | 1 | Issue unresolved | Fatigue | 2021-07-29 | 2021-09-29 | 2021-09-29 |
| A-2 | A | 2 | Issue unresolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-10-29 |
| B-3 | B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-09-02 | 2021-08-18 |
| C-4 | C | 4 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-03 | 2021-10-03 |
| C-5 | C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-09-20 | 2021-10-20 |

InitialDataID {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

#### ChangedDataID

We create an identical join column in the `ChangedData`

``` r

ChangedDataID <- create_join_column(df = ChangedData, 
  by_colums = c('subject_id', 'record'), 
  new_by_column_name = 'subrecid')
```

| subrecid | subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|:---|---:|:---|:---|:---|:---|:---|
| A-1 | A | 1 | Issue resolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-11-30 |
| A-2 | A | 2 | Issue resolved | Fatigue | 2021-07-29 | 2021-11-27 | 2021-11-30 |
| B-3 | B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-10-20 | 2021-11-21 |
| C-4 | C | 4 | Issue resolved | Joint pain, stiffness and swelling | 2021-08-24 | 2021-10-13 | 2021-11-11 |
| C-5 | C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-14 | 2021-11-16 |

ChangedDataID {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

Now we can test row-by-row comparisons and comparisons with a `by`
column.

## `create_modified_data()`

The
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
function is a wrapper around
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html),
but only returns a small fraction of the output.

``` r

modified_cdf <- arsenal::comparedf(
  x = ChangedDataID,
  y = InitialDataID, 
  by = "subrecid")
```

This function also requires a call to
[`summary()`](https://rdrr.io/r/base/summary.html) to clean up the
output a bit.

``` r

modified_cdf_sum <- summary(modified_cdf)
names(modified_cdf_sum)
#> [1] "frame.summary.table"      "comparison.summary.table"
#> [3] "vars.ns.table"            "vars.nc.table"           
#> [5] "obs.table"                "diffs.byvar.table"       
#> [7] "diffs.table"              "attrs.table"             
#> [9] "control"
```

We’re only interested in the `diffs.byvar.table` and the `diffs.table`.

### Call structure

Within `dfdiffs`,
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
calls
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
to build (and name) the join column; the comparison itself comes from
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html)
(from another package, so it isn’t shown below). The call tree below was
generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "create_modified_data")
```

    █─create_modified_data
    ├─rename_join_col
    └─create_new_column

### `comparedf()` -\> `diffs.byvar.table`

``` r

modified_cdf_sum$diffs.byvar.table
```

| var.x        | var.y        |   n | NAs |
|:-------------|:-------------|----:|----:|
| subject_id   | subject_id   |   0 |   0 |
| record       | record       |   0 |   0 |
| text_value_a | text_value_a |   2 |   0 |
| text_value_b | text_value_b |   1 |   0 |
| created_date | created_date |   0 |   0 |
| updated_date | updated_date |   5 |   0 |
| entered_date | entered_date |   5 |   0 |

modified_cdf_sum\$diffs.byvar.table {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `comparedf()` -\> `diffs.byvar.table`

``` r

modified_cdf_sum$diffs.table
```

| var.x        | var.y        | subrecid | values.x   | values.y   | row.x | row.y |
|:-------------|:-------------|:---------|:-----------|:-----------|------:|------:|
| text_value_a | text_value_a | A-1      | Issue re…. | Issue un…. |     1 |     1 |
| text_value_a | text_value_a | A-2      | Issue re…. | Issue un…. |     2 |     2 |
| text_value_b | text_value_b | C-4      | Joint pa…. | Joint pain |     4 |     4 |
| updated_date | updated_date | A-1      | 2021-10-03 | 2021-09-29 |     1 |     1 |
| updated_date | updated_date | A-2      | 2021-11-27 | 2021-10-03 |     2 |     2 |
| updated_date | updated_date | B-3      | 2021-10-20 | 2021-09-02 |     3 |     3 |
| updated_date | updated_date | C-4      | 2021-10-13 | 2021-10-03 |     4 |     4 |
| updated_date | updated_date | C-5      | 2021-10-14 | 2021-09-20 |     5 |     5 |
| entered_date | entered_date | A-1      | 2021-11-30 | 2021-09-29 |     1 |     1 |
| entered_date | entered_date | A-2      | 2021-11-30 | 2021-10-29 |     2 |     2 |
| entered_date | entered_date | B-3      | 2021-11-21 | 2021-08-18 |     3 |     3 |
| entered_date | entered_date | C-4      | 2021-11-11 | 2021-10-03 |     4 |     4 |
| entered_date | entered_date | C-5      | 2021-11-16 | 2021-10-20 |     5 |     5 |

modified_cdf_sum\$diffs.table {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

``` r

modified <- create_modified_data(
  compare = ChangedDataID, 
  base = InitialDataID, 
  by = "subrecid")
names(modified)
#> [1] "diffs"       "diffs_byvar"
```

### `create_modified_data()` -\> `diffs_byvar`

We’ve removed the extra `var.y` (and renamed `var.x` to
`Variable name`).

``` r

modified$diffs_byvar
```

| Variable name | Modified Values | Missing Values |
|:--------------|----------------:|---------------:|
| subject_id    |               0 |              0 |
| record        |               0 |              0 |
| text_value_a  |               2 |              0 |
| text_value_b  |               1 |              0 |
| created_date  |               0 |              0 |
| updated_date  |               5 |              0 |
| entered_date  |               5 |              0 |

modified\$diffs_byvar {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

### `create_modified_data()` -\> `diffs`

We’ve removed the `var.y` (and renamed `var.x` to `Variable name`).
`values.x` was renamed to `Current Value`, and `values.y` was renamed to
`Previous Value`.

We’ve also removed the row position variables (`row.x` and `row.y`)

``` r

modified$diffs
```

| Variable name | subrecid | Current Value                      | Previous Value   |
|:--------------|:---------|:-----------------------------------|:-----------------|
| text_value_a  | A-1      | Issue resolved                     | Issue unresolved |
| text_value_a  | A-2      | Issue resolved                     | Issue unresolved |
| text_value_b  | C-4      | Joint pain, stiffness and swelling | Joint pain       |
| updated_date  | A-1      | 2021-10-03                         | 2021-09-29       |
| updated_date  | A-2      | 2021-11-27                         | 2021-10-03       |
| updated_date  | B-3      | 2021-10-20                         | 2021-09-02       |
| updated_date  | C-4      | 2021-10-13                         | 2021-10-03       |
| updated_date  | C-5      | 2021-10-14                         | 2021-09-20       |
| entered_date  | A-1      | 2021-11-30                         | 2021-09-29       |
| entered_date  | A-2      | 2021-11-30                         | 2021-10-29       |
| entered_date  | B-3      | 2021-11-21                         | 2021-08-18       |
| entered_date  | C-4      | 2021-11-11                         | 2021-10-03       |
| entered_date  | C-5      | 2021-11-16                         | 2021-10-20       |

modified\$diffs {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}
