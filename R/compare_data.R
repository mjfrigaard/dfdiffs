#' Compare data (create new, deleted, and changed data)
#'
#' @param compare comparison data table
#' @param base base data table
#' @param by join bs4Dash::column
#' @param by_col new join bs4Dash::column name
#' @param cols columns to compare
#'
#' @return list of comparison tables
#' @export compare_data
#'
#' @examples # not run
#' m15 <- dfdiffs::master15
#' m22 <- dfdiffs::master22
#' compare_data(compare = m22, base = m15,
#'     by = "playerID",
#'     by_col = "join",
#'     cols = c("nameFirst", "nameLast", "nameGiven"))
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
