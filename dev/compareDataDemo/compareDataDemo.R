source("helpers.R")
source("uploadDataUI.R")
source("uploadDataServer.R")
source("selectDataUI.R")
source("selectDataServer.R")
source("compareDataUI.R")
source("compareDataServer.R")


# reactable.theme ---------------------------------------------------------
options(reactable.theme = reactableTheme(
          color = "hsl(235, 9%, 87%)",
          backgroundColor = "hsl(208,100%, 17%)",
          borderColor = "hsl(235, 9%, 22%)",
          stripedColor = "hsl(235, 12%, 22%)",
          highlightColor = "hsl(235, 12%, 24%)",
          inputStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          selectStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonHoverStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonActiveStyle = list(backgroundColor = "hsl(235, 9%, 28%)")))

# set theme ---------------------------------------------------------------
compare_theme <- bmrn_theme()


# compareDataDemo ---------------------------------------------------------
#' compareDataDemo()
#'
#' @return UI module
#' @export compareDataDemo
#'
compareDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    skin = 'light',
    freshTheme = compare_theme,
    title = "compareDataDemo",
    header = bs4Dash::dashboardHeader(
      title = "compareDataDemo",
      status = "secondary"),
    # sidebar (menuItem) ------------------------------------------------------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      collapsed = TRUE,
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
        ),
        menuItem("Tables",
          tabName = "table_output_tab",
          icon = icon("table")
        )
      )
    ),
    # dashboardBody (tabItem) ------------------------------------------------
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
          tabName = "table_output_tab",
          ## tableOutputUI -----
          # tableOutputUI("tables")
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # upload data ------------------------------------------------
    upload_data_list <- uploadDataServer(id = "upload_data")
    # select data ------------------------------------------------
    select_data_list <- selectDataServer(
      id = "select_data",
      data_upload = upload_data_list
    )
    # compare data ------------------------------------------------
    compareDataServer(
      id = "compare_data",
      data_selected = select_data_list)
  }
  # tableOutputServer ------------------------------------------------
  shinyApp(
    ui = ui, server = server
  )
}

compareDataDemo()
