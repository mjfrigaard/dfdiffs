#' dev_uploadDataServer()
#'
#' @param id module id
#'
#' @export dev_uploadDataServer
#'
#' @description development Server module for upload
dev_uploadDataServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # |-- INPUT [base] base_xlsx_sheets -----
    observeEvent(eventExpr = input$base_file, handlerExpr = {
      if (tools::file_ext(input$base_file$name) == "xlsx") {
        choices <- readxl::excel_sheets(path = input$base_file$datapath)
      } else {
        choices <- c("", NULL)
      }
      updateSelectInput(
        session = session,
        inputId = "base_xlsx_sheets",
        choices = choices
      )
    })

    # |-- OUTPUT [base] xlsx file name -----
    output$base_filename <- renderPrint({
      req(input$base_file)
      base_filename <- as.character(input$base_file$name)
      paste0(
        tags$code(base_filename)
      )
    })

    base_data <- eventReactive(input$base_file, {
      if (nchar(input$base_xlsx_sheets) == 0) {
        uploaded <- upload_data(path = input$base_file$datapath)
      } else {
        uploaded <- upload_data(
          path = input$base_file$datapath,
          sheet = as.character(input$base_xlsx_sheets)
        )
      }
      return(uploaded)
    })

    # |-- OUTPUT display [base] xlsx ----
    # require name
    observeEvent(eventExpr = input$base_new_name, handlerExpr = {
      req(input$base_file)
      req(input$base_new_name)
      output$base_display_upload <- reactable::renderReactable(
        reactable(
          data = base_data(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = base_react_theme
        )
      )
    })

    ## DEV OUTPUT |-- (base_dev_a) ---------
    output$base_dev_a <- renderPrint({
      print(
        paste0("input$base_filename = ", input$base_file$name)
      )
    })
    ## DEV OUTPUT |-- (base_dev_b) ---------
    output$base_dev_b <- renderPrint({
      print(
        base_data()
      )
    })
    ## DEV OUTPUT |-- (base_dev_x) ---------
    output$base_dev_x <- renderPrint({
      print(
        paste0("input$base_xlsx_sheets = ", as.character(input$base_xlsx_sheets))
      )
    })
    ## DEV OUTPUT |-- (base_dev_y) ---------
    output$base_dev_y <- renderPrint({
      print(
        paste0("input$base_new_name = ", as.character(input$base_new_name))
      )
    })


    # |-- INPUT [comp] comp_xlsx_sheets -----
    observeEvent(eventExpr = input$comp_file, handlerExpr = {
      if (tools::file_ext(input$comp_file$name) == "xlsx") {
        choices <- readxl::excel_sheets(path = input$comp_file$datapath)
      } else {
        choices <- c("", NULL)
      }
      updateSelectInput(
        session = session,
        inputId = "comp_xlsx_sheets",
        choices = choices
      )
    })

    # |-- OUTPUT [comp] xlsx file name -----
    output$comp_filename <- renderPrint({
      req(input$comp_file)
      comp_filename <- as.character(input$comp_file$name)
      paste0(
        tags$code(comp_filename)
      )
    })

    comp_data <- eventReactive(input$comp_file, {
      if (nchar(input$comp_xlsx_sheets) == 0) {
        uploaded <- upload_data(path = input$comp_file$datapath)
      } else {
        uploaded <- upload_data(
          path = input$comp_file$datapath,
          sheet = as.character(input$comp_xlsx_sheets)
        )
      }
      return(uploaded)
    })

    # |-- OUTPUT display [comp] xlsx ----
    # require name
    observeEvent(eventExpr = input$comp_new_name, handlerExpr = {
      req(input$comp_file)
      req(input$comp_new_name)
      output$comp_display_upload <- reactable::renderReactable(
        reactable(
          data = comp_data(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = comp_react_theme
        )
      )
    })

    ## DEV OUTPUT |-- (comp_dev_a) ---------
    output$comp_dev_a <- renderPrint({
      print(
        paste0("input$comp_filename = ", as.character(input$comp_file$name))
      )
    })
    ## DEV OUTPUT |-- comp_dev_y (dev) ---------
    output$comp_dev_b <- renderPrint({
      print(
        comp_data()
      )
    })
    ## DEV OUTPUT |-- comp_dev_a (dev) ---------
    output$comp_dev_x <- renderPrint({
      print(
        paste0("input$comp_xlsx_sheets = ", as.character(input$comp_xlsx_sheets))
      )
    })
    ## DEV OUTPUT |-- comp_dev_b (dev) ---------
    output$comp_dev_y <- renderPrint({
      print(
        paste0("input$comp_new_name = ", as.character(input$comp_new_name))
      )
    })

    # |---- return list -----
    # assign this as 'upload_data_list'
    return(
      list(
        # |------ base_data ----
        base_data = reactive({
          req(input$base_file)
          req(input$base_new_name)
          if (nchar(input$base_xlsx_sheets) == 0) {
            uploaded <- upload_data(path = input$base_file$datapath)
          } else {
            uploaded <- upload_data(
              path = input$base_file$datapath,
              sheet = as.character(input$base_xlsx_sheets)
            )
          }
          return(uploaded)
        }),
        # |------ base_name ----
        base_name = reactive({
          # req(input$base_new_name)
          if (nchar(input$base_new_name) != 0) {
            as.character(input$base_new_name)
          } else {
            as.character(input$base_filename)
          }
        }),
        # |------ comp_data ----
        comp_data = reactive({
          req(input$comp_file)
          req(input$comp_new_name)
          if (nchar(input$comp_xlsx_sheets) == 0) {
            uploaded <- upload_data(path = input$comp_file$datapath)
          } else {
            uploaded <- upload_data(
              path = input$comp_file$datapath,
              sheet = as.character(input$comp_xlsx_sheets)
            )
          }
          return(uploaded)
        }),
        # |------ comp_name ----
        comp_name = reactive({
          # req(input$comp_new_name)
          if (nchar(input$comp_new_name) != 0) {
            as.character(input$comp_new_name)
          } else {
            as.character(input$base_filename)
          }
        })
      )
    )
  })
}
