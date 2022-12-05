# packages ----
library(shiny)
library(bs4Dash)

library(reactable)
# reactable.theme ----
options(reactable.theme = reactableTheme(
  color = "hsl(233, 9%, 87%)",
  backgroundColor = "hsl(233, 9%, 19%)",
  borderColor = "hsl(233, 9%, 22%)",
  stripedColor = "hsl(233, 12%, 22%)",
  highlightColor = "hsl(233, 12%, 24%)",
  inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
))
#' Display data demo
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
#' @return displayDataDemo app
#' @export displayDataDemo
#'
displayDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    dark = TRUE,
    title = "displayDataDemo",
    header = bs4Dash::dashboardHeader(title = "displayDataDemo"),
    # sidebar (menuItem) ------------------------------------------------------
    sidebar = bs4Dash::dashboardSidebar(
                bs4Dash::sidebarMenu(
                  id = "sidebarmenu",
                  bs4Dash::sidebarHeader("Data upload demo"),
                  menuItem("Upload Data",
                    tabName = "upload_data_tab",
                    icon = icon("file")
                  ),
                  menuItem("Display Data",
                    tabName = "display_data_tab",
                    icon = icon("table")
                  )
                )
              ),
    # dashboardBody (tabItem) ------------------------------------------------------
    body =  bs4Dash::dashboardBody(
              tabItems(
                tabItem(
                  tabName = "upload_data_tab",
                  ## uploadDataUI -----
                  uploadDataUI(id = "upload_data"),
                    fluidRow(
                      sortable(width = 12,
                        box(title = "Reactive values",
                          width = 12,
                          background = "gray",
                          solidHeader = TRUE,
                          closable = FALSE,
                          maximizable = TRUE,
                          collapsible = TRUE,
                          collapsed = TRUE,
                          ## values -----
                          verbatimTextOutput(outputId = "upload_values")
                          )
                        )
                      )
                  ),
                tabItem(
                  tabName = "display_data_tab",
                  ## displayDataUI -----
                  displayDataUI(id = "display_data")
                )
              )
            ),

    controlbar = bs4Dash::dashboardControlbar(),

    footer = bs4Dash::dashboardFooter()
  )

  server <- function(input, output, session) {

    upload_data_list <- uploadDataServer(id = "upload_data")

    displayDataServer(id = "display_data", data_upload = upload_data_list)

    output$upload_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- str_detect(names(all_values), "upload_data")
      module_values <- all_values[module_names]
      reactable_names <- str_detect(names(module_values), "__reactable__", negate = TRUE)
      values <- module_values[reactable_names]
      print(values)
    })

  }

  shinyApp(ui = ui, server = server,
    options = list(height = 800, width = 900))
}
