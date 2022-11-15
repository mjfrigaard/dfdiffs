## set theme ---------------------------------------------------------------
compare_theme <- bmrn_fresh_theme()

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
