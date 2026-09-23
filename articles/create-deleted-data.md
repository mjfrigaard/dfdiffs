# create-deleted-data

## Motivation

The goal of the `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  *What rows were here before that aren’t here now?*
3.  What values have been changed?

This vignette takes us through the
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
function, which answers the “*What rows were here before that aren’t
here now?*”

### Packages

``` r

library(dfdiffs)
library(dplyr)
library(stringr)
library(forcats)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(flextable)
```

### What rows were here before that aren’t here now?

We will need three datasets to test for deleted data: `CompleteData`,
`IncompleteData`, and `DeletedData`

#### CompleteData

The `CompleteData` has 9 rows and 7 column. Unique rows are identified
by a combination of `subject` and `record`:

``` r

CompleteData <- dfdiffs::CompleteData
flextable::qflextable(CompleteData)
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | The copper bowl shone in the sun's rays. | interest |
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Take a chance and win a china doll. | sure |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A cramp is no small danger on a swim. | white |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Wake and rise, and step into the green outdoors. | situate |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Say it slow!y but make it ring clear. | document |

#### IncompleteData

`IncompeleteData` has 5 rows (4 have been removed)

``` r

IncompleteData <- dfdiffs::IncompleteData
flextable::qflextable(IncompleteData) |> 
  flextable::set_table_properties(layout = "autofit")
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 1 | 2021-12-28 | 2022-01-27 | 2022-02-26 | The copper bowl shone in the sun's rays. | interest |
| B | 1 | 2021-12-26 | 2022-01-25 | 2022-02-24 | Take a chance and win a china doll. | sure |
| B | 2 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A cramp is no small danger on a swim. | white |
| A | 3 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Wake and rise, and step into the green outdoors. | situate |
| D | 2 | 2021-12-27 | 2022-01-26 | 2022-02-25 | Say it slow!y but make it ring clear. | document |

#### DeletedData

`DeletedData` contains the 4 rows of data removed from `CompleteData` to
create `IncompleteData`

``` r

DeletedData <- dfdiffs::DeletedData
flextable::qflextable(DeletedData) |>
  flextable::set_table_properties(layout = "autofit")
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

If we check, the combination of `IncompleteData` and `DeletedData`
create `CompleteData`.

``` r

dplyr::all_equal(target = bind_rows(IncompleteData, DeletedData), 
                 current = CompleteData)
#> Warning: `all_equal()` was deprecated in dplyr 1.1.0.
#> ℹ Please use `all.equal()` instead.
#> ℹ And manually order the rows/cols as needed
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> [1] TRUE
```

### Conditions

Each function in the `dfdiffs` package assumes the following conditions:

1.  Two datasets

2.  Multiple columns to compare (`cols`)

3.  Single by column

4.  Single `by` column, new column name (`by_col`)

5.  Single `by` column, multiple compare columns (`cols`)

6.  `Single` by column, new column name (`by_col`), multiple compare
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

4.  Single by column, new column name (`by_col`)

    ``` r

    create_deleted_data(
      compare = IncompleteDataJoin, 
      base = CompleteDataJoin, 
      by = "join_var", 
      by_col = 'new_join_var')
    ```

5.  Single `by` column, multiple compare columns `cols`

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

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.
    #> Error:
    #> ! object 'CompleteDataJoin' not found

``` r

IncompleteDataJoin <- create_new_column(data = IncompleteData, 
  cols = c("subject", "record"), 
  new_name = "join_var")
IncompleteDataJoin
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.
    #> Error:
    #> ! object 'IncompleteDataJoin' not found

  
  

## create_deleted_data()

Below is our
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
function, which returns a tibble of the deleted rows.

``` r
create_deleted_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

### Call structure

[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
relies on the same two helpers as
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md):
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
(renames the join column) and
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
    ├─rename_join_col
    └─create_new_column

### Single `by` column conditions

The function should also be able to handle multiple conditions. Below we
cover the conditions for a single `by` columns (assuming there is an
existing unique identifier in each dataset). But first, we’ll cover a
few uncommon conditions, like a missing `by` column, or a missing `by`
column and specific columns selected for comparison.

#### 1) Two datasets

- No `by` columns (only two datasets)

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData)
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |

When we compare this `DeletedData`, we can see this performs a
row-by-row comparison.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

#### 2) Multiple columns to compare (`cols`)

- No `by` columns (only two datasets) and multiple compare (`cols`)

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin,
  cols = c("text_var", "factor_var"))
```

    #> Error:
    #> ! object 'IncompleteDataJoin' not found

When we compare this `DeletedData`, we can see the `text_var` and
`factor_var` are identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

#### 3) Single `by` column

- If the tables have a joining column, like `CompleteDataJoin` and
  `IncompleteDataJoin`, we can supply the (`by`) joining column

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin, 
  by = "join_var")
```

    #> Error:
    #> ! object 'IncompleteDataJoin' not found

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

#### 4) Single `by` column, new column name (`by_col`)

- We can also provide a single `by` column (for unique identifiers) and
  a new name for the `by_col`

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin, 
  by = "join_var", 
  by_col = 'new_join_var')
```

    #> Error:
    #> ! object 'IncompleteDataJoin' not found

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

#### 5) Single `by` column, multiple compare columns `cols`

- Single `by` column and multiple compare columns (`cols`)

``` r

create_deleted_data(
  compare = IncompleteDataJoin, 
  base = CompleteDataJoin, 
  by = "join_var", 
  cols = c("subject", "record", "factor_var", "text_var"))
```

    #> Error:
    #> ! object 'IncompleteDataJoin' not found

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

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

    #> Error:
    #> ! object 'IncompleteDataJoin' not found

When we compare this to `DeletedData`, we can see the rows are
identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

### Multiple `by` column conditions

Now we’re going to test conditions in which there are multiple columns
used to create a unique identifier.

#### 7) Multiple `by` columns

- Multiple `by` columns (assuming the columns create a unique
  identifier)

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData, 
  by = c('subject', 'record'))
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

This creates a new `join` column and it’s a combination of `subject` and
`record`, and when we compare this to `DeletedData`, we can see the rows
are identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

#### 8) Multiple `by` columns, new column name (`by_col`)

We can provide multiple `by` columns, a new `by_col`, and **no `cols`**

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData,
  by = c('subject', 'record'),
  by_col = "new_join_col")
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

This creates a new `new_join_col` column and it’s a combination of
`subject` and `record`, and when we compare this to `DeletedData`, we
can see the rows are identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

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

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

This creates a new `join` column, and it’s a combination of `subject`
and `record`, and when we compare this to `DeletedData`, we can see the
rows are identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |

#### 10) Multiple `by` columns, a new `by_col`, and `cols`

We can provide multiple `by` columns, new `by_col`, and multiple `cols`

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData, 
  by = c('subject', 'record'),
  by_col = "new_join_col",
  cols = c("subject", "record", "text_var", "factor_var"))
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

This creates a new `join` column, and it’s a combination of `subject`
and `record`, and when we compare this to `DeletedData`, we can see the
rows are identical.

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|----|----|----|----|----|----|----|
| A | 2 | 2021-12-28 | 2022-01-27 | 2022-02-26 | Mark the spot with a sign painted red. | state |
| B | 3 | 2021-12-26 | 2022-01-25 | 2022-02-24 | A blue crane is a tall wading bird. | shut |
| C | 1 | 2021-12-30 | 2022-01-29 | 2022-02-28 | It's easy to tell the depth of a well. | grant |
| D | 1 | 2021-12-27 | 2022-01-26 | 2022-02-25 | The sky that morning was clear and bright blue. | tape |
