## set theme ---------------------------------------------------------------
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
compare_theme <- dfdiffs_fresh_theme()

#' compareDataApp
#'
#' @export compareDataApp
#' @description app for comparisons
#'
#' @examples
#' compareDataApp()
compareDataApp <- function() {
  ui <- bs4Dash::dashboardPage(
    skin = "light",
    freshTheme = compare_theme,
    title = "compareDataApp",
    header = bs4Dash::dashboardHeader(
      title = "compareDataApp",
      status = "secondary"
    ),
    # sidebar (menuItem) -------------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      minified = TRUE,
      expandOnHover = TRUE,
      bs4Dash::sidebarMenu(
        id = "sidebarmenu",
        menuItem("Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file-upload")
        ),
        menuItem("Select Data",
          tabName = "select_data_tab",
          icon = icon("columns")
        ),
        menuItem("Compare Data",
          tabName = "compare_data_tab",
          icon = icon("compress-alt")
        )
      )
    ),
    # dashboardBody (tabItem) ----------
    body = bs4Dash::dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## uploadDataUI -----
          uploadDataUI(id = "upload_data"),
        ),
        tabItem(
          tabName = "select_data_tab",
          ## selectDataUI -----
          selectDataUI(id = "select_data")
        ),
        tabItem(
          tabName = "compare_data_tab",
          ## compareDataUI -----
          compareDataUI("compare_data")
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # uploadDataServer ------------------------------------------------
    upload_data_list <- uploadDataServer(id = "upload_data")
    # selectDataServer ------------------------------------------------
    select_data_list <- selectDataServer(
      id = "select_data",
      data_upload = upload_data_list
    )
    # compareDataServer ------------------
    compareDataServer(
      id = "compare_data",
      data_selected = select_data_list
    )
  }

  shinyApp(
    ui = ui, server = server
  )
}
