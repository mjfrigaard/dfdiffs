#' Display uploaded data (Server)
#'
#' @param id module id
#' @param data_upload list or uploaded xlsx and flat files
#'
#' @return list of previous xlsx/flat files and current xlsx/flat files
#' @export displayDataServer
#'
displayDataServer <- function(id, data_upload) {

  moduleServer(id = id, module = function(input, output, session) {

    ### prev_xlsx (reactive) ---------
    prev_xlsx <- reactive({
      prev_xlsx_data <- data_upload$prev_xlsx_data()
      return(prev_xlsx_data)
    })
    ### prev_xlsx_name (reactive) ---------
    prev_xlsx_name <- reactive({
      prev_xlsx_data_name <- data_upload$prev_xlsx_data_name()
      return(prev_xlsx_data_name)
    })

    ### prev_flat_file (reactive) ---------
    prev_flat_file <- reactive({
      prev_flat_file_data <- data_upload$prev_flat_file_data()
      return(prev_flat_file_data)
    })
    ### prev_flat_file_name (reactive) ---------
    prev_flat_file_name <- reactive({
      prev_flat_file_data_name <- data_upload$prev_flat_file_data_name()
      return(prev_flat_file_data_name)
    })

    ### curr_xlsx (reactive) ---------
    curr_xlsx <- reactive({
      curr_xlsx_data <- data_upload$curr_xlsx_data()
      return(curr_xlsx_data)
    })
    ### curr_xlsx_name (reactive) ---------
    curr_xlsx_name <- reactive({
      curr_xlsx_data_name <- data_upload$curr_xlsx_data_name()
      return(curr_xlsx_data_name)
    })

    ### curr_flat_file (reactive) ---------
    curr_flat_file <- reactive({
      curr_flat_file_data <- data_upload$curr_flat_file_data()
      return(curr_flat_file_data)
    })
    ### curr_flat_file_name (reactive) ---------
    curr_flat_file_name <- reactive({
      curr_flat_file_data_name <- data_upload$curr_flat_file_data_name()
      return(curr_flat_file_data_name)
    })

    ### prev_xlsx_data_name (display) ---------
    output$prev_xlsx_data_name <- renderPrint({
      print(prev_xlsx_name())
    })
    ### prev_xlsx_data (display) ---------
    output$prev_xlsx_data <- reactable::renderReactable({
      reactable::reactable(data = prev_xlsx(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

    ### prev_flat_file_data_name (display) ---------
    output$prev_flat_file_data_name <- renderPrint({
      print(prev_flat_file_name())
    })
    ### prev_flat_file_data (display) ---------
    output$prev_flat_file_data <- reactable::renderReactable({
      reactable::reactable(data = prev_flat_file(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

    ### curr_excel_data_name (display) ---------
    output$curr_excel_data_name <- renderPrint({
      print(curr_xlsx_name())
    })
    ### curr_excel_data (display) ---------
    output$curr_excel_data <- reactable::renderReactable({
      reactable::reactable(data = curr_xlsx(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

    ### curr_flat_file_data_name (display) ---------
    output$curr_flat_file_data_name <- renderPrint({
      print(curr_flat_file_name())
    })
    ### curr_flat_file_data (display) ---------
    output$curr_flat_file_data <- reactable::renderReactable({
      reactable::reactable(data = curr_flat_file(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

  })
}
