# packages ----
library(shiny)
library(bs4Dash)
library(tidyverse)
library(reactable)


# load modules ------------------------------------------------------------
source("helpers.R")
source("uploadDataUI.R")
source("uploadDataServer.R")

upload_theme <- bmrn_fresh_theme()

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
    freshTheme = upload_theme,
    dark = FALSE,
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
    body = dashboardBody(
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

  shinyApp(
    ui = ui, server = server,
    options = list(width = 800, height = 1000)
  )
}
uploadDataDemo()
