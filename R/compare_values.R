#' Compare two vectors of values (base R)
#'
#' @param base_val vector of base/previous values
#' @param compare_val vector of compare/current values
#' @param tolerance numeric tolerance for numeric/date-time comparisons
#'   (default `sqrt(.Machine$double.eps)`, matching `diffdf::diffdf()`)
#' @param scale optional scale applied before the tolerance check (default
#'   `NULL`, i.e. no scaling)
#' @param strict_factor if `TRUE`, a factor compared against a non-factor
#'   is always flagged as different, regardless of label (default `FALSE`,
#'   which compares factor/character pairs by label)
#'
#' @return logical vector, `TRUE` where `base_val`/`compare_val` differ
#' @export compare_values
#'
#' @description Element-wise value comparison used by `diff_values_by_key()`
#'   in place of `diffdf::diffdf()`. NA-safe (`NA` vs `NA` is never
#'   "different"; `NA` vs a value always is). Numeric values (including a
#'   mix of integer/double) are compared with tolerance, matching
#'   `diffdf:::compare_vectors.numeric()`'s formula. `Date`/`POSIXct` values
#'   are compared as epoch seconds with the same tolerance, so a `Date` and
#'   a `POSIXct` representing the same instant compare as equal. Factors are
#'   cast to character before comparing (label comparison), unless
#'   `strict_factor = TRUE`, in which case a factor/non-factor class
#'   mismatch is always flagged as different.
compare_values <- function(base_val, compare_val,
                            tolerance = sqrt(.Machine$double.eps),
                            scale = NULL,
                            strict_factor = FALSE) {
  one_sided_na <- xor(is.na(base_val), is.na(compare_val))
  both_present <- !is.na(base_val) & !is.na(compare_val)

  is_datetime <- inherits(base_val, "Date") || inherits(base_val, "POSIXct") ||
    inherits(compare_val, "Date") || inherits(compare_val, "POSIXct")
  is_numeric <- is.numeric(base_val) && is.numeric(compare_val)
  is_factor <- is.factor(base_val) || is.factor(compare_val)

  different <- logical(length(base_val))

  if (is_datetime) {
    base_num <- as.numeric(as.POSIXct(base_val))
    compare_num <- as.numeric(as.POSIXct(compare_val))
    xy <- abs(base_num[both_present] - compare_num[both_present])
    if (!is.null(scale)) xy <- xy / scale
    different[both_present] <- xy > tolerance
  } else if (is_numeric) {
    xy <- abs(as.double(base_val[both_present]) - as.double(compare_val[both_present]))
    if (!is.null(scale)) xy <- xy / scale
    different[both_present] <- xy > tolerance
  } else if (is_factor && strict_factor) {
    class_mismatch <- class(base_val)[1] != class(compare_val)[1]
    different[both_present] <- class_mismatch ||
      (as.character(base_val[both_present]) != as.character(compare_val[both_present]))
  } else if (is_factor) {
    different[both_present] <-
      as.character(base_val[both_present]) != as.character(compare_val[both_present])
  } else {
    different[both_present] <- base_val[both_present] != compare_val[both_present]
  }

  different[one_sided_na] <- TRUE
  different
}

#' Class differences between two data frames' shared columns
#'
#' @param base a data.frame or tibble
#' @param compare a data.frame or tibble
#' @param cols shared column names to check (default: all shared names)
#'
#' @return a tibble with `variable`, `class_base`, `class_compare` for each
#'   shared column whose classes differ
#'
#' @description Sub-helper for `diff_values_by_key()`. `Date`/`POSIXct` and
#'   factor/character pairs are unified by `compare_values()`, so they're
#'   excluded here; only genuinely mismatched classes are reported.
#' @noRd
class_diffs <- function(base, compare, cols = intersect(names(base), names(compare))) {
  rows <- list()
  for (col in cols) {
    base_class <- class(base[[col]])[1]
    compare_class <- class(compare[[col]])[1]
    if (identical(base_class, compare_class)) next
    unified <- c("Date", "POSIXct", "factor", "character")
    if (base_class %in% unified && compare_class %in% unified) next
    if (is.numeric(base[[col]]) && is.numeric(compare[[col]])) next
    rows[[col]] <- tibble::tibble(
      variable = col, class_base = base_class, class_compare = compare_class
    )
  }
  if (length(rows) == 0) {
    return(tibble::tibble(
      variable = character(), class_base = character(), class_compare = character()
    ))
  }
  do.call(rbind, rows)
}

#' Compare matched rows of two data frames by key (base R)
#'
#' @param base a data.frame or tibble
#' @param compare a data.frame or tibble
#' @param by character vector of shared key column(s), or `NULL` to match
#'   rows by position (base row 1 vs. compare row 1, etc.)
#' @param tolerance,scale,strict_factor passed to `compare_values()`
#'
#' @return a list with `diffs` (long format: `Variable name`, `by` key
#'   column(s), `Current Value`, `Previous Value`), `diffs_byvar` (count of
#'   differing values per variable), and `class_diffs` (class mismatches by
#'   shared column)
#' @export diff_values_by_key
#'
#' @description Base-R replacement for `diffdf::diffdf()`. Matches `base`
#'   and `compare` rows on `by`, then compares every other shared column
#'   row-by-row with `compare_values()`. With `by = NULL`, rows are matched
#'   by position instead (matching `diffdf::diffdf()`'s own behavior when
#'   `keys` is unset).
diff_values_by_key <- function(base, compare, by = NULL,
                                tolerance = sqrt(.Machine$double.eps),
                                scale = NULL,
                                strict_factor = FALSE) {
  base <- as.data.frame(base)
  compare <- as.data.frame(compare)
  if (is.null(by)) {
    by <- "rownumber"
    base[[by]] <- seq_len(nrow(base))
    compare[[by]] <- seq_len(nrow(compare))
  }

  base_key <- do.call(paste, c(base[by], sep = "\r"))
  compare_key <- do.call(paste, c(compare[by], sep = "\r"))
  shared_keys <- intersect(base_key, compare_key)

  base_matched <- base[match(shared_keys, base_key), , drop = FALSE]
  compare_matched <- compare[match(shared_keys, compare_key), , drop = FALSE]

  compare_cols <- setdiff(intersect(names(base), names(compare)), by)

  diffs_rows <- list()
  byvar_rows <- list()

  for (col in compare_cols) {
    different <- compare_values(
      base_matched[[col]], compare_matched[[col]],
      tolerance = tolerance, scale = scale, strict_factor = strict_factor
    )
    byvar_rows[[col]] <- tibble::tibble(
      `Variable name` = col, `Modified Values` = sum(different, na.rm = TRUE)
    )
    if (any(different)) {
      key_tbl <- base_matched[different, by, drop = FALSE]
      diffs_rows[[col]] <- tibble::as_tibble(data.frame(
        `Variable name` = col,
        key_tbl,
        `Current Value` = as.character(compare_matched[[col]][different]),
        `Previous Value` = as.character(base_matched[[col]][different]),
        check.names = FALSE,
        stringsAsFactors = FALSE
      ))
    }
  }

  diffs <- if (length(diffs_rows) == 0) {
    empty <- tibble::tibble(
      `Variable name` = character(), `Current Value` = character(),
      `Previous Value` = character()
    )
    for (key_col in by) empty[[key_col]] <- character()
    empty
  } else {
    do.call(rbind, diffs_rows)
  }

  diffs_byvar <- if (length(byvar_rows) == 0) {
    tibble::tibble(`Variable name` = character(), `Modified Values` = integer())
  } else {
    do.call(rbind, byvar_rows)
  }

  list(
    diffs = tibble::as_tibble(diffs),
    diffs_byvar = tibble::as_tibble(diffs_byvar),
    class_diffs = class_diffs(base, compare, compare_cols)
  )
}
