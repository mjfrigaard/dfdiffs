# packages ----------------------------------------------------------------
library(knitr)
library(arsenal)
library(diffdf)
library(stringr)
library(janitor)
library(dplyr)
library(tidyr)
library(tibble)
library(lubridate)
library(purrr)
library(rmdformats)
library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(markdown)
library(shiny)
library(shinythemes)
library(bs4Dash)
library(fresh)
library(RColorBrewer)

source("app_utils.R")
source("app_ui.R")
source("app_server.R")

## set theme -------
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
      pinned = TRUE,
      collapsed = FALSE,
      skin = "light",
      column(
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

# run compareDataDemo --------------

compareDataDemo()
