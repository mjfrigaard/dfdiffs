# create-deleted-data

## Motivation

When we receive an updated version of a dataset, `dfdiffs` helps us
answer three questions:

1.  What rows are here now that weren’t here before?
2.  *What rows were here before that aren’t here now?*
3.  What values have been changed?

This vignette covers
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
which answers the second question: “*What rows were here before that
aren’t here now?*”

### Packages

``` r

library(dfdiffs)
library(flextable)
```

### What rows were here before that aren’t here now?

We’ll use three datasets from the package to test for deleted data:
`CompleteData`, `IncompleteData`, and `DeletedData`.

#### CompleteData

`CompleteData` has 9 rows and 7 columns. Each row is uniquely identified
by the combination of `subject` and `record`:

``` r

CompleteData <- dfdiffs::CompleteData
flextable::qflextable(CompleteData)
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at screening visit. | vitals |
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Laboratory sample collected for hematology panel. | labs |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | ECG performed during screening assessment. | ecg |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at follow-up visit. | vitals |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Laboratory sample collected for chemistry panel. | labs |

#### IncompleteData

`IncompleteData` is `CompleteData` with 4 rows removed, leaving 5 rows:

``` r

IncompleteData <- dfdiffs::IncompleteData
flextable::qflextable(IncompleteData) |>
  flextable::set_table_properties(layout = "autofit")
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at screening visit. | vitals |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Laboratory sample collected for hematology panel. | labs |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | ECG performed during screening assessment. | ecg |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at follow-up visit. | vitals |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Laboratory sample collected for chemistry panel. | labs |

#### DeletedData

`DeletedData` contains the 4 rows removed from `CompleteData` to create
`IncompleteData`, so it’s the result we expect
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
to return:

``` r

DeletedData <- dfdiffs::DeletedData
flextable::qflextable(DeletedData) |>
  flextable::set_table_properties(layout = "autofit")
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

We can confirm that combining `IncompleteData` and `DeletedData`
recreates `CompleteData`:

``` r

combined <- rbind(IncompleteData, DeletedData)
combined <- combined[do.call(order, combined), ]
complete <- CompleteData[do.call(order, CompleteData), ]
all.equal(combined, complete, check.attributes = FALSE)
#> [1] TRUE
```

### Arguments

[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
takes the same `compare`, `base`, `by`, `by_col`, and `cols` arguments
as
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).
The [reference
table](https://mjfrigaard.github.io/dfdiffs/articles/create-new-data.html#arguments)
in that vignette lists every combination.

The only difference between the two functions is the direction of the
anti join.
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
looks for `compare` rows missing from `base`, and
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
does the mirror image: it looks for `base` rows missing from `compare`.

## create_deleted_data()

The signature for
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
is below. It returns a data frame of the deleted rows.

``` r
create_deleted_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

### Call structure

[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
relies on the same four helpers as
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md):
[`anti_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/anti_join_base.md),
[`select_cols()`](https://mjfrigaard.github.io/dfdiffs/reference/select_cols.md),
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
(which renames the join column), and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
(which builds the join column from the `by` columns, as shown in the
[create-new-data](https://mjfrigaard.github.io/dfdiffs/articles/create-new-data.html#create_new_column)
vignette). The call tree below was generated from the package source
with [stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "create_deleted_data")
```

    █─create_deleted_data
    ├─anti_join_base
    ├─select_cols
    ├─rename_join_col
    └─create_new_column

### Worked examples

#### No `by` column: matching whole rows

When we supply only the two datasets,
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
treats a row in `base` as deleted if no row in `compare` has identical
values across every shared column. The result below matches
`DeletedData`:

``` r

create_deleted_data(
  compare = IncompleteData,
  base = CompleteData)
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |

#### A single `by` column

First, we’ll use
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
to build a `join_var` column from `subject` and `record` in both
datasets:

``` r

CompleteDataJoin <- create_new_column(data = CompleteData,
  cols = c("subject", "record"),
  new_name = "join_var")
IncompleteDataJoin <- create_new_column(data = IncompleteData,
  cols = c("subject", "record"),
  new_name = "join_var")
```

Passing `join_var` as the `by` column matches rows on that key instead
of on row position:

``` r

create_deleted_data(
  compare = IncompleteDataJoin,
  base = CompleteDataJoin,
  by = "join_var")
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|----|
| A-2 | A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| C-1 | C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| B-3 | B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |

#### Multiple `by` columns, a new `by_col`, and `cols`

This is the most complete case. The `by` columns are combined into a
single key named with `by_col`, and only the columns in `cols` are
compared:

``` r

create_deleted_data(
  compare = IncompleteData,
  base = CompleteData,
  by = c('subject', 'record'),
  by_col = "new_join_col",
  cols = c("subject", "record", "text_var", "factor_var"))
```

| new_join_col | subject | record | text_var | factor_var |
|----|----|----|----|----|
| A-2 | A | 2 | Concomitant medication reported at baseline. | conmed |
| C-1 | C | 1 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | Medical history reviewed and confirmed complete. | history |
| B-3 | B | 3 | Concomitant medication updated at visit two. | conmed |
