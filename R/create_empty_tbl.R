#' Create empty tibble
#'
#' @param tbl input table
#'
#' @importFrom rlang !!!
#'
#' @return tibble with columns from tbl, all logical
#' @export create_empty_tbl
#'
#' @examples
#' DF <- data.frame(
#'         id = 1:6,
#'         lowercase = letters[1:6],
#'         uppercase = LETTERS[1:6])
#' create_empty_tbl(DF)
create_empty_tbl <- function(tbl) {
  nms <- names(tbl)
  empty_tbl <- tibble::tibble(!!!nms, .rows = 1)
  nmd_tbl <- purrr::set_names(empty_tbl, nms)
  log_tbl <- dplyr::mutate(.data = nmd_tbl,
    dplyr::across(.cols = tidyselect::everything(), .fns = as.logical))
  return(log_tbl)
}
