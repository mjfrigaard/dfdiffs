#' Compare the column structure of two data frames
#'
#' @param base a data.frame or tibble
#' @param compare a data.frame or tibble
#'
#' @return a `dfdiffs_column_diff` object: a list with `base_only`
#'   (columns only in `base`), `compare_only` (columns only in `compare`),
#'   and `common` (columns in both), each a character vector
#' @export compare_columns
#'
#' @description Base-R column/variable structure diff, similar to the
#'   variable summary PROC COMPARE reports before comparing any values.
#'   Works on its own, independent of the Shiny app.
#'
#' @examples
#' Roster2021 <- dfdiffs::Roster2021
#' Roster2022 <- dfdiffs::Roster2022
#' compare_columns(base = Roster2021, compare = Roster2022)
compare_columns <- function(base, compare) {
  base <- as.data.frame(base)
  compare <- as.data.frame(compare)
  structure(
    list(
      base_only = setdiff(names(base), names(compare)),
      compare_only = setdiff(names(compare), names(base)),
      common = intersect(names(base), names(compare))
    ),
    class = "dfdiffs_column_diff"
  )
}

#' Print a dfdiffs_column_diff object
#'
#' @param x a `dfdiffs_column_diff` object
#' @param ... unused
#'
#' @return `x`, invisibly
#' @export
print.dfdiffs_column_diff <- function(x, ...) {
  cat("<dfdiffs column diff>\n")
  cat(sprintf("  common to both: %d\n", length(x$common)))
  if (length(x$common) > 0) {
    cat("   ", paste(x$common, collapse = ", "), "\n")
  }
  cat(sprintf("  base only: %d\n", length(x$base_only)))
  if (length(x$base_only) > 0) {
    cat("   ", paste(x$base_only, collapse = ", "), "\n")
  }
  cat(sprintf("  compare only: %d\n", length(x$compare_only)))
  if (length(x$compare_only) > 0) {
    cat("   ", paste(x$compare_only, collapse = ", "), "\n")
  }
  invisible(x)
}
