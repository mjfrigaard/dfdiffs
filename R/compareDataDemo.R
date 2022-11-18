## set theme ---------------------------------------------------------------
compare_theme <- dfdiffs_fresh_theme()

#' compareDataDemo
#'
#' @export compareDataDemo
#' @description demo app for comparisons
#'
#' @examples
#' compareDataDemo()
compareDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    skin = "light",
    freshTheme = compare_theme,
    title = "(dev) compareDataDemo",
    header = bs4Dash::dashboardHeader(
      title = "(dev) compareDataDemo",
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
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # dev_uploadDataServer ------------------------------------------------
    upload_data_list <- dev_uploadDataServer(id = "upload_data")
    # dev_selectDataServer ------------------------------------------------
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
