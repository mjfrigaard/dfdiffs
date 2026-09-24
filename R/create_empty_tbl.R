#' Create empty tibble
#'
#' @param tbl input table
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
  empty_tbl <- as.data.frame(matrix(NA, nrow = 1, ncol = length(nms)))
  names(empty_tbl) <- nms
  empty_tbl[] <- lapply(empty_tbl, as.logical)
  tibble::as_tibble(empty_tbl)
}
