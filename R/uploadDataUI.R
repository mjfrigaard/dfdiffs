#' data upload (UI)
#'
#' @param id module id
#'
#' @export uploadDataUI
#'
#' @examples # build ui for data upload
#' uploadDataUI("input_id")
uploadDataUI <- function(id) {
  tagList(
    # first row
    h3("Previous File:"),
    h4(em("Import a previous data source: ")),
    fluidRow(
      sortable(
        width = 12,
        # upload previous xlsx file ----
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          solidHeader = TRUE,
          status = "success",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload Excel File (previous)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## INPUT [xlsx_file_prev] -------
                inputId = NS(
                  namespace = id,
                  id = "xlsx_file_prev"
                ),
                label = "Excel file input",
                accept = c(".xlsx")
              )
            ),
            column(
              width = 6,
              ## INPUT [xlsx_sheets_prev] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_sheets_prev"
                ),
                label = "Select sheet:",
                choices = ""
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## OUTPUT [xlsx_filename_prev] ---------
              tags$strong("Excel Data File:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_filename_prev"
                )
              )
            ),
            column(
              width = 6,
              ## INPUT [new_xlsx_name_prev] ---------
              textInput(
                inputId = NS(namespace = id,
                  id = "new_xlsx_name_prev"),
                  label = "Previous Excel File Name:"
              ),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## OUTPUT [xlsx_upload_prev] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_upload_prev"
                )
              )
            )
          )
        )
      )
    ),
    # upload previous xlsx file ----
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Import Data File (previous)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## INPUT [flat_file_prev] -------
                inputId = NS(
                  namespace = id,
                  id = "flat_file_prev"
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
              ## OUTPUT [flat_filename_prev] ---------
              tags$strong("Flat file data:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_filename_prev"))
              ),
           column(
              width = 6,
              ## INPUT [new_flat_file_name_prev] ---------
              textInput(
                inputId = NS(namespace = id,
                  id = "new_flat_file_name_prev"),
                  label = "Previous Excel File Name:"
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              ## OUTPUT [flat_file_data_prev] -------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_file_data_prev"
                  )
                )
              )
            )
          )
        )
    ),
    h3("Current Files:"),
    h4(em("Import a current data source: ")),
    fluidRow(
      sortable(
        width = 12,
        # upload current xlsx file ----
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          solidHeader = TRUE,
          status = "success",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload Excel File (current)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## INPUT [xlsx_file_curr] -------
                inputId = NS(
                  namespace = id,
                  id = "xlsx_file_curr"
                ),
                label = "Excel file input",
                accept = c(".xlsx")
              )
            ),
            column(
              width = 6,
              ## INPUT [xlsx_sheets_curr] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_sheets_curr"
                ),
                label = "Select sheet:",
                choices = ""
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## OUTPUT [xlsx_filename_curr] ---------
              tags$strong("Excel Data File:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_filename_curr"
                )
              )
            ),
            column(
              width = 6,
              ## INPUT [xlsx_new_name_curr] ---------
              textInput(
                inputId = NS(namespace = id,
                  id = "xlsx_new_name_curr"),
                label = "Current Excel File Name:"
              ),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## OUTPUT [xlsx_upload_curr] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_upload_curr"
                )
              )
            )
          )
        )
      )
    ),
    # upload current flat file ----
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Import Data File (current)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## INPUT [flat_file_curr] -------
                inputId = NS(
                  namespace = id,
                  id = "flat_file_curr"
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
              ## OUTPUT [flat_filename_curr] ---------
              tags$strong("Flat file data:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_filename_curr"))
              ),
           column(
              width = 6,
              ## INPUT [new_flat_file_name_curr] ---------
              textInput(
                inputId = NS(namespace = id,
                  id = "new_flat_file_name_curr"),
                  label = "Current Excel File Name:"
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              ## OUTPUT [flat_file_data_curr] -------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_file_data_curr"
                  )
                )
              )
            )
          )
      )
    )
  )
}
