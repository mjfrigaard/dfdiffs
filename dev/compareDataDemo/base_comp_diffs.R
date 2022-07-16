

        fluidRow(
          column(
            width = 6,
            ## OUTPUT |-- (base_diffs_display) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "base_diffs_display"
              )
            )
          ),
          column(
            width = 6,
            ## OUTPUT |-- (comp_diffs_display) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "comp_diffs_display"
              )
            )
          )
        )


    ### OUTPUT |-- (base_diffs_display) -----
    observeEvent(input$go_changed_data, {
      # if there is a base_diffs table
      if (!is.null(changed_data()[["base_diffs"]])) {
        output$base_diffs_display <- renderReactable({
          reactable(
            data = changed_data()$base_diffs,
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
        # if no base_diffs table
        empty_base_diff <- tibble::tibble(
          `[IDs] in BASE that are not in COMPARE` = 0
        )
        output$base_diffs_display <- renderReactable({
          reactable(
            data = empty_base_diff,
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
    ### OUTPUT |-- (comp_diffs_display) -----
    observeEvent(input$go_changed_data, {
      if (!is.null(changed_data()[["comp_diffs"]])) {
        output$comp_diffs_display <- renderReactable({
          reactable(
            data = changed_data()$comp_diffs,
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
        empty_comp_diff <- tibble::tibble(
          `[IDs] in COMPARE that are not in BASE` = 0
        )
        output$comp_diffs_display <- renderReactable({
          reactable(
            data = empty_comp_diff,
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
