#' Create a dataset of deleted records
#'
#' @param compare a 'new' or 'current' dataset
#' @param base an 'old' or 'previous' dataset
#' @param by the joining bs4Dash::column between the two datasets
#' @param by_col name of the new joining bs4Dash::column
#' @param  cols names of columns to compare
#'
#' @return deleted_data
#' @export create_deleted_data
#'
#' @importFrom dplyr anti_join
#' @importFrom dplyr distinct
#' @importFrom dplyr select
#' @importFrom dplyr intersect
#' @importFrom dplyr relocate
#' @importFrom tidyr unite
#' @importFrom tibble add_column
#'
#' @examples # using local data
#' CompleteData <- dfdiffs::CompleteData
#' IncompleteData <- dfdiffs::IncompleteData
#' create_deleted_data(compare = IncompleteData,
#'                     base = CompleteData)
create_deleted_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  compare <- mutate(compare, across(.cols = everything(), .fns = as.character))
  base <- mutate(base, across(.cols = everything(), .fns = as.character))
  if (is.null(by) & is.null(by_col) & is.null(cols)) {
     # 1) NOTHING ----
     # (no 'by', no 'by_col', and no 'cols')
      deleted_join <- dplyr::anti_join(x = base, y = compare,
                                    by = dplyr::intersect(
                                      x = names(base),
                                      y = names(compare)))
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
     # 2) multiple compare columns ----
     # (no 'by', no 'by_col', and multiple compare 'cols')
    compare_cols <- select(compare, all_of(cols))
    base_cols <- select(base, all_of(cols))
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                    by = dplyr::intersect(
                                      x = names(base_cols),
                                      y = names(compare_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
     # 3) single 'by' bs4Dash::column ----
     deleted_join <- dplyr::anti_join(x = base, y = compare,
                                        by = {{by}})
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) single `by` bs4Dash::column, new `by_col` ----
    compare_cols <- rename_join_col(data = compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(data = base, by = by, by_col = by_col)
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                        by = {{by_col}})
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' and multiple compare 'cols' ----
    # no 'by_col'
    compare_cols <- dplyr::select(compare, all_of(by), all_of(cols))
    base_cols <- dplyr::select(base, all_of(by), all_of(cols))
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                    by = dplyr::intersect(
                                    x = names(base_cols),
                                    y = names(compare_cols)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) multiple 'by', new 'by_col', multiple compare 'cols' ----
    base_join <- create_new_column(data = base,
                      cols = all_of(by), new_name = {{by_col}})
    compare_join <- create_new_column(data = compare,
                      cols = all_of(by), new_name = {{by_col}})
    compare_cols <- dplyr::select(compare_join, {{by_col}}, all_of(cols))
    base_cols <- dplyr::select(base_join, {{by_col}}, all_of(cols))
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                      by = dplyr::intersect(
                                      x = names(base_cols),
                                      y = names(compare_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple 'by', no 'by_col', no 'cols' -----
      base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
      compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                    by = dplyr::intersect(
                                      x = names(base_join),
                                      y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple 'by', new bs4Dash::column ('by_col') -----
      # no compare 'cols'
      base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = {{by_col}})
      compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = {{by_col}})
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                    by = dplyr::intersect(
                                      x = names(base_join),
                                      y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple 'by', multiple compare columns ('cols') -----
      # no 'by_col'
      base_cols <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
      compare_cols <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
      base_join <- dplyr::select(base_cols, matches("join"), all_of(cols))
      compare_join <- dplyr::select(compare_cols, matches("join"), all_of(cols))
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                    by = dplyr::intersect(
                                      x = names(base_join),
                                      y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new bs4Dash::column ('by_col'), multiple compare 'cols' -----
      compare_cols <- create_new_column(data = compare,
                        cols = all_of(by), new_name = {{by_col}})
      base_cols <- create_new_column(data = base,
                        cols = all_of(by), new_name = {{by_col}})
      compare_join <- dplyr::select(compare_cols, {{by_col}}, all_of(cols))
      base_join <- dplyr::select(base_cols, {{by_col}}, all_of(cols))
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                        by = dplyr::intersect(
                                          x = names(base_join),
                                          y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  }

  return(deleted_data)
}
