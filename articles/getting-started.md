# getting-started

## Motivation

This vignette introduces the `dfdiffs` package. The goal of `dfdiffs` is
to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

### Packages

Load `dfdiffs`:

``` r

library(dfdiffs)
```

Load the other packages used in this vignette:

``` r

library(shiny)
library(data.table)
library(stringr)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(haven)
library(readxl)
library(janitor)
library(reactable)
library(labelled)
library(gtsummary)
```

### Package functions

`dfdiffs` has a function for each of the questions posed above, and each
function comes with a pair of example datasets that demonstrate how it
works (which we’ll cover below).

#### Call structure

The four comparison functions below are built from a few small helpers,
and the same functions power the package’s Shiny app. The call trees in
this section were generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
`dfdiffs` are shown.

``` r

library(stackcallr)
call_tree_dir("R", root = "create_new_data")
call_tree_dir("R", root = "create_deleted_data")
call_tree_dir("R", root = "create_changed_data")
call_tree_dir("R", root = "create_modified_data")
```

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
and
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
(the “new rows”/“deleted rows” answers) share
[`anti_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/anti_join_base.md),
[`select_cols()`](https://mjfrigaard.github.io/dfdiffs/reference/select_cols.md),
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md),
and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md).
These are all base-R helpers, so no external comparison package is
involved:

    █─create_new_data
    ├─anti_join_base
    ├─select_cols
    ├─rename_join_col
    └─create_new_column

    █─create_deleted_data
    ├─anti_join_base
    ├─select_cols
    ├─rename_join_col
    └─create_new_column

[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
(the “changed values” answer) both build on
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md),
which compares matched rows column-by-column with
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
(tolerance-aware for numeric/date-time values, label-aware for factors)
and records any class mismatches via `class_diffs()`:

    █─create_changed_data
    ├─select_cols
    ├─█─diff_values_by_key
    │ ├─compare_values
    │ └─class_diffs
    ├─rename_join_col
    └─create_new_column

The Shiny app
([`launch_app()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_app.md))
wires these functions together with three modules (upload, select, and
compare), each with a UI function and a server function.
[`app_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/app_ui.md)
and
[`app_server()`](https://mjfrigaard.github.io/dfdiffs/reference/app_server.md)
assemble the modules, and
[`dfdiffs_fresh_theme()`](https://mjfrigaard.github.io/dfdiffs/reference/dfdiffs_fresh_theme.md)
supplies the app’s theme:

``` r

call_tree_dir("R", root = "launch_app")
```

    █─launch_app
    ├─█─app_ui
    │ ├─dfdiffs_fresh_theme
    │ ├─mod_upload_ui
    │ ├─mod_select_ui
    │ └─mod_compare_ui
    └─█─app_server
      ├─█─mod_upload_server
      │ ├─█─upload_data
      │ │ └─load_flat_file
      │ ├─base_react_theme
      │ └─comp_react_theme
      ├─█─mod_select_server
      │ ├─select_cols
      │ ├─base_react_theme
      │ ├─comp_react_theme
      │ ├─info_react_theme
      │ └─█─create_join_column
      │   └─select_cols
      └─█─mod_compare_server
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
        │ └─create_new_column
        ├─select_cols
        ├─changed_react_theme
        └─left_join_base

### *What rows are here now that weren’t here before?*

To check for new data, we’ll use `T1Data` and `T2Data`.

``` r

T1Data <- dfdiffs::T1Data
T2Data <- dfdiffs::T2Data
NewData <- dfdiffs::NewData
```

#### Timepoint 1 data (original)

`T1Data` represents data collected at the first timepoint (T1).

**`T1Data`**: Simulated ‘time-point 1’ data

#### Timepoint 2 data (new)

`T2Data` is the ‘new’ dataset, representing data collected at the second
timepoint (T2).

**`T2Data`**: Simulated ‘time-point 2’ data

#### `create_new_data()`

The
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
function returns the ‘new data’ (i.e., the rows that are here now but
weren’t here before).

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data)
```

Output from
**[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)**:
Difference between ‘time-point 1’ & ‘time-point 2’

We can check this against the `NewData` dataset, which should match the
output from
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md).

**`NewData`**: stored differences from
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)

### *What rows were here before that aren’t here now?*

To test for deleted data, we’ll compare `CompleteData` and
`IncompleteData`, then check the result against `DeletedData`.

``` r

CompleteData <- dfdiffs::CompleteData
IncompleteData <- dfdiffs::IncompleteData
DeletedData <- dfdiffs::DeletedData
```

#### A complete dataset

`CompleteData` represents a ‘complete’ set of data.

**`CompleteData`**: simulated data for checking ‘deleted data’

#### An incomplete dataset

This is a dataset with rows removed from `CompleteData`.

**`IncompleteData`**: simulated data for checking ‘deleted data’

#### `create_deleted_data()`

Running
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
checks for rows that were deleted between `CompleteData` and
`IncompleteData`.

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData) 
```

Output from
**[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)**:
Differences between `CompleteData` and `IncompleteData`

#### The deleted data

The output above is identical to the data stored in `DeletedData`.

**`DeletedData`**: Output from
**[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)**

### *What values have been changed?*

To answer this question, we have two options:
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).
Both build on the same base-R
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)/[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)
engine and differ only in the shape of their output:
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
returns `$num_diffs`/`$var_diffs` (used by
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
returns `$diffs_byvar`/`$diffs` (used by `mod_compare` and
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)).

To check for changes between two datasets, we’ll use `InitialData` and
`ChangedData`.

``` r

InitialData <- dfdiffs::InitialData
ChangedData <- dfdiffs::ChangedData
```

#### Initial data

**`InitialData`**: simulated data for checking ‘changed/modified data’

#### Changed data

**`ChangedData`**: simulated data for checking ‘modified data’

#### `create_changed_data()`

[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
creates a list of tables.

``` r

changed <- create_changed_data(
  compare = ChangedData,
  base = InitialData)
names(changed)
#> [1] "num_diffs" "var_diffs"
```

##### Counts of changes (`num_diffs`)

The counts of changes by variable are stored in `num_diffs`.

**`num_diffs`**: counts of changes for ‘changed data’

##### Changes by row (`var_diffs`)

The changes by row are stored in `var_diffs`.

**`var_diffs`**: Row-by-row of changes for ‘changed data’

#### `create_modified_data()`

The
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
function also creates a list of tables.

``` r

modified <- create_modified_data(
  compare = ChangedData,
  base = InitialData)
names(modified)
#> [1] "diffs"       "diffs_byvar"
```

##### Counts of changes (`diffs_byvar`)

The counts of changes by variable are stored in `diffs_byvar`.

**`diffs_byvar`**: counts of changes for ‘modified data’

##### Changes by row

The changes by row are stored in `diffs`.

**`diffs`**: Row-by-row changes of ‘modified data’
