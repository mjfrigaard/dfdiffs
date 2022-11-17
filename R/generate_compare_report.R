#' Generate comparison report (xlsx)
#'
#' @param compare comparison data table
#' @param base base data table
#' @param by join column
#' @param by_col new join column name
#' @param cols columns to compare
#' @param path path to excel file
#'
#' @importFrom openxlsx createWorkbook
#' @importFrom openxlsx addWorksheet
#' @importFrom openxlsx writeDataTable
#' @importFrom openxlsx saveWorkbook
#'
#' @return exported xlsx file
#' @export generate_compare_report
#'
#' @examples # not run
#' m15 <- dfdiffs::master15
#' m22 <- dfdiffs::master22
#' generate_compare_report(compare = m22, base = m15,
#'     by = "playerID",
#'     by_col = "join",
#'     cols = c("nameFirst", "nameLast", "nameGiven"),
#'     path = "inst/extdata/xlsx/compare-report-text.xlsx")
generate_compare_report <- function(compare, base, by = NULL, by_col = NULL, cols = NULL, path) {

  comparisons <- compare_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols)

  compare_wb <- openxlsx::createWorkbook()

  openxlsx::addWorksheet(wb = compare_wb,
    sheetName = "new data",
    gridLines = FALSE)
  openxlsx::addWorksheet(wb = compare_wb,
    sheetName = "deleted data",
    gridLines = FALSE)
  openxlsx::addWorksheet(compare_wb,
    sheetName = "change frequency",
    gridLines = FALSE)
  openxlsx::addWorksheet(wb = compare_wb,
    sheetName = "changes",
    gridLines = FALSE)

  openxlsx::writeDataTable(wb = compare_wb,
    sheet = "new data", x = comparisons$new_data,
    colNames = TRUE, rowNames = FALSE,
    withFilter = FALSE
  )
  openxlsx::writeDataTable(wb = compare_wb,
    sheet = "deleted data", x = comparisons$deleted_data,
    colNames = TRUE, rowNames = FALSE, withFilter = FALSE
  )
  openxlsx::writeDataTable(wb = compare_wb,
    sheet = "change frequency", x = comparisons$changed_num_diffs,
    colNames = TRUE, rowNames = FALSE, withFilter = FALSE
  )
  openxlsx::writeDataTable(compare_wb,
    sheet = "changes", x = comparisons$changed_var_diffs,
    colNames = TRUE, rowNames = FALSE,  withFilter = FALSE
  )
  # export xlsx
  openxlsx::saveWorkbook(wb = compare_wb, file = path, overwrite = TRUE)
}
