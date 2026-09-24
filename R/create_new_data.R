#' Create a table of new records
#'
#' @param compare a 'new' or 'current' dataset
#' @param base an 'old' or 'previous' dataset
#' @param by the joining column between the two datasets
#' @param by_col name of the new joining column
#' @param  cols names of columns to compare
#'
#' @return new_data
#' @export create_new_data
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
  compare[] <- lapply(compare, as.character)
  base[] <- lapply(base, as.character)

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) no 'by', no 'by_col', no 'cols' -----
    new_data_join <- anti_join_base(x = compare, y = base,
                                     by = intersect(names(compare), names(base)))
    new_data <- unique(new_data_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) no 'by', no 'by_col', multiple compare 'cols' -----
    compare_join_cols <- select_cols(compare, cols)
    base_join_cols <- select_cols(base, cols)
    new_data_join <- anti_join_base(x = compare_join_cols, y = base_join_cols,
                            by = intersect(names(compare_join_cols), names(base_join_cols)))
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) single 'by' column ----
    new_data_join <- anti_join_base(x = compare, y = base, by = by)
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & length(by_col) == 1 & is.null(cols)) {
    # 4) single 'by' column, new 'by_col' ----
    compare <- rename_join_col(compare, by = by, by_col = by_col)
    base <- rename_join_col(base, by = by, by_col = by_col)
    new_data_join <- anti_join_base(x = compare, y = base, by = by_col)
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' column, multiple compare 'cols' ----
    compare_cols <- select_cols(compare, c(by, cols))
    base_cols <- select_cols(base, c(by, cols))
    new_data_join <- anti_join_base(x = compare_cols, y = base_cols, by = by)
    new_data <- unique(new_data_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) single 'by' column, new 'by_col', multiple compare 'cols' ----
    compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(base, by = by, by_col = by_col)
    compare_join <- select_cols(compare_cols, c(by_col, cols))
    base_join <- select_cols(base_cols, c(by_col, cols))
    new_data_join <- anti_join_base(x = compare_join, y = base_join, by = by_col)
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) multiple 'by' ----
    # no 'by_col', no multiple compare 'cols'
    compare_join <- create_new_column(data = compare, cols = by, new_name = "join")
    base_join <- create_new_column(data = base, cols = by, new_name = "join")
    new_data_join <- anti_join_base(x = compare_join, y = base_join,
                            by = intersect(names(compare_join), names(base_join)))
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) multiple 'by' and 'by_col' ----
    # no multiple compare 'cols'
    compare_join <- create_new_column(data = compare, cols = by, new_name = by_col)
    base_join <- create_new_column(data = base, cols = by, new_name = by_col)
    new_data_join <- anti_join_base(x = compare_join, y = base_join,
                            by = intersect(names(compare_join), names(base_join)))
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple 'by' & multiple compare 'cols' ----
    # no 'by_col'
    compare_join <- create_new_column(data = compare, cols = by, new_name = "join")
    base_join <- create_new_column(data = base, cols = by, new_name = "join")
    compare_join_cols <- select_cols(compare_join, c("join", cols))
    base_join_cols <- select_cols(base_join, c("join", cols))
    new_data_join <- anti_join_base(x = compare_join_cols, y = base_join_cols,
                            by = intersect(names(compare_join_cols), names(base_join_cols)))
    new_data <- unique(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new 'by_col' & compare multiple 'cols' ----
    compare_join <- create_new_column(data = compare, cols = by, new_name = by_col)
    base_join <- create_new_column(data = base, cols = by, new_name = by_col)
    compare_join_cols <- select_cols(compare_join, c(by_col, cols))
    base_join_cols <- select_cols(base_join, c(by_col, cols))
    new_data_join <- anti_join_base(x = compare_join_cols, y = base_join_cols,
                            by = intersect(names(compare_join_cols), names(base_join_cols)))
    new_data <- unique(new_data_join)
  }

  return(new_data)
}
