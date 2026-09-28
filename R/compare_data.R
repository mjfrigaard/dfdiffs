#' Compare data (create new, deleted, and changed data)
#'
#' @param compare comparison data table
#' @param base base data table
#' @param by join column
#' @param by_col new join column name
#' @param cols columns to compare
#' @param ignore_case,trim_ws passed to `compare_values()` for character
#'   comparisons.
#'
#' @return list of comparison tables, plus `changed_class_diffs` (class
#'   mismatches on shared columns) and `column_diffs` (a
#'   `dfdiffs_column_diff` from `compare_columns()`, columns only in `base`
#'   vs. only in `compare`)
#' @export compare_data
#'
#' @examples # not run
#' r21 <- dfdiffs::Roster2021
#' r22 <- dfdiffs::Roster2022
#' compare_data(compare = r22, base = r21,
#'     by = "subject_id",
#'     cols = c("first_name", "last_name", "full_name"))
compare_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL,
                          ignore_case = FALSE, trim_ws = FALSE) {

  new_data <- create_new_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols)

  deleted_data <- create_deleted_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols)

  changed_data <- create_changed_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols,
    ignore_case = ignore_case, trim_ws = trim_ws)

  changed_num_diffs <- changed_data$num_diffs
  changed_var_diffs <- changed_data$var_diffs

  return(list(
    'new_data' = new_data,
    'deleted_data' = deleted_data,
    'changed_num_diffs' = changed_num_diffs,
    'changed_var_diffs' = changed_var_diffs,
    'changed_class_diffs' = changed_data$class_diffs,
    'column_diffs' = compare_columns(base = base, compare = compare)
  ))
}
