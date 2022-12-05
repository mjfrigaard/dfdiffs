# packages ----------------------------------------------------------------
library(knitr)
library(arsenal)
library(diffdf)
library(stringr)
library(janitor)
library(dplyr)
library(tidyr)
library(tibble)
library(lubridate)
library(purrr)
library(rmdformats)
library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(markdown)
library(shiny)
library(shinythemes)
library(bs4Dash)
library(fresh)
library(RColorBrewer)


# shiny.maxRequestSize ----------------------------------------------------
options(shiny.maxRequestSize = 2000 * 1024^2)

# %nin% -------------------------------------------------------------------
`%nin%` <- function(x, table) {
  match(x, table, nomatch = 0L) == 0L
}
# "A" %in% "B"

# UPLOAD ------------------------------------------------------------------
# load_flat_file ----------------------------------------------------------
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
# upload_data -------------------------------------------------------------
upload_data <- function(path, sheet = NULL) {
  ext <- tools::file_ext(path)
  if (ext == "xlsx") {
    raw_data <- readxl::read_excel(
        path = path,
        sheet = sheet
      )
    uploaded <- tibble::as_tibble(raw_data)
  } else {
    uploaded <- load_flat_file(path = path)
  }
  return(uploaded)
}
# COMPARE ---------------------------------------------------------
## rename_join_col ------
rename_join_col <- function(data, by, by_col) {
    # names(data)[names(data) == by] <- by_col
    renamed_data <-  dplyr::rename_with(.data = data,
      ~ stringr::str_replace_all(.x, by, by_col))
    return_data <- dplyr::relocate(renamed_data, all_of(by_col), everything())
    return(return_data)
}
## create_new_column ------
create_new_column <- function(data, cols, new_name) {
    new_col_data <- data %>%
      tidyr::unite({{new_name}}, {{cols}}, remove = FALSE, sep = "-") %>%
      dplyr::relocate({{new_name}}, everything())
    return(new_col_data)
}
## create_join_column ------
  create_join_column <- function(df, by_colums, new_by_column_name) {
    # select by_vars
    tmp <- dplyr::select(df, all_of(by_colums))
    # convert to character
    tmp <- dplyr::mutate(tmp, across(.fns = as.character))
    # rename data
    join_col_data <- df
    # assign new col
    join_col_data$new_col <- purrr::pmap_chr(.l = tmp, .f = paste, sep = "-")
    # rename
    names(join_col_data)[names(join_col_data) == "new_col"] <- new_by_column_name
    # relocate
    join_col_data <- dplyr::relocate(join_col_data,
      all_of(new_by_column_name))
    # return
    return(join_col_data)
  }
## create_new_data ------
create_new_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  compare <- mutate(compare, across(.cols = everything(), .fns = as.character))
  base <- mutate(base, across(.cols = everything(), .fns = as.character))

  if (is.null(by) & is.null(by_col) & is.null(cols)) {
    # 1) no 'by', no 'by_col', no 'cols'
    new_data_join <- dplyr::anti_join(x = compare,
                                      y = base,
                                      by = dplyr::intersect(
                                                  x = names(compare),
                                                  y = names(base)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
    # 2) no 'by', no 'by_col', multiple compare 'cols'
    compare_join_cols <- dplyr::select(compare, all_of(cols))
    base_join_cols <- dplyr::select(base, all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join_cols,
                                      y = base_join_cols,
                            by = dplyr::intersect(x = names(compare_join_cols),
                                                  y = names(base_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
    # 3) single 'by' column
    new_data_join <- dplyr::anti_join(x = compare, y = base, by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & length(by_col) == 1 & is.null(cols)) {
    # 4) single 'by' column, new 'by_col'
    compare <- rename_join_col(compare, by = by, by_col = by_col)
    base <- rename_join_col(base, by = by, by_col = by_col)
    new_data_join <- dplyr::anti_join(x = compare, y = base, by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' column, multiple compare 'cols'
    compare_cols <- select(compare, matches(by), all_of(cols))
    base_cols <- select(base, matches(by), all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_cols, y = base_cols,
                                      by = {{by}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) single 'by' column, new 'by_col', multiple compare 'cols'
    compare_cols <- rename_join_col(compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(base, by = by, by_col = by_col)
    compare_join <- select(compare_cols, matches(by_col), all_of(cols))
    base_join <- select(base_cols, matches(by_col), all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join, y = base_join,
                                      by = {{by_col}})
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
    # 7) multiple 'by'
    # no 'by_col', no multiple compare 'cols'
    compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
    base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
    new_data_join <- dplyr::anti_join(x = compare_join,
                                      y = base_join,
                                      by = dplyr::intersect(
                                                  x = names(compare_join),
                                                  y = names(base_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
    # 8) multiple 'by' and 'by_col'
    # no multiple compare 'cols'
    compare_join <- create_new_column(data = compare,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    base_join <- create_new_column(data = base,
                                    cols = all_of(by),
                                    new_name = {{by_col}})
    new_data_join <- dplyr::anti_join(x = compare_join, y = base_join,
                            by = dplyr::intersect(x = names(compare_join),
                                                  y = names(base_join)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
    # 9) multiple 'by' & multiple compare 'cols'
    # no 'by_col'
    compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
    base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
    compare_join_cols <- dplyr::select(compare_join, join, all_of(cols))
    base_join_cols <- dplyr::select(base_join, join, all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join_cols,
                                      y = base_join_cols,
                            by = dplyr::intersect(x = names(compare_join_cols),
                                                  y = names(base_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new 'by_col' & compare multiple 'cols'
    compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = {{by_col}})
    base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = {{by_col}})
    compare_join_cols <- dplyr::select(compare_join, {{by_col}}, all_of(cols))
    base_join_cols <- dplyr::select(base_join, {{by_col}}, all_of(cols))
    new_data_join <- dplyr::anti_join(x = compare_join_cols,
                                      y = base_join_cols,
                            by = dplyr::intersect(x = names(compare_join_cols),
                                                  y = names(base_join_cols)))
    new_data <- dplyr::distinct(new_data_join)
  }

  return(new_data)
}
## create_deleted_data ------
create_deleted_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
  # convert all columns to character
  compare <- mutate(compare, across(.cols = everything(), .fns = as.character))
  base <- mutate(base, across(.cols = everything(), .fns = as.character))
  if (is.null(by) & is.null(by_col) & is.null(cols)) {
     # 1) NOTHING
     # (no 'by', no 'by_col', and no 'cols')
      deleted_join <- dplyr::anti_join(x = base, y = compare,
                                    by = dplyr::intersect(
                                      x = names(base),
                                      y = names(compare)))
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (is.null(by) & is.null(by_col) & !is.null(cols)) {
     # 2) multiple compare columns
     # (no 'by', no 'by_col', and multiple compare 'cols')
    compare_cols <- select(compare, all_of(cols))
    base_cols <- select(base, all_of(cols))
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                    by = dplyr::intersect(
                                      x = names(base_cols),
                                      y = names(compare_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & is.null(cols)) {
     # 3) single 'by' column
     deleted_join <- dplyr::anti_join(x = base, y = compare,
                                        by = {{by}})
     deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & is.null(cols)) {
    # 4) single `by` column, new `by_col`
    compare_cols <- rename_join_col(data = compare, by = by, by_col = by_col)
    base_cols <- rename_join_col(data = base, by = by, by_col = by_col)
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                        by = {{by_col}})
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & is.null(by_col) & !is.null(cols)) {
    # 5) single 'by' and multiple compare 'cols'
    # no 'by_col'
    compare_cols <- dplyr::select(compare, all_of(by), all_of(cols))
    base_cols <- dplyr::select(base, all_of(by), all_of(cols))
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                    by = dplyr::intersect(
                                    x = names(base_cols),
                                    y = names(compare_cols)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) == 1 & !is.null(by_col) & !is.null(cols)) {
    # 6) multiple 'by', new 'by_col', multiple compare 'cols'
    base_join <- create_new_column(data = base,
                      cols = all_of(by), new_name = {{by_col}})
    compare_join <- create_new_column(data = compare,
                      cols = all_of(by), new_name = {{by_col}})
    compare_cols <- dplyr::select(compare_join, {{by_col}}, all_of(cols))
    base_cols <- dplyr::select(base_join, {{by_col}}, all_of(cols))
    deleted_join <- dplyr::anti_join(x = base_cols, y = compare_cols,
                                      by = dplyr::intersect(
                                      x = names(base_cols),
                                      y = names(compare_cols)))
    deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & is.null(cols)) {
      # 7) multiple 'by', no 'by_col', no 'cols'
      base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
      compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                    by = dplyr::intersect(
                                      x = names(base_join),
                                      y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & is.null(cols)) {
      # 8) multiple 'by', new column ('by_col')
      # no compare 'cols'
      base_join <- create_new_column(data = base,
                        cols = all_of(by), new_name = {{by_col}})
      compare_join <- create_new_column(data = compare,
                        cols = all_of(by), new_name = {{by_col}})
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                    by = dplyr::intersect(
                                      x = names(base_join),
                                      y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & is.null(by_col) & !is.null(cols)) {
      # 9) multiple 'by', multiple compare columns ('cols')
      # no 'by_col'
      base_cols <- create_new_column(data = base,
                        cols = all_of(by), new_name = "join")
      compare_cols <- create_new_column(data = compare,
                        cols = all_of(by), new_name = "join")
      base_join <- dplyr::select(base_cols, matches("join"), all_of(cols))
      compare_join <- dplyr::select(compare_cols, matches("join"), all_of(cols))
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                    by = dplyr::intersect(
                                      x = names(base_join),
                                      y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  } else if (length(by) > 1 & !is.null(by_col) & !is.null(cols)) {
    # 10) multiple 'by', new column ('by_col'), multiple compare 'cols' s
      compare_cols <- create_new_column(data = compare,
                        cols = all_of(by), new_name = {{by_col}})
      base_cols <- create_new_column(data = base,
                        cols = all_of(by), new_name = {{by_col}})
      compare_join <- dplyr::select(compare_cols, {{by_col}}, all_of(cols))
      base_join <- dplyr::select(base_cols, {{by_col}}, all_of(cols))
      deleted_join <- dplyr::anti_join(x = base_join, y = compare_join,
                                        by = dplyr::intersect(
                                          x = names(base_join),
                                          y = names(compare_join)))
      deleted_data <- dplyr::distinct(deleted_join)
  }

  return(deleted_data)
}
## extract_df_tables ------
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
  var_diffs_chr_lst <- map(var_diffs_lst,
                            .f = ~mutate(.x,across(.cols = everything(),
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
## create_changed_data ------
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
## create_modified_data ------
create_modified_data <- function(compare, base, by = NULL, by_col = NULL, cols = NULL) {
    # convert all columns to character
    compare <- dplyr::mutate(compare,
                        across(.cols = everything(), .fns = as.character))
    base <- dplyr::mutate(base,
                        across(.cols = everything(), .fns = as.character))

    if (is.null(by) & is.null(by_col) & is.null(cols)) {
      # 1) NOTHING (two datasets)
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
      # 2) multiple 'cols'
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
      # 3) Single 'by' column
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
      # 3) Single 'by' column, new column ('by_col')
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
      # 5) Single 'by' column, multiple compare cols ('cols')
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
      # 6) Single 'by' column, new 'by_col', multiple compare 'cols'
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
      # 7) multiple `by` columns
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
      # 8) multiple `by` columns, new 'by_col'
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
      # 9) multiple `by` columns, multiple compare 'cols'
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
      # 10) multiple `by` columns, new 'by_col', multiple compare 'cols'
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

# THEMES ------------------------------------------------------------------
## dfdiffs_fresh_theme -----
dfdiffs_fresh_theme <- function() {
  fresh::create_theme(
    # theme vars  -------
    fresh::bs4dash_vars(
      navbar_light_color = "#353d98", # purple
      navbar_light_active_color = "#353d98", # purple
      navbar_light_hover_color = "#f26631" # orange
    ),
    # # theme yiq ------
    fresh::bs4dash_yiq(
      contrasted_threshold = 255,
      text_dark = "#0a0a0a", # dark_gray_s10
      text_light = "#f5f5f5" # gray_t10
    ),
    # theme layout ------
    fresh::bs4dash_layout(
      main_bg = NULL, # #ececec
      font_size_root = 12
    ),
    # theme sidebar_light ------
    fresh::bs4dash_sidebar_light(
      header_color = "#ccd5dd", # light blue
      bg = "#eaebf4", # background of entire side-bar
      color = "#002E56", # text color (no hover)
      hover_color = "#ee304e", # text color on hover
      hover_bg = "#353D98", # color on hover
      active_color = "#f26631", # color is actually the 'primary' status color
      submenu_bg = "#f5f5f5", # purple
      submenu_color = "#002444",
      submenu_hover_color = "#353D98" # purple
    ),
    # # theme sidebar_dark ------
    fresh::bs4dash_sidebar_dark(
      header_color = "#ccd5dd",
      bg = "#1a1e4c",
      color = "#EE304E", # text color (no hover)
      hover_bg = "#aeb1d5", # color on hover
      hover_color = "#EE304E", # text color on hover
      active_color = "#f26631" # color is actually the 'primary' status color
    ),
    # theme status ------
    fresh::bs4dash_status(
      dark = "#323232",
      light = "#A0A0A0", # gray
      warning = "#F26631", # orange
      primary = "#A9218E", # violet = #A9218E, blue = #00509C
      secondary = "#353D98", # purple
      success = "#00509C", # blue
      danger = "#EE304E", # red
      info = "#A0A0A0" # gray
    ),
    # theme color ------
    fresh::bs4dash_color(
      gray_900 = "#1f245b",
      gray_800 = "#646464",
      lightblue = "#6696c3",
      blue = "#00509C"
    )
  )
}
# reactable themes --------------------------------------------------------
## base_react_theme ------
base_react_theme <- reactableTheme(
          color = "#FFFFFF",
          backgroundColor = "#761763",
          borderColor = "#646464",
          stripedColor = "hsl(233, 12%, 22%)",
          highlightColor = "#a9218e",
          inputStyle = list(backgroundColor = "#3A3B45"),
          selectStyle = list(backgroundColor = "#3A3B45"),
          pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
          pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
        )
## comp_react_theme -------
comp_react_theme <- reactableTheme(
          color = "#FFFFFF",
          backgroundColor = "#2f3688",
          borderColor = "#646464",
          stripedColor = "hsl(233, 12%, 22%)",
          highlightColor = "#353d98",
          inputStyle = list(backgroundColor = "#3A3B45"),
          selectStyle = list(backgroundColor = "#3A3B45"),
          pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
          pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
        )
## new_react_theme -------
new_react_theme <- reactableTheme(
          color = "#00509C",
          backgroundColor = "#FFFFFF",
          borderColor = "#A0A0A0",
          stripedColor = "#3A3B45",
          highlightColor = "#eeeeee",
          inputStyle = list(backgroundColor = "#eeeeee"),
          selectStyle = list(backgroundColor = "#eeeeee"),
          pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
          pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
        )
## deleted_react_theme --------
deleted_react_theme <- reactableTheme(
          color = "#d62b46",
          backgroundColor = "#FFFFFF",
          borderColor = "#A0A0A0",
          stripedColor = "#3A3B45",
          highlightColor = "#eeeeee",
          inputStyle = list(backgroundColor = "#eeeeee"),
          selectStyle = list(backgroundColor = "#eeeeee"),
          pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
          pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
        )
## changed_react_theme -----
changed_react_theme <- reactableTheme(
          color = "#c15127",
          backgroundColor = "#FFFFFF",
          borderColor = "#646464",
          stripedColor = "#3A3B45",
          highlightColor = "#eeeeee",
          inputStyle = list(backgroundColor = "#eeeeee"),
          selectStyle = list(backgroundColor = "#eeeeee"),
          pageButtonHoverStyle = list(backgroundColor = "3A3B45"),
          pageButtonActiveStyle = list(backgroundColor = "#3A3B45")
        )
