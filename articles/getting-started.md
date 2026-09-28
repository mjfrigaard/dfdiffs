# getting-started

## Motivation

When a new version of a dataset arrives, the first thing we usually want
to know is what changed since the last one. `dfdiffs` answers that with
three questions:

1.  What rows are here now that weren’t here before?  
2.  What rows were here before that aren’t here now?  
3.  What values have been changed?

### Packages

We’ll start by loading `dfdiffs`:

``` r

library(dfdiffs)
```

The code below loads the other packages used in this vignette:

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

`dfdiffs` has a function for each question above, and each function
comes with a pair of example datasets that show how it works. We’ll walk
through each pair below.

#### Call structure

The four comparison functions are built from a few small helpers, and
the same functions power the package’s Shiny app. I generated the call
trees in this section from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`), and they only show functions
defined in `dfdiffs`.

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
answer the first two questions (new rows and deleted rows), and both
rely on the same four helpers:
[`anti_join_base()`](https://mjfrigaard.github.io/dfdiffs/reference/anti_join_base.md),
[`select_cols()`](https://mjfrigaard.github.io/dfdiffs/reference/select_cols.md),
[`rename_join_col()`](https://mjfrigaard.github.io/dfdiffs/reference/rename_join_col.md),
and
[`create_new_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_column.md).
These helpers are written in base R, so no external comparison package
is involved:

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
answer the third question (changed values), and both build on
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md).
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
compares matched rows column by column with
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md),
which is tolerance-aware for numeric and date-time values and
label-aware for factors. Any class mismatches are recorded with
`class_diffs()`. The call tree for
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
is shown below:

    █─create_changed_data
    ├─select_cols
    ├─█─diff_values_by_key
    │ ├─compare_values
    │ └─class_diffs
    ├─rename_join_col
    ├─create_new_column
    └─class_diffs

The Shiny app
([`launch_app()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_app.md))
wires these functions together with three modules (upload, select, and
compare), and each module has a UI function and a server function.
[`app_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/app_ui.md)
and
[`app_server()`](https://mjfrigaard.github.io/dfdiffs/reference/app_server.md)
assemble the modules, and
[`dfdiffs_fresh_theme()`](https://mjfrigaard.github.io/dfdiffs/reference/dfdiffs_fresh_theme.md)
supplies the app’s theme. The code below generates the full call tree
for the app:

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
        ├─compare_columns
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
        │ ├─create_new_column
        │ └─class_diffs
        ├─select_cols
        ├─changed_react_theme
        ├─left_join_base
        └─█─create_comparison_report
          ├─█─create_new_data
          │ ├─anti_join_base
          │ ├─select_cols
          │ ├─rename_join_col
          │ └─create_new_column
          ├─█─create_deleted_data
          │ ├─anti_join_base
          │ ├─select_cols
          │ ├─rename_join_col
          │ └─create_new_column
          ├─█─create_modified_data
          │ ├─select_cols
          │ ├─█─diff_values_by_key
          │ │ ├─compare_values
          │ │ └─class_diffs
          │ ├─rename_join_col
          │ ├─create_new_column
          │ └─class_diffs
          ├─create_empty_tbl
          ├─compare_columns
          ├─class_diffs
          └─█─compare_summary
            └─█─compare_data
              ├─█─create_new_data
              │ ├─anti_join_base
              │ ├─select_cols
              │ ├─rename_join_col
              │ └─create_new_column
              ├─█─create_deleted_data
              │ ├─anti_join_base
              │ ├─select_cols
              │ ├─rename_join_col
              │ └─create_new_column
              ├─█─create_changed_data
              │ ├─select_cols
              │ ├─█─diff_values_by_key
              │ │ ├─compare_values
              │ │ └─class_diffs
              │ ├─rename_join_col
              │ ├─create_new_column
              │ └─class_diffs
              ├─class_diffs
              └─compare_columns

### *What rows are here now that weren’t here before?*

To find new rows, we’ll compare `T1Data` and `T2Data`, then check the
result against `NewData`.

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

[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)
returns the ‘new data’ (i.e., the rows that are here now but weren’t
here before). We pass the newer dataset to `compare` and the original
dataset to `base`:

``` r

create_new_data(
  compare = T2Data, 
  base = T1Data)
```

Output from
**[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md)**:
Differences between ‘time-point 1’ and ‘time-point 2’

We can confirm this output is correct by checking it against the stored
`NewData` dataset. The two tables should match.

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

`CompleteData` is the full dataset, before any rows were removed.

**`CompleteData`**: simulated data for checking ‘deleted data’

#### An incomplete dataset

`IncompleteData` is a copy of `CompleteData` with some rows removed.

**`IncompleteData`**: simulated data for checking ‘deleted data’

#### `create_deleted_data()`

[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)
returns the rows in `base` that are missing from `compare`. Here, that
means the rows in `CompleteData` that were dropped from
`IncompleteData`:

``` r

create_deleted_data(
  compare = IncompleteData, 
  base = CompleteData) 
```

Output from
**[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)**:
Differences between `CompleteData` and `IncompleteData`

#### The deleted data

The output above matches the data stored in `DeletedData`, which
confirms the deleted rows were identified correctly.

**`DeletedData`**: Output from
**[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md)**

### *What values have been changed?*

`dfdiffs` has two functions for this question:
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).
Both build on the same base-R engine
([`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md)
and
[`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md)),
and they differ only in the shape of their output.
[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
returns `$num_diffs` and `$var_diffs`, which
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
uses.
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
returns `$diffs_byvar` and `$diffs`, which the app’s compare module
(`mod_compare`) and
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
use.

To check for changed values, we’ll compare `InitialData` and
`ChangedData`:

``` r

InitialData <- dfdiffs::InitialData
ChangedData <- dfdiffs::ChangedData
```

#### Initial data

`InitialData` is the original version of the data.

**`InitialData`**: simulated data for checking ‘changed/modified data’

#### Changed data

`ChangedData` is the version we’ll compare against `InitialData`.

**`ChangedData`**: simulated data for checking ‘modified data’

#### `create_changed_data()`

[`create_changed_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_changed_data.md)
returns a list of tables. The code below stores the result and prints
the names of its elements:

``` r

changed <- create_changed_data(
  compare = ChangedData,
  base = InitialData)
names(changed)
#> [1] "num_diffs"   "var_diffs"   "class_diffs"
```

##### Counts of changes (`num_diffs`)

`num_diffs` stores the number of changes for each variable.

**`num_diffs`**: counts of changes for ‘changed data’

##### Changes by row (`var_diffs`)

`var_diffs` lists the changes row by row.

**`var_diffs`**: Row-by-row of changes for ‘changed data’

#### `create_modified_data()`

[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)
also returns a list of tables, with different element names:

``` r

modified <- create_modified_data(
  compare = ChangedData,
  base = InitialData)
names(modified)
#> [1] "diffs"       "diffs_byvar" "class_diffs"
```

##### Counts of changes (`diffs_byvar`)

`diffs_byvar` stores the number of changes for each variable.

**`diffs_byvar`**: counts of changes for ‘modified data’

##### Changes by row (`diffs`)

`diffs` lists the changes row by row.

**`diffs`**: Row-by-row changes of ‘modified data’
