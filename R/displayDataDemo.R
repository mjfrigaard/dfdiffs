# packages ----
library(shiny)
library(bs4Dash)
library(tidyverse)
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
