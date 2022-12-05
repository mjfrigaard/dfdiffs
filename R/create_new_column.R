#' Create new (joining) bs4Dash::column
#'
#' @param data a tibble or data.frame
#' @param cols cols to create new bs4Dash::column from (they will be pasted together with "-")
#' @param new_name new bs4Dash::column name
#'
#' @importFrom dplyr relocate
#' @importFrom tidyr unite
#'
#' @return new_col_data data with new bs4Dash::column
#' @export create_new_column
#'
#' @examples
#' library(dplyr)
#' library(tidyr)
#' CompleteData <- dfdiffs::CompleteData
#' IncompleteData <- dfdiffs::IncompleteData
#' CompleteDataJoin <- create_new_column(data = CompleteData,
#'                                        cols = c("subject", "record"),
#'                                        new_name = "join_var")
#' IncompleteDataJoin <- create_new_column(data = IncompleteData,
#'                                        cols = c("subject", "record"),
#'                                        new_name = "join_var")
create_new_column <- function(data, cols, new_name) {
    new_col_data <- data %>%
      tidyr::unite({{new_name}}, {{cols}}, remove = FALSE, sep = "-") %>%
      dplyr::relocate({{new_name}}, everything())
    return(new_col_data)
}
