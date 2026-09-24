#' Create unique row identifier
#'
#' @param df a data.frame or tibble
#' @param by_colums columns to uniquely identify a row
#' @param new_by_column_name the new column name
#'
#' @return join_col_data
#' @export create_join_column
#'
#' @examples # using dfdiffs::InitialData
#' InitialData <- dfdiffs::InitialData
#' create_join_column(df = InitialData,
#'                     by_colums = c('subject_id', 'record'),
#'                     new_by_column_name = 'join_var')
create_join_column <- function(df, by_colums, new_by_column_name) {
    # select by_vars, convert to character
    tmp <- select_cols(df, by_colums)
    tmp[] <- lapply(tmp, as.character)
    # rename data
    join_col_data <- as.data.frame(df)
    # assign new col
    join_col_data$new_col <- do.call(paste, c(tmp, sep = "-"))
    # rename
    names(join_col_data)[names(join_col_data) == "new_col"] <- new_by_column_name
    # relocate
    join_col_data <- join_col_data[c(new_by_column_name, setdiff(names(join_col_data), new_by_column_name))]
    # return
    return(join_col_data)
}
