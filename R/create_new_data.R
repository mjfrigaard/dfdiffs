#' Create a table of new records
#'
#' @param compare a 'new' or 'current' dataset
#' @param base an 'old' or 'previous' dataset
#' @param by the joining bs4Dash::column between the two datasets
#' @param by_col name of the new joining bs4Dash::column
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
#' create_new_data(compare = T2Data, base = T1Data,
#'                 by = c('subject', 'record'))
#' create_new_data(compare = T2Data, base = T1Data,
#'                 by = c('subject', 'record'),
#'                 cols = c("text_var", "factor_var"))
create_new_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  compare <- mutate(compare, across(.cols = everything(), .fns = as.character))
  base <- mutate(base, across(.cols = everything(), .fns = as.character))

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) no 'by', no 'by_col', no 'cols' -----
    new_data_join <- dplyr::anti_join(x = compare,
                                      y = base,
                                      by = dplyr::intersect(
                                                  x = names(compare),
                                                  y = names(base)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) no 'by', no 'by_col', multiple compare 'cols' -----
    compare_join_cols <- dplyr::select(compare, all_of(cols))
    base_join_cols <- dplyr::select(base, all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join_cols,
                                      y = base_join_cols,
                            by = dplyr::intersect(x = names(compare_join_cols),
                                                  y = names(base_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) single 'by' bs4Dash::column ----
    new_data_join <- dplyr::anti_join(x = compare, y = base, by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & length(by_col) == 1 & is.null(cols)) {
    # 4) single 'by' bs4Dash::column, new 'by_col' ----
    compare <- rename_join_col(compare, by = by, by_col = by_col)
    base <- rename_join_col(base, by = by, by_col = by_col)
    new_data_join <- dplyr::anti_join(x = compare, y = base, by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' bs4Dash::column, multiple compare 'cols' ----
    compare_cols <- select(compare, matches(by), all_of(cols))
    base_cols <- select(base, matches(by), all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_cols, y = base_cols,
                                      by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) single 'by' bs4Dash::column, new 'by_col', multiple compare 'cols' ----
    compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(base, by = by, by_col = by_col)
    compare_join <- select(compare_cols, matches(by_col), all_of(cols))
    base_join <- select(base_cols, matches(by_col), all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join, y = base_join,
                                      by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) multiple 'by' ----
    # no 'by_col', no multiple compare 'cols'
    compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
    base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
    new_data_join <- dplyr::anti_join(x = compare_join,
                                      y = base_join,
                                      by = dplyr::intersect(
                                                  x = names(compare_join),
                                                  y = names(base_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) multiple 'by' and 'by_col' ----
    # no multiple compare 'cols'
    compare_join <- create_new_column(data = compare,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    base_join <- create_new_column(data = base,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    new_data_join <- dplyr::anti_join(x = compare_join, y = base_join,
                            by = dplyr::intersect(x = names(compare_join),
                                                  y = names(base_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple 'by' & multiple compare 'cols' ----
    # no 'by_col'
    compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
    base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
    compare_join_cols <- dplyr::select(compare_join, join, all_of(cols))
    base_join_cols <- dplyr::select(base_join, join, all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join_cols,
                                      y = base_join_cols,
                            by = dplyr::intersect(x = names(compare_join_cols),
                                                  y = names(base_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new 'by_col' & compare multiple 'cols' ----
    compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = {{by_col}})
    base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = {{by_col}})
    compare_join_cols <- dplyr::select(compare_join, {{by_col}}, all_of(cols))
    base_join_cols <- dplyr::select(base_join, {{by_col}}, all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join_cols,
                                      y = base_join_cols,
                            by = dplyr::intersect(x = names(compare_join_cols),
                                                  y = names(base_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  }

  return(new_data)
}
