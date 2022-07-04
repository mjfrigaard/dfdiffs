source("helpers.R")
#' Select data columns
#'
#' @param id
#'
#' @return select data module
#' @export selectDataUI
#'
selectDataUI <- function(id) {
  tagList(
    h3("Select Previous Data"),
    h4(em("Pick a previous data source:")),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          status = "success",
          width = 12,
          title = tags$strong("Previous Data Files"),
          ## |-- INPUT [prev_data_select] ---------
          selectInput(
            inputId = NS(namespace = id,
              id = "prev_data_select"),
            label = "Select previous data",
            choices = c("xlsx_prev_data", "flat_file_prev_data"),
            selected = NULL),
          ## |-- OUTPUT [prev_data_display] ---------
          strong("Previous Data"),
          br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "prev_data_display"
            )
          ),
          ## |-- INPUT [prev_col_select] ---------
          br(),
          selectizeInput(
            inputId = NS(namespace = id,
              id = "prev_col_select"),
            label = "Select previous columns",
            choices = names(xlsx_prev_data),
            multiple = TRUE,
            selected = names(xlsx_prev_data))
        )
      )),
      h3("Select Current Data"),
      h4(em("Pick a current data source:")),
      br(),
      fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          closable = FALSE,
          status = "success",
          width = 12,
          title = tags$strong("Current Data Files"),
          ## |-- INPUT [curr_data_select] ---------
          selectInput(inputId = NS(namespace = id,
            id = "curr_data_select"),
            label = "Select current data",
            choices = c("xlsx_curr_data", "flat_file_curr_data"),
            selected = NULL),
          ## |-- OUTPUT [curr_data_display] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "curr_data_display"
            )
          ),
          ## |-- INPUT [curr_col_select] ---------
          br(),
          selectizeInput(
            inputId = NS(namespace = id,
              id = "curr_col_select"),
            label = "Select current columns",
            choices = names(xlsx_curr_data),
            multiple = TRUE,
            selected = names(xlsx_curr_data))
        )
      )
    )
  )
}
