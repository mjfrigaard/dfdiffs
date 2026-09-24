#' Compare data (create new, deleted, and changed data)
#'
#' @param compare comparison data table
#' @param base base data table
#' @param by join column
#' @param by_col new join column name
#' @param cols columns to compare
#'
#' @return list of comparison tables
#' @export compare_data
#'
#' @examples # not run
#' r21 <- dfdiffs::Roster2021
#' r22 <- dfdiffs::Roster2022
#' compare_data(compare = r22, base = r21,
#'     by = "subject_id",
#'     cols = c("first_name", "last_name", "full_name"))
compare_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {

  new_data <- create_new_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols)

  deleted_data <- create_deleted_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols)

  changed_data <- create_changed_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols)

  changed_num_diffs <- changed_data$num_diffs
  changed_var_diffs <- changed_data$var_diffs

  return(list(
    'new_data' = new_data,
    'deleted_data' = deleted_data,
    'changed_num_diffs' = changed_num_diffs,
    'changed_var_diffs' = changed_var_diffs
  ))
}
