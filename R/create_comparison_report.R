#' Create comparison report
#'
#' @importFrom tibble as_tibble
#' @importFrom openxlsx createWorkbook
#' @importFrom openxlsx addWorksheet
#' @importFrom openxlsx writeData
#' @importFrom openxlsx saveWorkbook
#'
#' @param compare compare df
#' @param base base df
#' @param by keys or joining column
#' @param by_col column name for joining column
#' @param cols columns to compare
#' @param file export file (with path)
#'
#' @return xlsx workbook
#' @export create_comparison_report
#'
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
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "New Data")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Deleted Data")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Changed Data")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Review Changes")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Base Data")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Compare Data")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Column Diffs")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Class Diffs")
  openxlsx::addWorksheet(wb = comp_wb,
                         sheetName = "Summary")

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
  #### write COLUMN DIFFS ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Column Diffs",
    x = comparisons$column_diffs,
    startCol = 1,
    startRow = 1
  )
  #### write CLASS DIFFS ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Class Diffs",
    x = comparisons$class_diffs,
    startCol = 1,
    startRow = 1
  )
  #### write SUMMARY ----
  openxlsx::writeData(
    wb = comp_wb,
    sheet = "Summary",
    x = comparisons$summary,
    startCol = 1,
    startRow = 1
  )

  openxlsx::saveWorkbook(comp_wb, file = file, overwrite = TRUE)

}
