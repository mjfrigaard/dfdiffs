#' Create modified data
#'
#' @param compare A 'current' or 'new' dataset (tibble or data.frame)
#' @param base A 'previous' or 'old' dataset (tibble or data.frame)
#' @param by A join column between the two datasets, or any combination of columns that constitute a unique row.
#' @param by_col A new name for the joining column.
#' @param cols Columns to be compared.
#'
#' @return a list with `diffs` (long format: `Variable name`, key column(s),
#'   `Current Value`, `Previous Value`) and `diffs_byvar` (count of
#'   differing values per variable)
#' @export create_modified_data
#'
#' @examples # with local data
#' CurrentData <- dfdiffs::ChangedData
#' PreviousData <- dfdiffs::InitialData
#' create_modified_data(
#'            compare = CurrentData,
#'            base = PreviousData,
#'            by = c("subject_id", "record"),
#'            cols = c("text_value_a", "text_value_b", "updated_date"))
#' create_modified_data(
#'            compare = CurrentData,
#'            base = PreviousData,
#'            by = c("subject_id", "record"))
create_modified_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
    if (is.null(by)) {
      # 1)/2) NOTHING or multiple 'cols' (row-position match) ----
      if (!is.null(cols)) {
        compare <- select_cols(compare, cols)
        base <- select_cols(base, cols)
      }
      mod_data <- diff_values_by_key(base = base, compare = compare, by = NULL)

    } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
      # 3) Single 'by' column ----
      mod_data <- diff_values_by_key(base = base, compare = compare, by = by)

    } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
      # 4) Single by column, new column ('by_col') ----
      compare_join_cols <- rename_join_col(compare, by = by, by_col = by_col)
      base_join_cols <- rename_join_col(base, by = by, by_col = by_col)
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)

    } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
      # 5) Single 'by' column, multiple compare cols ('cols') ----
      compare_join_cols <- select_cols(compare, c(by, cols))
      base_join_cols <- select_cols(base, c(by, cols))
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by)

    } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
      # 6) Single 'by' column, new 'by_col', multiple compare 'cols' ----
      compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
      base_cols <- rename_join_col(base, by = by, by_col = by_col)
      compare_join_cols <- select_cols(compare_cols, c(by_col, cols))
      base_join_cols <- select_cols(base_cols, c(by_col, cols))
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)

    } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple `by` columns ----
      compare_join_cols <- create_new_column(data = compare, cols = by, new_name = "join")
      base_join_cols <- create_new_column(data = base, cols = by, new_name = "join")
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = "join")

    } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple `by` columns, new 'by_col' ----
      compare_join_cols <- create_new_column(data = compare, cols = by, new_name = by_col)
      base_join_cols <- create_new_column(data = base, cols = by, new_name = by_col)
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)

    } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple `by` columns, multiple compare 'cols' ----
      compare_cols <- create_new_column(data = compare, cols = by, new_name = "join")
      base_cols <- create_new_column(data = base, cols = by, new_name = "join")
      compare_join_cols <- select_cols(compare_cols, c("join", cols))
      base_join_cols <- select_cols(base_cols, c("join", cols))
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = "join")

    } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
      # 10) multiple `by` columns, new 'by_col', multiple compare 'cols' ----
      compare_cols <- create_new_column(data = compare, cols = by, new_name = by_col)
      base_cols <- create_new_column(data = base, cols = by, new_name = by_col)
      compare_join_cols <- select_cols(compare_cols, c(by_col, cols))
      base_join_cols <- select_cols(base_cols, c(by_col, cols))
      mod_data <- diff_values_by_key(base = base_join_cols, compare = compare_join_cols, by = by_col)
    }

    list("diffs" = mod_data$diffs, "diffs_byvar" = mod_data$diffs_byvar)
}
