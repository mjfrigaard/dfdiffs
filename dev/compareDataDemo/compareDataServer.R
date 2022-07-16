#' compareDataServer() (SERVER module for compareData)
#'
#' @param id module id (from NS)
#' @param data_selected data list from selectData module
#'
#' @return compare_data_tables tables from comparison
#' @export compareDataServer
#'
compareDataServer <- function(id, data_selected) {

  moduleServer(id = id, module = function(input, output, session) {

    # |-- REACTIVE data_prev() --------------------------------------
    data_prev <- eventReactive( data_selected$prev_data(), {
      data_prev <- data_selected$prev_data()
      return(data_prev)
    })

    # |-- REACTIVE data_prev_cols() --------------------------------------
    data_prev_cols <- eventReactive( data_selected$prev_cols(), {
      prev_cols <- data_selected$prev_cols()
      return(prev_cols)
    })

    # |-- REACTIVE data_curr() --------------------------------------
    data_curr <- eventReactive( data_selected$curr_data(), {
      data_curr <- data_selected$curr_data()
      return(data_curr)
    })
    # |-- REACTIVE data_curr_cols() --------------------------------------
    data_curr_cols <- eventReactive( data_selected$curr_cols(), {
      curr_cols <- data_selected$curr_cols()
      return(curr_cols)
    })
    # |-- REACTIVE col_intersect() --------------------------------------
    col_intersect <- reactive({
      intersecting_cols <- dplyr::intersect(x = data_prev_cols(),
                                            y = data_curr_cols())
      col_intersect_tbl <- tibble::tibble(Columns = intersecting_cols)
    })

    # |-- OUTPUT (intersecting_cols) --------------------------------------
    output$intersecting_cols <- renderReactable({
      reactable(
        col_intersect(),
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
        theme = reactableTheme(
        color = "hsl(0, 0%, 100%)",
        backgroundColor = "hsl(235, 48%, 40%)",
        borderColor = "hsl(233, 9%, 22%)",
        stripedColor = "hsl(233, 12%, 22%)",
        highlightColor = "hsl(233, 12%, 24%)",
        inputStyle = list(backgroundColor = "hsl(0,0%,39%)"),
        selectStyle = list(backgroundColor = "hsl(0,0%,39%)"),
        pageButtonHoverStyle = list(backgroundColor = "hsl(0,0%,39%)"),
        pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)"))
      )
    })

    # |-- REACTIVE (prev_data()) --------------------------------------
    prev_data <- eventReactive( col_intersect(), {
      cols <- col_intersect()$Columns
      prev_data <- select(data_prev(),
                   all_of(cols))
      return(prev_data)
    })

    # |-- REACTIVE (curr_data()) --------------------------------------
    curr_data <- eventReactive( col_intersect(), {
      cols <- col_intersect()$Columns
      curr_data <- select(data_curr(),
                   all_of(cols))
      return(curr_data)
    })

    # |-- UPDATE (new_join_col) ---------------------------------------------
    observeEvent(eventExpr = col_intersect(), handlerExpr = {
      if (nrow(col_intersect()) < 1) {
        intersecting_cols <- c("", NULL)
      updateSelectizeInput(
        inputId = "new_join_col",
        choices = intersecting_cols,
        selected = c("", NULL))
      } else {
        intersecting_cols <- purrr::as_vector(
          .x = col_intersect(),
          .type = "character") %>%
          base::unname(obj = .)
      updateSelectizeInput(
        inputId = "new_join_col",
        choices = intersecting_cols,
        selected = c("", NULL))
      }
    })

    # |-- REACTIVE prev_join_var() -----
    prev_join_var <- reactive({
      req(input$new_join_col)
      # create join column
      prev_join_var <- create_new_column(
        data = data_prev(),
        cols = input$new_join_col,
        new_name = "join")
          return(prev_join_var)
      })

    # |-- REACTIVE curr_join_var() -----
    curr_join_var <- reactive({
      req(input$new_join_col)
      # create join column
      curr_join_var <- create_new_column(
        data = data_curr(),
        cols = input$new_join_col,
        new_name = "join")
          return(curr_join_var)
      })

    # |-- OUTPUT (intersecting_cols) --------------------------------------
    # display intersecting columns
    output$new_join_var <- renderReactable({
      reactable(
        head(select(prev_join_var(), join), 3),
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
        theme = reactableTheme(
        color = "hsl(0, 0%, 100%)",
        backgroundColor = "hsl(235, 48%, 40%)",
        borderColor = "hsl(233, 9%, 22%)",
        stripedColor = "hsl(233, 12%, 22%)",
        highlightColor = "hsl(233, 12%, 24%)",
        inputStyle = list(backgroundColor = "hsl(0,0%,39%)"),
        selectStyle = list(backgroundColor = "hsl(0,0%,39%)"),
        pageButtonHoverStyle = list(backgroundColor = "hsl(0,0%,39%)"),
        pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)"))
      )
    })


    # |-- OUTPUT (prev) --------------------------------------
    output$dev_display_a <- renderPrint({
      print(prev_data())
    })

    # |-- OUTPUT (dev_display_b) --------------------------------------
    output$dev_display_b <- renderPrint({
      print(curr_data())
    })

    # |-- REACTIVE (new_data()) --------------------------------------
    new_data <- reactive({
      req(input$new_join_col)
      new_data <- create_new_data(
        newdf = curr_data(),
        olddf = prev_data(),
        by = input$new_join_col)
    })

    # |-- OUTPUT (dev_display_x) --------------------------------------
    output$dev_display_x <- renderPrint({
      print(new_data())
    })

    # |-- REACTIVE (deleted_data()) --------------------------------------
    deleted_data <- reactive({
      req(input$new_join_col)
      new_data <- create_deleted_data(
        newdf = curr_data(),
        olddf = prev_data(),
        by = input$new_join_col)
    })

    # |-- OUTPUT (dev_display_y) --------------------------------------
    output$dev_display_y <- renderPrint({
      print(deleted_data())
    })












  })
}
