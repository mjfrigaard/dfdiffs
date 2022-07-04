source("helpers.R")
#' Select data (server) for selectDataDemo
#'
#' @param id module id
#' @param data_upload upload data
#'
#' @export selectDataServer
#'
selectDataServer <- function(id, data_upload) {

  moduleServer(id = id, module = function(input, output, session) {

    # PREVIOUS DATA |-- ----
    ## REACTIVE |-- prev_xlsx_data (reactive) ---------
    # input$sidebarmenu == "select_data_tab"
    prev_xlsx_data <- eventReactive(data_upload$prev_xlsx_data(), {
      prev_xlsx <- data_upload$prev_xlsx_data()
      return(prev_xlsx)
    })

    ## REACTIVE |-- prev_xlsx_data_name (reactive) ---------
    prev_xlsx_data_name <- eventReactive(data_upload$prev_xlsx_data_name(), {
      prev_xlsx_name <- data_upload$prev_xlsx_data_name()
      return(prev_xlsx_name)
    })

    ## REACTIVE |-- prev_flat_file_data (reactive) ---------
    prev_flat_file_data <- eventReactive(data_upload$prev_flat_file_data(), {
      prev_flat_file <- data_upload$prev_flat_file_data()
      return(prev_flat_file)
    })
    ## REACTIVE |-- prev_flat_file_data_name (reactive) ---------
    prev_flat_file_data_name <- eventReactive(data_upload$prev_flat_file_data_name(), {
      prev_flat_file_name <- data_upload$prev_flat_file_data_name()
      return(prev_flat_file_name)
    })

    ## REACTIVE |-- prev_data_names (reactive) ---------
    prev_data_names <- reactive({
      if (nchar(prev_xlsx_data_name()) != 0 & nchar(prev_flat_file_data_name()) != 0 ) {
        prev_xlsx_data_name <- as.character(prev_xlsx_data_name())
        prev_flat_file_data_name <- as.character(prev_flat_file_data_name())
        names <- c(prev_flat_file_data_name, prev_xlsx_data_name)
      } else if (nchar(prev_xlsx_data_name()) != 0 & nchar(prev_flat_file_data_name()) == 0 ) {
        names <- as.character(prev_xlsx_data_name())
      } else if (nchar(prev_xlsx_data_name()) == 0 & nchar(prev_flat_file_data_name()) != 0 ) {
        names <- as.character(prev_flat_file_data_name())
      } else {
        NULL
      }
      return(names)
    })

    ##  UPDATE (input$prev_data_select) |-- (prev_data) ---------
    # observeEvent(eventExpr = input$sidebarmenu == "select_data_tab", handlerExpr = {
    observeEvent(prev_data_names(), {
      if (is.character(unclass(prev_data_names())) == TRUE) {
        data_choices <- prev_data_names()
        updated_select <- as.character(input$prev_data_select)
        selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
      } else {
        data_choices <- c("xlsx_prev_data", "flat_file_prev_data")
        updated_select <- "xlsx"
        selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
      }
      updateSelectInput(inputId = "prev_data_select",
        choices = data_choices,
        selected = selected)
    })

    ##  REACTIVE |-- (prev_data) ---------
    prev_data <- reactive({
      req(input$prev_data_select)
      if (as.character(input$prev_data_select) == as.character(prev_xlsx_data_name())) {
        data <- prev_xlsx_data()
        prev_data <- tibble::as_tibble(data)
      } else if (as.character(input$prev_data_select) == as.character(prev_flat_file_data_name())) {
        data <- prev_flat_file_data()
        prev_data <- tibble::as_tibble(data)
      } else if (as.character(input$prev_data_select) == "flat_file_prev_data") {
        prev_data <- flat_file_prev_data
      } else {
        prev_data <- xlsx_prev_data
      }
      return(prev_data)
    })

    ## OUTPUT |-- prev_data_display (display) ---------
    output$prev_data_display <- reactable::renderReactable({
      validate(
        need(prev_data(), "please upload data")
      )
        reactable::reactable(
          data = prev_data(),
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE)
        })

    ##  UPDATE |-- input$prev_col_select   ---------
    # observeEvent(eventExpr = input$sidebarmenu == "select_data_tab", handlerExpr = {
      observeEvent(input$prev_data_select, {
      if (is.data.frame(prev_data()) == TRUE) {
        data_choices <- names(prev_data())
      } else {
        data_choices <- names(xlsx_prev_data)
      }
      updateSelectizeInput(
        inputId = "prev_col_select",
        choices = data_choices,
        selected = data_choices
        )
    })

    # CURRENT DATA |-- ----
    ## REACTIVE |-- curr_xlsx_data (reactive) ---------
    curr_xlsx_data <- eventReactive(data_upload$curr_xlsx_data(), {
      curr_xlsx <- data_upload$curr_xlsx_data()
      return(curr_xlsx)
    })

    ## REACTIVE |-- curr_xlsx_data_name (reactive) ---------
    curr_xlsx_data_name <- eventReactive(data_upload$curr_xlsx_data_name(), {
      curr_xlsx_name <- data_upload$curr_xlsx_data_name()
      return(curr_xlsx_name)
    })

    ## REACTIVE |-- curr_flat_file_data (reactive) ---------
    curr_flat_file_data <- eventReactive(data_upload$curr_flat_file_data(), {
      curr_flat_file <- data_upload$curr_flat_file_data()
      return(curr_flat_file)
    })
    ## REACTIVE |-- curr_flat_file_data_name (reactive) ---------
    curr_flat_file_data_name <- eventReactive(data_upload$curr_flat_file_data_name(), {
      curr_flat_file_name <- data_upload$curr_flat_file_data_name()
      return(curr_flat_file_name)
    })

    ## REACTIVE |-- curr_data_names (reactive) ---------
    curr_data_names <- reactive({
      if (nchar(curr_xlsx_data_name()) != 0 & nchar(curr_flat_file_data_name()) != 0) {
        curr_xlsx_data_name <- as.character(curr_xlsx_data_name())
        curr_flat_file_data_name <- as.character(curr_flat_file_data_name())
        names <- c(curr_flat_file_data_name, curr_xlsx_data_name)
      } else if (nchar(curr_xlsx_data_name()) != 0 & nchar(curr_flat_file_data_name()) == 0 ) {
        names <- as.character(curr_xlsx_data_name())
      } else if (nchar(curr_xlsx_data_name()) == 0 & nchar(curr_flat_file_data_name()) != 0 ) {
        names <- as.character(curr_flat_file_data_name())
      } else {
        NULL
      }
      return(names)
    })

    ##  UPDATE |-- (input$curr_data_select) ---------
    # observeEvent(eventExpr = input$sidebarmenu == "select_data_tab", handlerExpr = {
    observeEvent(curr_data_names(), {
      if (is.character(unclass(curr_data_names())) == TRUE) {
        data_choices <- curr_data_names()
        updated_select <- as.character(input$curr_data_select)
        selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
      } else {
        data_choices <- c("xlsx_curr_data", "flat_file_curr_data")
        updated_select <- "xlsx_curr_data"
        selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
      }
      updateSelectInput(inputId = "curr_data_select",
        choices = data_choices,
        selected = selected)
    })

    ##  REACTIVE |-- (curr_data) ---------
    curr_data <- reactive({
      req(input$curr_data_select)
      req(input$prev_col_select)
      if (as.character(input$curr_data_select) == as.character(curr_xlsx_data_name())) {
        data <- curr_xlsx_data()
        curr_data <- tibble::as_tibble(data)
      } else if (as.character(input$curr_data_select) == as.character(curr_flat_file_data_name())) {
        data <- curr_flat_file_data()
        curr_data <- tibble::as_tibble(data)
      } else if (as.character(input$curr_data_select) == "flat_file_curr_data") {
        curr_data <- flat_file_curr_data
      } else {
        curr_data <- xlsx_curr_data
      }
      return(curr_data)
    })

    ## OUTPUT |---- curr_data_display (display) ---------
    output$curr_data_display <- reactable::renderReactable({
      validate(
        need(curr_data(), "please upload data")
      )
        reactable::reactable(
          data = curr_data(),
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE)
        })

   ##  UPDATE |-- input$curr_col_select   ---------
    # changed this to the current data selected instead of curr_data()
    observeEvent(input$curr_data_select, {
      if (is.data.frame(curr_data()) == TRUE) {
        data_choices <- names(curr_data())
      } else {
        data_choices <- names(xlsx_curr_data)
      }
      updateSelectizeInput(
        inputId = "curr_col_select",
        choices = data_choices,
        selected = data_choices
        )
    })


    # RETURN LIST |-- ----
    return(
      list(
        ## |--- PREVIOUS DATA RETURN ----
      prev_data = reactive({
          req(input$prev_data_select)
            if (as.character(input$prev_data_select) == as.character(prev_xlsx_data_name())) {
              data <- prev_xlsx_data()
              return_prev_data <- tibble::as_tibble(data)
            } else if (as.character(input$prev_data_select) == as.character(prev_flat_file_data_name())) {
              data <- prev_flat_file_data()
              return_prev_data <- tibble::as_tibble(data)
            } else if (as.character(input$prev_data_select) == "flat_file_prev_data") {
              return_prev_data <- flat_file_prev_data
            } else {
              return_prev_data <- xlsx_prev_data
            }
              return(return_prev_data)
          }),
        ## |--- PREVIOUS COLS RETURN ----
      prev_cols = reactive({
        req(input$prev_col_select)
        return_prev_cols <- as.character(input$prev_col_select)
        return(return_prev_cols)
      }),
        ## |--- CURRENT DATA RETURN ----
      curr_data = reactive({
          req(input$curr_data_select)
            if (as.character(input$curr_data_select) == as.character(curr_xlsx_data_name())) {
              data <- curr_xlsx_data()
              return_curr_data <- tibble::as_tibble(data)
            } else if (as.character(input$curr_data_select) == as.character(curr_flat_file_data_name())) {
              data <- curr_flat_file_data()
              return_curr_data <- tibble::as_tibble(data)
            } else if (as.character(input$curr_data_select) == "flat_file_curr_data") {
              return_curr_data <- flat_file_curr_data
            } else {
              return_curr_data <- xlsx_curr_data
            }
              return(return_curr_data)
          }),
        ## |--- CURRENT COLS RETURN ----
      curr_cols = reactive({
        req(input$curr_col_select)
        return_curr_cols <- as.character(input$curr_col_select)
        return(return_curr_cols)
      })
          )
      )


  })
}
