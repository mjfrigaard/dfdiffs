#' dev_compareDataServer
#'
#' @param id module id
#'
#' @importFrom bs4Dash dashboardPage
#' @importFrom bs4Dash insertTab
#' @importFrom bs4Dash actionButton
#' @importFrom bs4Dash tabsetPanel
#' @importFrom bs4Dash column
#' @importFrom bs4Dash menuItem
#' @importFrom bs4Dash renderMenu
#' @importFrom bs4Dash sidebarUserPanel
#' @importFrom bs4Dash valueBox
#' @importFrom bs4Dash dropdownMenu
#' @importFrom bs4Dash dropdownMenuOutput
#' @importFrom bs4Dash renderInfoBox
#' @importFrom bs4Dash messageItem
#' @importFrom bs4Dash sidebarMenu
#' @importFrom bs4Dash dashboardBody
#' @importFrom bs4Dash tabItems
#' @importFrom bs4Dash notificationItem
#' @importFrom bs4Dash dashboardHeader
#' @importFrom bs4Dash renderValueBox
#' @importFrom bs4Dash menuSubItem
#' @importFrom bs4Dash dashboardSidebar
#' @importFrom bs4Dash updateTabItems
#' @importFrom bs4Dash tabItem
#' @importFrom bs4Dash box
#' @importFrom bs4Dash infoBox
#' @importFrom bs4Dash taskItem
#' @importFrom bs4Dash sidebarMenuOutput
#' @importFrom bs4Dash tabBox
#' @importFrom bs4Dash infoBoxOutput
#' @importFrom bs4Dash valueBoxOutput
#' @importFrom bs4Dash menuItemOutput
#' @importFrom bs4Dash dashboardPage
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
      # remove join bs4Dash::column, data_source, join_source
      compare_cols_tbl <- filter(
        compare_cols_tbl,
        `Compare Columns` %nin% c("join_column", "data_source", "join_source")
      )
      return(compare_cols_tbl)
    })
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
    ## INFO ----------------------------
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
          " bs4Dash::column(s). The columns being compared are:"
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
      # join bs4Dash::column
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
        new <- create_new_data(
          compare = comp_join_data(),
          base = base_join_data(),
          by = "join_column"
        )
        # no join bs4Dash::column
      } else {
        new <- create_new_data(
          compare = comp_join_data(),
          base = base_join_data()
        )
      }
      return(new)
    })
    ### |-- OUTPUT (new_data_display) -----------
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

    ## DELETED DATA ----------------------------------
    ### |-- REACTIVE  deleted data ---------
    deleted_data <- reactive({
      # join bs4Dash::column
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
        deleted <- create_deleted_data(
          compare = comp_join_data(),
          base = base_join_data(),
          by = "join_column"
        )
        # no join bs4Dash::column
      } else {
        deleted <- create_deleted_data(
          compare = comp_join_data(),
          base = base_join_data()
        )
      }
      return(deleted)
    })
    ### |-- OUTPUT (deleted_data_display) ------------------
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
    ### this creates $diffs and $diffs_byvar
    changed_data <- reactive({
      # join bs4Dash::column
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
        # remove data source
        comp_join_data <- select(comp_join_data(), -data_source)
        base_join_data <- select(base_join_data(), -data_source)
        # changes
        changed <- create_modified_data(
          compare = comp_join_data,
          base = base_join_data,
          by = "join_column"
        )
        # no join bs4Dash::column
      } else {
        # remove data source
        comp_join_data <- select(comp_join_data(), -data_source)
        base_join_data <- select(base_join_data(), -data_source)
        changed <- create_modified_data(
          compare = comp_join_data,
          base = base_join_data
        )
      }
      return(changed)
    })

    #### DEV OUTPUT |--  (dev_c) ---------
    output$dev_c <- renderPrint({
      print(
        comp_var_diffs()
      )
    })
    ### OUTPUT |-- (num_diffs_display) -----
    ### we want to extract the $diffs_byvar table from changed_data()
    observeEvent(input$go_changed_data, {
      if (!is.null(changed_data()[["diffs_byvar"]])) {
        output$num_diffs_display <- renderReactable({
          reactable(
            data = dplyr::select(
              changed_data()$diffs_byvar,
              `Variable name`,
              `Modified Values`
            ),
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
          reactable(
            data =
              dplyr::rename(
                empty_num_diffs,
                `Variable name` = variable,
                `Modified Values` = no_of_differences
              ),
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
        diffs_byvar <- tibble::as_tibble(changed_data()$diffs_byvar)
        # rename bs4Dash::column names
        rename(diffs_byvar,
          variable = `Variable name`,
          mod_values = `Modified Values`) |>
          # create graph
          ggplot2::ggplot(
            ggplot2::aes(
              x = fct_reorder(.f = variable, .x = mod_values),
              y =  mod_values,
              fill = variable
            )
          ) +
          ggplot2::geom_col(show.legend = FALSE) +
          ggplot2::coord_flip() +
          ggplot2::labs(
            title = "Number of Differences by Variable",
            x = "Variable",
            y = "Modified Values") +
          ggplot2::theme_minimal() -> num_diffs_graph

        num_diffs_graph

      })
    })

    ### |-- REACTIVE comp_var_diffs -------------------
    ### we want to extract the $diffs tibble from the changed_data() list
    comp_var_diffs <- eventReactive(input$go_review_changed_data, {
      if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
        # join to var_diffs
        left_join(
          x = changed_data()$diffs,
          y = comp_join_data(),
          by = "join_column"
        )
      } else {
        compare_row_by_row <- comp_join_data() %>%
          mutate(
            rownumber = row_number(),
            rownumber = as.character(rownumber)
          ) |>
          relocate(rownumber, .before = 1)
        # join to var_diffs
        left_join(
          x = changed_data()$diffs,
          y = compare_row_by_row,
          by = "rownumber"
        )
      }
    })

    ###  OUTPUT |-- (var_diffs_display) ----
    observeEvent(comp_var_diffs(), {
      if (!is.null(changed_data()[["diffs"]])) {
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
            variable = 0,
            join_column = 0,
            base = 0,
            compare = 0
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

   #### DOWNLOAD REPORT = report  ---------------
    output$download <- downloadHandler(

      filename = function() {
        paste(Sys.Date(), "-comparison-report",
              ".xlsx", sep = "")
      },
      content = function(file) {
        # create workbook
        comp_wb <- openxlsx::createWorkbook()

        # add sheets
        openxlsx::addWorksheet(wb = comp_wb,
                               sheetName = "New Data")
        openxlsx::addWorksheet(wb = comp_wb,
                               sheetName = "Deleted Data")
        openxlsx::addWorksheet(wb = comp_wb,
                               sheetName = "Changed Data")
        openxlsx::addWorksheet(wb = comp_wb,
                               sheetName = "Review Changes")

        #### DATA download ----
          if (sum(str_detect(string = compare_cols(), "^join_column")) > 0) {
             #### NEW DATA ----
             new <- create_new_data(
                compare = comp_join_data(),
                base = base_join_data(),
                by = "join_column"
              )
              #### DELETED DATA ----
              deleted <- create_deleted_data(
                compare = comp_join_data(),
                base = base_join_data(),
                by = "join_column"
              )
              #### CHANGED DATA ----
              #### we have two tibbles in changed_data(),
              #### $diffs_byvar and $diffs
              #### remove data_source from base and compare
              comp_join_data <- select(comp_join_data(), -data_source)
              base_join_data <- select(base_join_data(), -data_source)
              # changed_data
              # create changed_data with by bs4Dash::column
              changed_data <- create_modified_data(
                compare = comp_join_data,
                base = base_join_data,
                by = "join_column"
              )
              ##### num_diffs_dwnld ----
              num_diffs_dwnld <- dplyr::select(
              changed_data()$diffs_byvar,
              `Variable name`,
              `Modified Values`)
              ##### comp_var_diffs_dwnld ----
                comp_var_diffs_dwnld <- left_join(
                      x = changed_data()$diffs,
                      y = comp_join_data(),
                      by = "join_column"
                    )

          } else {
            #### NEW DATA ----
            new <- create_new_data(
              compare = comp_join_data(),
              base = base_join_data()
            )
            #### DELETED DATA ----
            deleted <- create_deleted_data(
              compare = comp_join_data(),
              base = base_join_data()
            )
            #### CHANGED DATA ----
            comp_join_data <- select(comp_join_data(), -data_source)
            base_join_data <- select(base_join_data(), -data_source)
            changed_data <- create_changed_data(
              compare = comp_join_data,
              base = base_join_data
            )
            ##### num_diffs_dwnld ----
            num_diffs_dwnld <-  dplyr::select(
              changed_data()$diffs_byvar,
              `Variable name`,
              `Modified Values`)
            ##### comp_var_diffs_dwnld ----
            ###### ROW-BY-ROW comparison ----
            comp_var_diffs_dwnld <- comp_join_data() |>
              mutate(
                rownumber = row_number(),
                rownumber = as.character(rownumber)
              ) |>
              relocate(rownumber, .before = 1)
              # join to var_diffs
              left_join(
                x = changed_data()$var_diffs,
                y = compare_row_by_row,
                by = "rownumber"
              )
          }
        #### write NEW DATA ----
        openxlsx::writeData(
          wb = comp_wb,
          sheet = "New Data",
          x = new,
          startCol = 1,
          startRow = 1
        )
        #### write DELETED DATA ----
        openxlsx::writeData(
          wb = comp_wb,
          sheet = "Deleted Data",
          x = deleted,
          startCol = 1,
          startRow = 1
        )
        #### write NUM DIFFS DATA ----
        openxlsx::writeData(
          wb = comp_wb,
          sheet = "Changed Data",
          x = num_diffs_dwnld,
          startCol = 1,
          startRow = 1
        )
        #### write VAR DIFFS DATA ----
        openxlsx::writeData(
          wb = comp_wb,
          sheet = "Review Changes",
          x = comp_var_diffs_dwnld,
          startCol = 1,
          startRow = 1
        )

        openxlsx::saveWorkbook(comp_wb, file = file, overwrite = TRUE)
      }
    )


  })
}
