#' dev_compareDataServer
#'
#' @param id module id
#'
#' @export dev_compareDataServer
#'
#' @description dev compare server module
dev_compareDataServer <- function(id, data_selected) {
  moduleServer(id = id, module = function(input, output, session) {

    ## SELECTED DATA ----------------------------------------------
    ### |-- REACTIVE base_join_data() ----------------
    base_join_data <- eventReactive(data_selected$base_join_col_data(), {
      data_base <- data_selected$base_join_col_data()
      return(data_base)
    })

    ### |-- REACTIVE comp_join_data() ----------------
    comp_join_data <- eventReactive(data_selected$comp_join_col_data(), {
      data_comp <- data_selected$comp_join_col_data()
      return(data_comp)
    })

    ### |-- REACTIVE |-- compare_cols (reactive) ---------
    compare_cols <- reactive({
      base_cols <- names(base_join_data())
      comp_cols <- names(comp_join_data())
      compare_cols <- intersect(x = base_cols, y = comp_cols)
      return(compare_cols)
    })

    ### |-- REACTIVE |-- compare_cols_tbl (reactive) ---------
    compare_cols_tbl <- reactive({
      # convert to tibble
      compare_cols_tbl <- tibble::tibble(
        `Compare Columns` = compare_cols()
      )
      # remove join column, data_source, join_source
      compare_cols_tbl <- filter(
        compare_cols_tbl,
        `Compare Columns` %nin% c("join_column", "data_source", "join_source")
      )
      return(compare_cols_tbl)
    })

    ## INFO ---------
    #### DEV OUTPUT |--  (dev_a) ---------
    output$dev_a <- renderPrint({
      print(
        base_join_data()
      )
    })
    #### DEV OUTPUT |--  (dev_b) ---------
    output$dev_b <- renderPrint({
      print(
        comp_join_data()
      )
    })
    #### DEV OUTPUT |--  (dev_c) ---------
    output$dev_c <- renderPrint({
      print(
        new_data()
      )
    })
    ### OUTPUT |--  (base_info) ---------
    output$base_info <- renderUI({
      HTML(paste0(
        "The name for your ",
        code("base"), " file is ",
        strong(unique(base_join_data()$data_source)), ". ",
        "There are ", strong(nrow(base_join_data())), " rows and ",
        strong(ncol(base_join_data())), " columns in this dataset."
      ))
    })
    ### OUTPUT |--  (comp_info) ---------
    output$comp_info <- renderUI({
      HTML(paste0(
        "The name for your ",
        code("compare"), " file is ",
        strong(unique(comp_join_data()$data_source)), ". ",
        "There are ", strong(nrow(comp_join_data())), " rows and ",
        strong(ncol(comp_join_data())), " columns in this dataset."
      ))
    })
    ### OUTPUT |--  (info) ---------
    output$info <- renderUI({
      if (length(base_join_data()$join_source) > 0) {
        HTML(paste0(
          "The ",
          code("base"), " and ", code("compare"),
          " datasets are joined using the ",
          strong(unique(base_join_data()$join_source)),
          " column(s). The columns being compared are:"
        ))
      } else {
        HTML(paste0(
          "The ",
          code("base"), " and ", code("compare"),
          " are compared using a row-by-row comparison.",
          " The columns being compared are:"
        ))
      }


    })
    ### OUTPUT |--  (display_compare_cols) ---------
    output$display_compare_cols <- renderReactable({
      reactable(
        data = compare_cols_tbl(),
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

    ## NEW DATA --------------------------------------------------------
    ###  |-- REACTIVE  new data ---------
    new_data <- reactive({
      # join column
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
        new <- create_new_data(
          compare = comp_join_data(),
          base = base_join_data(),
          by = "join_column"
        )
        # no join column
      } else {
        new <- create_new_data(
          compare = comp_join_data(),
          base = base_join_data()
        )
      }
      return(new)
    })
    ### OUTPUT |-- (new_data_display) -----------
    observeEvent(input$go_new_data, {
      output$new_data_display <- renderReactable({
        reactable(
          data = new_data(),
          resizable = TRUE,
          height = 600,
          pagination = TRUE,
          defaultPageSize = 25,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = new_react_theme
        )
      })
    })

    ## DELETED DATA --------------------------------------------------------
    ### |-- REACTIVE  deleted data ---------
    deleted_data <- reactive({
      # join column
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
        deleted <- create_deleted_data(
          compare = comp_join_data(),
          base = base_join_data(),
          by = "join_column"
        )
        # no join column
      } else {
        deleted <- create_deleted_data(
          compare = comp_join_data(),
          base = base_join_data()
        )
      }
      return(deleted)
    })
    ### |-- OUTPUT (new_data_display)
    observeEvent(input$go_deleted_data, {
      output$deleted_data_display <- renderReactable({
        reactable(
          data = deleted_data(),
          resizable = TRUE,
          pagination = TRUE,
          defaultPageSize = 25,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = deleted_react_theme
        )
      })
    })

    ## CHANGED DATA --------------------------------------------------------
    ### |-- REACTIVE  changed_data ---------
    changed_data <- reactive({
      # join column
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
          # remove data source
          comp_join_data <- select(comp_join_data(), -data_source)
          base_join_data <- select(base_join_data(), -data_source)
          # changes
        changed <- create_changed_data(
          compare = comp_join_data,
          base = base_join_data,
          by = "join_column"
        )
        # no join column
      } else {
          # remove data source
          comp_join_data <- select(comp_join_data(), -data_source)
          base_join_data <- select(base_join_data(), -data_source)
        changed <- create_changed_data(
          compare = comp_join_data,
          base = base_join_data
        )
      }
      return(changed)
    })
    ### OUTPUT |-- (num_diffs_display) -----
    observeEvent(input$go_changed_data, {
      if (!is.null(changed_data()[["num_diffs"]])) {
        output$num_diffs_display <- renderReactable({
          reactable(
            data = dplyr::rename(
              changed_data()$num_diffs,
              Variable = variable,
              `Differences` = no_of_differences),
            resizable = TRUE,
            pagination = TRUE,
            defaultPageSize = 10,
            highlight = TRUE,
            compact = TRUE,
            wrap = FALSE,
            bordered = TRUE,
            filterable = TRUE,
            theme = changed_react_theme
          )
        })
      } else {
        output$num_diffs_display <- renderReactable({
          empty_num_diffs <- tibble::tibble(
            variable = 0, no_of_differences = 0
          )
          reactable(data =
              dplyr::rename(
              empty_num_diffs,
              Variable = variable,
              `Differences` = no_of_differences),
            resizable = TRUE,
            pagination = TRUE,
            defaultPageSize = 10,
            highlight = TRUE,
            compact = TRUE,
            wrap = FALSE,
            bordered = TRUE,
            filterable = TRUE,
            theme = changed_react_theme
          )
        })
      }
    })

    ### OUTPUT  |-- (num_diffs_graph) -----
    observeEvent(input$go_changed_data, {
      output$num_diffs_graph <- renderPlot({
        # clean up labels
        gg_names <- sort(
          str_to_title(
            str_replace_all(names(changed_data()$num_diffs), "_", " ")
          ),
          decreasing = TRUE
        )
        gg_names_alpha_p1 <- gg_names[1]
        gg_names_alpha_p2 <- gg_names[2]
        # create graph
        num_diffs_graph <- ggplot2::ggplot(
          data = changed_data()$num_diffs,
          mapping = aes(
            x = no_of_differences,
            y = fct_reorder(variable, no_of_differences),
            fill = variable
          )
        ) +
          geom_col(show.legend = FALSE) +
          labs(
            title = "Number of Differences by Variable",
            x = gg_names_alpha_p2,
            y = gg_names_alpha_p1
          ) +
          ggplot2::theme_minimal()
        num_diffs_graph
      })
    })

    ### |-- REACTIVE comp_var_diffs -------------------
    comp_var_diffs <- eventReactive(input$go_changed_data, {
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
          # join to var_diffs
            left_join(x = changed_data()$var_diffs,
                      y = comp_join_data(),
                      by = "join_column")
      } else {
        # HERE! ----
        compare_row_by_row <- comp_join_data() %>%
          mutate(rownumber = row_number(),
                 rownumber = as.character(rownumber)) |>
          relocate(rownumber, .before = 1)
        # join to var_diffs
            left_join(x = changed_data()$var_diffs,
                      y = compare_row_by_row,
                      by = "rownumber")
      }

    })

    ###  OUTPUT |-- (var_diffs_display) ----
    observeEvent(comp_var_diffs(), {
      if (!is.null(changed_data()[["var_diffs"]])) {
        output$var_diffs_display <- renderReactable({
          reactable(
            data = comp_var_diffs(),
            resizable = TRUE,
            pagination = TRUE,
            defaultPageSize = 25,
            highlight = TRUE,
            compact = TRUE,
            wrap = FALSE,
            bordered = TRUE,
            filterable = TRUE,
            theme = changed_react_theme
          )
        })
      } else {
        output$var_diffs_display <- renderReactable({
          empty_var_diffs <- tibble::tibble(
            variable = 0, join_column = 0, base = 0, compare = 0
          )
          reactable(
            data = empty_var_diffs,
            resizable = TRUE,
            pagination = TRUE,
            defaultPageSize = 25,
            highlight = TRUE,
            compact = TRUE,
            wrap = FALSE,
            bordered = TRUE,
            filterable = TRUE,
            theme = changed_react_theme
          )
        })
      }
    })
  })
}
