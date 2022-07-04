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


# load modules ------------------------------------------------------------
# source("R/uploadDataUI.R")
# source("R/uploadDataServer.R")


#' uploadDataDemo
#'
#' @export uploadDataDemo
#'
#' @importFrom bs4Dash dashboardPage
#' @importFrom bs4Dash dashboardHeader
#' @importFrom bs4Dash dashboardControlbar
#' @importFrom bs4Dash dashboardFooter
#' @importFrom bs4Dash dashboardBody
#' @importFrom bs4Dash dashboardSidebar
#'
#' @examples # run app
#' uploadDataDemo()
uploadDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    dark = TRUE,
    title = "uploadDataDemo",
    header = dashboardHeader(title = "uploadDataDemo"),
    # sidebar (menuItem) ------------------------------------------------------
    sidebar = dashboardSidebar(
                sidebarMenu(
                  id = "sidebarmenu",
                  sidebarHeader("Data upload demo"),
                  menuItem("Upload Data",
                    tabName = "upload_data_tab",
                    icon = icon("file")
                  )
                )
              ),
    # dashboardBody (tabItem) ------------------------------------------------------
    body =  dashboardBody(
              tabItems(
                tabItem(
                  tabName = "upload_data_tab",
                  ## uploadDataUI -----
                  uploadDataUI(id = "upload_data")
                )
              )
            ),
    controlbar = dashboardControlbar(),
    footer = dashboardFooter()
  )

  server <- function(input, output, session) {
    uploadDataServer(id = "upload_data")
  }

  shinyApp(ui = ui, server = server,
    options = list(width = 900, height = 1000))
}
