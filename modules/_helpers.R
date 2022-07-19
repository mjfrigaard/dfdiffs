#=====================================================================#
# File name: helpers.R
# This is code to create: functions for the coding report app
# Authored by and feedback to: ma904058@brmn.com
# Last updated:  2022-01-12
# MIT License
# Version: 0.4.3.2
#=====================================================================#


# packages --------
library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(arsenal)
library(stringr)
library(lubridate)
library(DT)
library(inspectdf)
library(openxlsx)
library(tibble)
library(markdown)


# load_file ---------------------------------------------------------------
load_file <- function(name, path) {
  ext <- tools::file_ext(name)
  switch(ext,
         sas7bdat = haven::read_sas(data_file = path),
         feather = feather::read_feather(path),
         validate("Invalid file; Please upload a .sas7bdat or .feather file")
  )
}
# data <- reactive({
#   req(input$upload)
#   load_file(input$upload$name, input$upload$datapath)
# })


# report date -------------------------------------------------------------
now_raw <- str_replace_all(string = lubridate::now(), 
                           pattern = ":", replacement = ".")
# now_raw
report_date <- str_replace_all(string = now_raw,  
                               pattern = " ", 
                               replacement = "-")
# report_date

# css for selectize -------------------------------------------------------
all_cols_css <- "
#compare_vars ~ .selectize-control .selectize-input {
  max-height: 150px;
  overflow-y: auto;
  background: ghostwhite;
}
"

# system variables --------------------------------------------------------
sys_vars <- c("ENVIRONMENTNAME", "SDVTIER", "RECORDPOSITION", 
              "STUDYENVSITENUMBER")

# create_join_column  -----------------------------------------------------

create_join_column <- function(df, join_cols, new_col_name){
  # select by_vars
  tmp <- select(df, all_of(join_cols))
  # convert to character
  tmp <- mutate(tmp, across(.fns = as.character))
  # rename data 
  join_col_data <- df
  # assign new col
  join_col_data$new_col <- pmap_chr(.l = tmp, .f = paste, sep = "-")
  # rename 
  names(join_col_data)[names(join_col_data) == "new_col"] <- new_col_name
  # relocate
  join_col_data <- relocate(join_col_data, all_of(new_col_name))
  # return
  return(join_col_data)
}


# create_new_column -------------------------------------------------------

create_new_column <- function(data, cols, new_name) {
  data %>% 
    unite({{new_name}}, {{cols}}, remove = FALSE, sep = "-") %>% 
    relocate({{new_name}}, everything())
}



# create_new_data ---------------------------------------------------------
create_new_data <- function(newdf, olddf, by) {
  new_data <- dplyr::anti_join(x = newdf, y = olddf, by = by)
  new_data <- distinct(new_data)
  # add column
  new_data <- tibble::add_column(.data = new_data, FLAG = "New Record")
  return(new_data)
}


# create deleted data -----------------------------------------------------
create_deleted_data <- function(newdf, olddf, by) {
  deleted_data <- dplyr::anti_join(x = olddf, y = newdf, by = by)
  deleted_data <- distinct(deleted_data)
  # add column
  deleted_data <- add_column(.data = deleted_data, FLAG = "Deleted Record")
  return(deleted_data)
}


# proc_compare_df ---------------------------------------------------------
proc_compare_df <- function(data_x, data_y, by, by_col = NULL, cols = NULL) {
  # inputs
  by_columns <- as.character(by)
  new_by_column_name <- as.character(by_col)
  compare_columns <- as.character(cols)
  # create new join column
  create_join_column <- function(df, by_colums, new_by_column_name) {
    # select by_vars
    tmp <- select(df, all_of(by_colums))
    # convert to character
    tmp <- mutate(tmp, across(.fns = as.character))
    # rename data
    join_col_data <- df
    # assign new col
    join_col_data$new_col <- pmap_chr(.l = tmp, .f = paste, sep = "-")
    # rename
    names(join_col_data)[names(join_col_data) == "new_col"] <- new_by_column_name
    # relocate
    join_col_data <- relocate(join_col_data, all_of(new_by_column_name))
    # return
    return(join_col_data)
  }
  # multiple by columns, and selected columns
  if ((length(by) > 1) & !is.null(by_col) & !is.null(cols)) {
    
    cols_data_x <- select(data_x, all_of(by), all_of(cols))
    cols_data_y <- select(data_y, all_of(by), all_of(cols))
    
    # get new join cols
    join_data_x <- create_join_column(
      df = cols_data_x, by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    
    join_data_y <- create_join_column(
      df = cols_data_y,
      by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    # create compare object
    compdf_list <- summary(comparedf(
      x = join_data_x, y = join_data_y,
      by = new_by_column_name
    ))
    return(compdf_list)
    
  } else if ((length(by) > 1) & is.null(by_col) & !is.null(cols)) {
    # multiple by, no by_col, multiple cols
    cols_data_x <- select(data_x, all_of(by), all_of(cols))
    cols_data_y <- select(data_y, all_of(by), all_of(cols))
    # get new join cols
    join_data_x <- create_join_column(
      df = cols_data_x, by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    join_data_y <- create_join_column(
      df = cols_data_y, by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    compdf_list <- summary(comparedf(
      x = join_data_x, y = join_data_y,
      by = "JOINCOL"
    ))
    return(compdf_list)
    
  } else if ((length(by) > 1) & !is.null(by_col) & is.null(cols)) {
    # multiple 'by', 'by_col', no 'cols'
    # get new join cols
    join_data_x <- create_join_column(
      df = data_x, by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    join_data_y <- create_join_column(
      df = data_y,
      by_colums = by_columns,
      new_by_column_name = new_by_column_name
    )
    # create compare object
    compdf_list <- summary(comparedf(
      x = join_data_x, y = join_data_y,
      by = new_by_column_name
    ))
    return(compdf_list)
    
  } else if ((length(by) = 1) & is.null(by_col) & is.null(cols)) {
    # single 'by' col, no by_col, no cols ----
    compdf_list <- summary(comparedf(x = data_x, y = data_y, by = by_columns))
    
    return(compdf_list)
    
  } else if ((length(by) = 1) & is.null(by_col) & !is.null(cols)) {
    # single 'by' col, no by_col, multp cols 
    cols_data_x <- select(data_x, all_of(by), all_of(cols))
    cols_data_y <- select(data_y, all_of(by), all_of(cols))
    # get compare object
    compdf_list <- summary(comparedf(
      x = cols_data_x, y = cols_data_y,
      by = by
    ))
    return(compdf_list)
    
  } else {
    # single 'by' col, no 'by_col', and no 'cols' 
    # get new join cols
    join_data_x <- create_join_column(
      df = data_x, by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    join_data_y <- create_join_column(
      df = data_y,
      by_colums = by_columns,
      new_by_column_name = "JOINCOL"
    )
    # create compare object
    compdf_list <- summary(comparedf(
      x = join_data_x, y = join_data_y,
      by = "JOINCOL"
    ))
    
    return(compdf_list)
  }
}

# extract_frame_summary_table ---------------------------------------------
extract_frame_summary_table <- function(comparedf_object, table) { 
  
  comparedf_list <- comparedf_object
  
  if (table == "frame.summary.table" & nrow(comparedf_list[["frame.summary.table"]]) > 0) {
    # frame.summary.table 
    frame_summary_table <- as_tibble(comparedf_list[["frame.summary.table"]])
    frame_summary_table <- select(frame_summary_table, 
                                  Dataset = arg, Columns = ncol, Rows = nrow)
    return(frame_summary_table)
    
  } else {
    
    message("this table is empty")
    frame_summary_table_names <- c("Dataset", "Columns", "Rows")
    empty_frame_summary_table <- 
      tibble::tibble(x = frame_summary_table_names) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value)
    
    return(empty_frame_summary_table)
    
  }
  
}


# extract_comparison_summary_table ----------------------------------------
extract_comparison_summary_table <- function(comparedf_object, table) { 
  
  comparedf_list <- comparedf_object
  
  if (table == "comparison.summary.table" & nrow(comparedf_list[["comparison.summary.table"]]) > 0) {
    # comparison.summary.table ----
    comparison_summary_table <- as_tibble(comparedf_list[["comparison.summary.table"]])
    # rename these to be a little prettier 
    comparison_summary_table <- select(comparison_summary_table, 
                                       Statistic = statistic, Value = value)
    comparison_summary_table <- mutate(comparison_summary_table, Statistic = case_when(
      Statistic == "Number of variables in x but not y" ~ "Number of variables in current but not in previous", 
      Statistic == "Number of variables in y but not x" ~ "Number of variables in previous but not in current",
      Statistic == "Number of observations in x but not y" ~ "Number of observations in current but not in previous",
      Statistic == "Number of observations in y but not x" ~  "Number of observations in previous but not in current",
      TRUE ~ Statistic
    ))
    return(comparison_summary_table)
    
  } else {
    
    message("this table is empty")
    comparison_summary_table_names <- c("Statistic", "Value")
    empty_comparison_summary_table <- 
      tibble::tibble(x = comparison_summary_table_names) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value)
    return(empty_comparison_summary_table)
    
  }
  
}

## extract_vars_ns_table ---------------------------------------------------
extract_vars_ns_table <- function(comparedf_object, table) { 
  
  comparedf_list <- comparedf_object
  
  if (table == "vars.ns.table" & nrow(comparedf_list[["vars.ns.table"]]) > 0) {
    # vars.ns.table 
    vars_ns_table <- as_tibble(comparedf_list[["vars.ns.table"]])
    vars_ns_table <- rename_with(.data = vars_ns_table, str_to_title)
    return(vars_ns_table)
    
  } else {
    
    message("this table is empty")
    vars_ns_table_names <- str_to_title(names(test_proc_compare$vars.ns.table))
    empty_vars_ns_table <- 
      tibble::tibble(x = vars_ns_table_names) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value)
    
    return(empty_vars_ns_table)
    
  }
  
}

## extract_vars_nc_table ---------------------------------------------------
extract_vars_nc_table <- function(comparedf_object, table) { 
  
  comparedf_list <- comparedf_object
  
  if (table == "vars.nc.table" & nrow(comparedf_list[["vars.nc.table"]]) > 0) {
    # vars.nc.table ----
    vars_nc_table <- as_tibble(comparedf_list[["vars.nc.table"]])
    vars_nc_table <- rename(vars_nc_table, 
                            `Current variable` = var.x, 
                            `Current position` = pos.x, 
                            `Current class` = class.x, 
                            `Previous variable` = var.y, 
                            `Previous position` = pos.y, 
                            `Previous class` = class.y)
    
    return(vars_nc_table)
    
  } else {
    
    message("this table is empty")
    vars_nc_table_names <- c("Current variable", "Current position", 
                             "Current class", "Previous variable", 
                             "Previous position", "Previous class")
    empty_vars_nc_table <- 
      tibble::tibble(x = vars_nc_table_names) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value)
    
    return(empty_vars_nc_table)
    
  }
  
}

## extract_obs_table -------------------------------------------------------
extract_obs_table <- function(comparedf_object, table) {
  
  comparedf_list <- comparedf_object
  
  if (table == "obs.table" & nrow(comparedf_list[["obs.table"]]) > 0) {
    # obs.table ----
    obs_table <- as_tibble(comparedf_list[["obs.table"]])
    obs_table <- rename(obs_table, Dataset = version)
    obs_table <- mutate(obs_table, Dataset = if_else(condition = Dataset == "x", 
                                                     true = "Current", 
                                                     false = "Previous"))
    obs_table <- rename_with(.data = obs_table, .fn = str_to_title)
    
    return(obs_table)
    
  } else {
    
    message("this table is empty")
    empty_obs_table <- 
      tibble::tibble(x = names(comparedf_list$obs.table)) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value) %>% 
      rename_with(.data = ., .fn = str_to_title)
    
    return(empty_obs_table)
    
  }
  
}

## extract_diffs_byvar_table -----------------------------------------------
extract_diffs_byvar_table <- function(comparedf_object, table) {
  
  comparedf_list <- comparedf_object
  
  if (table == "diffs.byvar.table" & nrow(comparedf_list[["diffs.byvar.table"]]) > 0) {
    # diffs.byvar.table ----
    diffs_byvar_table <- as_tibble(comparedf_list[["diffs.byvar.table"]])
    diffs_byvar_table <- select(diffs_byvar_table, 
                                Column = var.x, Diffs = n, 
                                Missing = NAs)
    return(diffs_byvar_table)
    
  } else {
    
    message("this table is empty")
    empty_diffs_byvar_table <- 
      tibble::tibble(x = c("Column", "Diffs", "Missing")) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value) %>% 
      rename_with(.data = ., .fn = str_to_title)
    return(empty_diffs_byvar_table)
    
  }
  
}

## extract_diffs_table -----------------------------------------------------
extract_diffs_table <- function(comparedf_object, table) {
  comparedf_list <- comparedf_object
  
  if (table == "diffs.table" & nrow(comparedf_list[["diffs.table"]]) > 0) {
    # diffs.table 
    diffs_table <- tibble::as_tibble(comparedf_list[["diffs.table"]]) %>% 
      tidyr::unnest(cols = c(values.x, values.y)) %>% 
      dplyr::mutate(across(.cols = everything(), .fns = as.character)) %>% 
      dplyr::rename(`Modified Column` = var.x,
                    `Current Value` = values.x, 
                    `Previous Value` = values.y) %>% 
      dplyr::select(`Modified Column`, `Current Value`, `Previous Value`, 
                    everything(), -var.y, -row.x, -row.y)
    return(diffs_table)
    
  } else {
    
    message("this table is empty")
    empty_diffs_table <- 
      tibble::tibble(x = c("JOINCOL", "Modified Column", "Current Value", 
                           "Previous Value")) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value) %>% 
      rename_with(.data = ., .fn = str_to_title)
    return(empty_diffs_table)
  }
  
}

## extract_attrs_table -----------------------------------------------------
extract_attrs_table <- function(comparedf_object, table) {
  comparedf_list <- comparedf_object
  if (table == "attrs.table" & nrow(comparedf_list[["attrs.table"]]) > 0) {
    # attrs.table ----
    attrs_table <- tibble::as_tibble(comparedf_list[["attrs.table"]])
    # rename the columns
    attrs_table <- rename(attrs_table, 
                          `Current Column` = var.x, 
                          `Previous Column` = var.y, 
                          Name = name)
    return(attrs_table)
  } else {
    message("this table is empty")
    attrs_table_names <- c("Current Column", "Previous Column", "Name")
    empty_attrs_table <- 
      tibble::tibble(x = attrs_table_names) %>% 
      tibble::add_column(value = NA_character_) %>% 
      tidyr::pivot_wider(names_from = x, values_from = value) %>% 
      rename_with(.data = ., .fn = str_to_title)
    return(empty_attrs_table)
  }
}

## proc_extract_table ------------------------------------------------------

proc_extract_table <- function(comparedf_list, table, by_col) {
  
  if (table == "frame.summary.table" & nrow(comparedf_list[["frame.summary.table"]]) > 0) {
    # frame.summary.table ----
    frame_summary_table <- as_tibble(comparedf_list[["frame.summary.table"]])
    
    return_table <- select(frame_summary_table, 
                           Dataset = arg, Columns = ncol, Rows = nrow)
    
  } else if (table == "comparison.summary.table" & nrow(comparedf_list[["comparison.summary.table"]]) > 0) {
    # comparison.summary.table ----
    comparison_summary_table <- as_tibble(comparedf_list[["comparison.summary.table"]])
    # rename these to be a little prettier 
    comparison_summary_table <- select(comparison_summary_table, 
                                       Statistic = statistic, Value = value)
    comparison_summary_table <- mutate(comparison_summary_table, Statistic = case_when(
      Statistic == "Number of variables in x but not y" ~ "Number of variables in current but not in previous", 
      Statistic == "Number of variables in y but not x" ~ "Number of variables in previous but not in current",
      Statistic == "Number of observations in x but not y" ~ "Number of observations in current but not in previous",
      Statistic == "Number of observations in y but not x" ~  "Number of observations in previous but not in current",
      TRUE ~ Statistic
    ))
    return_table <- mutate(comparison_summary_table, Value = as.integer(Value))
    
  } else if (table == "vars.ns.table" & nrow(comparedf_list[["vars.ns.table"]]) > 0) {
    # vars.ns.table ----
    vars_ns_table <- as_tibble(comparedf_list[["vars.ns.table"]])
    vars_ns_table <- rename(vars_ns_table, Dataset = version)
    return_table <- rename_with(.data = vars_ns_table, .fn = str_to_title)
    
  } else if (table == "vars.nc.table" & nrow(comparedf_list[["vars.nc.table"]]) > 0) {
    # vars.nc.table ----
    # var.x	pos.x	class.x	var.y	pos.y	class.y
    vars_nc_table <- as_tibble(comparedf_list[["vars.nc.table"]])
    return_table <- rename(vars_nc_table, 
                           `Column X` = var.x, `Position X` = pos.x, `Class X` = class.x,
                           `Column Y` = var.y, `Position Y` = pos.y, `Class Y` = class.y)
    
  } else if (table == "obs.table" & nrow(comparedf_list[["obs.table"]]) > 0) {
    # obs.table ----
    obs_table <- as_tibble(comparedf_list[["obs.table"]])
    obs_table <- rename(obs_table, Dataset = version)
    obs_table <- mutate(obs_table, Dataset = if_else(condition = Dataset == "x", 
                                        true = "Current", 
                                        false = "Previous"))
    return_table <- rename_with(.data = obs_table,
                                .cols = everything(), .fn = str_to_title)
    
  } else if (table == "diffs.byvar.table" & nrow(comparedf_list[["diffs.byvar.table"]]) > 0) {
    # diffs.byvar.table ----
    diffs_byvar_table <- as_tibble(comparedf_list[["diffs.byvar.table"]])
    return_table <- select(diffs_byvar_table, 
                           Column = var.x, Diffs = n, Missing = NAs)
    
    
  } else if (table == "diffs.table" & nrow(comparedf_list[["diffs.table"]]) > 0) {
    # diffs.table ----
    # diffs.table 
    diffs_table <- tibble::as_tibble(comparedf_list[["diffs.table"]])
    # all character 
    diffs_table_chr <- dplyr::mutate(.data = diffs_table, 
                                 across(.cols = everything(), .fns = as.character))
    # new col names
    diffs_table_nms <- dplyr::rename(.data = diffs_table_chr,
                                 `Modified Column` = var.x,
                                 `Current Value` = values.x, 
                                 `Previous Value` = values.y)
    # reduce
    return_table <- dplyr::select(.data = diffs_table_nms, 
                                  `Modified Column`, `Current Value`, 
                                  `Previous Value`, everything(), 
                                  -var.y, -row.x, -row.y)
    
  } else {
    
    message("This table is empty.")
    return(tibble(`Value` = NA_character_))
    
  }
  
  return(return_table)
  
}

# excel workbook style -----
report_header_style <- createStyle(
  fontColour = "#ffffff",
  fgFill = "#4F80BD",
  halign = "left", 
  valign = "center", 
  textDecoration = "Bold",
  border = "TopBottomLeftRight")


# dataShape ---------------------------------------------------------------
# 
dataShape <- function(df) {
  obs <- nrow(df)
  vars <- ncol(df)
  class <- paste0(class(df), collapse = "; ")
  first_var <- base::names(df) %>% head(1)
  last_var <- base::names(df) %>% tail(1)
  group <- is_grouped_df(df)
  cat("Observations: ", obs, "\n", sep = "")
  cat("Variables: ", vars, "\n", sep = "")
  cat("Class(es): ", class, "\n", sep = " ")
  cat("First/last variable: ", first_var, "/", last_var, "\n", sep = "")
  cat("Grouped: ", group, "\n", sep = "")
}