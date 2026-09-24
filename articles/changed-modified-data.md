# changed-modified-data

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
    **3. What values have been changed?**

This vignette takes us through two functions:
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).
Both are built on the same base-R
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)/[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
engine and answer the question, “*What values have been changed?*” They
differ only in the shape of their output:
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
returns `$num_diffs`/`$var_diffs` (used by
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
returns `$diffs_byvar`/`$diffs` (used by `mod_compare` and
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)).

### Packages

``` r

library(dfdiffs)
library(stringr)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(haven)
library(readxl)
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

### Creating join columns

We’ll use the
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
function to create `join_var` from `subject_id` and `record`:

``` r

ChangedDataJoin <- dfdiffs::create_new_column(
  data = ChangedData, 
  cols = c("subject_id", "record"), 
  new_name = "join_var")
ChangedDataJoin
```

| join_var | subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|:---|---:|:---|:---|:---|:---|:---|
| A-1 | A | 1 | Issue resolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-11-30 |
| A-2 | A | 2 | Issue resolved | Fatigue | 2021-07-29 | 2021-11-27 | 2021-11-30 |
| B-3 | B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-10-20 | 2021-11-21 |
| C-4 | C | 4 | Issue resolved | Joint pain, stiffness and swelling | 2021-08-24 | 2021-10-13 | 2021-11-11 |
| C-5 | C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-14 | 2021-11-16 |

ChangedDataJoin {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

``` r

InitialDataJoin <- dfdiffs::create_new_column(
  data = InitialData, 
  cols = c("subject_id", "record"), 
  new_name = "join_var")
InitialDataJoin
```

| join_var | subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|:---|---:|:---|:---|:---|:---|:---|
| A-1 | A | 1 | Issue unresolved | Fatigue | 2021-07-29 | 2021-09-29 | 2021-09-29 |
| A-2 | A | 2 | Issue unresolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-10-29 |
| B-3 | B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-09-02 | 2021-08-18 |
| C-4 | C | 4 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-03 | 2021-10-03 |
| C-5 | C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-09-20 | 2021-10-20 |

InitialDataJoin {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

## create_changed_data()

Each comparison function in the `dfdiffs` package assumes `base` and
`compare` datasets *might* have one of the following conditions:

1.  Two datasets

2.  Multiple columns to compare (`cols`)

3.  Single `by` column

4.  Single `by` column, new column name (`by_col`)

5.  Single `by` column, multiple compare columns (`cols`)

6.  Single `by` column, new column name (`by_col`), multiple compare
    columns (`cols`)

7.  Multiple `by` columns

8.  Multiple `by` columns, new column name (`by_col`)

9.  Multiple `by` columns, multiple compare columns (`cols`)

10. Multiple `by` columns, a new `by_col`, and `cols`

### Call structure

[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
is built on
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md),
a base-R engine that compares matched rows column-by-column with
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md),
plus the same
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
helpers used by the other comparison functions. The call tree below was
generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "create_changed_data")
```

    █─create_changed_data
    ├─select_cols
    ├─█─diff_values_by_key
    │ ├─compare_values
    │ └─class_diffs
    ├─rename_join_col
    └─create_new_column

### Single by column conditions

#### 1) Two datasets

Compare all columns:

``` r

create_changed_data(
  compare = ChangedData, 
  base = InitialData)
```

[TABLE]

#### 2) Multiple columns to compare (`cols`)

``` r

create_changed_data(
  compare = ChangedData, 
  base = InitialData, 
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

#### 3) Single `by` column

With no new column name:

``` r

create_changed_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var")
```

[TABLE]

#### 4) Single `by` column, new column name (`by_col`)

``` r

create_changed_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var",
  by_col = "join")
```

[TABLE]

#### 5) Single `by` column, multiple compare columns (`cols`)

``` r

create_changed_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var", 
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

#### 6) Single `by` column, new column name (`by_col`), multiple compare columns (`cols`)

``` r

create_changed_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var", 
  by_col = "join",
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

### Multiple by column conditions

#### 7) Multiple `by` columns

``` r

create_changed_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"))
```

[TABLE]

#### 8) Multiple `by` columns, new column name (`by_col`)

``` r

create_changed_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"), 
  by_col = "new_join_var")
```

[TABLE]

#### 9) Multiple `by` columns, multiple compare columns (`cols`)

``` r

create_changed_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"), 
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

#### 10) Multiple `by` columns, a new `by_col`, and `cols`

``` r

create_changed_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"), 
  by_col = "join",
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

------------------------------------------------------------------------

## create_modified_data()

Below we have the
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
function, which takes two data frames (`compare` and `base`), a `by`
column, and the `cols` to compare.

``` r

create_modified_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

We’ll test this function below on all ten possible conditions for `base`
and `compare`.

### Call structure

[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
is built on
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md),
the same base-R comparison engine as
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md).
Within `dfdiffs`, it also calls
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
to build (and name) the join column. The call tree below was generated
with [stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "create_modified_data")
```

    █─create_modified_data
    ├─select_cols
    ├─█─diff_values_by_key
    │ ├─compare_values
    │ └─class_diffs
    ├─rename_join_col
    └─create_new_column

### Single joining (`by`) column conditions

#### 1) Two datasets

- No `by` columns (only two datasets)

``` r

compare_list <- create_modified_data(
  compare = ChangedData, 
  base = InitialData)
```

[TABLE]

#### 2) Multiple columns to compare (`cols`)

- No `by` columns (only two datasets) and multiple compare columns
  (`cols`)

``` r

compare_list <- create_modified_data(
  compare = ChangedData, 
  base = InitialData, 
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

#### 3) Single `by` column

- We can provide a single `by` column using the `InitialDataJoin` and
  `ChangedDataJoin` datasets we created above.

``` r

compare_list <- create_modified_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var")
```

[TABLE]

#### 4) Single `by` column, new column name (`by_col`)

- We can also provide a single `by` column (the unique identifier) and a
  new name for it with `by_col`.

``` r

compare_list <- create_modified_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var",
  by_col = "new_join_var")
```

[TABLE]

#### 5) Single `by` column, multiple compare columns (`cols`)

- Single `by` column and multiple compare columns (`cols`)

``` r

compare_list <- create_modified_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var", 
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

#### 6) Single `by` column, new column name (`by_col`), multiple compare columns (`cols`)

- Single `by` column, a new name for the by column (`by_col`), and
  multiple compare columns (`cols`)

``` r

compare_list <- create_modified_data(
  compare = ChangedDataJoin, 
  base = InitialDataJoin, 
  by = "join_var", 
  by_col = "new_join_var",
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

### Multiple `by` column conditions

The next conditions cover when two existing columns are used to create a
unique identifier between the two datasets.

#### 7) Multiple `by` columns

- Multiple `by` columns (assuming the columns create a unique
  identifier).

``` r

compare_list <- create_modified_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"))
```

[TABLE]

This creates a `join` column from the `by` columns.

#### 8) Multiple `by` columns, new column name (`by_col`)

We can provide multiple `by` columns, a new `by_col`, and **no `cols`**.

``` r

compare_list <- create_modified_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"), 
  by_col = "new_join_var")
```

[TABLE]

#### 9) Multiple `by` columns, multiple compare columns (`cols`)

- Multiple `by` columns and multiple compare columns (`cols`), and **no
  new `by_col`**.

``` r

compare_list <- create_modified_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"), 
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]

This creates a `join` column from the `by` columns.

#### 10) Multiple `by` columns, a new `by_col`, and `cols`

- We can provide multiple `by` columns, a new `by_col`, and multiple
  `cols`.

``` r

compare_list <- create_modified_data(
  compare = ChangedData, 
  base = InitialData, 
  by = c("subject_id", "record"), 
  by_col = "new_join_var",
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]
