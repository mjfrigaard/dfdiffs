#' Not in
#'
#' @param x object
#' @param table table
#'
#' @export `%nin%`
#'
#' @examples
#' "A" %in% "B"
`%nin%` <- function(x, table) {
  match(x, table, nomatch = 0L) == 0L
}
