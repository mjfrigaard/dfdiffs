#' Select data columns
#'
#' @param id
#'
#' @return select data module
#' @export selectDataUI
#'
selectDataUI <- function(id) {
  tagList(
    fluidRow(
      sortable(
        width = 12,
        box(
          status = "success",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Excel File Data (previous)"),
          ## OUTPUT [prev_excel_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "prev_excel_data_name")),
          ## OUTPUT [prev_excel_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "prev_excel_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          status = "primary",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Flat File Data (previous)"),
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
          status = "success",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Excel File Data (current)"),
          ## OUTPUT [curr_excel_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
              id = "curr_excel_data_name")),
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
          status = "primary",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Flat File Data (current)"),
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
