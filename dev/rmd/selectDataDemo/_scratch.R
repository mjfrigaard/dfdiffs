##  BASE UPDATE (input$base_data_select) |-- (base_data) --------
observeEvent(base_name(), {
  if (is.character(unclass(base_name())) == TRUE) {
    data_choices <- as.character(base_name())
  } else {
    data_choices <- c("", NULL)
  }
  updateSelectInput(
    inputId = "base_data_select",
    choices = data_choices
  )
})
## BASE REACTIVE |-- (base_data) ---------
base_data <- reactive({
  req(input$base_data_select)
  # if the selected data is the excel data name
  if (as.character(input$base_data_select) == as.character(base_xlsx_data_name())) {
    data <- base_xlsx_data()
    base_data <- tibble::as_tibble(data)
    # if the selected data is the flat file name
  } else if (as.character(input$base_data_select) == as.character(base_flat_file_data_name())) {
    data <- base_flat_file_data()
    base_data <- tibble::as_tibble(data)
  } else {
    NULL
  }
  return(base_data)
})
## BASE OUTPUT |-- base_data_display (display) ---------
output$base_data_display <- reactable::renderReactable({
  req(input$base_col_select)
  req(input$base_data_select)
  validate(
    need(base_data(), "please upload data")
  )
  reactable::reactable(
    data = select(base_data(), all_of(input$base_col_select)),
    # data = base_data(),
    defaultPageSize = 10,
    resizable = TRUE,
    highlight = TRUE,
    compact = TRUE,
    wrap = FALSE,
    bordered = TRUE,
    filterable = TRUE
  )
})
## BASE OUTPUT |-- reactive_values (dev) ---------
output$base_reactive_values <- renderPrint({
  all_values <- reactiveValuesToList(x = input, all.names = TRUE)
  module_names <- str_detect(names(all_values), "base")
  module_values <- all_values[module_names]
  reactable_names <- str_detect(
    names(module_values),
    "__reactable__",
    negate = TRUE
  )
  values <- module_values[reactable_names]
  print(values)
})
# COMPARE DATA |-- ----
## COMPARE REACTIVE |-- comp_xlsx_data (reactive) ---------
comp_xlsx_data <- eventReactive(data_upload$comp_xlsx_data(), {
  comp_xlsx <- data_upload$comp_xlsx_data()
  return(comp_xlsx)
})

## COMPARE REACTIVE |-- comp_xlsx_data_name (reactive) ---------
comp_xlsx_data_name <- eventReactive(data_upload$comp_xlsx_data_name(), {
  comp_xlsx_name <- data_upload$comp_xlsx_data_name()
  return(comp_xlsx_name)
})
## COMPARE REACTIVE |-- comp_flat_file_data (reactive) ---------
comp_flat_file_data <- eventReactive(data_upload$comp_flat_file_data(), {
  comp_flat_file <- data_upload$comp_flat_file_data()
  return(comp_flat_file)
})
## COMPARE REACTIVE |-- comp_flat_file_data_name (reactive) ---------
comp_flat_file_data_name <- eventReactive(data_upload$comp_flat_file_data_name(), {
  comp_flat_file_name <- data_upload$comp_flat_file_data_name()
  return(comp_flat_file_name)
})
## COMPARE REACTIVE |-- comp_uploaded_data_names (reactive) ---------
## comp_uploaded_data_names
comp_uploaded_data_names <- reactive({
  if (nchar(comp_xlsx_data_name()) != 0 & nchar(comp_flat_file_data_name()) != 0) {
    comp_xlsx_data_name <- as.character(comp_xlsx_data_name())
    comp_flat_file_data_name <- as.character(comp_flat_file_data_name())
    names <- c(comp_flat_file_data_name, comp_xlsx_data_name)
  } else if (nchar(comp_xlsx_data_name()) != 0 & nchar(comp_flat_file_data_name()) == 0) {
    names <- as.character(comp_xlsx_data_name())
  } else if (nchar(comp_xlsx_data_name()) == 0 & nchar(comp_flat_file_data_name()) != 0) {
    names <- as.character(comp_flat_file_data_name())
  } else {
    NULL
  }
  return(names)
})
# COMPARE UPDATE |-- (input$comp_data_select) ---------
observeEvent(comp_uploaded_data_names(), {
  if (is.character(unclass(comp_uploaded_data_names())) == TRUE) {
    data_choices <- comp_uploaded_data_names()
    updated_select <- as.character(input$comp_data_select)
    selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
  } else {
    data_choices <- c("", NULL)
    selected <- c("", NULL)
  }
  updateSelectInput(
    inputId = "comp_data_select",
    choices = data_choices,
    selected = selected
  )
})
## COMPARE REACTIVE |-- (comp_data) ---------
comp_data <- reactive({
  req(input$comp_data_select)
  # if the selected data is the excel data name
  if (as.character(input$comp_data_select) == as.character(comp_xlsx_data_name())) {
    data <- comp_xlsx_data()
    comp_data <- tibble::as_tibble(data)
    # if the selected data is the flat file name
  } else if (as.character(input$comp_data_select) == as.character(comp_flat_file_data_name())) {
    data <- comp_flat_file_data()
    comp_data <- tibble::as_tibble(data)
  } else {
    NULL
  }
  return(comp_data)
})
## COMPARE UPDATE |-- input$comp_col_select   ---------
observeEvent(comp_data(), {
  data_choices <- names(comp_data())
  updateSelectizeInput(
    inputId = "comp_col_select",
    choices = data_choices,
    selected = data_choices
  )
})
## COMPARE OUTPUT |---- comp_data_display (display) ---------
output$comp_data_display <- reactable::renderReactable({
  req(input$comp_col_select)
  validate(
    need(comp_data(), "please upload data")
  )
  reactable::reactable(
    data = select(comp_data(), all_of(input$comp_col_select)),
    # data = comp_data(),
    defaultPageSize = 10,
    resizable = TRUE,
    highlight = TRUE,
    compact = TRUE,
    wrap = FALSE,
    bordered = TRUE,
    filterable = TRUE
  )
})
## COMPARE OUTPUT |-- reactive_values (dev) ---------
output$compare_reactive_values <- renderPrint({
  all_values <- reactiveValuesToList(x = input, all.names = TRUE)
  module_names <- str_detect(names(all_values), "comp")
  module_values <- all_values[module_names]
  reactable_names <- str_detect(
    names(module_values),
    "__reactable__",
    negate = TRUE
  )
  values <- module_values[reactable_names]
  print(values)
  # print(is.character(unclass(comp_uploaded_data_names())))
})
# RETURN LIST |-- ----
return(
  list(
    ## |--- BASE DATA RETURN (base_data) ----
    base_data = reactive({
      req(input$base_data_select)
      req(input$base_col_select)
      # base selected xlsx data
      if (as.character(input$base_data_select) == as.character(base_xlsx_data_name())) {
        data <- base_xlsx_data()
        base_data <- tibble::as_tibble(data)
        # base selected flat file data
      } else {
        data <- base_flat_file_data()
        base_data <- tibble::as_tibble(data)
      }
      return_base_data <- select(base_data, all_of(input$base_col_select))
      return(return_base_data)
    }),
    ## |--- COMPARE DATA RETURN (comp_data) ----
    comp_data = reactive({
      req(input$comp_data_select)
      req(input$comp_col_select)
      # compare xlsx file
      if (as.character(input$comp_data_select) == as.character(comp_xlsx_data_name())) {
        data <- comp_xlsx_data()
        comp_data <- tibble::as_tibble(data)
        # compare flat file data
      } else {
        data <- comp_flat_file_data()
        comp_data <- tibble::as_tibble(data)
      }
      return_comp_data <- select(comp_data, all_of(input$comp_col_select))
      return(return_comp_data)
    })
  )
)

    ##  UPDATE (input$base_data_select) |-- (base_data) --------
    observeEvent(base_uploaded_data_names(), {
      if (is.character(unclass(base_uploaded_data_names())) == TRUE) {
        data_choices <- base_uploaded_data_names()
      } else {
        data_choices <- c("", NULL)
      }
      updateSelectInput(inputId = "base_data_select",
        choices = data_choices)
    })

    ##  UPDATE |-- input$base_col_select   ---------
    observeEvent(input$base_data_select, {
        data_choices <- base_data_cols()
      updateSelectizeInput(
        inputId = "base_col_select",
        choices = data_choices,
        selected = data_choices
        )
    })

    ## OUTPUT |-- base_data_display (display) ---------
    observeEvent(base_data_cols(), {
    output$base_data_display <- reactable::renderReactable({
        reactable::reactable(
          data = select(base_data(), all_of(input$base_col_select)),
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE)
      })
    })

      ## BASE OUTPUT |-- reactive_values (dev) ---------
      output$base_dev_x <- renderPrint({
        # all_values <- reactiveValuesToList(x = input, all.names = TRUE)
        # module_names <- str_detect(names(all_values), "base")
        # module_values <- all_values[module_names]
        # reactable_names <- str_detect(
        #   names(module_values),
        #   "__reactable__",
        #   negate = TRUE
        # )
        # values <- module_values[reactable_names]
        print(base_xlsx_data())
      })


# Name Joining Column(s) --------------------------------------------------
# the UI component
    #   strong(
    #     em("Name Joining Column(s)")
    #   )
    # ),
    # ## INPUT |-- (by_col) ------
    # textInput(
    #   inputId = NS(namespace = id, id = "by_col"),
    #   label =
    #     em("Provide an optional name for the joining bs4Dash::column (or columns)"),
    #   value = NULL
    # ),
    # em(
    #   "If no name is provided, the join bs4Dash::column will be named",
    #   code("join")
# This is the server component:
    # ##  REACTIVE |--  base_join_col_data
    # base_join_col_data <- eventReactive(base_select(), {
    #    # no by col, no new name
    #   if (length(input$by) == 0 & nchar(input$by_col) == 0) {
    #     base_join_col <- base_select()
    #   # by col, no by_col
    #   } else if (length(input$by) > 0 & nchar(input$by_col) == 0) {
    #     base_join_col <- create_join_column(
    #       df = base_select(),
    #       by_colums = input$by,
    #       new_by_column_name = "join_column"
    #     )
    #     # no by col, new name
    #   } else if (length(input$by) == 0 & nchar(input$by_col) != 0) {
    #     base_join_col <- base_select()
    #     # by col and new col name
    #   } else if (length(input$by) > 0 & nchar(input$by_col) != 0) {
    #     base_join_col <- create_join_column(
    #       df = base_select(),
    #       by_colums = input$by,
    #       new_by_column_name = as.character(input$by_col)
    #     )
    #     # no by col, no new name
    #   } else {
    #     base_join_col <- base_select()
    #   }
    # })
