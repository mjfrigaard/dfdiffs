# tests

## Motivation

The Shiny modules in `dfdiffs` (upload, select, and compare) keep their
reactive logic in server functions. These are tested with
[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html),
which runs a module’s server function without starting an app or a
browser: the test sets inputs with `session$setInputs()`, and then
checks the reactive values (or rendered outputs) the module returns. The
base-R comparison engine
([`compare_values()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_values.md),
[`diff_values_by_key()`](https://mjfrigaard.github.io/dfdiffs/reference/diff_values_by_key.md),
and the join helpers) is tested directly with plain
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
blocks, no Shiny session needed.

The tests live in `tests/testthat/`. Run them with:

``` r

devtools::test()
```

There are currently 8 test files containing 36 tests
([`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
blocks) and 82 expectations.

## Test inventory

Each row is one
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
block. The first column gives the file and the test name (the string
passed to
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)),
the second column is the app feature or function the test protects, and
the third describes what the test does and expects.

[TABLE]

### Test data

The tests use the package’s own datasets, so they don’t depend on files
outside of `dfdiffs`:

- `InitialData` and `ChangedData` (from `data/`) are the base and
  compare data for the select and compare tests.
- `Roster2021`/`Roster2022` are the base and compare data for the
  [`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)/[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
  tests.
- `inst/extdata/csv/InitialData.csv` and
  `inst/extdata/csv/ChangedData.csv` are the files uploaded in the CSV
  upload tests.

## Call structure

Each Shiny-module test targets a module’s server function; the call
trees below show the `dfdiffs` functions those tests exercise indirectly
(for example, the compare module tests also run
[`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)).
They were generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
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

`test-compare_data.R`, `test-create_comparison_report.R`,
`test-join_helpers.R`, and `test-compare_values.R` call their target
functions directly and don’t go through a Shiny module, so there’s no
call tree to show for them beyond what’s already in the
[getting-started](https://mjfrigaard.github.io/dfdiffs/articles/getting-started.md)
vignette.

## What isn’t tested

The current tests cover the reactive logic of the three modules, the
base-R comparison engine,
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md),
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md),
and a build smoke test for every `launch_*()` entry point. These areas
don’t have tests yet:

- The UI functions
  ([`mod_upload_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_ui.md),
  [`mod_select_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_select_ui.md),
  [`mod_compare_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_ui.md),
  and
  [`app_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/app_ui.md)).
- [`cross_tabyl()`](https://mjfrigaard.github.io/dfdiffs/reference/cross_tabyl.md)
  and
  [`create_join_column()`](https://mjfrigaard.github.io/dfdiffs/reference/create_join_column.md)’s
  multi-column `by_colums` path.
- `class_diffs()` beyond the one genuine-class-mismatch case covered in
  `test-compare_values.R`.
