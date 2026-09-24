#' Create changed data
#'
#' @param compare A 'current' or 'new' dataset (tibble or data.frame)
#' @param base A 'previous' or 'old' dataset (tibble or data.frame)
#' @param by A join column between the two datasets, or any combination of columns that constitute a unique row.
#' @param by_col A new name for the joining column.
#' @param cols Columns to be compared.
#'
#' @return a list with `num_diffs` (count of differing values per variable)
#'   and `var_diffs` (long format: `Variable name`, key column(s),
#'   `Current Value`, `Previous Value`)
#' @export create_changed_data
#'
#' @examples # with local data
#' ChangedData <- dfdiffs::ChangedData
#' InitialData <- dfdiffs::InitialData
#' create_changed_data(
#'   compare = ChangedData,
#'   base = InitialData,
#'   by = c("subject_id", "record"),
#'   cols = c("text_value_a", "text_value_b", "updated_date")
#' )
#' create_changed_data(
#'   compare = ChangedData,
#'   base = InitialData,
#'   by = c("subject_id", "record")
#' )
create_changed_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # check to see if 'by' is included in cols
  if (sum(by %in% cols) > 0) {
    stop("The 'by' column is listed in the columns to compare ('cols)")
  }

  if (is.null(by)) {
    # 1)/2) no 'by' (row-position match, optionally on 'cols') ----
    if (!is.null(cols)) {
      base <- select_cols(base, cols)
      compare <- select_cols(compare, cols)
    }
    diff_lst <- diff_values_by_key(base = base, compare = compare, by = NULL)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) Single 'by' column, no new column name ----
    diff_lst <- diff_values_by_key(base = base, compare = compare, by = by)
  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) Single by column, new column name (by_col) -----
    compare_join_cols <- rename_join_col(compare, by = by, by_col = by_col)
    base_join_cols <- rename_join_col(base, by = by, by_col = by_col)
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) Single by column, multiple compare columns 'cols' ----
    compare_join_cols <- select_cols(compare, c(by, cols))
    base_join_cols <- select_cols(base, c(by, cols))
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) Single by column, new column name (by_col), multiple compare columns (cols) ----
    compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(base, by = by, by_col = by_col)
    compare_join_cols <- select_cols(compare_cols, c(by_col, cols))
    base_join_cols <- select_cols(base_cols, c(by_col, cols))
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) Multiple by columns ----
    compare_join_cols <- create_new_column(data = compare, cols = by, new_name = "join")
    base_join_cols <- create_new_column(data = base, cols = by, new_name = "join")
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = "join")
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) Multiple by columns, new column name (by_col) ----
    compare_join_cols <- create_new_column(data = compare, cols = by, new_name = by_col)
    base_join_cols <- create_new_column(data = base, cols = by, new_name = by_col)
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple `by` columns, multiple compare 'cols' ----
    compare_cols <- create_new_column(data = compare, cols = by, new_name = "join")
    base_cols <- create_new_column(data = base, cols = by, new_name = "join")
    compare_join_cols <- select_cols(compare_cols, c("join", cols))
    base_join_cols <- select_cols(base_cols, c("join", cols))
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = "join")
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple `by` columns, new 'by_col', and 'cols' ----
    compare_cols <- create_new_column(data = compare, cols = by, new_name = by_col)
    base_cols <- create_new_column(data = base, cols = by, new_name = by_col)
    compare_join_cols <- select_cols(compare_cols, c(by_col, cols))
    base_join_cols <- select_cols(base_cols, c(by_col, cols))
    diff_lst <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)
  }

  list("num_diffs" = diff_lst$diffs_byvar, "var_diffs" = diff_lst$diffs)
}
