#' Select data columns
#'
#' @param id
#'
#' @return select data module
#' @export selectDataUI
#'
selectDataUI <- function(id) {
  tagList(
    h3("Pick a ", strong("base"), "data source"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          status = "primary",
          width = 12,
          title = tags$strong("Base Data Files"),
          ## |-- INPUT [base_data_select] ---------
          ## displays dummy data when initially loaded, then imports list
          ## of imported objects from baseUploadDataServer()
          br(),
          selectInput(
            inputId = NS(
              namespace = id,
              id = "base_data_select"
            ),
            label = strong("Select ", code("base"), " data"),
            choices = c("", NULL),
            selected = NULL
          ),
          ## |-- INPUT [base_col_select] ---------
          ## displays the columns from the imported dataset
          br(),
          selectizeInput(
            inputId = NS(
              namespace = id,
              id = "base_col_select"
            ),
            label = strong("Select ", code("base"), " columns"),
            choices = c("", NULL),
            multiple = TRUE,
            selected = NULL
          ),
          ## |-- OUTPUT [base_data_display] ---------
          ## displays uploaded/named/selected data
          strong("Base Data"),
          br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "base_data_display"
            )
          )
        )
      )
    ),
    ## reactive values -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          background = "gray",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          ## values -----
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_reactive_values"
            )
          )
        )
      )
    ),
    h3("Pick a ", strong("compare"), "data source"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          closable = FALSE,
          status = "secondary",
          width = 12,
          title = tags$strong("Compare Data Files"),
          ## |-- INPUT [comp_data_select] ---------
          ## displays dummy data when initially loaded, then imports list
          ## of imported objects from uploadDataServer()
          br(),
          selectInput(
            inputId = NS(
              namespace = id,
              id = "comp_data_select"
            ),
            label = strong("Select ", code("comare"), " data"),
            choices = c("", NULL),
            selected = c("", NULL)
          ),
          ## |-- INPUT [comp_col_select] ---------
          ## displays the columns from the imported dataset
          br(),
          selectizeInput(
            inputId = NS(
              namespace = id,
              id = "comp_col_select"
            ),
            label = strong("Select ", code("compare"), " columns"),
            choices = c("", NULL),
            multiple = TRUE,
            selected = c("", NULL)
          ),
          ## |-- OUTPUT [comp_data_display] ---------
          ## displays uploaded/named/selected data
          br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "comp_data_display"
            )
          )
        )
      )
    ),
    ## reactive values -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          background = "gray",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          title = "Reactive values (compasre)",
          ## values -----
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "compare_reactive_values"
            )
          )
        )
      )
    )
  )
}
