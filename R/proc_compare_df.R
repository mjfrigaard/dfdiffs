#' Perform comparison on two datasets
#'
#' @param data_x 'current' or 'new' dataset
#' @param data_y 'previous' or 'old' dataset
#' @param by supplied join columns
#' @param by_col unique identifier
#' @param cols columns to compare
#'
#' @importFrom arsenal comparedf
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom purrr pmap_chr
#' @importFrom dplyr relocate
#'
#' @return compdf_list list of tables
#' @export proc_compare_df
#'
#' @examples # using dfdiffs::diff_modified_data
#' diff_modified_data <- dfdiffs::diff_modified_data
#' diff_current_modified <- diff_modified_data$diff_current_modified
#' diff_previous_modified <- diff_modified_data$diff_previous_modified
#' proc_compare_df(data_x = diff_current_modified,
#'                 data_y = diff_previous_modified,
#'                 by = c("subject_id", "record"),
#'                 cols = c("text_value_a", "text_value_b"))
proc_compare_df <- function(data_x, data_y, by, by_col = NULL, cols = NULL) {
  # inputs
  by_columns <- as.character(by)
  new_by_column_name <- as.character(by_col)
  compare_columns <- as.character(cols)
  # create new join column
  create_join_column <- function(df, by_colums, new_by_column_name) {
    # select by_vars
    tmp <- dplyr::select(df, all_of(by_colums))
    # convert to character
    tmp <- dplyr::mutate(tmp, across(.fns = as.character))
    # rename data
    join_col_data <- df
    # assign new col
    join_col_data$new_col <- purrr::pmap_chr(.l = tmp, .f = paste, sep = "-")
    # rename
    names(join_col_data)[names(join_col_data) == "new_col"] <- new_by_column_name
    # relocate
    join_col_data <- dplyr::relocate(join_col_data,
      all_of(new_by_column_name))
    # return
    return(join_col_data)
  }
  # multiple by columns, and selected columns
  if ((length(by) > 1) & !is.null(by_col) & !is.null(cols)) {

    cols_data_x <- dplyr::select(data_x, all_of(by), all_of(cols))
    cols_data_y <- dplyr::select(data_y, all_of(by), all_of(cols))

    # get new join cols
    join_data_x <- create_join_column(
      df = cols_data_x, by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )

    join_data_y <- create_join_column(
      df = cols_data_y,
      by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    # create compare object
    compdf_list <- summary(arsenal::comparedf(
      x = join_data_x, y = join_data_y,
      by = new_by_column_name
    ))
    return(compdf_list)

  } else if ((length(by) > 1) & is.null(by_col) & !is.null(cols)) {
    # multiple by, no by_col, multiple cols
    cols_data_x <- dplyr::select(data_x, all_of(by), all_of(cols))
    cols_data_y <- dplyr::select(data_y, all_of(by), all_of(cols))
    # get new join cols
    join_data_x <- create_join_column(
      df = cols_data_x, by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    join_data_y <- create_join_column(
      df = cols_data_y, by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    compdf_list <- summary(arsenal::comparedf(
      x = join_data_x, y = join_data_y,
      by = "JOINCOL"
    ))
    return(compdf_list)

  } else if ((length(by) > 1) & !is.null(by_col) & is.null(cols)) {
    # multiple 'by', 'by_col', no 'cols'
    # get new join cols
    join_data_x <- create_join_column(
      df = data_x, by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    join_data_y <- create_join_column(
      df = data_y,
      by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    # create compare object
    compdf_list <- summary(arsenal::comparedf(
      x = join_data_x, y = join_data_y,
      by = new_by_column_name
    ))
    return(compdf_list)

  } else if ((length(by) = 1) & is.null(by_col) & is.null(cols)) {
    # single 'by' col, no by_col, no cols ----
    compdf_list <- summary(arsenal::comparedf(x = data_x, y = data_y, by = by_columns))

    return(compdf_list)

  } else if ((length(by) = 1) & is.null(by_col) & !is.null(cols)) {
    # single 'by' col, no by_col, multp cols
    cols_data_x <- dplyr::select(data_x, all_of(by), all_of(cols))
    cols_data_y <- dplyr::select(data_y, all_of(by), all_of(cols))
    # get compare object
    compdf_list <- summary(arsenal::comparedf(
      x = cols_data_x, y = cols_data_y,
      by = by
    ))
    return(compdf_list)

  } else {
    # single 'by' col, no 'by_col', and no 'cols'
    # get new join cols
    join_data_x <- create_join_column(
      df = data_x, by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    join_data_y <- create_join_column(
      df = data_y,
      by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    # create compare object
    compdf_list <- summary(arsenal::comparedf(
      x = join_data_x, y = join_data_y,
      by = "JOINCOL"
    ))

    return(compdf_list)
  }
}
