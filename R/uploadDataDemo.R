# set theme ---------------------------------------------------------------
upload_theme <- dfdiffs_fresh_theme()

#' uploadDataDemo
#'
#' @return app
#' @export uploadDataDemo
#'
#' @description demo of dev upload module
uploadDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    freshTheme = upload_theme,
    dark = FALSE,
    title = "dev uploadDataDemo",
    header = dashboardHeader(title = "dev uploadDataDemo"),
    # sidebar (menuItem) -------------------
    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "sidebarmenu",
        sidebarHeader("Data upload demo"),
        menuItem("1) Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file")
        )
      )
    ),
    # dashboardBody (tabItem) --------------
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## uploadDataUI -----
          dev_uploadDataUI(id = "upload_data")
        )
      )
    ),
    controlbar = dashboardControlbar(),
    footer = dashboardFooter()
  )

  server <- function(input, output, session) {
    dev_uploadDataServer(id = "upload_data")
  }

  shinyApp(
    ui = ui, server = server
  )
}
