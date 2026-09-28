# create-new-data

## Motivation

When we receive an updated version of a dataset, `dfdiffs` helps us
answer three questions:

1.  *What rows are here now that weren’t here before?*
2.  What rows were here before that aren’t here now?
3.  What values have been changed?

This vignette covers
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
which answers the first question: “*What rows are here now that weren’t
here before?*”

### Packages

``` r

library(dfdiffs)
library(dplyr)
```

### What rows are here now that weren’t here before?

We’ll use two test datasets from the package to demonstrate
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).

#### Base Data

`T1Data` is our base (original) dataset. It contains six rows and eight
variables.

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

Each row in `T1Data` is uniquely identified by the combination of
`subject` and `record`, which we can confirm below:

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

`T2Data` is the dataset we’ll compare against `T1Data`. It has the same
six rows as `T1Data`, plus three additional rows.

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

The same `subject` and `record` combination uniquely identifies each row
in `T2Data`:

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

Matching rows between two datasets requires a joining variable that
uniquely identifies each row. The simplest option is a row number, so
we’ll start by adding a `join_var` column to both `T1Data` and `T2Data`
and moving it to the front:

``` r

T1DataJoin <- mutate(T1Data, 
  join_var = as.character(row_number())) %>% 
  dplyr::relocate(join_var, everything())
T2DataJoin <- mutate(T2Data, 
  join_var = as.character(row_number())) %>% 
  dplyr::relocate(join_var, everything())
```

Both datasets now start with a `join_var` column:

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

### `create_new_column()`

`T1DataJoin` and `T2DataJoin` use a plain row number as the join key.
When the unique identifier is a *combination* of existing columns (like
`subject` and `record`),
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
pastes those columns together into a single new column. The function
takes the data, the columns to combine, and a name for the new column:

``` r

create_new_column(data = , cols = , new_name = )
```

Below we combine `subject` and `record` into `join_var` for both
datasets:

``` r

T1DataSubjRec <- create_new_column(data = T1Data,
  cols = c("subject", "record"),
  new_name = "join_var")
T2DataSubjRec <- create_new_column(data = T2Data,
  cols = c("subject", "record"),
  new_name = "join_var")
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|---:|:---|:---|:---|:---|:---|
| A-1 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | Patient reports mild headache after morning dose. | headache |
| A-2 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Patient reports occasional nausea following meals. | nausea |
| B-3 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | Patient reports persistent fatigue throughout the day. | fatigue |
| C-4 | C | 4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | Patient reports brief dizziness upon standing. | dizziness |
| D-5 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Patient reports mild rash on the left forearm. | rash |
| D-6 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | Patient reports low-grade fever in the evening. | fever |

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
all call this same helper internally whenever `by` has more than one
column (see the call trees below and in
[create-deleted-data](https://mjfrigaard.github.io/dfdiffs/articles/create-deleted-data.html#call-structure)).

### Arguments

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
takes five arguments, and every comparison function in the package
shares them: `compare`, `base`, `by`, `by_col`, and `cols`. The last
three are optional, and the combination we supply determines how rows
are matched and which columns are compared:

| `by` | `by_col` | `cols` | What happens |
|:---|:---|:---|:---|
| (none) | (none) | (none) | rows are matched on their values across every shared column ([`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md) and [`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md) match by row position instead) |
| (none) | (none) | given | the same matching, restricted to `cols` |
| single column | (none) | (none) | join on `by`, compare every shared column |
| single column | given | (none) | join, renaming the key column to `by_col` |
| single column | (none) | given | join on `by`, compare only `cols` |
| single column | given | given | join renamed to `by_col`, compare only `cols` |
| multiple columns | (none) | (none) | `by` columns combined into one `join` key |
| multiple columns | given | (none) | `by` columns combined into a key named `by_col` |
| multiple columns | (none) | given | combined key, compare only `cols` |
| multiple columns | given | given | combined key named `by_col`, compare only `cols` |

The worked examples below cover three of these cases: no `by` column, a
single `by` column, and multiple `by` columns with `by_col` and `cols`.
Every other row in the table is a combination of the same pieces.

## create_new_data()

The signature and source for
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
are below:

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

The source above is for display only (`eval=FALSE`). The examples below
call the exported
[`dfdiffs::create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).

`compare` = the current (new) dataset in the comparison

`base` = the previous (old) dataset in the comparison

`by` = the unique identifier for joining the two tables

`by_col` = a new name for the joining column

`cols` = the columns to compare (if none are provided, all columns are
compared)

### Call structure

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
relies on four helpers from the package.
[`anti_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/anti_join_base.md)
and
[`select_cols()`](https://mjfrigaard.github.io/dfdiffs/reference/select_cols.md)
are base R replacements for
[`dplyr::anti_join()`](https://dplyr.tidyverse.org/reference/filter-joins.html)
and
[`dplyr::select()`](https://dplyr.tidyverse.org/reference/select.html),
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
renames the join column, and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md)
builds the join column from the `by` columns.

The call tree below was generated from the package source with
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

### Worked examples

#### No `by` column: matching whole rows

When we supply only the two datasets,
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
treats a row in `compare` as new if no row in `base` has identical
values across every shared column:

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

#### A single `by` column

`T1DataJoin` and `T2DataJoin` both contain the `join_var` identifier we
created above. Passing it as a single `by` column matches rows on that
key instead of on row position:

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

#### Multiple `by` columns, a new `by_col`, and `cols`

This is the most complete case. The `by` columns are combined into a
single key named with `by_col`, and only the columns in `cols` are
compared:

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
