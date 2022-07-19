# bmrn_fresh_theme --------------------------------------------------------
select_data_theme <- bmrn_fresh_theme()


#' selectDataDemo
#'
#' @export selectDataDemo
#' @description select module demo
#'
#' @examples
#' selectDataDemo()
selectDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    title = "selectDataDemo",
    dark = FALSE,
    freshTheme = select_data_theme,
    header = bs4Dash::dashboardHeader(title = "selectDataDemo"),
    # sidebar (menuItem) ------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      bs4Dash::sidebarMenu(
        id = "sidebarmenu",
        bs4Dash::sidebarHeader("Data upload demo"),
        menuItem("1) Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file")
        ),
        menuItem("2) Select Data",
          tabName = "select_data_tab",
          icon = icon("table")
        )
      )
    ),
    # dashboardBody (tabItem) ------
    body = bs4Dash::dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## dev_uploadDataUI -----
          dev_uploadDataUI(id = "upload_data")
        ),
        tabItem(
          tabName = "select_data_tab",
          ## dev_selectDataUI -----
          dev_selectDataUI(id = "select_data"),
          ## reactive values -----
          fluidRow(
            sortable(
              width = 12,
              box(
                width = 12,
                status = "info",
                solidHeader = TRUE,
                closable = TRUE,
                maximizable = TRUE,
                collapsible = TRUE,
                collapsed = TRUE,
                title = "Reactive values",
                ## values -----
                verbatimTextOutput(
                  outputId = "upload_values"
                )
              )
            )
          )
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # upload data ------------------------------------------------
    upload_data_list <- dev_uploadDataServer(id = "upload_data")
    # display data ------------------------------------------------
    select_data_list <- dev_selectDataServer(id = "select_data",
                                         data_upload = upload_data_list)
    # reactive values ------------------------------------------------
    output$upload_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- str_detect(names(all_values), "upload_data")
      module_values <- all_values[module_names]
      reactable_names <- str_detect(
        names(module_values),
        "__reactable__",
        negate = TRUE
      )
      values <- module_values[reactable_names]
      print(values)
    })
  }
  shinyApp(
    ui = ui, server = server
  )
}
