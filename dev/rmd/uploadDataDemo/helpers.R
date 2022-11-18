#' Load flat data files
#'
#' @param path path to data file (with extension)
#'
#' @return return_data
#' @export load_flat_file
#' @importFrom data.table fread
#' @importFrom haven read_sas
#' @importFrom haven read_sav
#' @importFrom haven read_dta
#' @importFrom tools file_ext
#' @importFrom tibble as_tibble
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

#' Upload data to app `upload_data()`
#'
#' @param path path to data file (with extension)
#' @param sheet excel sheet (if excel file)
#'
#' @return uploaded
#' @export upload_data
#' @importFrom readxl read_excel
#' @importFrom tools file_ext
#' @importFrom tibble as_tibble
#'
#'
#' @examples # not run
#' upload_data(path = "inst/extdata/app-testing/lahman_compare.xlsx",
#'             sheet = "master-2015")
#' upload_data(path = "inst/extdata/app-testing/m15.csv")
#' upload_data(path = "inst/extdata/dta/iris.dta")
#' upload_data(path = "inst/extdata/sas7bdat/iris.sas7bdat")
#' upload_data(path = "inst/extdata/sav/iris.sav")
#' upload_data(path = "inst/extdata/tsv/Batting.tsv")
#' upload_data(path = "inst/extdata/txt/Batting.txt")
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


# dfdiffs_fresh_theme --------------------------------------------------------
dfdiffs_fresh_theme <- function() {
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
      light = "#A0A0A0", # gray
      warning = "#F26631", # orange
      primary = "#A9218E", # violet = #A9218E, blue = #00509C
      secondary = "#353D98", # purple
      success = "#00509C", # blue
      danger = "#EE304E", # red
      info = "#A0A0A0" # gray
    ),
    # theme color -------------------------------------------------
    fresh::bs4dash_color(
      gray_900 = "#1f245b",
      gray_800 = "#646464",
      lightblue = "#6696c3",
      blue = "#00509C"
    )
  )
}


# base_react_theme --------------------------------------------------------
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


# compare_react_theme -----------------------------------------------------
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
