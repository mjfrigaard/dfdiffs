# set theme ---------------------------------------------------------------
upload_theme <- dfdiffs_fresh_theme()

#' uploadDataDemo
#'
#' @importFrom bs4Dash dashboardPage
#' @importFrom bs4Dash insertTab
#' @importFrom bs4Dash actionButton
#' @importFrom bs4Dash tabsetPanel
#' @importFrom bs4Dash column
#' @importFrom bs4Dash menuItem
#' @importFrom bs4Dash renderMenu
#' @importFrom bs4Dash sidebarUserPanel
#' @importFrom bs4Dash valueBox
#' @importFrom bs4Dash dropdownMenu
#' @importFrom bs4Dash dropdownMenuOutput
#' @importFrom bs4Dash renderInfoBox
#' @importFrom bs4Dash messageItem
#' @importFrom bs4Dash sidebarMenu
#' @importFrom bs4Dash dashboardBody
#' @importFrom bs4Dash tabItems
#' @importFrom bs4Dash notificationItem
#' @importFrom bs4Dash dashboardHeader
#' @importFrom bs4Dash renderValueBox
#' @importFrom bs4Dash menuSubItem
#' @importFrom bs4Dash dashboardSidebar
#' @importFrom bs4Dash updateTabItems
#' @importFrom bs4Dash tabItem
#' @importFrom bs4Dash box
#' @importFrom bs4Dash infoBox
#' @importFrom bs4Dash taskItem
#' @importFrom bs4Dash sidebarMenuOutput
#' @importFrom bs4Dash tabBox
#' @importFrom bs4Dash infoBoxOutput
#' @importFrom bs4Dash valueBoxOutput
#' @importFrom bs4Dash menuItemOutput
#' @importFrom bs4Dash dashboardPage
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
