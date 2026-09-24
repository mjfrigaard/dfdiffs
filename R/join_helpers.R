#' Select columns by name (base R)
#'
#' @param df a data.frame or tibble
#' @param cols character vector of column names to select
#'
#' @return df subset to `cols`, in the order given
#' @export select_cols
#'
#' @description Base-R replacement for `dplyr::select(df, tidyselect::all_of(cols))`.
#'   Errors clearly when a requested column doesn't exist, matching
#'   `tidyselect::all_of()`'s safety net.
select_cols <- function(df, cols) {
  df <- as.data.frame(df)
  missing_cols <- setdiff(cols, names(df))
  if (length(missing_cols) > 0) {
    stop("column(s) not found: ", paste(missing_cols, collapse = ", "), call. = FALSE)
  }
  df[, cols, drop = FALSE]
}

#' Anti-join two data frames (base R)
#'
#' @param x a data.frame or tibble
#' @param y a data.frame or tibble
#' @param by character vector of shared key column(s)
#'
#' @return rows of `x` with no matching `by`-key combination in `y`,
#'   keeping only `x`'s columns
#' @export anti_join_base
#'
#' @description Base-R replacement for `dplyr::anti_join(x, y, by)`. Builds
#'   a pasted composite key from `by` (treating `NA` as the literal string
#'   `"NA"`, matching `dplyr`'s NA-as-equal join semantics) and keeps rows
#'   of `x` whose key isn't present in `y`.
anti_join_base <- function(x, y, by) {
  x <- as.data.frame(x)
  y <- as.data.frame(y)
  x_key <- do.call(paste, c(x[by], sep = "\r"))
  y_key <- do.call(paste, c(y[by], sep = "\r"))
  x[!(x_key %in% y_key), , drop = FALSE]
}

#' Left-join two data frames (base R)
#'
#' @param x a data.frame or tibble
#' @param y a data.frame or tibble
#' @param by character vector of shared key column(s)
#'
#' @return `x` with `y`'s non-key columns attached where `by` matches
#' @export left_join_base
#'
#' @description Base-R replacement for `dplyr::left_join(x, y, by)`, used
#'   to join review-changes data back to its source row.
left_join_base <- function(x, y, by) {
  x <- as.data.frame(x)
  y <- as.data.frame(y)
  merge(x, y, by = by, all.x = TRUE, sort = FALSE)
}
