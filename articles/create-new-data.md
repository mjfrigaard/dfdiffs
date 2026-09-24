# create-new-data

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  *What rows are here now that weren’t here before?*
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

This vignette takes us through the
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function, which answers the question, “*What rows are here now that
weren’t here before?*”

### Packages

``` r

library(dfdiffs)
library(dplyr)
library(stringr)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
```

### What rows are here now that weren’t here before?

We’re going to use two test datasets to demonstrate the
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function.

#### Base Data

The `T1Data` below contains six rows and eight variables.

``` r

T1Data <- dfdiffs::T1Data
glimpse(T1Data)
#> Rows: 6
#> Columns: 7
#> $ subject    <chr> "A", "A", "B", "C", "D", "D"
#> $ record     <int> 1, 2, 3, 4, 5, 6
#> $ start_date <date> 2022-01-28, 2022-01-25, 2022-01-26, 2022-01-29, 2022-01-30,…
#> $ mid_date   <date> 2022-03-20, 2022-03-15, 2022-03-19, 2022-03-18, 2022-03-16,…
#> $ end_date   <date> 2022-03-30, 2022-03-29, 2022-03-25, 2022-03-27, 2022-03-26…
#> $ text_var   <chr> "Patient reports mild headache after morning dose.", "Pati…
#> $ factor_var <chr> "headache", "nausea", "fatigue", "dizziness", "rash", "fev…
```

The unique identifier in this dataset is the combination of subject and
record (which we can see below):

``` r

distinct(T1Data, subject)
#> # A tibble: 4 × 1
#>   subject
#>   <chr>  
#> 1 A      
#> 2 B      
#> 3 C      
#> 4 D
distinct(T1Data, subject, record)
#> # A tibble: 6 × 2
#>   subject record
#>   <chr>    <int>
#> 1 A            1
#> 2 A            2
#> 3 B            3
#> 4 C            4
#> 5 D            5
#> 6 D            6
```

#### Compare Data

We’ll compare `T2Data` to the original data. `T2Data` has the same six
rows as `T1Data`, plus three additional rows.

``` r

T2Data <- dfdiffs::T2Data
glimpse(T2Data)
#> Rows: 9
#> Columns: 7
#> $ subject    <chr> "D", "D", "D", "C", "B", "B", "A", "A", "A"
#> $ record     <int> 5, 6, 5, 4, 3, 4, 1, 2, 2
#> $ start_date <date> 2022-01-30, 2022-01-27, 2022-04-04, 2022-01-29, 2022-01-26,…
#> $ mid_date   <date> 2022-03-16, 2022-03-17, 2022-04-13, 2022-03-18, 2022-03-19,…
#> $ end_date   <date> 2022-03-26, 2022-03-31, 2022-04-22, 2022-03-27, 2022-03-25…
#> $ text_var   <chr> "Patient reports mild rash on the left forearm.", "Patient…
#> $ factor_var <chr> "rash", "fever", "back pain", "dizziness", "fatigue", "ins…
```

The unique identifier in this dataset is the combination of subject and
record (which we can see below):

``` r

distinct(T2Data, subject)
#> # A tibble: 4 × 1
#>   subject
#>   <chr>  
#> 1 D      
#> 2 C      
#> 3 B      
#> 4 A
distinct(T2Data, subject, record)
#> # A tibble: 7 × 2
#>   subject record
#>   <chr>    <int>
#> 1 D            5
#> 2 D            6
#> 3 C            4
#> 4 B            3
#> 5 B            4
#> 6 A            1
#> 7 A            2
```

#### Creating a unique identifier

We also need a function that lets users specify the joining variables.
It creates a new `join_var` from the supplied columns that together form
a unique identifier in each dataset.

For example, we can create a unique identifier named `join_var` in
`T1Data` and `T2Data`:

``` r

T1DataJoin <- mutate(T1Data, 
  join_var = as.character(row_number())) %>% 
  dplyr::relocate(join_var, everything())
T2DataJoin <- mutate(T2Data, 
  join_var = as.character(row_number())) %>% 
  dplyr::relocate(join_var, everything())
```

``` r

T1DataJoin
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|---:|:---|:---|:---|:---|:---|
| 1 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | Patient reports mild headache after morning dose. | headache |
| 2 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Patient reports occasional nausea following meals. | nausea |
| 3 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | Patient reports persistent fatigue throughout the day. | fatigue |
| 4 | C | 4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | Patient reports brief dizziness upon standing. | dizziness |
| 5 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Patient reports mild rash on the left forearm. | rash |
| 6 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | Patient reports low-grade fever in the evening. | fever |

``` r

T2DataJoin
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|---:|:---|:---|:---|:---|:---|
| 1 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Patient reports mild rash on the left forearm. | rash |
| 2 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | Patient reports low-grade fever in the evening. | fever |
| 3 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| 4 | C | 4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | Patient reports brief dizziness upon standing. | dizziness |
| 5 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | Patient reports persistent fatigue throughout the day. | fatigue |
| 6 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | Patient reports mild headache after morning dose. | headache |
| 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Patient reports occasional nausea following meals. | nausea |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

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

    create_new_data(
      compare = T2Data, 
      base = T1Data)
    ```

2.  Multiple columns to compare (`cols`):

    ``` r

    create_new_data(
      compare = T2Data, 
      base = T1Data,
      cols = c("text_var", "factor_var"))
    ```

3.  Single `by` column, no new column name

    ``` r

    create_new_data(
      compare = T2DataJoin, 
      base = T1DataJoin, 
      by = "join_var")
    ```

4.  Single `by` column, new column name (`by_col`)

    ``` r

    create_new_data(
      compare = T2DataJoin, 
      base = T1DataJoin, 
      by = "join_var", 
      by_col = 'new_join_var')
    ```

5.  Single `by` column, multiple compare columns (`cols`)

    ``` r

    create_new_data(
      compare = T2DataJoin, 
      base = T1DataJoin, 
      by = "join_var", 
      cols = c("text_var", "factor_var", "subject", "record"))
    ```

6.  Single `by` column, new column name (`by_col`), multiple compare
    columns (`cols`)

    ``` r

    create_new_data(
    compare = T2DataJoin, 
    base = T1DataJoin, 
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

    create_new_data(
      compare = T2Data, 
      base = T1Data, 
      by = c('subject', 'record'))
    ```

8.  Multiple `by` columns, new column name (`by_col`)

    ``` r

    create_new_data(
      compare = T2Data, 
      base = T1Data, 
      by = c('subject', 'record'),
      by_col = "new_join_col")
    ```

9.  Multiple `by` columns, multiple compare columns (`cols`)

    ``` r

    create_new_data(
      compare = T2Data, 
      base = T1Data, 
      by = c('subject', 'record'),
      cols = c("subject",  "record", "factor_var", "text_var"))
    ```

10. Multiple `by` columns, a new `by_col`, and `cols`

    ``` r

    create_new_data(
      compare = T2Data, 
      base = T1Data, 
      by = c('subject', 'record'),
      by_col = "new_join_col",
      cols = c("subject", "record", "text_var", "factor_var"))
    ```

## create_new_data()

Below is the
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function:

``` r

create_new_data(compare, base, by = NULL, by_col = NULL, cols = NULL)
```

``` r

create_new_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  compare[] <- lapply(compare, as.character)
  base[] <- lapply(base, as.character)

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) no 'by', no 'by_col', no 'cols' -----
    new_data_join <- anti_join_base(x = compare, y = base,
                                     by = intersect(names(compare), names(base)))
    new_data <- unique(new_data_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) no 'by', no 'by_col', multiple compare 'cols' -----
    compare_join_cols <- select_cols(compare, cols)
    base_join_cols <- select_cols(base, cols)
    new_data_join <- anti_join_base(x = compare_join_cols, y = base_join_cols,
                            by = intersect(names(compare_join_cols), names(base_join_cols)))
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) single 'by' column ----
    new_data_join <- anti_join_base(x = compare, y = base, by = by)
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & length(by_col) == 1 & is.null(cols)) {
    # 4) single 'by' column, new 'by_col' ----
    compare <- rename_join_col(compare, by = by, by_col = by_col)
    base <- rename_join_col(base, by = by, by_col = by_col)
    new_data_join <- anti_join_base(x = compare, y = base, by = by_col)
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' column, multiple compare 'cols' ----
    compare_cols <- select_cols(compare, c(by, cols))
    base_cols <- select_cols(base, c(by, cols))
    new_data_join <- anti_join_base(x = compare_cols, y = base_cols, by = by)
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) single 'by' column, new 'by_col', multiple compare 'cols' ----
    compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(base, by = by, by_col = by_col)
    compare_join <- select_cols(compare_cols, c(by_col, cols))
    base_join <- select_cols(base_cols, c(by_col, cols))
    new_data_join <- anti_join_base(x = compare_join, y = base_join, by = by_col)
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) multiple 'by' ----
    # no 'by_col', no multiple compare 'cols'
    compare_join <- create_new_column(data = compare, cols = by, new_name = "join")
    base_join <- create_new_column(data = base, cols = by, new_name = "join")
    new_data_join <- anti_join_base(x = compare_join, y = base_join,
                            by = intersect(names(compare_join), names(base_join)))
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) multiple 'by' and 'by_col' ----
    # no multiple compare 'cols'
    compare_join <- create_new_column(data = compare, cols = by, new_name = by_col)
    base_join <- create_new_column(data = base, cols = by, new_name = by_col)
    new_data_join <- anti_join_base(x = compare_join, y = base_join,
                            by = intersect(names(compare_join), names(base_join)))
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple 'by' & multiple compare 'cols' ----
    # no 'by_col'
    compare_join <- create_new_column(data = compare, cols = by, new_name = "join")
    base_join <- create_new_column(data = base, cols = by, new_name = "join")
    compare_join_cols <- select_cols(compare_join, c("join", cols))
    base_join_cols <- select_cols(base_join, c("join", cols))
    new_data_join <- anti_join_base(x = compare_join_cols, y = base_join_cols,
                            by = intersect(names(compare_join_cols), names(base_join_cols)))
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new 'by_col' & compare multiple 'cols' ----
    compare_join <- create_new_column(data = compare, cols = by, new_name = by_col)
    base_join <- create_new_column(data = base, cols = by, new_name = by_col)
    compare_join_cols <- select_cols(compare_join, c(by_col, cols))
    base_join_cols <- select_cols(base_join, c(by_col, cols))
    new_data_join <- anti_join_base(x = compare_join_cols, y = base_join_cols,
                            by = intersect(names(compare_join_cols), names(base_join_cols)))
    new_data <- unique(new_data_join)
  }

  return(new_data)
}
```

The `cond-1` through `cond-10` examples above call the real, exported
[`dfdiffs::create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).
The source shown here is display-only (`eval=FALSE`) and no longer
redefines the function, so it can’t shadow the package’s own
implementation.

`compare` = The current or new dataset in the comparison

`base` = The previous or old dataset in the comparison

`by` = the unique identifier for joining the two tables

`by_col` = a new name for the joining column

`cols` = the columns to compare (if none are provided, all columns are
compared)

### Call structure

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
relies on four helpers from the package:
[`anti_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/anti_join_base.md)
and
[`select_cols()`](https://mjfrigaard.github.io/dfdiffs/reference/select_cols.md)
(base-R replacements for
[`dplyr::anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)/[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html)),
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
(renames the join column), and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
(builds the join column from the `by` columns). The call tree below was
generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "create_new_data")
```

    █─create_new_data
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

create_new_data(
  compare = T2Data, 
  base = T1Data)
```

|  | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 3 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| 6 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin)
```

|  | join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | 1 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Patient reports mild rash on the left forearm. | rash |
| 2 | 2 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | Patient reports low-grade fever in the evening. | fever |
| 3 | 3 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| 5 | 5 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | Patient reports persistent fatigue throughout the day. | fatigue |
| 6 | 6 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| 7 | 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | Patient reports mild headache after morning dose. | headache |
| 8 | 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Patient reports occasional nausea following meals. | nausea |
| 9 | 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

We can see this performs a row-by-row comparison.

#### 2) Multiple columns to compare (`cols`)

- No `by` columns (only two datasets) and multiple compare columns
  (`cols`)

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data,
  cols = c("text_var", "factor_var"))
```

|     | text_var                                               | factor_var |
|:----|:-------------------------------------------------------|:-----------|
| 3   | Patient reports lower back pain after activity.        | back pain  |
| 6   | Patient reports difficulty sleeping through the night. | insomnia   |
| 9   | Patient reports dry cough lasting several days.        | cough      |

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin,
  cols = c("text_var", "factor_var"))
```

|     | text_var                                               | factor_var |
|:----|:-------------------------------------------------------|:-----------|
| 3   | Patient reports lower back pain after activity.        | back pain  |
| 6   | Patient reports difficulty sleeping through the night. | insomnia   |
| 9   | Patient reports dry cough lasting several days.        | cough      |

#### 3) Single `by` column

- We can provide a single `by` column using the `T1DataJoin` and
  `T2DataJoin` datasets we created above.

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin, 
  by = "join_var")
```

|  | join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 7 | 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | Patient reports mild headache after morning dose. | headache |
| 8 | 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Patient reports occasional nausea following meals. | nausea |
| 9 | 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

#### 4) Single `by` column, new column name (`by_col`)

- We can also provide a single `by` column (the unique identifier) and a
  new name for it with `by_col`.

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin, 
  by = "join_var", 
  by_col = 'new_join_var')
```

|  | new_join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 7 | 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | Patient reports mild headache after morning dose. | headache |
| 8 | 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Patient reports occasional nausea following meals. | nausea |
| 9 | 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

#### 5) Single `by` column, multiple compare columns (`cols`)

- Single `by` column and multiple compare columns (`cols`)

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin, 
  by = "join_var", 
  cols = c("text_var", "factor_var", "subject", "record"))
```

|  | join_var | text_var | factor_var | subject | record |
|:---|:---|:---|:---|:---|:---|
| 7 | 7 | Patient reports mild headache after morning dose. | headache | A | 1 |
| 8 | 8 | Patient reports occasional nausea following meals. | nausea | A | 2 |
| 9 | 9 | Patient reports dry cough lasting several days. | cough | A | 2 |

#### 6) Single `by` column, new column name (`by_col`), multiple compare columns (`cols`)

- Single `by` column, a new name for the by column (`by_col`), and
  multiple compare columns (`cols`)

``` r

create_new_data(
  # data 
  compare = T2DataJoin, 
  base = T1DataJoin, 
  # unique id
  by = "join_var", 
  # new name for id
  by_col = 'new_join_var', 
  # cols to compare
  cols = c("subject", "record", "text_var", "factor_var"))
```

|  | new_join_var | subject | record | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|
| 7 | 7 | A | 1 | Patient reports mild headache after morning dose. | headache |
| 8 | 8 | A | 2 | Patient reports occasional nausea following meals. | nausea |
| 9 | 9 | A | 2 | Patient reports dry cough lasting several days. | cough |

### Multiple `by` column conditions

Next, we’ll test conditions in which multiple columns are used to create
a unique identifier.

#### 7) Multiple `by` columns

- Multiple `by` columns (assuming the columns create a unique
  identifier)

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'))
```

|  | join | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 3 | D-5 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| 6 | B-4 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| 9 | A-2 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

This creates a new `join` column that combines `subject` and `record`.

#### 8) Multiple `by` columns, new column name (`by_col`)

We can provide multiple `by` columns, a new `by_col`, and **no `cols`**.

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'),
  by_col = "new_join_col")
```

|  | new_join_col | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 3 | D-5 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Patient reports lower back pain after activity. | back pain |
| 6 | B-4 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | Patient reports difficulty sleeping through the night. | insomnia |
| 9 | A-2 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | Patient reports dry cough lasting several days. | cough |

#### 9) Multiple `by` columns, multiple compare columns (`cols`)

- Multiple `by` columns and multiple compare columns (`cols`), and **no
  new `by_col`**.

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'),
  cols = c("subject",  "record", "factor_var", "text_var"))
```

|  | join | subject | record | factor_var | text_var |
|:---|:---|:---|:---|:---|:---|
| 3 | D-5 | D | 5 | back pain | Patient reports lower back pain after activity. |
| 6 | B-4 | B | 4 | insomnia | Patient reports difficulty sleeping through the night. |
| 9 | A-2 | A | 2 | cough | Patient reports dry cough lasting several days. |

#### 10) Multiple `by` columns, a new `by_col`, and `cols`

We can provide multiple `by` columns, a new `by_col`, and multiple
`cols`.

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'),
  by_col = "new_join_col",
  cols = c("subject", "record", "text_var", "factor_var"))
```

|  | new_join_col | subject | record | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|
| 3 | D-5 | D | 5 | Patient reports lower back pain after activity. | back pain |
| 6 | B-4 | B | 4 | Patient reports difficulty sleeping through the night. | insomnia |
| 9 | A-2 | A | 2 | Patient reports dry cough lasting several days. | cough |
