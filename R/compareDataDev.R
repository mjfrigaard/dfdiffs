## set theme ---------------------------------------------------------------
compare_theme <- dfdiffs_fresh_theme()

#' compareDataDev
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
#' @import fresh
#'
#' @export compareDataDev
#' @description demo app for comparisons
#'
#' @examples
#' compareDataDev()
compareDataDev <- function() {
  ui <- bs4Dash::dashboardPage(
    skin = "light",
    freshTheme = compare_theme,
    title = "(dev) compareDataApp",
    header = bs4Dash::dashboardHeader(
      title = "(dev) compareDataApp",
      status = "secondary"
    ),
    # sidebar (menuItem) -------------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      minified = TRUE,
      expandOnHover = TRUE,
      bs4Dash::sidebarMenu(
        id = "sidebarmenu",
        # bs4Dash::sidebarHeader("Data upload demo"),
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
          ## dev_uploadDataUI -----
          dev_uploadDataUI(id = "upload_data"),
        ),
        tabItem(
          tabName = "select_data_tab",
          ## dev_selectDataUI -----
          dev_selectDataUI(id = "select_data")
        ),
        tabItem(
          tabName = "compare_data_tab",
          ## dev_compareDataUI -----
          dev_compareDataUI("compare_data")
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
      pinned = FALSE,
      collapsed = TRUE,
      skin = "light",
      bs4Dash::column(
        width = 12,
        br(),
        shiny::includeMarkdown(path = "assets/intro.md")
      )
    ),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # dev_uploadDataServer --------------------
    upload_data_list <- dev_uploadDataServer(id = "upload_data")
    # dev_selectDataServer --------------------
    select_data_list <- dev_selectDataServer(
      id = "select_data",
      data_upload = upload_data_list
    )
    # dev_compareDataServer ------------------
    dev_compareDataServer(
      id = "compare_data",
      data_selected = select_data_list
    )
  }

  shinyApp(
    ui = ui, server = server
  )
}
