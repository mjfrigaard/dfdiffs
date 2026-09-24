#' Create new (joining) column
#'
#' @param data a tibble or data.frame
#' @param cols cols to create new column from (they will be pasted together with "-")
#' @param new_name new column name
#' @param sep separator pasted between `cols` values (default `"-"`)
#'
#' @return new_col_data data with new column
#' @export create_new_column
#'
#' @examples
#' CompleteData <- dfdiffs::CompleteData
#' IncompleteData <- dfdiffs::IncompleteData
#' CompleteDataJoin <- create_new_column(data = CompleteData,
#'                                        cols = c("subject", "record"),
#'                                        new_name = "join_var")
#' IncompleteDataJoin <- create_new_column(data = IncompleteData,
#'                                        cols = c("subject", "record"),
#'                                        new_name = "join_var")
create_new_column <- function(data, cols, new_name, sep = "-") {
    new_col_data <- as.data.frame(data)
    new_col_data[[new_name]] <- do.call(paste, c(new_col_data[cols], list(sep = sep)))
    new_col_data[c(new_name, setdiff(names(new_col_data), new_name))]
}
