#' uploadDataUI()
#'
#' @param id module id
#'
#' @export uploadDataUI
#'
#' @description UI module for upload
uploadDataUI <- function(id) {
  tagList(
    h3("Upload a ", strong("base"), " (i.e., target) data source "),
    fluidRow(
      sortable(
        width = 12,
        # |- upload base file ----
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
            column(
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
                  code(".txt"), code(".tsv"), code(".xlsx")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            column(
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
            column(
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
            column(
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
            column(
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
    h3("Upload a ", strong("compare"), " (i.e., current) data source"),
    # br(), br(),
    fluidRow(
      sortable(
        width = 12,
        # |- upload compare file ----
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
            column(
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
                  code(".txt"), code(".tsv"), code(".xlsx")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            column(
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
            column(
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
            column(
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
            column(
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
    )
  )
}
