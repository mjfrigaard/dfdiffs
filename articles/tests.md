# tests

## Motivation

The Shiny modules in `dfdiffs` (upload, select, compare, and display)
keep their reactive logic in server functions. These are tested with
[`shiny::testServer()`](https://rdrr.io/pkg/shiny/man/testServer.html),
which runs a module’s server function without starting an app or a
browser: the test sets inputs with `session$setInputs()`, and then
checks the reactive values (or rendered outputs) the module returns.

The tests live in `tests/testthat/`. Run them with:

``` r

devtools::test()
```

There are currently 4 test files containing 7 tests
([`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
blocks) and 26 expectations.

## Test inventory

Each row is one
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)
block. The first column gives the file and the test name (the string
passed to
[`test_that()`](https://testthat.r-lib.org/reference/test_that.html)),
the second column is the app feature the test protects, and the third
describes what the test does and expects.

[TABLE]

### Test data

The tests use the package’s own datasets, so they don’t depend on files
outside of `dfdiffs`:

- `InitialData` and `ChangedData` (from `data/`) are the base and
  compare data for the select, compare, and display tests.
- `inst/extdata/csv/InitialData.csv` and
  `inst/extdata/csv/ChangedData.csv` are the files uploaded in the
  upload tests.

## Call structure

Each test targets a module’s server function. The call trees below show
the `dfdiffs` functions those tests exercise indirectly (for example,
the compare module test also runs
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
call_tree_dir("R", root = "mod_display_server")
```

    █─mod_upload_server
    └─█─upload_data
      └─load_flat_file

    █─mod_select_server
    └─create_join_column

    █─mod_compare_server
    ├─%nin%
    ├─█─create_new_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_deleted_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_modified_data
    │ ├─rename_join_col
    │ └─create_new_column
    └─█─create_changed_data
      ├─extract_df_tables
      ├─rename_join_col
      └─create_new_column

    mod_display_server

## What isn’t tested

The current tests cover the reactive logic of the four modules. These
areas don’t have tests yet:

- The UI functions
  ([`mod_upload_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_upload_ui.md),
  [`mod_select_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_select_ui.md),
  [`mod_compare_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_compare_ui.md),
  [`mod_display_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/mod_display_ui.md),
  and
  [`app_ui()`](https://mjfrigaard.github.io/dfdiffs/reference/app_ui.md)).
- The app launchers
  ([`launch_app()`](https://mjfrigaard.github.io/dfdiffs/reference/launch_app.md)
  and the `launch_*_demo()` functions).
- Uploading Excel (`.xlsx`) files (the upload tests use CSVs).
- The compare module’s row-by-row path (no `join_column`), and the
  report download.
- [`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md)
  and
  [`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md),
  which have vignettes but no tests.
