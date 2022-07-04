#' Create unique row identifier
#'
#' @param df a data.frame or tibble
#' @param by_colums columns to uniquely identify a row
#' @param new_by_column_name the new column name
#'
#' @return join_col_data
#' @export create_join_column
#'
#' @examples # using dfdiffs::diff_modified_data
#' diff_modified_data <- dfdiffs::diff_modified_data
#' current_modified <- diff_modified_data$diff_current_modified
#' previous_modified <- diff_modified_data$diff_previous_modified
#' create_join_column(df = current_modified,
#'                    by_columns = c("subject_id", "record"),
#'                    new_by_column_name = "join")
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
