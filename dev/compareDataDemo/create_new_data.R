#' Create a table of new records
#'
#' @param newdf a 'new' or 'current' dataset
#' @param olddf an 'old' or 'previous' dataset
#' @param by the joining column between the two datasets
#' @param by_col name of the new joining column
#' @param  cols names of columns to compare
#'
#' @return new_data
#' @export create_new_data
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
#' T2Data <- dfdiffs::T2Data
#' T1Data <- dfdiffs::T1Data
#' create_new_data(newdf = T2Data, olddf = T1Data,
#'                 by = c('subject', 'record'))
#' create_new_data(newdf = T2Data, olddf = T1Data,
#'                 by = c('subject', 'record'),
#'                 cols = c("text_var", "factor_var"))
create_new_data <- function(newdf, olddf, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  newdf <- mutate(newdf, across(.cols = everything(), .fns = as.character))
  olddf <- mutate(olddf, across(.cols = everything(), .fns = as.character))

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) no 'by', no 'by_col', no 'cols' -----
    new_data_join <- dplyr::anti_join(x = newdf,
                                      y = olddf,
                                      by = dplyr::intersect(
                                                  x = names(newdf),
                                                  y = names(olddf)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) no 'by', no 'by_col', multiple compare 'cols' -----
    newdf_join_cols <- dplyr::select(newdf, all_of(cols))
    olddf_join_cols <- dplyr::select(olddf, all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join_cols,
                                      y = olddf_join_cols,
                            by = dplyr::intersect(x = names(newdf_join_cols),
                                                  y = names(olddf_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) single 'by' column ----
    new_data_join <- dplyr::anti_join(x = newdf, y = olddf, by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & length(by_col) == 1 & is.null(cols)) {
    # 4) single 'by' column, new 'by_col' ----
    newdf <- rename_join_col(newdf, by = by, by_col = by_col)
    olddf <- rename_join_col(olddf, by = by, by_col = by_col)
    new_data_join <- dplyr::anti_join(x = newdf, y = olddf, by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' column, multiple compare 'cols' ----
    newdf_cols <- select(newdf, matches(by), all_of(cols))
    olddf_cols <- select(olddf, matches(by), all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_cols, y = olddf_cols,
                                      by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) single 'by' column, new 'by_col', multiple compare 'cols' ----
    newdf_cols <- rename_join_col(newdf, by = by, by_col = by_col)
    olddf_cols <- rename_join_col(olddf, by = by, by_col = by_col)
    newdf_join <- select(newdf_cols, matches(by_col), all_of(cols))
    olddf_join <- select(olddf_cols, matches(by_col), all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join, y = olddf_join,
                                      by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) multiple 'by' ----
    # no 'by_col', no multiple compare 'cols'
    newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
    olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
    new_data_join <- dplyr::anti_join(x = newdf_join,
                                      y = olddf_join,
                                      by = dplyr::intersect(
                                                  x = names(newdf_join),
                                                  y = names(olddf_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) multiple 'by' and 'by_col' ----
    # no multiple compare 'cols'
    newdf_join <- create_new_column(data = newdf,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    olddf_join <- create_new_column(data = olddf,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    new_data_join <- dplyr::anti_join(x = newdf_join, y = olddf_join,
                            by = dplyr::intersect(x = names(newdf_join),
                                                  y = names(olddf_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple 'by' & multiple compare 'cols' ----
    # no 'by_col'
    newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
    olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
    newdf_join_cols <- dplyr::select(newdf_join, join, all_of(cols))
    olddf_join_cols <- dplyr::select(olddf_join, join, all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join_cols,
                                      y = olddf_join_cols,
                            by = dplyr::intersect(x = names(newdf_join_cols),
                                                  y = names(olddf_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new 'by_col' & compare multiple 'cols' ----
    newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = {{by_col}})
    olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = {{by_col}})
    newdf_join_cols <- dplyr::select(newdf_join, {{by_col}}, all_of(cols))
    olddf_join_cols <- dplyr::select(olddf_join, {{by_col}}, all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join_cols,
                                      y = olddf_join_cols,
                            by = dplyr::intersect(x = names(newdf_join_cols),
                                                  y = names(olddf_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  }

  return(new_data)
}
