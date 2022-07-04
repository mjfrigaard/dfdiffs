# packages ----------------------------------------------------------------
library(knitr)
library(rmdformats)
library(tidyverse)
library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(shiny)
library(shinythemes)
library(bs4Dash)
library(fresh)

# flat_file_curr_data ---------------------------------------------------------
flat_file_curr_data <- tibble::tibble(
  col_a = c(20L, 12L, 18L, 37L),
  col_b = c("l", "m", "n", "o"),
  col_c = c(6.6, 7.1, 4.3, 7.2),
  col_d = c(TRUE, TRUE, FALSE, FALSE)
  )
# flat_file_prev_data ---------------------------------------------------------
flat_file_prev_data <- tibble::tibble(
  col_a = c(20L, 12L, 12L, 12L),
  col_b = c("l", "m", "m", "m"),
  col_c = c(8.3, 4.4, 2.2, 8.9),
  col_d = c(FALSE, FALSE, TRUE, TRUE)
  )
# xlsx_curr_data ---------------------------------------------------------
xlsx_curr_data <- tibble::tibble(
  col_a = c(4L, 3L, 2L, 1L),
  col_b = c("W", "X", "Y", "Z"),
  col_c = c(8.3, 3.3, 22.1, 0.1),
  col_d = c(FALSE, TRUE, FALSE, FALSE)
  )
# xlsx_prev_data ---------------------------------------------------------------
xlsx_prev_data <- tibble::tibble(
  col_a = c(4L, 4L, 2L, 2L),
  col_b = c("W", "W", "Y", "Y"),
  col_c = c(0.5, 1.2, 5.33, 9.1),
  col_d = c(TRUE, FALSE, TRUE, TRUE)
  )

#' Load flat data files
#'
#' @param path path to data file (with extension)
#'
#' @return return_data
#' @export load_flat_file
#'
#' @examples # from local
#' load_flat_file(path = "inst/extdata/csv/2015-baseballdatabank/core/AllstarFull.csv")
#'
load_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = data.table::fread(path),
    csv = data.table::fread(path),
    tsv = data.table::fread(path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  return_data <- tibble::as_tibble(data)
  return(return_data)
}

#' Create new (joining) column
#'
#' @param data a tibble or data.frame
#' @param cols cols to create new column from (they will be pasted together with "-")
#' @param new_name new column name
#'
#' @importFrom dplyr relocate
#' @importFrom tidyr unite
#'
#' @return new_col_data data with new column
#' @export create_new_column
#'
#' @examples
#' library(dplyr)
#' library(tidyr)
#' CompleteData <- dfdiffs::CompleteData
#' IncompleteData <- dfdiffs::IncompleteData
#' CompleteDataJoin <- create_new_column(data = CompleteData,
#'                                        cols = c("subject", "record"),
#'                                        new_name = "join_var")
#' IncompleteDataJoin <- create_new_column(data = IncompleteData,
#'                                        cols = c("subject", "record"),
#'                                        new_name = "join_var")
create_new_column <- function(data, cols, new_name) {
    new_col_data <- data %>%
      tidyr::unite({{new_name}}, {{cols}}, remove = FALSE, sep = "-") %>%
      dplyr::relocate({{new_name}}, everything())
    return(new_col_data)
}

#' Rename join column name
#'
#' @param data a tibble or data.frame
#' @param by_col new join column name
#' @param by join column name
#'
#' @return renamed_data
#' @export rename_join_col
#'
#' @importFrom dplyr rename
#' @importFrom dplyr across
#' @importFrom dplyr select
#' @importFrom dplyr relocate
rename_join_col <- function(data, by, by_col) {
    # names(data)[names(data) == by] <- by_col
    renamed_data <-  dplyr::rename_with(.data = data,
      ~ stringr::str_replace_all(.x, by, by_col))
    return_data <- dplyr::relocate(renamed_data, all_of(by_col), everything())
    return(return_data)
}

# theme -------------------------------------------------------------------
bmrn_theme <- function() {
  fresh::create_theme(
    # theme vars  -------------------------------------------------------------
    fresh::bs4dash_vars(
      navbar_light_color = "#353d98", # purple
      navbar_light_active_color = "#353d98", # purple
      navbar_light_hover_color = "#f26631" # orange
    ),
    # # theme yiq -------------------------------------------------------------
    fresh::bs4dash_yiq(
      contrasted_threshold = 255,
      text_dark = "#0a0a0a", # dark_gray_s10
      text_light = "#f5f5f5" # gray_t10
    ),
    # theme layout ---------------------------------------------------------
    fresh::bs4dash_layout(
      main_bg = NULL, # #ececec
      font_size_root = 12
    ),
    # theme sidebar_light -------------------------------------------------
    fresh::bs4dash_sidebar_light(
      header_color = "#ccd5dd", # dark_blue_t9
      bg = "#eaebf4", # background of entire side-bar
      color = "#002E56", # text color (no hover)
      hover_color = "#ee304e", # text color on hover
      hover_bg = "#353D98", # color on hover
      active_color = "#f26631", # color is actually the 'primary' status color
      submenu_bg = "#f5f5f5", # purple
      submenu_color = "#002444",
      submenu_hover_color = "#353D98" # purple
    ),
    # # theme sidebar_dark -------------------------------------------------
    fresh::bs4dash_sidebar_dark(
      header_color = "#ccd5dd",
      bg = "#1a1e4c",
      color = "#EE304E", # text color (no hover)
      hover_bg = "#aeb1d5", # color on hover
      hover_color = "#EE304E", # text color on hover
      active_color = "#f26631" # color is actually the 'primary' status color
    ),
   # theme status -------------------------------------------------
    fresh::bs4dash_status(
      dark = "#323232",
      light = "#A0A0A0",
      warning = "#F26631", # orange
      primary = "#00509C", # blue
      secondary = "#353D98", # purple
      success = "#A9218E", # violet
      danger = "#EE304E", # red
      info = "#A0A0A0" #orange
    ),
    # theme color -------------------------------------------------
  fresh::bs4dash_color(
    gray_900 = "#1f245b",
    gray_800 = "#646464",
    lightblue = "#6696c3", # blue_t5
    blue = "#00509C" # bluw
    # gray_600 = "#353D98",
    # yellow = "#F26631",
    # gray_900 = "#15183c",
    # gray_800 = "#646464",
    # green = "#A9218E",
    # navy = "#002E56",
    # cyan = "#A0A0A0",
    # gray_800 = "#646464",
    # red = "#EE304E",
    # white = "#272c30"
   )
  )
}

#' Create a table of new records
#'
#' @param newdf a 'new' or 'current' dataset
#' @param olddf an 'old' or 'previous' dataset
#' @param by the joining column between the two datasets
#' @param by_col name of the new joining column
#' @param  cols names of columns to compare
#'
#' @return new_data
#' @export create_new_data
#'
#' @importFrom dplyr anti_join
#' @importFrom dplyr distinct
#' @importFrom dplyr select
#' @importFrom dplyr intersect
#' @importFrom dplyr relocate
#' @importFrom tidyr unite
#' @importFrom tibble add_column
#'
#' @examples # using local data
#' T2Data <- dfdiffs::T2Data
#' T1Data <- dfdiffs::T1Data
#' create_new_data(newdf = T2Data, olddf = T1Data,
#'                 by = c('subject', 'record'))
#' create_new_data(newdf = T2Data, olddf = T1Data,
#'                 by = c('subject', 'record'),
#'                 cols = c("text_var", "factor_var"))
create_new_data <- function(newdf, olddf, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  newdf <- mutate(newdf, across(.cols = everything(), .fns = as.character))
  olddf <- mutate(olddf, across(.cols = everything(), .fns = as.character))

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) no 'by', no 'by_col', no 'cols' -----
    new_data_join <- dplyr::anti_join(x = newdf,
                                      y = olddf,
                                      by = dplyr::intersect(
                                                  x = names(newdf),
                                                  y = names(olddf)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) no 'by', no 'by_col', multiple compare 'cols' -----
    newdf_join_cols <- dplyr::select(newdf, all_of(cols))
    olddf_join_cols <- dplyr::select(olddf, all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join_cols,
                                      y = olddf_join_cols,
                            by = dplyr::intersect(x = names(newdf_join_cols),
                                                  y = names(olddf_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) single 'by' column ----
    new_data_join <- dplyr::anti_join(x = newdf, y = olddf, by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & length(by_col) == 1 & is.null(cols)) {
    # 4) single 'by' column, new 'by_col' ----
    newdf <- rename_join_col(newdf, by = by, by_col = by_col)
    olddf <- rename_join_col(olddf, by = by, by_col = by_col)
    new_data_join <- dplyr::anti_join(x = newdf, y = olddf, by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' column, multiple compare 'cols' ----
    newdf_cols <- select(newdf, matches(by), all_of(cols))
    olddf_cols <- select(olddf, matches(by), all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_cols, y = olddf_cols,
                                      by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) single 'by' column, new 'by_col', multiple compare 'cols' ----
    newdf_cols <- rename_join_col(newdf, by = by, by_col = by_col)
    olddf_cols <- rename_join_col(olddf, by = by, by_col = by_col)
    newdf_join <- select(newdf_cols, matches(by_col), all_of(cols))
    olddf_join <- select(olddf_cols, matches(by_col), all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join, y = olddf_join,
                                      by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) multiple 'by' ----
    # no 'by_col', no multiple compare 'cols'
    newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
    olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
    new_data_join <- dplyr::anti_join(x = newdf_join,
                                      y = olddf_join,
                                      by = dplyr::intersect(
                                                  x = names(newdf_join),
                                                  y = names(olddf_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) multiple 'by' and 'by_col' ----
    # no multiple compare 'cols'
    newdf_join <- create_new_column(data = newdf,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    olddf_join <- create_new_column(data = olddf,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    new_data_join <- dplyr::anti_join(x = newdf_join, y = olddf_join,
                            by = dplyr::intersect(x = names(newdf_join),
                                                  y = names(olddf_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple 'by' & multiple compare 'cols' ----
    # no 'by_col'
    newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
    olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
    newdf_join_cols <- dplyr::select(newdf_join, join, all_of(cols))
    olddf_join_cols <- dplyr::select(olddf_join, join, all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join_cols,
                                      y = olddf_join_cols,
                            by = dplyr::intersect(x = names(newdf_join_cols),
                                                  y = names(olddf_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new 'by_col' & compare multiple 'cols' ----
    newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = {{by_col}})
    olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = {{by_col}})
    newdf_join_cols <- dplyr::select(newdf_join, {{by_col}}, all_of(cols))
    olddf_join_cols <- dplyr::select(olddf_join, {{by_col}}, all_of(cols))
    new_data_join <- dplyr::anti_join(x = newdf_join_cols,
                                      y = olddf_join_cols,
                            by = dplyr::intersect(x = names(newdf_join_cols),
                                                  y = names(olddf_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  }

  return(new_data)
}

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

#' Create a dataset of deleted records
#'
#' @param newdf a 'new' or 'current' dataset
#' @param olddf an 'old' or 'previous' dataset
#' @param by the joining column between the two datasets
#' @param by_col name of the new joining column
#' @param  cols names of columns to compare
#'
#' @return deleted_data
#' @export create_deleted_data
#'
#' @importFrom dplyr anti_join
#' @importFrom dplyr distinct
#' @importFrom dplyr select
#' @importFrom dplyr intersect
#' @importFrom dplyr relocate
#' @importFrom tidyr unite
#' @importFrom tibble add_column
#'
#' @examples # using local data
#' CompleteData <- dfdiffs::CompleteData
#' IncompleteData <- dfdiffs::IncompleteData
#' create_deleted_data(newdf = IncompleteData, olddf = CompleteData,
#'                     by = c("subject", "record"))
#' create_deleted_data(newdf = IncompleteData, olddf = CompleteData,
#'                     by = c("subject", "record")
#'                     by_col = "join_var"
#'                     )
#' create_deleted_data(newdf = IncompleteData, olddf = CompleteData,
#'                     by = c("subject", "record")
#'                     by_col = "join_var",
#'                     cols = c("subject", "record")
#'                     )
create_deleted_data <- function(newdf, olddf, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  newdf <- mutate(newdf, across(.cols = everything(), .fns = as.character))
  olddf <- mutate(olddf, across(.cols = everything(), .fns = as.character))
  if (is.null(by) & is.null(by_col) & is.null(cols)) {
     # 1) NOTHING ----
     # (no 'by', no 'by_col', and no 'cols')
      deleted_join <- dplyr::anti_join(x = olddf, y = newdf,
                                    by = dplyr::intersect(
                                      x = names(olddf),
                                      y = names(newdf)))
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
     # 2) multiple compare columns ----
     # (no 'by', no 'by_col', and multiple compare 'cols')
    newdf_cols <- select(newdf, all_of(cols))
    olddf_cols <- select(olddf, all_of(cols))
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                    by = dplyr::intersect(
                                      x = names(olddf_cols),
                                      y = names(newdf_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
     # 3) single 'by' column ----
     deleted_join <- dplyr::anti_join(x = olddf, y = newdf,
                                        by = {{by}})
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) single `by` column, new `by_col` ----
    newdf_cols <- rename_join_col(data = newdf, by = by, by_col = by_col)
    olddf_cols <- rename_join_col(data = olddf, by = by, by_col = by_col)
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                        by = {{by_col}})
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' and multiple compare 'cols' ----
    # no 'by_col'
    newdf_cols <- dplyr::select(newdf, all_of(by), all_of(cols))
    olddf_cols <- dplyr::select(olddf, all_of(by), all_of(cols))
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                    by = dplyr::intersect(
                                    x = names(olddf_cols),
                                    y = names(newdf_cols)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) multiple 'by', new 'by_col', multiple compare 'cols' ----
    olddf_join <- create_new_column(data = olddf,
                      cols = all_of(by), new_name = {{by_col}})
    newdf_join <- create_new_column(data = newdf,
                      cols = all_of(by), new_name = {{by_col}})
    newdf_cols <- dplyr::select(newdf_join, {{by_col}}, all_of(cols))
    olddf_cols <- dplyr::select(olddf_join, {{by_col}}, all_of(cols))
    deleted_join <- dplyr::anti_join(x = olddf_cols, y = newdf_cols,
                                      by = dplyr::intersect(
                                      x = names(olddf_cols),
                                      y = names(newdf_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple 'by', no 'by_col', no 'cols' -----
      olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
      newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                    by = dplyr::intersect(
                                      x = names(olddf_join),
                                      y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple 'by', new column ('by_col') -----
      # no compare 'cols'
      olddf_join <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = {{by_col}})
      newdf_join <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = {{by_col}})
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                    by = dplyr::intersect(
                                      x = names(olddf_join),
                                      y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple 'by', multiple compare columns ('cols') -----
      # no 'by_col'
      olddf_cols <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = "join")
      newdf_cols <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = "join")
      olddf_join <- dplyr::select(olddf_cols, matches("join"), all_of(cols))
      newdf_join <- dplyr::select(newdf_cols, matches("join"), all_of(cols))
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                    by = dplyr::intersect(
                                      x = names(olddf_join),
                                      y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new column ('by_col'), multiple compare 'cols' -----
      newdf_cols <- create_new_column(data = newdf,
                        cols = all_of(by), new_name = {{by_col}})
      olddf_cols <- create_new_column(data = olddf,
                        cols = all_of(by), new_name = {{by_col}})
      newdf_join <- dplyr::select(newdf_cols, {{by_col}}, all_of(cols))
      olddf_join <- dplyr::select(olddf_cols, {{by_col}}, all_of(cols))
      deleted_join <- dplyr::anti_join(x = olddf_join, y = newdf_join,
                                        by = dplyr::intersect(
                                          x = names(olddf_join),
                                          y = names(newdf_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  }

  return(deleted_data)
}
