#' Create modified data
#'
#' @param compare A 'current' or 'new' dataset (tibble or data.frame)
#' @param base A 'previous' or 'old' dataset (tibble or data.frame)
#' @param by A join column between the two datasets, or any combination of columns that constitute a unique row.
#' @param by_col A new name for the joining column.
#' @param cols Columns to be compared.
#'
#' @importFrom arsenal comparedf
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom dplyr select
#' @importFrom dplyr contains
#' @importFrom dplyr relocate
#' @importFrom dplyr row_number
#' @importFrom tibble as_tibble
#'
#' @return modified data
#' @export create_modified_data
#'
#' @examples # with local data
#' CurrentData <- dfdiffs::ChangedData
#' PreviousData <- dfdiffs::InitialData
#' create_modified_data(
#'            compare = CurrentData,
#'            base = PreviousData,
#'            by = c("subject_id", "record"),
#'            cols = c("text_value_a", "text_value_b", "updated_date"))
#' create_modified_data(
#'            compare = CurrentData,
#'            base = PreviousData,
#'            by = c("subject_id", "record"))
create_modified_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
    # convert all columns to character
    compare <- dplyr::mutate(compare,
                        across(.cols = everything(), .fns = as.character))
    base <- dplyr::mutate(base,
                        across(.cols = everything(), .fns = as.character))

    if (is.null(by) & is.null(by_col) & is.null(cols)) {
      # 1) NOTHING (two datasets) ----
      compare_join_cols <- compare
      base_join_cols <- base
      # check
      # mod_data <- list(compare_join_cols, base_join_cols)
      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols))
      # diffs
      diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(.data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
      # 2) multiple 'cols' ----
      # no 'by' & no 'by_col'
      compare_join_cols <- dplyr::select(compare, all_of(cols))
      base_join_cols <- dplyr::select(base, all_of(cols))
      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols))
      # diffs
      diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
      # 3) Single 'by' column ----
      compare_join_cols <- dplyr::relocate(compare, {{by}}, everything())
      base_join_cols <- dplyr::relocate(base, {{by}}, everything())
      # check
      # mod_data <- list(compare_join_cols, base_join_cols)
      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = {{by}}))
      # diffs
      diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       all_of(by),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
      # 3) Single 'by' column, new column ('by_col') ----
      compare_join_cols <- rename_join_col(compare, by = by, by_col = by_col)
      base_join_cols <- rename_join_col(base, by = by, by_col = by_col)

      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = {{by_col}}))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       all_of(by_col),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
      # 5) Single 'by' column, multiple compare cols ('cols') ----
      compare_join_cols <- dplyr::select(compare, {{by}}, all_of(cols))
      base_join_cols <- dplyr::select(base, {{by}}, all_of(cols))

      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = {{by}}))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       all_of(by),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
      # 6) Single 'by' column, new 'by_col', multiple compare 'cols' ----
      compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
      base_cols <- rename_join_col(base, by = by, by_col = by_col)
      compare_join_cols <- dplyr::select(compare_cols, {{by_col}}, all_of(cols))
      base_join_cols <- dplyr::select(base_cols, {{by_col}}, all_of(cols))

      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = {{by_col}}))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       all_of(by_col),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple `by` columns ----
      compare_join_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = "join")
      base_join_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = "join")

      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = "join"))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       matches("join"),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)
    } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple `by` columns, new 'by_col' ----
      compare_join_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = {{by_col}})
      base_join_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = {{by_col}})
      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = {{by_col}}))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       all_of(by_col),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple `by` columns, multiple compare 'cols' ----
      compare_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = "join")
      base_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = "join")
      compare_join_cols <- dplyr::select(compare_cols,
                                      matches("join"), all_of(cols))
      base_join_cols <- dplyr::select(base_cols,
                                      matches("join"), all_of(cols))
      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = "join"))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       matches("join"),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)

    } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
      # 10) multiple `by` columns, new 'by_col', multiple compare 'cols' ----
      compare_cols <- create_new_column(data = compare,
                          cols = all_of(by), new_name = {{by_col}})
      base_cols <- create_new_column(data = base,
                          cols = all_of(by), new_name = {{by_col}})
      compare_join_cols <- dplyr::select(compare_cols,
                                      all_of(by_col), all_of(cols))
      base_join_cols <- dplyr::select(base_cols,
                                      all_of(by_col), all_of(cols))
      comparedf_list <- summary(arsenal::comparedf(
                                  x = compare_join_cols,
                                  y = base_join_cols,
                                    by = {{by_col}}))
      # diffs
     diffs_table <- dplyr::mutate(
                .data = comparedf_list$diffs.table,
                    dplyr::across(.cols = dplyr::contains("values"),
                          .fns = base::as.character))
      diffs_names <- dplyr::select(
                      .data = diffs_table,
                      `Variable name` = var.x,
                       all_of(by_col),
                      `Current Value` = values.x,
                      `Previous Value` = values.y)
      diffs_tbl <- tibble::as_tibble(diffs_names)
      # diffs_byvar
      diffs_byvar_names <- dplyr::select(
                      .data = comparedf_list$diffs.byvar.table,
                      `Variable name` = var.x,
                      `Modified Values` = n,
                      `Missing Values` = NAs)
      diffs_byvar_tbl <- tibble::as_tibble(diffs_byvar_names)
      mod_data <- list('diffs' = diffs_tbl, 'diffs_byvar' = diffs_byvar_tbl)
    }
    return(mod_data)
}
