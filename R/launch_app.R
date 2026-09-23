#' Application UI
#'
#' @importFrom bslib page_navbar nav_panel nav_spacer nav_item navbar_options input_dark_mode
#'
#' @return A Shiny UI definition
#' @export app_ui
#'
#' @description UI for the production `dfdiffs` comparison app
app_ui <- function() {
  compare_theme <- dfdiffs_fresh_theme()
  bslib::page_navbar(
    title = "dfdiffs",
    theme = compare_theme,
    navbar_options = bslib::navbar_options(bg = "#011627", theme = "dark"),
    # 1) upload data -----
    bslib::nav_panel(
      title = "1) Upload Data",
      icon = icon("file-upload"),
      mod_upload_ui(id = "upload_data")
    ),
    # 2) select data -----
    bslib::nav_panel(
      title = "2) Select Data",
      icon = icon("columns"),
      mod_select_ui(id = "select_data")
    ),
    # 3) compare data -----
    bslib::nav_panel(
      title = "3) Compare Data",
      icon = icon("compress-alt"),
      mod_compare_ui("compare_data")
    ),
    bslib::nav_spacer(),
    # getting started -----
    bslib::nav_panel(
      title = "Getting Started",
      icon = icon("compass"),
      shiny::includeMarkdown(
        system.file("compareDataApp/assets/intro.md", package = "dfdiffs")
      )
    ),
    # about -----
    bslib::nav_panel(
      title = "About",
      icon = icon("book-open"),
      shiny::includeMarkdown(
        system.file("compareDataApp/assets/about.md", package = "dfdiffs")
      )
    ),
    bslib::nav_item(bslib::input_dark_mode(id = "dark_mode"))
  )
}

#' Application server
#'
#' @param input,output,session Shiny server arguments
#'
#' @export app_server
#'
#' @description Server for the production `dfdiffs` comparison app
app_server <- function(input, output, session) {
  # mod_upload_server ------------------------------------------------
  upload_data_list <- mod_upload_server(id = "upload_data")
  # mod_select_server ------------------------------------------------
  select_data_list <- mod_select_server(
    id = "select_data",
    data_upload = upload_data_list
  )
  # mod_compare_server ------------------
  mod_compare_server(
    id = "compare_data",
    data_selected = select_data_list
  )
}

#' Launch the dfdiffs app
#'
#' @param options A list of Shiny options (e.g., \code{list(test.mode = TRUE)})
#'
#' @return A \code{shiny.appobj}
#' @export launch_app
#'
#' @description Standalone launcher for the production `dfdiffs` comparison
#'   app (upload, select, and compare two datasets)
#'
#' @examples
#' \dontrun{
#' launch_app()
#' }
launch_app <- function(options = list()) {
  # NOTE: base::options() is namespaced here because `options` is also this
  # function's argument name (the Shiny options list passed to shinyApp()).
  base::options(shiny.maxRequestSize = 2000 * 1024^2)
  shinyApp(
    ui = app_ui(),
    server = app_server,
    options = options
  )
}
