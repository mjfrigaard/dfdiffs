#' Rename join bs4Dash::column name
#'
#' @param data a tibble or data.frame
#' @param by_col new join bs4Dash::column name
#' @param by join bs4Dash::column name
#'
#' @return renamed_data
#' @export rename_join_col
#'
#' @importFrom dplyr rename
#' @importFrom dplyr across
#' @importFrom dplyr select
#' @importFrom dplyr relocate
rename_join_col <- function(data, by, by_col) {
    # names(data)[names(data) == by] <- by_col
    renamed_data <-  dplyr::rename_with(.data = data,
      ~ stringr::str_replace_all(.x, by, by_col))
    return_data <- dplyr::relocate(renamed_data, all_of(by_col), everything())
    return(return_data)
}
