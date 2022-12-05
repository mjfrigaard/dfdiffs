source("app_utils.R")
source("app_ui.R")
source("app_server.R")
## set theme ---------------------------------------------------------------
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
        menuItem("1) Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file-upload")
        ),
        menuItem("2) Select Data",
          tabName = "select_data_tab",
          icon = icon("columns")
        ),
        menuItem("3) Compare Data",
          tabName = "compare_data_tab",
          icon = icon("compress-alt")
        ),
        menuItem("About",
          tabName = "about_tab",
          icon = icon("book-open")
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
        ),
        tabItem(
          tabName = "about_tab",
          ## about.md -----
          shiny::includeMarkdown("assets/about.md")
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(
      width = 320,
      pinned = TRUE,
      collapsed = FALSE,
      skin = "light",
      column(
        width = 12,
        br(),
        shiny::includeMarkdown(path = "assets/intro.md")
        )
      ),
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
# run app -----------------------------------------------------------------
compareDataApp()
