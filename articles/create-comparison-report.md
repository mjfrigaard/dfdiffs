# create-comparison-report

## Motivation

The goal of `dfdiffs` is to answer the following questions:

1.  What rows are here now that weren’t here before?
2.  What rows were here before that aren’t here now?
3.  What values have been changed?

Answering these questions at the console works well during an analysis,
but reviewers often want the results in a file they can open and filter.
In this vignette I’ll cover
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md),
which runs all three comparison functions and exports the results to an
Excel file.

### Packages

The only package we need is `dfdiffs`:

``` r

library(dfdiffs)
```

### Site roster data

We’ll use four yearly pulls of a synthetic (not real) clinical site
roster for our comparisons (see
[`?Roster2021`](https://mjfrigaard.github.io/dfdiffs/reference/Roster2021.md)).
The code below loads each roster and prints its row count:

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

The source for
[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
is shown below (display-only; the chunk isn’t evaluated, so it can’t
shadow the package’s own exported function). It builds each comparison
table, swaps in placeholder tables when a comparison comes back empty,
and writes everything to a nine-sheet workbook with `openxlsx`.

``` r

create_comparison_report <- function(compare, base, by = NULL, by_col = NULL, cols = NULL, file) {
  # convert to tibble
  comp_tbl <- tibble::as_tibble(compare)
  base_tbl <- tibble::as_tibble(base)

  # args
  BY <- by
  BY_COL <- by_col
  COLS <- cols

  # create new data
  new <- create_new_data(compare = comp_tbl, base = base_tbl,
                          by = BY, by_col = BY_COL, cols = COLS)
  # create deleted data
  deleted <- create_deleted_data(compare = comp_tbl, base = base_tbl,
                          by = BY, by_col = BY_COL, cols = COLS)
  # create changed/modified data
  changed <- create_modified_data(compare = comp_tbl, base = base_tbl,
                          by = BY, by_col = BY_COL, cols = COLS)
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
            `Modified Values` = 0)
  } else {
    diffs_byvar_data <- changed$diffs_byvar
  }
  # check for rows in diffs
  if (is.null(changed[["diffs"]])) {
    diffs_data <- tibble::tibble(
            `Variable name` = 0,
            `Current Value` = 0,
            `Previous Value` = 0)
  } else {
    diffs_data <- changed$diffs
  }

  # column structure diff (base-only / compare-only variables)
  col_diffs <- compare_columns(base = base_tbl, compare = comp_tbl)
  column_diffs_data <- data.frame(
    variable = c(col_diffs$common, col_diffs$base_only, col_diffs$compare_only),
    status = c(
      rep("common", length(col_diffs$common)),
      rep("base only", length(col_diffs$base_only)),
      rep("compare only", length(col_diffs$compare_only))
    ),
    stringsAsFactors = FALSE
  )

  # class mismatches on shared columns
  class_diffs_data <- changed$class_diffs

  # headline summary stats
  summary_obj <- unclass(compare_summary(
    compare = comp_tbl, base = base_tbl, by = BY, by_col = BY_COL, cols = COLS
  ))
  summary_data <- data.frame(
    metric = names(summary_obj),
    value = unlist(summary_obj),
    stringsAsFactors = FALSE
  )

  # comparison list
  comparisons <- list(
      'new' = new_data,
      'deleted' = deleted_data,
      'diffs_byvar' = diffs_byvar_data,
      'diffs' = diffs_data,
      'base' = base_tbl,
      'compare' = comp_tbl,
      'column_diffs' = column_diffs_data,
      'class_diffs' = class_diffs_data,
      'summary' = summary_data
    )

  # create workbook
  comp_wb <- openxlsx::createWorkbook()
  # add sheets
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "New Data")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Deleted Data")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Changed Data")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Review Changes")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Base Data")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Compare Data")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Column Diffs")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Class Diffs")
  openxlsx::addWorksheet(wb = comp_wb, sheetName = "Summary")

  #### write NEW DATA ----
  openxlsx::writeData(wb = comp_wb, sheet = "New Data", x = comparisons$new, startCol = 1, startRow = 1)
  #### write DELETED DATA ----
  openxlsx::writeData(wb = comp_wb, sheet = "Deleted Data", x = comparisons$deleted, startCol = 1, startRow = 1)
  #### write NUM DIFFS DATA ----
  openxlsx::writeData(wb = comp_wb, sheet = "Changed Data", x = comparisons$diffs_byvar, startCol = 1, startRow = 1)
  #### write VAR DIFFS DATA ----
  openxlsx::writeData(wb = comp_wb, sheet = "Review Changes", x = comparisons$diffs, startCol = 1, startRow = 1)
  #### write BASE DATA ----
  openxlsx::writeData(wb = comp_wb, sheet = "Base Data", x = comparisons$base, startCol = 1, startRow = 1)
  #### write COMPARE DATA ----
  openxlsx::writeData(wb = comp_wb, sheet = "Compare Data", x = comparisons$compare, startCol = 1, startRow = 1)
  #### write COLUMN DIFFS ----
  openxlsx::writeData(wb = comp_wb, sheet = "Column Diffs", x = comparisons$column_diffs, startCol = 1, startRow = 1)
  #### write CLASS DIFFS ----
  openxlsx::writeData(wb = comp_wb, sheet = "Class Diffs", x = comparisons$class_diffs, startCol = 1, startRow = 1)
  #### write SUMMARY ----
  openxlsx::writeData(wb = comp_wb, sheet = "Summary", x = comparisons$summary, startCol = 1, startRow = 1)

  openxlsx::saveWorkbook(comp_wb, file = file, overwrite = TRUE)
}
```

### Call structure

[`create_comparison_report()`](https://mjfrigaard.github.io/dfdiffs/reference/create_comparison_report.md)
runs the new, deleted, and modified comparisons
([`create_new_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_new_data.md),
[`create_deleted_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_deleted_data.md),
and
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)).
When there are no new or deleted rows to report,
[`create_empty_tbl()`](https://mjfrigaard.github.io/dfdiffs/reference/create_empty_tbl.md)
supplies a placeholder table. For the three sheets that mirror SAS
`PROC COMPARE` output:
[`compare_columns()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_columns.md)
supplies the Column Diffs sheet,
[`create_modified_data()`](https://mjfrigaard.github.io/dfdiffs/reference/create_modified_data.md)’s
own `class_diffs` (already computed, just surfaced here) supplies the
Class Diffs sheet, and
[`compare_summary()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_summary.md)
(itself built on
[`compare_data()`](https://mjfrigaard.github.io/dfdiffs/reference/compare_data.md))
supplies the Summary sheet.

I generated the call tree below from the package source with
[stackcallr](https://github.com/mjfrigaard/stackcallr)
(`pak::pak("mjfrigaard/stackcallr")`), and it only shows functions
defined in `dfdiffs`.

``` r

stackcallr::call_tree_dir("R", root = "create_comparison_report")
```

    █─create_comparison_report
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

### Running `create_comparison_report()`

The code below compares `roster2022` against `roster2021`, matches rows
on `subject_id`, and writes the report to an xlsx file:

``` r

create_comparison_report(
  compare = roster2022,
  base = roster2021,
  by = "subject_id",
  file = "../inst/out/compare-report-roster-2021-2022.xlsx"
)
```
