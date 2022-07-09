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
    h3("Upload a ", strong("base"), " (target) data source "),
    fluidRow(
      sortable(
        width = 12,
        # |- upload base xlsx file ----
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          closable = FALSE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          title = tags$strong("Upload Excel File (base)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [xlsx_file_base] -------
                inputId = NS(
                  namespace = id,
                  id = "xlsx_file_base"
                ),
                label = "Excel file input",
                accept = c(".xlsx")
              )
            ),
            column(
              width = 6,
              ### |-- INPUT [xlsx_sheets_base] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_sheets_base"
                ),
                label = "Select sheet:",
                choices = ""
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [xlsx_filename_base] ---------
              tags$strong("Excel data file:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_filename_base"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [xlsx_new_name_base] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_new_name_base"
                ),
                label = strong(
                  "Provide a name for the", code("base"), " excel fil:"
                )
              ),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [xlsx_upload_base] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_upload_base"
                )
              )
            )
          )
        )
      )
    ),
    # |- upload base flat file ----
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsed = FALSE,
          collapsible = TRUE,
          closable = FALSE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          title = tags$strong("Upload Flat Data File (base)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [flat_file_base] -------
                inputId = NS(
                  namespace = id,
                  id = "flat_file_base"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"), code(".txt"), code(".tsv")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv")
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [flat_filename_base] ---------
              tags$strong("Flat file data:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_filename_base"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [flat_file_new_name_base] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "flat_file_new_name_base"
                ),
                label = strong(
                  "Provide a name for the ", code("base"), " flat file:"
                )
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              ## |-- OUTPUT [flat_file_upload_base] -------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_file_upload_base"
                )
              )
            )
          )
        )
      )
    ),
    h3("Upload a ", strong("compare"), " (current) data source"),
    # br(), br(),
    fluidRow(
      sortable(
        width = 12,
        # |- upload compare xlsx file ----
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          solidHeader = TRUE,
          status = "secondary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload Excel File (compare)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [xlsx_file_comp] -------
                inputId = NS(
                  namespace = id,
                  id = "xlsx_file_comp"
                ),
                label = "Excel file upload",
                accept = c(".xlsx")
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [xlsx_sheets_comp] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_sheets_comp"
                ),
                label = "Select sheet:",
                choices = ""
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [xlsx_filename_comp] ---------
              tags$strong("Excel Data File:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_filename_comp"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [xlsx_new_name_comp] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_new_name_comp"
                ),
                label = strong(
                  "Provide a name for the ", code("compare"), " excel file :"
                )
              ),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [xlsx_upload_comp] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_upload_comp"
                )
              )
            )
          )
        )
      )
    ),
    # |- upload compare flat file ----
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsed = FALSE,
          solidHeader = TRUE,
          status = "secondary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload Flat Data File (compare)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [flat_file_comp] -------
                inputId = NS(
                  namespace = id,
                  id = "flat_file_comp"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"), code(".txt"), code(".tsv")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv")
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [flat_filename_comp] ---------
              tags$strong("Flat file data:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_filename_comp"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [flat_file_new_name_comp] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "flat_file_new_name_comp"
                ),
                label = strong(
                  "Provide a name for the ", code("compare"), " flat file:"
                )
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              ## |-- OUTPUT [flat_file_upload_comp] -------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_file_upload_comp"
                )
              )
            )
          )
        )
      )
    )
  )
}
