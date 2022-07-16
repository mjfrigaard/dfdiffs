#' dev_selectDataServer
#'
#' @param id module id
#'
#' @export dev_selectDataServer
#'
#' @description dev select server module
dev_selectDataServer <- function(id, data_upload) {
  moduleServer(id = id, module = function(input, output, session) {
    # BASE DATA |-- ----
    ## BASE REACTIVE |-- base_data (reactive) ---------
    base_data <- eventReactive(data_upload$base_data(), {
      base_data <- data_upload$base_data()
      return(base_data)
    })
    ## BASE REACTIVE |-- base_name (reactive) ---------
    base_name <- eventReactive(data_upload$base_name(), {
      base_name <- data_upload$base_name()
      return(base_name)
    })
    ## BASE UPDATE |-- input$base_col_select   ---------
    observeEvent(base_data(), {
      data_choices <- names(base_data())
      updateSelectizeInput(
        inputId = "base_col_select",
        choices = data_choices,
        selected = data_choices
      )
    })
    ## DEV OUTPUT |-- base_dev_x (dev) ---------
    output$base_dev_a <- renderPrint({
      print(
        base_select()
      )
    })
    ## DEV OUTPUT |-- base_dev_y (dev) ---------
    output$base_dev_b <- renderPrint({
      print(
        paste0(input$by, collapse = "-")
      )
    })
    ## DEV OUTPUT |-- base_dev_a (dev) ---------
    output$base_dev_c <- renderPrint({
      print(
        as.character(input$base_col_select)
      )
    })
    ## BASE OUTPUT |-- base_data_display (display) ---------
    output$base_data_display <- reactable::renderReactable({
      req(input$base_col_select)
      validate(
        need(base_data(), "please upload data")
      )
      reactable::reactable(
        data = select(base_data(),
                      all_of(input$base_col_select)),
        theme = base_react_theme,
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE
      )
    })
    ## BASE REACTIVE |-- base_select   ---------
    base_select <- eventReactive(input$base_col_select, {
      # create selection
      base_select <- select(base_data(), all_of(input$base_col_select))
      return(base_select)
    })

    # COMP DATA |-- -----------------------------------------------------------
    ## COMPARE REACTIVE |-- comp_data (reactive) ---------
    comp_data <- eventReactive(data_upload$comp_data(), {
      comp_data <- data_upload$comp_data()
      return(comp_data)
    })
    ## COMPARE REACTIVE |-- comp_name (reactive) ---------
    comp_name <- eventReactive(data_upload$comp_name(), {
      comp_name <- data_upload$comp_name()
      return(comp_name)
    })
    ## COMP UPDATE |-- input$comp_col_select   ---------
    observeEvent(comp_data(), {
      data_choices <- names(comp_data())
      updateSelectizeInput(
        inputId = "comp_col_select",
        choices = data_choices,
        selected = data_choices
      )
    })
    ## |-- DEV OUTPUT |-- comp_dev_x (dev) ---------
    output$comp_dev_a <- renderPrint({
      print(
        comp_select()
      )
    })
    ## |-- DEV OUTPUT |-- comp_dev_y (dev) ---------
    output$comp_dev_b <- renderPrint({
      print(
        paste0(input$by, collapse = "-")
      )
    })
    ## |-- DEV OUTPUT |-- comp_dev_a (dev) ---------
    output$comp_dev_c <- renderPrint({
      print(
        as.character(input$comp_col_select)
      )
    })

    ## |-- COMP OUTPUT |-- comp_data_display (display) ---------
    output$comp_data_display <- reactable::renderReactable({
      req(input$comp_col_select)
      validate(
        need(comp_data(), "please upload data")
      )
      reactable::reactable(
        data = select(comp_data(),
                      all_of(input$comp_col_select)),
        theme = comp_react_theme,
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE
      )
    })
    ## COMPARE REACTIVE |-- comp_select (reactive) ---------
    comp_select <- eventReactive(input$comp_col_select, {
      # create selection
      comp_select <- select(comp_data(), all_of(input$comp_col_select))
      return(comp_select)
    })

    ## REACTIVE |-- col_intersect (reactive) ---------
    col_intersect <- reactive({
      base_cols <- names(base_select())
      comp_cols <- names(comp_select())
      intersecting_cols <- intersect(x = base_cols, y = comp_cols)
      col_intersect <- tibble::tibble(Columns = intersecting_cols)
      return(col_intersect)
    })

    # |-- OUTPUT (intersecting_cols) --------
    output$intersecting_cols <- renderReactable({
      reactable(
        col_intersect(),
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        defaultPageSize = 5,
        theme = reactableTheme(
          color = "#2a3079",
          borderColor = "#e5eaee",
          stripedColor = "#f6f8fa",
          highlightColor = "#f0f5f9",
          cellPadding = "8px 12px"
        )
      )
    })
    ##  UPDATE |-- input$by   ---------
    observeEvent(col_intersect(), {
      data_choices <- col_intersect()$Columns
      updateSelectizeInput(
        inputId = "by",
        choices = data_choices,
        selected = NULL
      )
    })

    ##  REACTIVE |--  base_join_col_data -----
    base_join_col_data <- reactive({
      # no by col, no new name
      if (length(input$by) != 0) {
        base_join_col <- create_join_column(
          df = base_select(),
          by_colums = input$by,
          new_by_column_name = "join_column"
        )
        base_join_col <- select(
          base_join_col,
          join_column, all_of(col_intersect()$Columns)
        )
      } else {
        base_join_col <- base_select()
        # no by col, new name
        base_join_col <- select(
          base_join_col,
          all_of(col_intersect()$Columns)
        )
      }
    })

    # |-- OUTPUT (base_join_col_display) --------
    output$base_join_col_display <- renderReactable({
      reactable(
        data = base_join_col_data(),
        resizable = TRUE,
        defaultPageSize = 5,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE,
        theme = base_react_theme
      )
    })

    ##  REACTIVE |--  comp_join_col_data -----
    comp_join_col_data <- reactive({
      # no by col, no new name
      if (length(input$by) != 0) {
        comp_join_col <- create_join_column(
          df = comp_select(),
          by_colums = input$by,
          new_by_column_name = "join_column"
        )
        comp_join_col <- select(
          comp_join_col,
          join_column, all_of(col_intersect()$Columns)
        )
      } else {
        comp_join_col <- comp_select()
        # no by col
        comp_join_col <- select(
          comp_join_col,
          all_of(col_intersect()$Columns)
        )
      }
    })

    output$comp_join_col_display <- renderReactable({
      reactable(
        data = comp_join_col_data(),
        resizable = TRUE,
        defaultPageSize = 5,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE,
        theme = comp_react_theme
      )
    })

    # |---- return list ---------
    return(
      list(
        ## base_join_col_data -----
        base_join_col_data = reactive({
          # no by col, no new name
          if (length(input$by) > 0) {
            # by columns
            by_cols <- paste0(input$by, collapse = "-")
            # create new column(s)
            base_join_col <- create_join_column(
              df = base_select(),
              by_colums = input$by,
              new_by_column_name = "join_column"
            )
            # only intersecting columns
            base_join_col <- dplyr::select(
              base_join_col,
              join_column, all_of(col_intersect()$Columns)
            )
            # join column
            base_join_col <- tibble::add_column(
              .data = base_join_col,
              join_source = by_cols, .after = 1
            )
            # data source column
            base_join_col <- tibble::add_column(
              .data = base_join_col,
              data_source = base_name(), .after = 1
            )
          } else {
            # no by col, new name
            base_join_col <- base_select()
            base_join_col <- select(
              base_join_col,
              all_of(col_intersect()$Columns)
            )
            # data source column
            base_join_col <- tibble::add_column(
              .data = base_join_col,
              data_source = base_name(), .after = 1
            )
          }
          return(base_join_col)
        }),
        ## comp_join_col_data -----
        comp_join_col_data = reactive({
          # no by col, no new name
          if (length(input$by) > 0) {
            # by columns
            by_cols <- paste0(input$by, collapse = "-")
            # create new column(s)
            comp_join_col <- create_join_column(
              df = comp_select(),
              by_colums = input$by,
              new_by_column_name = "join_column"
            )
            # only intersecting columns
            comp_join_col <- select(
              comp_join_col,
              join_column, all_of(col_intersect()$Columns)
            )
            # data source column
            comp_join_col <- tibble::add_column(
              .data = comp_join_col,
              join_source = by_cols, .after = 1
            )
            # data source column
            comp_join_col <- tibble::add_column(
              .data = comp_join_col,
              data_source = comp_name(), .after = 1
            )
          } else {
            # no by col, new name
            comp_join_col <- comp_select()
            # only intersecting columns
            comp_join_col <- select(
              comp_join_col,
              all_of(col_intersect()$Columns)
            )
            # data source column
            comp_join_col <- tibble::add_column(
              .data = comp_join_col,
              data_source = comp_name(), .after = 1
            )
          }
          return(comp_join_col)
        })
      )
    )

  })
}
