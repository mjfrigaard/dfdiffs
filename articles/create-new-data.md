# create-new-data

## Motivation

The goal of the `dfdiffs` is to answer the following questions:

1.  *What rows are here now that weren’t here before?*
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

This vignette takes us through the
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function, which answers the “*What rows are here now that weren’t here
before?*”

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
#> $ text_var   <chr> "The birch canoe slid on the smooth planks.", "Glue the sh…
#> $ factor_var <chr> "food", "most", "park", "between", "regard", "law"
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

We will be comparing the `T2Data` to the original data, and we can see
this dataset has the same six rows as `T1Data`, but includes three
additional rows.

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
#> $ text_var   <chr> "Rice is often served in round bowls.", "The juice of lemo…
#> $ factor_var <chr> "regard", "law", "associate", "between", "park", "encourag…
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

We also need a function that allows users to specify joining variables,
which creates a new `join_var` given the supplied columns that
constitute a unique identifier in each dataset.

For example, in `T1Data` and `T2Data`, we can create a unique identifier
named `join_var`

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
| 1 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks. | food |
| 2 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most |
| 3 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | It’s easy to tell the depth of a well. | park |
| 4 | C | 4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | These days a chicken leg is a rare dish. | between |
| 5 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Rice is often served in round bowls. | regard |
| 6 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | The juice of lemons makes fine punch. | law |

``` r

T2DataJoin
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|---:|:---|:---|:---|:---|:---|
| 1 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Rice is often served in round bowls. | regard |
| 2 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | The juice of lemons makes fine punch. | law |
| 3 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us. | associate |
| 4 | C | 4 | 2022-01-29 | 2022-03-18 | 2022-03-27 | These days a chicken leg is a rare dish. | between |
| 5 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | It’s easy to tell the depth of a well. | park |
| 6 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage |
| 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks. | food |
| 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

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

4.  Single by column, new column name (`by_col`)

    ``` r

    create_new_data(
      compare = T2DataJoin, 
      base = T1DataJoin, 
      by = "join_var", 
      by_col = 'new_join_var')
    ```

5.  Single `by` column, multiple compare columns `cols`

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

`compare` = The current or new dataset in the comparison

`base` = The previous or old dataset in the comparison

`by` = the unique identifier for joining the two tables

`by_col` = a new name for the joining column

`cols` = the columns to compare (if none are provided, all columns are
compared)

### Call structure

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
relies on two helpers from the package:
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md)
(renames the join column) and
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

create_new_data(
  compare = T2Data, 
  base = T1Data)
```

| subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|
| D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us. | associate |
| B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage |
| A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin)
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | D | 5 | 2022-01-30 | 2022-03-16 | 2022-03-26 | Rice is often served in round bowls. | regard |
| 2 | D | 6 | 2022-01-27 | 2022-03-17 | 2022-03-31 | The juice of lemons makes fine punch. | law |
| 3 | D | 5 | 2022-04-04 | 2022-04-13 | 2022-04-22 | Four hours of steady work faced us. | associate |
| 5 | B | 3 | 2022-01-26 | 2022-03-19 | 2022-03-25 | It’s easy to tell the depth of a well. | park |
| 6 | B | 4 | 2022-04-02 | 2022-04-14 | 2022-04-20 | The hogs were fed chopped corn and garbage. | encourage |
| 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks. | food |
| 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

We can see this performs a row-by-row comparison.

#### 2) Multiple columns to compare (`cols`)

- No `by` columns (only two datasets) and multiple compare (`cols`)

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data,
  cols = c("text_var", "factor_var"))
```

| text_var                                    | factor_var |
|:--------------------------------------------|:-----------|
| Four hours of steady work faced us.         | associate  |
| The hogs were fed chopped corn and garbage. | encourage  |
| The box was thrown beside the parked truck. | pension    |

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin,
  cols = c("text_var", "factor_var"))
```

| text_var                                    | factor_var |
|:--------------------------------------------|:-----------|
| Four hours of steady work faced us.         | associate  |
| The hogs were fed chopped corn and garbage. | encourage  |
| The box was thrown beside the parked truck. | pension    |

#### 3) Single `by` column

- We can provide a single `by` column (using our `T1DataJoin` and
  `T2DataJoin`) datasets we created above.

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin, 
  by = "join_var")
```

| join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks. | food |
| 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

#### 4) Single `by` column, new column name (`by_col`)

- We can also provide a single `by` column (for unique identifiers) and
  a new name for the `by_col`

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin, 
  by = "join_var", 
  by_col = 'new_join_var')
```

| new_join_var | subject | record | start_date | mid_date | end_date | text_var | factor_var |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 7 | A | 1 | 2022-01-28 | 2022-03-20 | 2022-03-30 | The birch canoe slid on the smooth planks. | food |
| 8 | A | 2 | 2022-01-25 | 2022-03-15 | 2022-03-29 | Glue the sheet to the dark blue background. | most |
| 9 | A | 2 | 2022-04-04 | 2022-04-15 | 2022-04-21 | The box was thrown beside the parked truck. | pension |

#### 5) Single `by` column, multiple compare columns `cols`

- Single `by` column and multiple compare columns (`cols`)

``` r

create_new_data(
  compare = T2DataJoin, 
  base = T1DataJoin, 
  by = "join_var", 
  cols = c("text_var", "factor_var", "subject", "record"))
```

| join_var | text_var | factor_var | subject | record |
|:---|:---|:---|:---|:---|
| 7 | The birch canoe slid on the smooth planks. | food | A | 1 |
| 8 | Glue the sheet to the dark blue background. | most | A | 2 |
| 9 | The box was thrown beside the parked truck. | pension | A | 2 |

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

| new_join_var | subject | record | text_var | factor_var |
|:---|:---|:---|:---|:---|
| 7 | A | 1 | The birch canoe slid on the smooth planks. | food |
| 8 | A | 2 | Glue the sheet to the dark blue background. | most |
| 9 | A | 2 | The box was thrown beside the parked truck. | pension |

### Multiple `by` column conditions

Now we’re going to test conditions in which there are multiple columns
used to create a unique identifier.

#### 7) Multiple `by` columns

- Multiple `by` columns (assuming the columns create a unique
  identifier)

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'))
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

This creates a new `join` column and it’s a combination of `subject` and
`record`.

#### 8) Multiple `by` columns, new column name (`by_col`)

We can provide multiple `by` columns, a new `by_col`, and **no `cols`**

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'),
  by_col = "new_join_col")
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

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

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.

#### 10) Multiple `by` columns, a new `by_col`, and `cols`

We can provide multiple `by` columns, new `by_col`, and multiple `cols`

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data, 
  by = c('subject', 'record'),
  by_col = "new_join_col",
  cols = c("subject", "record", "text_var", "factor_var"))
```

    #> Error in `tidyr::unite()`:
    #> ! `sep` must be a single string, not absent.
