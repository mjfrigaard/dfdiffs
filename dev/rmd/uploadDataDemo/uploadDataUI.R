#' data upload (UI) for selectDataDemo
#'
#' @param id module id
#'
#' @export uploadDataUI
#'
#' @description `uploadDataUI()`/`uploadDataServer()` create the upload module
#' for the dfdiffs app.
uploadDataUI <- function(id) {
  tagList(
    h3("Upload a ", strong("base"), " (i.e., target) data source "),
    fluidRow(
      sortable(
        width = 12,
        # |- upload base xlsx file ----
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          title = tags$strong("Upload File (base)"),
          fluidRow(
            bs4Dash::column(
              width = 6,
              fileInput(
                ## |-- INPUT [base_file] -------
                inputId = NS(
                  namespace = id,
                  id = "base_file"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"),
                  code(".txt"), code(".tsv"), code(".xlsx")),
                  accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            bs4Dash::column(
              width = 6,
              ### |-- INPUT [base_xlsx_sheets] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "base_xlsx_sheets"
                ),
                label = strong("Select sheet (if ", code(".xlsx"), " file):"),
                choices = c("", NULL)
              )
            )
          ),
          fluidRow(
            bs4Dash::column(
              width = 6,
              ## |-- OUTPUT [base_filename] ---------
              tags$strong("Data file name:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_filename"
                )
              )
            ),
            bs4Dash::column(
              width = 6,
              ## |-- INPUT [base_new_name] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "base_new_name"
                ),
                label = strong(
                  "Provide a name to preview the", code("base"), " file:"
                )
              ),
              em("Not sure what name to use? Copy + paste the file name."),
            )
          ),
          fluidRow(
            bs4Dash::column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [base_display_upload] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_display_upload"
                )
              )
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          strong(em("For DEV purposes only")),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_a -----
              code("base_dev_a"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_a"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_b -----
              code("base_dev_b"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_b"
            )
          ))
          ),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_x -----
              code("base_dev_x"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_x"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_y -----
              code("base_dev_y"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_y"
            )
          ))
          )
        )
      )
    ),
    h3("Upload a ", strong("compare"), " (i.e., current) data source"),
    # br(), br(),
    fluidRow(
      sortable(
        width = 12,
        # |- upload compare xlsx file ----
        box(
          maximizable = TRUE,
          collapsed = FALSE,
          solidHeader = TRUE,
          status = "secondary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload File (compare)"),
          fluidRow(
            bs4Dash::column(
              width = 6,
              fileInput(
                ## |-- INPUT [comp_file] -------
                inputId = NS(
                  namespace = id,
                  id = "comp_file"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"),
                  code(".txt"), code(".tsv"), code(".xlsx")),
                  accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            bs4Dash::column(
              width = 6,
              ## |-- INPUT [comp_xlsx_sheets] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "comp_xlsx_sheets"
                ),
                label = strong("Select sheet (if ", code(".xlsx"), " file):"),
                choices = c("", NULL)
              )
            )
          ),
          fluidRow(
            bs4Dash::column(
              width = 6,
              ## |-- OUTPUT [comp_filename] ---------
              tags$strong("Data file name:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_filename"
                )
              )
            ),
            bs4Dash::column(
              width = 6,
              ## |-- INPUT [comp_new_name] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "comp_new_name"
                ),
                label = strong(
                  "Provide a name to preview the ", code("compare"), " file:"
                )
              ),
              em("Not sure what name to use? Copy + paste the file name."),
            )
          ),
          fluidRow(
            bs4Dash::column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [comp_display_upload] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_display_upload"
                )
              )
            )
          )
        )
      )
    ),
    ## DEV -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (compare)",
          strong(em("For DEV purposes only")),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_a -----
              code("comp_dev_a"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_a"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_b -----
              code("comp_dev_b"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_b"
            )
          ))
          ),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_x -----
              code("comp_dev_x"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_x"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_y -----
              code("comp_dev_y"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_y"
            )
          ))
          )
        )
      )
    )
  )
}
