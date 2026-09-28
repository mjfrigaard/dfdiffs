#' Summarize a data frame comparison (PROC-COMPARE-style headline stats)
#'
#' @param compare A 'current' or 'new' dataset (tibble or data.frame)
#' @param base A 'previous' or 'old' dataset (tibble or data.frame)
#' @param by A join column between the two datasets, or any combination of
#'   columns that constitute a unique row.
#' @param by_col A new name for the joining column.
#' @param cols Columns to be compared.
#' @param ignore_case,trim_ws passed to `compare_values()` for character
#'   comparisons.
#'
#' @return a `dfdiffs_summary` object (a list of counts) with a
#'   `print.dfdiffs_summary()` method for console output
#' @export compare_summary
#'
#' @description Builds a row/column/value headline summary on top of
#'   `compare_data()` and `compare_columns()` (no comparison logic of its
#'   own), similar to the summary PROC COMPARE prints before its detailed
#'   diff tables. Works on its own, independent of the Shiny app.
#'
#' @examples
#' Roster2021 <- dfdiffs::Roster2021
#' Roster2022 <- dfdiffs::Roster2022
#' compare_summary(compare = Roster2022, base = Roster2021, by = "subject_id")
compare_summary <- function(compare, base, by = NULL, by_col = NULL, cols = NULL,
                             ignore_case = FALSE, trim_ws = FALSE) {
  result <- compare_data(
    compare = compare, base = base, by = by, by_col = by_col, cols = cols,
    ignore_case = ignore_case, trim_ws = trim_ws
  )

  n_base <- nrow(as.data.frame(base))
  n_compare <- nrow(as.data.frame(compare))
  n_new <- nrow(result$new_data)
  n_deleted <- nrow(result$deleted_data)
  n_common <- n_base - n_deleted

  column_diffs <- result$column_diffs
  n_vars_base_only <- length(column_diffs$base_only)
  n_vars_compare_only <- length(column_diffs$compare_only)
  n_vars_common <- length(column_diffs$common)

  n_value_diffs <- nrow(result$changed_var_diffs)
  n_vars_with_diffs <- sum(result$changed_num_diffs$`Modified Values` > 0)
  n_class_mismatches <- nrow(result$changed_class_diffs)

  structure(
    list(
      n_base = n_base,
      n_compare = n_compare,
      n_common = n_common,
      n_new = n_new,
      n_deleted = n_deleted,
      n_vars_base = n_vars_common + n_vars_base_only,
      n_vars_compare = n_vars_common + n_vars_compare_only,
      n_vars_common = n_vars_common,
      n_vars_base_only = n_vars_base_only,
      n_vars_compare_only = n_vars_compare_only,
      n_vars_with_diffs = n_vars_with_diffs,
      n_value_diffs = n_value_diffs,
      n_class_mismatches = n_class_mismatches
    ),
    class = "dfdiffs_summary"
  )
}

#' Print a dfdiffs_summary object
#'
#' @param x a `dfdiffs_summary` object
#' @param ... unused
#'
#' @return `x`, invisibly
#' @export
print.dfdiffs_summary <- function(x, ...) {
  cat("<dfdiffs comparison summary>\n")
  cat(sprintf("  Observations: base = %d, compare = %d\n", x$n_base, x$n_compare))
  cat(sprintf("    common: %d | new: %d | deleted: %d\n", x$n_common, x$n_new, x$n_deleted))
  cat(sprintf(
    "  Variables: base = %d, compare = %d (%d common, %d base only, %d compare only)\n",
    x$n_vars_base, x$n_vars_compare, x$n_vars_common,
    x$n_vars_base_only, x$n_vars_compare_only
  ))
  if (x$n_value_diffs == 0 && x$n_class_mismatches == 0) {
    cat("  No unequal values found.\n")
  } else {
    cat(sprintf(
      "  Values: %d differing value(s) across %d variable(s); %d class mismatch(es)\n",
      x$n_value_diffs, x$n_vars_with_diffs, x$n_class_mismatches
    ))
  }
  invisible(x)
}
