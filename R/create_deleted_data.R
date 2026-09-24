#' Create a dataset of deleted records
#'
#' @param compare a 'new' or 'current' dataset
#' @param base an 'old' or 'previous' dataset
#' @param by the joining column between the two datasets
#' @param by_col name of the new joining column
#' @param  cols names of columns to compare
#'
#' @return deleted_data
#' @export create_deleted_data
#'
#' @examples # using local data
#' CompleteData <- dfdiffs::CompleteData
#' IncompleteData <- dfdiffs::IncompleteData
#' create_deleted_data(compare = IncompleteData,
#'                     base = CompleteData)
create_deleted_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  compare[] <- lapply(compare, as.character)
  base[] <- lapply(base, as.character)
  if (is.null(by) & is.null(by_col) & is.null(cols)) {
     # 1) NOTHING ----
     # (no 'by', no 'by_col', and no 'cols')
      deleted_join <- anti_join_base(x = base, y = compare,
                                      by = intersect(names(base), names(compare)))
     deleted_data <- unique(deleted_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
     # 2) multiple compare columns ----
     # (no 'by', no 'by_col', and multiple compare 'cols')
    compare_cols <- select_cols(compare, cols)
    base_cols <- select_cols(base, cols)
    deleted_join <- anti_join_base(x = base_cols, y = compare_cols,
                                    by = intersect(names(base_cols), names(compare_cols)))
    deleted_data <- unique(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
     # 3) single 'by' column ----
     deleted_join <- anti_join_base(x = base, y = compare, by = by)
     deleted_data <- unique(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) single `by` column, new `by_col` ----
    compare_cols <- rename_join_col(data = compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(data = base, by = by, by_col = by_col)
    deleted_join <- anti_join_base(x = base_cols, y = compare_cols, by = by_col)
    deleted_data <- unique(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' and multiple compare 'cols' ----
    # no 'by_col'
    compare_cols <- select_cols(compare, c(by, cols))
    base_cols <- select_cols(base, c(by, cols))
    deleted_join <- anti_join_base(x = base_cols, y = compare_cols,
                                    by = intersect(names(base_cols), names(compare_cols)))
      deleted_data <- unique(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) multiple 'by', new 'by_col', multiple compare 'cols' ----
    base_join <- create_new_column(data = base, cols = by, new_name = by_col)
    compare_join <- create_new_column(data = compare, cols = by, new_name = by_col)
    compare_cols <- select_cols(compare_join, c(by_col, cols))
    base_cols <- select_cols(base_join, c(by_col, cols))
    deleted_join <- anti_join_base(x = base_cols, y = compare_cols,
                                    by = intersect(names(base_cols), names(compare_cols)))
    deleted_data <- unique(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple 'by', no 'by_col', no 'cols' -----
      base_join <- create_new_column(data = base, cols = by, new_name = "join")
      compare_join <- create_new_column(data = compare, cols = by, new_name = "join")
      deleted_join <- anti_join_base(x = base_join, y = compare_join,
                                      by = intersect(names(base_join), names(compare_join)))
      deleted_data <- unique(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple 'by', new column ('by_col') -----
      # no compare 'cols'
      base_join <- create_new_column(data = base, cols = by, new_name = by_col)
      compare_join <- create_new_column(data = compare, cols = by, new_name = by_col)
      deleted_join <- anti_join_base(x = base_join, y = compare_join,
                                      by = intersect(names(base_join), names(compare_join)))
      deleted_data <- unique(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple 'by', multiple compare columns ('cols') -----
      # no 'by_col'
      base_cols <- create_new_column(data = base, cols = by, new_name = "join")
      compare_cols <- create_new_column(data = compare, cols = by, new_name = "join")
      base_join <- select_cols(base_cols, c("join", cols))
      compare_join <- select_cols(compare_cols, c("join", cols))
      deleted_join <- anti_join_base(x = base_join, y = compare_join,
                                      by = intersect(names(base_join), names(compare_join)))
      deleted_data <- unique(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new column ('by_col'), multiple compare 'cols' -----
      compare_cols <- create_new_column(data = compare, cols = by, new_name = by_col)
      base_cols <- create_new_column(data = base, cols = by, new_name = by_col)
      compare_join <- select_cols(compare_cols, c(by_col, cols))
      base_join <- select_cols(base_cols, c(by_col, cols))
      deleted_join <- anti_join_base(x = base_join, y = compare_join,
                                      by = intersect(names(base_join), names(compare_join)))
      deleted_data <- unique(deleted_join)
  }

  return(deleted_data)
}
