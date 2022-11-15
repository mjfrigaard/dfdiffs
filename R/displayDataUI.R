#' Display uploaded data (UI)
#'
#' @param id
#'
#' @return display data UI
#' @export displayDataUI
#'
displayDataUI <- function(id) {
  tagList(
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "success",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Excel File Data (previous)"),
          ## OUTPUT [prev_xlsx_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "prev_xlsx_data_name"),
            placeholder = TRUE),
          ## OUTPUT [prev_xlsx_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "prev_xlsx_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "primary",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Flat File Data (previous)"),
          ## OUTPUT [prev_flat_file_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "prev_flat_file_data_name"),
            placeholder = TRUE),
          ## OUTPUT [prev_flat_file_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "prev_flat_file_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "success",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Excel File Data (current)"),
          ## OUTPUT [curr_excel_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
              id = "curr_excel_data_name"),
            placeholder = TRUE),
          ## OUTPUT [curr_excel_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "curr_excel_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "primary",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Flat File Data (current)"),
          ## OUTPUT [curr_flat_file_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "curr_flat_file_data_name"),
            placeholder = TRUE),
          ## OUTPUT [curr_flat_file_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "curr_flat_file_data"
            )
          )
        )
      ),
    )
  )
}
