# changed-modified-data

## Motivation

When we receive an updated version of a dataset, `dfdiffs` helps us
answer three questions:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  *What values have been changed?*

This vignette covers the two functions that answer the third question:
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).
Both are built on the same base R engine
([`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
and
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)),
and they differ only in the shape of their output:

- [`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
  returns `$num_diffs` and `$var_diffs`, which are used by
  [`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md).
- [`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
  returns `$diffs_byvar` and `$diffs`, which are used by `mod_compare`
  and
  [`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md).

### Packages

``` r

library(dfdiffs)
library(arsenal) # comparedf, for comparison
```

### Example data

We’ll use two datasets from the package to test what’s been modified.

#### Initial Data

`InitialData` is the base (original) dataset:

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

`ChangedData` is the dataset we’ll compare against `InitialData`:

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

We’ll use
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
to build a `join_var` column from `subject_id` and `record` in both
datasets:

``` r

ChangedDataJoin <- create_new_column(
  data = ChangedData,
  cols = c("subject_id", "record"),
  new_name = "join_var")
InitialDataJoin <- create_new_column(
  data = InitialData,
  cols = c("subject_id", "record"),
  new_name = "join_var")
```

`ChangedDataJoin` now starts with the new `join_var` column:

| join_var | subject_id | record | text_value_a | text_value_b | created_date | updated_date | entered_date |
|:---|:---|---:|:---|:---|:---|:---|:---|
| A-1 | A | 1 | Issue resolved | Fatigue | 2021-07-29 | 2021-10-03 | 2021-11-30 |
| A-2 | A | 2 | Issue resolved | Fatigue | 2021-07-29 | 2021-11-27 | 2021-11-30 |
| B-3 | B | 3 | Issue resolved | Fever | 2021-07-16 | 2021-10-20 | 2021-11-21 |
| C-4 | C | 4 | Issue resolved | Joint pain, stiffness and swelling | 2021-08-24 | 2021-10-13 | 2021-11-11 |
| C-5 | C | 5 | Issue resolved | Joint pain | 2021-08-24 | 2021-10-14 | 2021-11-16 |

ChangedDataJoin {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

## create_changed_data()

### Arguments

[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
takes the same `compare`, `base`, `by`, `by_col`, and `cols` arguments
as
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).
The [reference
table](https://mjfrigaard.github.io/dfdiffs/articles/create-new-data.html#arguments)
in that vignette lists every combination.

The difference is what the function does with matched rows.
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
and
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
find rows with no match, but
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
compares the *values* within matched rows, column by column.

### Call structure

[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
is built on
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md),
a base R engine that uses
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
to compare matched rows column by column. It also uses the same
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
helpers as the other comparison functions. The call tree below was
generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
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
    ├─create_new_column
    └─class_diffs

### Worked examples

#### No `by` column: row-by-row comparison

When we supply only the two datasets,
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
compares them row by row. The `$num_diffs` and `$var_diffs` tables are
shown side by side below:

``` r

create_changed_data(
  compare = ChangedData,
  base = InitialData)
```

[TABLE]

#### A single `by` column

Passing `join_var` as the `by` column matches rows on that key instead
of on row position:

``` r

create_changed_data(
  compare = ChangedDataJoin,
  base = InitialDataJoin,
  by = "join_var")
```

[TABLE]

#### Multiple `by` columns, a new `by_col`, and `cols`

This is the most complete case. The `by` columns are combined into a
single key named with `by_col`, and only the columns in `cols` are
compared:

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

[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
answers the same question as
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md),
but its output is shaped for the “Review Changes” report instead of
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md).

### `arsenal::comparedf()`, for comparison

Before version 2.1.0,
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
was built directly on
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html).
To see where the current output comes from, we’ll run
[`arsenal::comparedf()`](https://mayoverse.github.io/arsenal/reference/comparedf.html)
on the same data:

``` r

modified_cdf <- arsenal::comparedf(
  x = ChangedDataJoin,
  y = InitialDataJoin,
  by = "join_var")
modified_cdf_sum <- summary(modified_cdf)
```

The summary contains several tables, but we’re only interested in
`diffs.byvar.table` and `diffs.table`:

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

| var.x        | var.y        | join_var | values.x   | values.y   | row.x | row.y |
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

[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
returns only a small fraction of this output, reshaped into
`$diffs_byvar` and `$diffs`. The extra `var.y` column is dropped,
`var.x` becomes `Variable name`, and `values.x` and `values.y` become
`Current Value` and `Previous Value`. The row position columns (`row.x`
and `row.y`) are also dropped in favor of the join key.

We can see the reshaped output by running
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
on the same joined datasets:

``` r

modified <- create_modified_data(
  compare = ChangedDataJoin,
  base = InitialDataJoin,
  by = "join_var")
```

| Variable name | Modified Values |
|:--------------|----------------:|
| subject_id    |               0 |
| record        |               0 |
| text_value_a  |               2 |
| text_value_b  |               1 |
| created_date  |               0 |
| updated_date  |               5 |
| entered_date  |               5 |

modified\$diffs_byvar {.table .lightable-paper
style="font-family: \"Arial Narrow\", arial, helvetica, sans-serif; margin-left: auto; margin-right: auto;"}

| Variable name | join_var | Current Value                      | Previous Value   |
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

### Arguments

[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
takes the same `compare`, `base`, `by`, `by_col`, and `cols` arguments
as
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
and
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md).
The [reference
table](https://mjfrigaard.github.io/dfdiffs/articles/create-new-data.html#arguments)
lists every combination.

### Call structure

[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
is built on the same
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
engine as
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md).
The call tree below was generated with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
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
    ├─create_new_column
    └─class_diffs

### Worked examples

#### No `by` column: row-by-row comparison

When we supply only the two datasets,
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
compares them row by row. The `$diffs_byvar` and `$diffs` tables are
shown side by side below:

``` r

create_modified_data(
  compare = ChangedData,
  base = InitialData)
```

[TABLE]

#### A single `by` column

Passing `join_var` as the `by` column matches rows on that key instead
of on row position:

``` r

create_modified_data(
  compare = ChangedDataJoin,
  base = InitialDataJoin,
  by = "join_var")
```

[TABLE]

#### Multiple `by` columns, a new `by_col`, and `cols`

As with
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md),
the `by` columns are combined into a single key named with `by_col`, and
only the columns in `cols` are compared:

``` r

create_modified_data(
  compare = ChangedData,
  base = InitialData,
  by = c("subject_id", "record"),
  by_col = "new_join_var",
  cols = c("text_value_a", "text_value_b"))
```

[TABLE]
