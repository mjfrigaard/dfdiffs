#' Rename join column name
#'
#' @param data a tibble or data.frame
#' @param by_col new join column name
#' @param by join column name
#'
#' @return renamed_data
#' @export rename_join_col
rename_join_col <- function(data, by, by_col) {
    renamed_data <- as.data.frame(data)
    names(renamed_data)[names(renamed_data) == by] <- by_col
    return_data <- renamed_data[c(by_col, setdiff(names(renamed_data), by_col))]
    return(return_data)
}
