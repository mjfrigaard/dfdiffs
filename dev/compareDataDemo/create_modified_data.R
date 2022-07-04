#' Create modified data
#'
#' @param newdf A 'current' or 'new' dataset (tibble or data.frame)
#' @param olddf A 'previous' or 'old' dataset (tibble or data.frame)
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
#'            newdf = CurrentData,
#'            olddf = PreviousData,
#'            by = c("subject_id", "record"),
#'            cols = c("text_value_a", "text_value_b", "updated_date"))
#' create_modified_data(
#'            newdf = CurrentData,
#'            olddf = PreviousData,
#'            by = c("subject_id", "record"))
create_modified_data <- function(newdf, olddf, by = NULL, by_col = NULL, cols = NULL) {
    # convert all columns to character
    newdf <- dplyr::mutate(newdf,
                        across(.cols = everything(), .fns = as.character))
    olddf <- dplyr::mutate(olddf,
                        across(.cols = everything(), .fns = as.character))

    if (is.null(by) & is.null(by_col) & is.null(cols)) {
      # 1) NOTHING (two datasets) ----
      newdf_join_cols <- newdf
      olddf_join_cols <- olddf
      # check
      # mod_data <- list(newdf_join_cols, olddf_join_cols)
      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols))
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
      newdf_join_cols <- dplyr::select(newdf, all_of(cols))
      olddf_join_cols <- dplyr::select(olddf, all_of(cols))
      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols))
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
      newdf_join_cols <- dplyr::relocate(newdf, {{by}}, everything())
      olddf_join_cols <- dplyr::relocate(olddf, {{by}}, everything())
      # check
      # mod_data <- list(newdf_join_cols, olddf_join_cols)
      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_join_cols <- rename_join_col(newdf, by = by, by_col = by_col)
      olddf_join_cols <- rename_join_col(olddf, by = by, by_col = by_col)

      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_join_cols <- dplyr::select(newdf, {{by}}, all_of(cols))
      olddf_join_cols <- dplyr::select(olddf, {{by}}, all_of(cols))

      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_cols <- rename_join_col(newdf, by = by, by_col = by_col)
      olddf_cols <- rename_join_col(olddf, by = by, by_col = by_col)
      newdf_join_cols <- dplyr::select(newdf_cols, {{by_col}}, all_of(cols))
      olddf_join_cols <- dplyr::select(olddf_cols, {{by_col}}, all_of(cols))

      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_join_cols <- create_new_column(data = newdf,
                          cols = all_of(by), new_name = "join")
      olddf_join_cols <- create_new_column(data = olddf,
                          cols = all_of(by), new_name = "join")

      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_join_cols <- create_new_column(data = newdf,
                          cols = all_of(by), new_name = {{by_col}})
      olddf_join_cols <- create_new_column(data = olddf,
                          cols = all_of(by), new_name = {{by_col}})
      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_cols <- create_new_column(data = newdf,
                          cols = all_of(by), new_name = "join")
      olddf_cols <- create_new_column(data = olddf,
                          cols = all_of(by), new_name = "join")
      newdf_join_cols <- dplyr::select(newdf_cols,
                                      matches("join"), all_of(cols))
      olddf_join_cols <- dplyr::select(olddf_cols,
                                      matches("join"), all_of(cols))
      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
      newdf_cols <- create_new_column(data = newdf,
                          cols = all_of(by), new_name = {{by_col}})
      olddf_cols <- create_new_column(data = olddf,
                          cols = all_of(by), new_name = {{by_col}})
      newdf_join_cols <- dplyr::select(newdf_cols,
                                      all_of(by_col), all_of(cols))
      olddf_join_cols <- dplyr::select(olddf_cols,
                                      all_of(by_col), all_of(cols))
      comparedf_list <- summary(arsenal::comparedf(
                                  x = newdf_join_cols,
                                  y = olddf_join_cols,
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
