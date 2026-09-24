# create-deleted-data

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  *What rows were here before that aren’t here now?*
3.  What values have been changed?

This vignette takes us through the
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
function, which answers the question, “*What rows were here before that
aren’t here now?*”

### Packages

``` r

library(dfdiffs)
library(stringr)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(flextable)
```

### What rows were here before that aren’t here now?

We’ll need three datasets to test for deleted data: `CompleteData`,
`IncompleteData`, and `DeletedData`.

#### CompleteData

`CompleteData` has 9 rows and 7 columns. Unique rows are identified by a
combination of `subject` and `record`:

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

`IncompleteData` has 5 rows (4 have been removed).

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

`DeletedData` contains the 4 rows of data removed from `CompleteData` to
create `IncompleteData`.

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

### Conditions

Each function in the `dfdiffs` package assumes the following conditions:

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

#### Single by column conditions

1.  Two datasets, compare all columns:

    ``` r

    create_deleted_data(
      compare = IncompleteData, 
      base = CompleteData)
    ```

2.  Multiple columns to compare (`cols`):

    ``` r

    create_deleted_data(
      compare = IncompleteDataJoin, 
      base = CompleteDataJoin,
      cols = c("text_var", "factor_var"))
    ```

3.  Single `by` column, no new column name

    ``` r

    create_deleted_data(
      compare = IncompleteDataJoin, 
      base = CompleteDataJoin, 
      by = "join_var")
    ```

4.  Single `by` column, new column name (`by_col`)

    ``` r

    create_deleted_data(
      compare = IncompleteDataJoin, 
      base = CompleteDataJoin, 
      by = "join_var", 
      by_col = 'new_join_var')
    ```

5.  Single `by` column, multiple compare columns (`cols`)

    ``` r

    create_deleted_data(
      compare = IncompleteDataJoin, 
      base = CompleteDataJoin, 
      by = "join_var", 
      cols = c("subject", "record", "factor_var", "text_var"))
    ```

6.  Single `by` column, new column name (`by_col`), multiple compare
    columns (`cols`)

    ``` r

    create_deleted_data(
      # data 
      compare = IncompleteDataJoin, 
      base = CompleteDataJoin, 
      # unique id
      by = "join_var", 
      # new name for id
      by_col = 'new_join_var', 
      # cols to compare
      cols = c("subject", "record", "text_var", "factor_var"))
    ```

#### Multiple by column conditions

7.  Multiple `by` columns

    ``` r

    create_deleted_data(
      compare = IncompleteData, 
      base = CompleteData, 
      by = c('subject', 'record'))
    ```

8.  Multiple `by` columns, new column name (`by_col`)

    ``` r

    create_deleted_data(
      compare = IncompleteData, 
      base = CompleteData,
      by = c('subject', 'record'),
      by_col = "new_join_col")
    ```

9.  Multiple `by` columns, multiple compare columns (`cols`)

    ``` r

    create_deleted_data(
      compare = IncompleteData, 
      base = CompleteData, 
      by = c('subject', 'record'),
      cols = c("subject",  "record", "factor_var", "text_var"))
    ```

10. Multiple `by` columns, a new `by_col`, and `cols`

    ``` r

    create_deleted_data(
      compare = IncompleteData, 
      base = CompleteData, 
      by = c('subject', 'record'),
      by_col = "new_join_col",
      cols = c("subject", "record", "text_var", "factor_var"))
    ```

### create_new_column()

We have a small helper function to create the join variables,
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md):

``` r

create_new_column(data = , cols = , new_name = )
```

We can use
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
with `CompleteData` and `IncompleteData` to create a joining variable
with `subject` and `record`:

``` r

CompleteDataJoin <- create_new_column(data = CompleteData, 
  cols = c("subject", "record"), 
  new_name = "join_var")
CompleteDataJoin
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|----|
| A-1 | A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at screening visit. | vitals |
| A-2 | A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B-1 | B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Laboratory sample collected for hematology panel. | labs |
| B-2 | B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | ECG performed during screening assessment. | ecg |
| C-1 | C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| A-3 | A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at follow-up visit. | vitals |
| B-3 | B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| D-2 | D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Laboratory sample collected for chemistry panel. | labs |

``` r

IncompleteDataJoin <- create_new_column(data = IncompleteData, 
  cols = c("subject", "record"), 
  new_name = "join_var")
IncompleteDataJoin
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|----|
| A-1 | A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at screening visit. | vitals |
| B-1 | B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Laboratory sample collected for hematology panel. | labs |
| B-2 | B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | ECG performed during screening assessment. | ecg |
| A-3 | A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Vital signs recorded at follow-up visit. | vitals |
| D-2 | D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Laboratory sample collected for chemistry panel. | labs |

  
  

## create_deleted_data()

Below is our
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
function, which returns a tibble of the deleted rows.

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
(renames the join column), and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
(builds the join column from the `by` columns, covered above). The call
tree below was generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
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

### Single `by` column conditions

The function also needs to handle multiple conditions. Below we cover
the conditions for a single `by` column (assuming each dataset already
has a unique identifier). First, we’ll cover a few uncommon conditions,
like a missing `by` column, or a missing `by` column with specific
columns selected for comparison.

#### 1) Two datasets

- No `by` columns (only two datasets)

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

When we compare this to `DeletedData`, we can see it performs a
row-by-row comparison.

    #> Error in `arrange()`:
    #> ! could not find function "arrange"

#### 2) Multiple columns to compare (`cols`)

- No `by` columns (only two datasets) and multiple compare columns
  (`cols`)

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin,
  cols = c("text_var", "factor_var"))
```

| text_var                                             | factor_var |
|------------------------------------------------------|------------|
| Concomitant medication reported at baseline.         | conmed     |
| Physical exam completed with no abnormalities noted. | exam       |
| Medical history reviewed and confirmed complete.     | history    |
| Concomitant medication updated at visit two.         | conmed     |

When we compare this to `DeletedData`, we can see the `text_var` and
`factor_var` columns are identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 3) Single `by` column

- If the tables have a joining column, like `CompleteDataJoin` and
  `IncompleteDataJoin`, we can supply that joining column with `by`.

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

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 4) Single `by` column, new column name (`by_col`)

- We can also provide a single `by` column (the unique identifier) and a
  new name for it with `by_col`.

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin, 
  by = "join_var", 
  by_col = 'new_join_var')
```

| new_join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|----|
| A-2 | A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| C-1 | C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| B-3 | B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 5) Single `by` column, multiple compare columns (`cols`)

- Single `by` column and multiple compare columns (`cols`)

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin, 
  by = "join_var", 
  cols = c("subject", "record", "factor_var", "text_var"))
```

| join_var | subject | record | factor_var | text_var |
|----|----|----|----|----|
| A-2 | A | 2 | conmed | Concomitant medication reported at baseline. |
| C-1 | C | 1 | exam | Physical exam completed with no abnormalities noted. |
| D-1 | D | 1 | history | Medical history reviewed and confirmed complete. |
| B-3 | B | 3 | conmed | Concomitant medication updated at visit two. |

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 6) Single `by` column, new column name (`by_col`), multiple compare columns (`cols`)

- Single `by` column, a new name for the by column (`by_col`), and
  multiple compare columns (`cols`)

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin, 
  by = "join_var", 
  by_col = 'new_join_var', 
  cols = c("subject", "record", "text_var", "factor_var"))
```

| new_join_var | subject | record | text_var | factor_var |
|----|----|----|----|----|
| A-2 | A | 2 | Concomitant medication reported at baseline. | conmed |
| C-1 | C | 1 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | Medical history reviewed and confirmed complete. | history |
| B-3 | B | 3 | Concomitant medication updated at visit two. | conmed |

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

### Multiple `by` column conditions

Next, we’ll test conditions in which multiple columns are used to create
a unique identifier.

#### 7) Multiple `by` columns

- Multiple `by` columns (assuming the columns create a unique
  identifier)

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData, 
  by = c('subject', 'record'))
```

| join | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|----|
| A-2 | A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| C-1 | C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| B-3 | B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |

This creates a new `join` column that combines `subject` and `record`.
When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 8) Multiple `by` columns, new column name (`by_col`)

We can provide multiple `by` columns, a new `by_col`, and **no `cols`**.

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData,
  by = c('subject', 'record'),
  by_col = "new_join_col")
```

| new_join_col | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|----|
| A-2 | A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| C-1 | C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D-1 | D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
| B-3 | B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |

This creates a new `new_join_col` column that combines `subject` and
`record`. When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 9) Multiple `by` columns, multiple compare columns (`cols`)

- Multiple `by` columns and multiple compare columns (`cols`), and **no
  new `by_col`**.

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData, 
  by = c('subject', 'record'),
  cols = c("subject",  "record", "factor_var", "text_var"))
```

| join | subject | record | factor_var | text_var |
|----|----|----|----|----|
| A-2 | A | 2 | conmed | Concomitant medication reported at baseline. |
| C-1 | C | 1 | exam | Physical exam completed with no abnormalities noted. |
| D-1 | D | 1 | history | Medical history reviewed and confirmed complete. |
| B-3 | B | 3 | conmed | Concomitant medication updated at visit two. |

This creates a new `join` column that combines `subject` and `record`.
When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |

#### 10) Multiple `by` columns, a new `by_col`, and `cols`

We can provide multiple `by` columns, a new `by_col`, and multiple
`cols`.

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

This creates a new `join` column that combines `subject` and `record`.
When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Concomitant medication reported at baseline. | conmed |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Concomitant medication updated at visit two. | conmed |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | Physical exam completed with no abnormalities noted. | exam |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Medical history reviewed and confirmed complete. | history |
