#' cross_tabyl
#'
#' @param df a data.frame or tibble
#' @param col a column with categorical or factor data
#' @description cross_tabyl() is a helper function to quickly create a
#' cross-tabulation of the values in a categorical variable.
#'
#' @return cross_tabyl
#' @export cross_tabyl
#'
#' @examples # not run
#' library(dplyr)
#' cross_tabyl(starwars, "hair_color")
#' cross_tabyl(starwars, "name")
cross_tabyl <- function(df, col) {
   col <- as.character(col)
   cross_tbl <- dplyr::select(df,
        all_of(as.character(col))) %>%
    purrr::as_vector(.x = .) %>%
    janitor::tabyl() %>%
    janitor::adorn_pct_formatting() %>%
    janitor::adorn_totals(where = "row",
        name = "Total Queries") %>%
    tibble::as_tibble()
   if (ncol(cross_tbl) > 3) {
       cross_tabyl <- purrr::set_names(x = cross_tbl,
           nm = c(paste0("Variable = ", col), "N", "Percent", "Valid Percent"))
   } else {
    cross_tabyl <- purrr::set_names(x = cross_tbl,
        nm = c(paste0("Variable = ", col), "N", "Percent"))
   }
   return(cross_tabyl)
}
