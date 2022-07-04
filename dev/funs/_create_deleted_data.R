#' Create a dataset of deleted records
#'
#' @param newdf a 'new' or 'current' dataset
#' @param olddf an 'old' or 'previous' dataset
#' @param by the joining column between the two datasets
#' @param by_col name of the new joining column
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
#' create_deleted_data(newdf = IncompleteData, olddf = CompleteData,
#'                     by = c("subject", "record"))
#' create_deleted_data(newdf = IncompleteData, olddf = CompleteData,
#'                     by = c("subject", "record")
#'                     by_col = "join_var"
#'                     )
#' create_deleted_data(newdf = IncompleteData, olddf = CompleteData,
#'                     by = c("subject", "record")
#'                     by_col = "join_var",
#'                     cols = c("subject", "record")
#'                     )
create_deleted_data <- function(newdf, olddf, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  newdf <- mutate(newdf, across(.cols = everything(), .fns = as.character))
  olddf <- mutate(olddf, across(.cols = everything(), .fns = as.character))
  if (is.null(by) & is.null(by_col) & is.null(cols)) {
     # 1) NOTHING ----
     # (no 'by', no 'by_col', and no 'cols')
      deleted_join <- dplyr::anti_join(x = olddf, y = newdf,
                                    by = dplyr::intersect(
                                      x = names(olddf),
                                      y = names(newdf)))
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
     # 2) multiple compare columns ----
     # (no 'by', no 'by_col', and multiple compare 'cols')
    newdf_cols <- select(newdf, all_of(cols))
    olddf_cols <- select(olddf, all_of(cols))
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                    by = dplyr::intersect(
                                      x = names(olddf_cols),
                                      y = names(newdf_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
     # 3) single 'by' column ----
     deleted_join <- dplyr::anti_join(x = olddf, y = newdf,
                                        by = {{by}})
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) single `by` column, new `by_col` ----
    newdf_cols <- rename_join_col(data = newdf, by = by, by_col = by_col)
    olddf_cols <- rename_join_col(data = olddf, by = by, by_col = by_col)
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                        by = {{by_col}})
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' and multiple compare 'cols' ----
    # no 'by_col'
    newdf_cols <- dplyr::select(newdf, all_of(by), all_of(cols))
    olddf_cols <- dplyr::select(olddf, all_of(by), all_of(cols))
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                    by = dplyr::intersect(
                                    x = names(olddf_cols),
                                    y = names(newdf_cols)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) multiple 'by', new 'by_col', multiple compare 'cols' ----
    olddf_join <- create_new_column(data = olddf,
                      cols = all_of(by), new_name = {{by_col}})
    newdf_join <- create_new_column(data = newdf,
                      cols = all_of(by), new_name = {{by_col}})
    newdf_cols <- dplyr::select(newdf_join, {{by_col}}, all_of(cols))
    olddf_cols <- dplyr::select(olddf_join, {{by_col}}, all_of(cols))
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                      by = dplyr::intersect(
                                      x = names(olddf_cols),
                                      y = names(newdf_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple 'by', no 'by_col', no 'cols' -----
      olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
      newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                    by = dplyr::intersect(
                                      x = names(olddf_join),
                                      y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple 'by', new column ('by_col') -----
      # no compare 'cols'
      olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = {{by_col}})
      newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = {{by_col}})
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                    by = dplyr::intersect(
                                      x = names(olddf_join),
                                      y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple 'by', multiple compare columns ('cols') -----
      # no 'by_col'
      olddf_cols <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
      newdf_cols <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
      olddf_join <- dplyr::select(olddf_cols, matches("join"), all_of(cols))
      newdf_join <- dplyr::select(newdf_cols, matches("join"), all_of(cols))
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                    by = dplyr::intersect(
                                      x = names(olddf_join),
                                      y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new column ('by_col'), multiple compare 'cols' -----
      newdf_cols <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = {{by_col}})
      olddf_cols <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = {{by_col}})
      newdf_join <- dplyr::select(newdf_cols, {{by_col}}, all_of(cols))
      olddf_join <- dplyr::select(olddf_cols, {{by_col}}, all_of(cols))
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                        by = dplyr::intersect(
                                          x = names(olddf_join),
                                          y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  }

  return(deleted_data)
}
