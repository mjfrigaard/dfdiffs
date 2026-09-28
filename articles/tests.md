# tests

## Motivation

`dfdiffs` has two kinds of code to test: the Shiny modules (upload,
select, and compare) and the base-R comparison engine. The modules keep
their reactive logic in server functions, which are tested with
[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html).
[`testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html) runs a
module’s server function without starting an app or a browser. Each test
sets inputs with `session$setInputs()`, then checks the reactive values
(or rendered outputs) the module returns.

The comparison engine
([`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md),
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md),
and the join helpers) is tested directly with plain
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
blocks, so no Shiny session is needed.

The tests live in `tests/testthat/`, and we can run the full suite with
[`devtools::test()`](https://devtools.r-lib.org/reference/test.html):

``` r

devtools::test()
```

There are currently 10 test files containing 48 tests
([`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
blocks) and 118 expectations.

## Test inventory

Each row is one
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
block, except the last few rows, which each summarize several tests from
one file (the row says how many). The first column gives the file and
the test name (the string passed to
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)).
The second column names the app feature or function the test protects,
and the third describes what the test does and what it expects.

[TABLE]

### Test data

The tests use the package’s own datasets, so they don’t depend on any
files outside of `dfdiffs`:

- `InitialData` and `ChangedData` (from `data/`) are the base and
  compare data for the select and compare tests.
- `Roster2021`/`Roster2022` are the base and compare data for the
  [`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md),
  [`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md),
  and
  [`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
  tests.
- `inst/extdata/csv/InitialData.csv` and
  `inst/extdata/csv/ChangedData.csv` are the files uploaded in the CSV
  upload tests.

## Call structure

Each Shiny module test targets a module’s server function, but those
server functions call other `dfdiffs` functions along the way. The call
trees below show the functions each module test exercises indirectly.
For example, the compare module tests also run
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md).

The trees were generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`). Only functions defined in
`dfdiffs` are shown.

``` r

library(stackcallr)
call_tree_dir("R", root = "mod_upload_server")
call_tree_dir("R", root = "mod_select_server")
call_tree_dir("R", root = "mod_compare_server")
```

    █─mod_upload_server
    ├─█─upload_data
    │ └─load_flat_file
    ├─base_react_theme
    └─comp_react_theme

    █─mod_select_server
    ├─select_cols
    ├─base_react_theme
    ├─comp_react_theme
    ├─info_react_theme
    └─█─create_join_column
      └─select_cols

    █─mod_compare_server
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

The download-handler tests for
[`mod_compare_server()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_server.md)
also exercise
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
(shown as a subtree above), because the module calls it instead of
building the report itself.

The remaining test files (`test-compare_data.R`,
`test-create_comparison_report.R`, `test-join_helpers.R`,
`test-compare_values.R`, `test-compare_columns.R`, and
`test-compare_summary.R`) call their target functions directly instead
of going through a Shiny module. Their call trees are already covered in
the
[getting-started](https://mjfrigaard.github.io/dfdiffs/articles/getting-started.md)
and
[compare-data](https://mjfrigaard.github.io/dfdiffs/articles/compare-data.md)
vignettes.

## What isn’t tested

The current tests cover the reactive logic of the three modules, the
base-R comparison engine,
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md),
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md),
[`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md),
and
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md).
They also include a build smoke test for every `launch_*()` entry point.
The following areas don’t have tests yet:

- The UI functions
  ([`mod_upload_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_ui.md),
  [`mod_select_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_select_ui.md),
  [`mod_compare_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_ui.md),
  and
  [`app_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/app_ui.md)).
- [`cross_tabyl()`](https://mjfrigaard.github.io/dfdiffs/reference/cross_tabyl.md),
  and a standalone (non-module) test of
  [`create_join_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_join_column.md).
  It’s only exercised indirectly, through the select and compare module
  tests.
- `class_diffs()` beyond the one genuine-class-mismatch case covered in
  `test-compare_values.R`.
