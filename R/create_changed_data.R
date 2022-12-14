#' Extract tables from `diffdf::diffdf` list
#'
#' @param diffdf_list output from `diffdf::diffdf()` function
#' @param by_keys `keys` argument from `diffdf::diffdf()`/`by` argument from
#'      `create_changed_data()`
#'
#' @importFrom stringr str_detect
#' @importFrom dplyr mutate
#' @importFrom stringr str_detect
#' @importFrom purrr map_df
#' @importFrom purrr map
#' @importFrom janitor clean_names
#' @importFrom purrr set_names
#' @importFrom dplyr across
#' @importFrom dplyr select
#' @importFrom dplyr contains
#' @importFrom dplyr relocate
#' @importFrom dplyr row_number
#' @importFrom tibble as_tibble
#' @importFrom tidyr unite
#' @importFrom tidyr unnest
#' @importFrom magrittr `%>%`
#'
#' @return diff_tbls list of diff tables
#' @export extract_df_tables
#'
#' @description This is a sub-function for create_changed_data()
extract_df_tables <- function(diffdf_list, by_keys) {
  diff_lst_nms <- base::names(diffdf_list)
  num_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Num")]
  var_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Var")]
  base_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Base")]
  comp_diffs_lst <- diffdf_list[stringr::str_detect(diff_lst_nms, "Comp")]
  # nums
  num_diffs <- purrr::map_df(.x = num_diffs_lst,
                                  .f = janitor::clean_names)
  # vars
  var_diffs_chr_lst <- purrr::map(var_diffs_lst,
                            .f = ~dplyr::mutate(.x,across(.cols = everything(),
                                                    .fns = as.character)))
  var_diffs <- purrr::map_df(.x = var_diffs_chr_lst, .f = janitor::clean_names)

  if (length(base_diffs_lst) > 0 & length(comp_diffs_lst) > 0) {
    # base & comps
    base_diffs_issue <- tibble::as_tibble(base_diffs_lst)
    base_diffs <- tidyr::unnest(base_diffs_issue, ExtRowsBase)
    base_diffs <- purrr::set_names(x = base_diffs,
                    nm = paste0(by_keys, "s in BASE that are not in COMPARE"))
    comp_diffs_issue <- tibble::as_tibble(comp_diffs_lst)
    comp_diffs <- tidyr::unnest(comp_diffs_issue, ExtRowsComp)
    comp_diffs <- purrr::set_names(x = comp_diffs,
                      nm = paste0(by_keys, "s in COMPARE that are not in BASE"))
    diff_tbls <- list(
      "base_diffs" = base_diffs, "comp_diffs" = comp_diffs,
      "num_diffs" = num_diffs, "var_diffs" = var_diffs
      )
  } else if (length(base_diffs_lst) > 0 & length(comp_diffs_lst) == 0) {
    # base
    base_diffs_issue <- tibble::as_tibble(base_diffs_lst)
    base_diffs <- tidyr::unnest(base_diffs_issue, ExtRowsBase)
    base_diffs <- purrr::set_names(x = base_diffs,
                    nm = paste0(by_keys, "s in BASE that are not in COMPARE"))
    diff_tbls <- list(
      "base_diffs" = base_diffs,
      "num_diffs" = num_diffs, "var_diffs" = var_diffs
      )
  } else if (length(base_diffs_lst) == 0 & length(comp_diffs_lst) > 0) {
    # comps
    comp_diffs_issue <- tibble::as_tibble(comp_diffs_lst)
    comp_diffs <- tidyr::unnest(comp_diffs_issue, ExtRowsComp)
    comp_diffs <- purrr::set_names(x = comp_diffs,
                      nm = paste0(by_keys, "s in COMPARE that are not in BASE"))
    diff_tbls <- list(
      "comp_diffs" = comp_diffs,
      "num_diffs" = num_diffs, "var_diffs" = var_diffs,
      )
  } else {
    diff_tbls <- list(
      "num_diffs" = num_diffs,
      "var_diffs" = var_diffs)
  }
  return(diff_tbls)
}


#' Create changed data
#'
#' @param compare A 'current' or 'new' dataset (tibble or data.frame)
#' @param base A 'previous' or 'old' dataset (tibble or data.frame)
#' @param by A join column between the two datasets, or any combination of columns that constitute a unique row.
#' @param by_col A new name for the joining column.
#' @param cols Columns to be compared.
#'
#' @importFrom diffdf diffdf
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr select
#' @importFrom dplyr contains
#' @importFrom dplyr relocate
#' @importFrom dplyr row_number
#' @importFrom tibble as_tibble
#' @importFrom tidyr unite
#' @importFrom tidyr separate
#' @importFrom magrittr `%>%`
#'
#' @return modified data
#' @export create_changed_data
#'
#' @examples # with local data
#' ChangedData <- dfdiffs::ChangedData
#' InitialData <- dfdiffs::InitialData
#' create_changed_data(
#'   compare = ChangedData,
#'   base = InitialData,
#'   by = c("subject_id", "record"),
#'   cols = c("text_value_a", "text_value_b", "updated_date")
#' )
#' create_changed_data(
#'   compare = ChangedData,
#'   base = InitialData,
#'   by = c("subject_id", "record")
#' )
create_changed_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # check to see if by is included in cols
  if (sum(by %in% cols) > 0) {
    stop("The 'by' column is listed in the columns to compare ('cols)")
  } else {
      # convert all columns to character
    compare <- mutate(compare, across(.cols = everything(), .fns = as.character))
    base <- mutate(base, across(.cols = everything(), .fns = as.character))
  }

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) NOTHING (Two datasets, compare all columns) ----
    diff_lst <- suppressWarnings(suppressMessages(
      diffdf::diffdf(base = base , compare = compare)))
    # get names
    diff_lst_nms <- base::names(diff_lst)
    # extract nums
    numdiffs_lst <- diff_lst[stringr::str_detect(diff_lst_nms, "NumDiff")]
    # better names
    num_diffs <- purrr::map_df(.x = numdiffs_lst, .f = janitor::clean_names)
    # extract vars
    vardiffs_lst <- diff_lst[stringr::str_detect(diff_lst_nms, "VarDiff")]
    # convert to character
    chr_vardiffs_lst <- purrr::map(.x = vardiffs_lst,
                                        dplyr::mutate_all, base::as.character)
    # better names
    var_diffs <- purrr::map_df(.x = chr_vardiffs_lst, .f = janitor::clean_names)
    # return object
    changed_data <- list("num_diffs" = num_diffs, "var_diffs" = var_diffs)

  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) Multiple columns to compare (cols): ----
    # no 'by' & no 'by_col'
    base_cols <- dplyr::select(base, all_of(cols))
    compare_cols <- dplyr::select(compare, all_of(cols))
    diff_lst <- suppressWarnings(suppressMessages(
      diffdf::diffdf(base = base_cols , compare = compare_cols)))

    # get names
    diff_lst_nms <- base::names(diff_lst)
    # extract nums
    numdiffs_lst <- diff_lst[stringr::str_detect(diff_lst_nms, "NumDiff")]
    # better names
    num_diffs <- purrr::map_df(.x = numdiffs_lst, .f = janitor::clean_names)
    # extract vars
    vardiffs_lst <- diff_lst[stringr::str_detect(diff_lst_nms, "VarDiff")]
    # convert to character
    chr_vardiffs_lst <- purrr::map(.x = vardiffs_lst,
                                        dplyr::mutate_all, base::as.character)
    # better names
    var_diffs <- purrr::map_df(.x = chr_vardiffs_lst, .f = janitor::clean_names)

    changed_data <- list("num_diffs" = num_diffs, "var_diffs" = var_diffs)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) Single 'by' column, no new column name ----
    diff_lst <- suppressWarnings(suppressMessages(
      diffdf::diffdf(base = base , compare = compare, keys = by)))

    changed_data <- extract_df_tables(diffdf_list = diff_lst, by_keys = by)

  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) Single by column, new column name (by_col) -----
      compare_join_cols <- rename_join_col(compare, by = by, by_col = by_col)
      base_join_cols <- rename_join_col(base, by = by, by_col = by_col)
      # create df list
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = by_col)))
      # extract tables (using by_col)
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = by_col)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) Single by column, multiple compare columns 'cols' ----
      compare_join_cols <- dplyr::select(compare, {{by}}, all_of(cols))
      base_join_cols <- dplyr::select(base, {{by}}, all_of(cols))
      # create df list
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = by)))
      # extract tables (using by)
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = by)

  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) Single by column, new column name (by_col), multiple compare columns (cols) ----
      compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
      base_cols <- rename_join_col(base, by = by, by_col = by_col)
      compare_join_cols <- dplyr::select(compare_cols, {{by_col}}, all_of(cols))
      base_join_cols <- dplyr::select(base_cols, {{by_col}}, all_of(cols))
      # create df list using 'by_col'
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = by_col)))
      # extract tables (using 'by_col')
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = by_col)

  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) Multiple by columns ----
      compare_join_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = 'join')
      base_join_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = 'join')
      # create df list using 'join'
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = 'join')))
      # extract tables (using 'join')
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = 'join')
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) Multiple by columns, new column name (by_col) ----
      compare_join_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = {{by_col}})
      base_join_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = {{by_col}})
      # create df list using 'by_col'
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = {{by_col}})))
      # extract tables (using 'by_col')
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = {{by_col}})

  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple `by` columns, multiple compare 'cols' ----
    # create new 'join' column
      compare_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = "join")
      base_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = "join")
      # select the 'cols'
      compare_join_cols <- dplyr::select(compare_cols,
                                      matches("join"), all_of(cols))
      base_join_cols <- dplyr::select(base_cols,
                                      matches("join"), all_of(cols))
      # create df list using 'join'
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = 'join')))
      # extract tables (using 'join')
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = 'join')

  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple `by` columns, new 'by_col', and 'cols' ----
      compare_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = {{by_col}})
      base_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = {{by_col}})
      compare_join_cols <- dplyr::select(compare_cols,
                                      all_of(by_col), all_of(cols))
      base_join_cols <- dplyr::select(base_cols,
                                      all_of(by_col), all_of(cols))
      # create df list using 'by_col'
      diff_lst <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base_join_cols,
                                  compare = compare_join_cols,
                                  keys = {{by_col}})))
      # extract tables (using 'by_col')
      changed_data <- extract_df_tables(diffdf_list = diff_lst,
                                          by_keys = {{by_col}})

  } else {

      changed_data <- suppressWarnings(suppressMessages(
                    diffdf::diffdf(base = base,
                                  compare = compare,
                                  keys = by)))
  }

  return(changed_data)
}
