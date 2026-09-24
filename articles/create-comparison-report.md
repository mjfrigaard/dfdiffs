# create-comparison-report

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?  
2.  *What rows were here before that aren’t here now?*
3.  What values have been changed?

This vignette takes us through the
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
function, which runs all three comparison functions and exports the
results to an Excel file.

### Packages

``` r

library(dfdiffs)
#> 
#> Attaching package: 'dfdiffs'
#> The following object is masked from 'package:arsenal':
#> 
#>     %nin%
```

``` r

library(janitor) # compare_df_cols
library(arsenal) # comparedf
library(diffdf) # diffdf
library(testthat) # expect_equal
library(tibble)
library(stringr)
library(lubridate)
library(fs)
library(vctrs)
library(glue)
library(purrr)
library(flextable)
```

### Site roster data

We have four yearly pulls of a synthetic (not real) clinical site roster
to use for comparisons (see
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md)):

``` r

roster2021 <- dfdiffs::Roster2021
nrow(roster2021)
#> [1] 200
roster2022 <- dfdiffs::Roster2022
nrow(roster2022)
#> [1] 237
roster2023 <- dfdiffs::Roster2023
nrow(roster2023)
#> [1] 255
roster2024 <- dfdiffs::Roster2024
nrow(roster2024)
#> [1] 275
```

## `create_comparison_report()`

Below is the
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
function.

``` r

create_comparison_report <- function(compare, base, by = NULL, by_col = NULL, cols = NULL, file) {
  # convert to tibble
  comp_tbl <- tibble::as_tibble(compare)
  base_tbl <- tibble::as_tibble(base)
  # get names
  comp_nms <- colnames(compare)
  base_nms <- colnames(base)
  compare_nms <- intersect(comp_nms, base_nms)

  # args
  BY <- by
  BY_COL <- by_col
  COLS <- cols

  # create new data
  new <- create_new_data(
    compare = comp_tbl, base = base_tbl,
    by = BY, by_col = BY_COL, cols = COLS
  )
  # create new data
  deleted <- create_deleted_data(
    compare = comp_tbl, base = base_tbl,
    by = BY, by_col = BY_COL, cols = COLS
  )
  # create new data
  changed <- create_modified_data(
    compare = comp_tbl, base = base_tbl,
    by = BY, by_col = BY_COL, cols = COLS
  )
  # this creates a list of $diffs and $diffs_byvar

  # check for rows in new
  if (nrow(new) == 1) {
    new_data <- create_empty_tbl(tbl = base_tbl)
  } else {
    new_data <- new
  }
  # check for rows in deleted
  if (nrow(deleted) == 1) {
    deleted_data <- create_empty_tbl(tbl = base_tbl)
  } else {
    deleted_data <- deleted
  }
  # check for rows in diffs_byvar
  if (is.null(changed[["diffs_byvar"]])) {
    diffs_byvar_data <- tibble::tibble(
      `Variable name` = 0,
      `Modified Values` = 0
    )
  } else {
    diffs_byvar_data <- changed$diffs_byvar
  }
  # check for rows in diffs
  if (is.null(changed[["diffs"]])) {
    diffs_data <- tibble::tibble(
      `Variable name` = 0,
      `Current Value` = 0,
      `Previous Value` = 0
    )
  } else {
    diffs_data <- changed$diffs
  }
  # comparison list
  comparisons <- list(
    "new" = new_data,
    "deleted" = deleted_data,
    "diffs_byvar" = diffs_byvar_data,
    "diffs" = diffs_data,
    "base" = base_tbl,
    "compare" = comp_tbl
  )

  # create workbook
  comp_wb <- openxlsx::createWorkbook()
  # add sheets
  openxlsx::addWorksheet(
    wb = comp_wb,
    sheetName = "New Data"
  )
  openxlsx::addWorksheet(
    wb = comp_wb,
    sheetName = "Deleted Data"
  )
  openxlsx::addWorksheet(
    wb = comp_wb,
    sheetName = "Changed Data"
  )
  openxlsx::addWorksheet(
    wb = comp_wb,
    sheetName = "Review Changes"
  )
  openxlsx::addWorksheet(
    wb = comp_wb,
    sheetName = "Base Data"
  )
  openxlsx::addWorksheet(
    wb = comp_wb,
    sheetName = "Compare Data"
  )

  #### write NEW DATA ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "New Data",
    x = comparisons$new,
    startCol = 1,
    startRow = 1
  )
  #### write DELETED DATA ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Deleted Data",
    x = comparisons$deleted,
    startCol = 1,
    startRow = 1
  )
  #### write NUM DIFFS DATA ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Changed Data",
    x = comparisons$diffs_byvar,
    startCol = 1,
    startRow = 1
  )
  #### write VAR DIFFS DATA ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Review Changes",
    x = comparisons$diffs,
    startCol = 1,
    startRow = 1
  )
  #### write BASE DATA ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Base Data",
    x = comparisons$base,
    startCol = 1,
    startRow = 1
  )
  #### write COMPARE DATA ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Compare Data",
    x = comparisons$compare,
    startCol = 1,
    startRow = 1
  )

  openxlsx::saveWorkbook(comp_wb, file = file, overwrite = TRUE)
}
```

### Call structure

[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
runs the new, deleted, and modified comparisons
([`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)),
and uses
[`create_empty_tbl()`](https://mjfrigaard.github.io/dfdiffs/reference/create_empty_tbl.md)
to supply a placeholder table when there are no new or deleted rows to
report. The call tree below was generated from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`); only functions defined in
`dfdiffs` are shown.

``` r

stackcallr::call_tree_dir("R", root = "create_comparison_report")
```

    █─create_comparison_report
    ├─█─create_new_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_deleted_data
    │ ├─rename_join_col
    │ └─create_new_column
    ├─█─create_modified_data
    │ ├─rename_join_col
    │ └─create_new_column
    └─create_empty_tbl

### Test `create_comparison_report()`

We test this below with `roster2022` and `roster2021`:

``` r

create_comparison_report(
  compare = roster2022,
  base = roster2021,
  by = "subject_id",
  file = "../inst/out/compare-report-roster-2021-2022.xlsx"
)
```
