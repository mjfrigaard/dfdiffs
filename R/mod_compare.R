#' mod_compare_ui
#'
#'
#' @importFrom bslib layout_column_wrap value_box card card_header card_body
#'   navset_card_tab nav_panel tooltip accordion accordion_panel
#'
#' @param id module id
#' @param dev show developer reactive-value outputs (default FALSE)
#'
#' @export mod_compare_ui
#'
#' @description compare UI module
mod_compare_ui <- function(id, dev = FALSE) {
  tagList(
    # KPI tiles ------
    bslib::layout_column_wrap(
      width = 1 / 2,
      fill = FALSE,
      bslib::value_box(
        title = textOutput(NS(id, "base_name")),
        value = textOutput(NS(id, "base_dims")),
        showcase = icon("table"),
        theme = "secondary",
        "Uploaded as base"
      ),
      bslib::value_box(
        title = textOutput(NS(id, "comp_name")),
        value = textOutput(NS(id, "comp_dims")),
        showcase = icon("table"),
        theme = "primary",
        "Uploaded as compare"
      )
    ),
    # Comparison Info ------
    bslib::card(
      bslib::card_header("How base and compare are matched"),
      bslib::card_body(
        fluidRow(
          column(
            width = 5,
            ## OUTPUT |-- (info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "info"
              )
            ),
            br(),
            reactable::reactableOutput(
              outputId = NS(
                namespace = id,
                id = "display_compare_cols"
              )
            )
          ),
          column(
            width = 7,
            downloadButton(outputId =
                NS(namespace = id, id = "download"),
              label = "Download Report", class = "btn-secondary")
          )
        )
      )
    ),
    # Results ------
    bslib::navset_card_tab(
      title = "Results",
      id = NS(namespace = id, id = "results_tabs"),
      # New Data ------
      bslib::nav_panel(
        title = "New Data",
        icon = icon("plus", style = "color:#2EC4B6;"),
        h5(
          "Rows in ", code("compare"), " not found in ", code("base"), ":"
        ),
        shiny::actionButton(
          inputId = NS(namespace = id, id = "go_new_data"),
          label = strong("Get new data!"),
          class = "btn-success"
        ),
        br(), br(),
        ## OUTPUT |-- (new_data_display) ------
        reactable::reactableOutput(
          outputId = NS(namespace = id, id = "new_data_display")
        )
      ),
      # Deleted Data ------
      bslib::nav_panel(
        title = "Deleted Data",
        icon = icon("minus", style = "color:#FF6F3C;"),
        h5(
          "Rows in ", code("base"), " not found in ", code("compare"), ":"
        ),
        shiny::actionButton(
          inputId = NS(namespace = id, id = "go_deleted_data"),
          class = "btn-danger",
          label = strong("Get deleted data!")
        ),
        br(), br(),
        ## OUTPUT |-- (deleted_data_display) ------
        reactable::reactableOutput(
          outputId = NS(namespace = id, id = "deleted_data_display")
        )
      ),
      # Changed Data ------
      bslib::nav_panel(
        title = "Changed Data",
        icon = icon("pen", style = "color:#8A6D00;"),
        h5(
          "Values that differ between ", code("base"), " and ", code("compare"), ":"
        ),
        shiny::actionButton(
          inputId = NS(namespace = id, id = "go_changed_data"),
          class = "btn-warning",
          label = strong("Get changed data!")
        ),
        br(), br(),
        p(strong("Differences by Variable:")),
        fluidRow(
          column(
            width = 5,
            ## OUTPUT |-- (num_diffs_display) ------
            reactable::reactableOutput(
              outputId = NS(namespace = id, id = "num_diffs_display")
            )
          ),
          column(
            width = 7,
            ## OUTPUT |-- (num_diffs_graph) ------
            plotOutput(outputId = NS(namespace = id, id = "num_diffs_graph"))
          )
        )
      ),
      # Review Changes ------
      bslib::nav_panel(
        title = "Review Changes",
        icon = icon("magnifying-glass", style = "color:#8A6D00;"),
        h5(
          "Row-by-row changes between ", code("base"), " and ", code("compare"),
          bslib::tooltip(
            icon("circle-info"),
            paste(
              "join_source is the column(s) used to join base and compare.",
              "data_source is the original file name of base and compare."
            )
          ),
          ":"
        ),
        ## OUTPUT |-- (go_changed_data) ------
        shiny::actionButton(
          inputId = NS(namespace = id, id = "go_review_changed_data"),
          class = "btn-warning",
          label = strong("Review changed data!")
        ),
        br(), br(),
        ## OUTPUT |-- (var_diffs_display) ------
        reactable::reactableOutput(
          outputId = NS(namespace = id, id = "var_diffs_display")
        )
      )
    ),
    if (dev) {
      bslib::accordion(
        id = NS(namespace = id, id = "compare_dev_accordion"),
        bslib::accordion_panel(
          title = "Reactive values",
          icon = icon("bug"),
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              strong(code("dev_a"), "=", code("base_join_data()")),
              verbatimTextOutput(
                outputId = NS(namespace = id, id = "dev_a")
              )
            )
          ),
          fluidRow(
            column(
              12,
              strong(code("dev_b"), "=", code("comp_join_data()")),
              verbatimTextOutput(
                outputId = NS(namespace = id, id = "dev_b")
              )
            )
          ),
          fluidRow(
            column(
              12,
              strong(code("dev_c"), "=", code("comp_var_diffs()")),
              verbatimTextOutput(
                outputId = NS(namespace = id, id = "dev_c")
              )
            )
          )
        )
      )
    }
  )
}

#' mod_compare_server
#'
#' @param id module id
#' @param dev show developer reactive-value outputs (default FALSE)
#'
#' @export mod_compare_server
#'
#' @description compare server module
mod_compare_server <- function(id, data_selected, dev = FALSE) {
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
      compare_cols_tbl <- dplyr::filter(
        compare_cols_tbl,
        `Compare Columns` %nin% c("join_column", "data_source", "join_source")
      )
      return(compare_cols_tbl)
    })
    #### DEV OUTPUT |--  (dev_a/dev_b) ---------
    if (dev) {
      output$dev_a <- renderPrint({
        print(
          base_join_data()
        )
      })
      output$dev_b <- renderPrint({
        print(
          comp_join_data()
        )
      })
    }
    ## INFO ----------------------------
    ### OUTPUT |-- KPI tiles (base_name/base_dims/comp_name/comp_dims) ---------
    output$base_name <- renderText({
      unique(base_join_data()$data_source)
    })
    output$base_dims <- renderText({
      paste0(nrow(base_join_data()), " rows × ", ncol(base_join_data()), " cols")
    })
    output$comp_name <- renderText({
      unique(comp_join_data()$data_source)
    })
    output$comp_dims <- renderText({
      paste0(nrow(comp_join_data()), " rows × ", ncol(comp_join_data()), " cols")
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
    output$display_compare_cols <- reactable::renderReactable({
      reactable::reactable(
        data = compare_cols_tbl(),
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        defaultPageSize = 5,
        theme = reactable::reactableTheme(
          color = "#011627",
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
    ### |-- OUTPUT (new_data_display) -----------
    observeEvent(input$go_new_data, {
      output$new_data_display <- reactable::renderReactable({
        reactable::reactable(
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
    ### |-- OUTPUT (deleted_data_display) ------------------
    observeEvent(input$go_deleted_data, {
      output$deleted_data_display <- reactable::renderReactable({
        reactable::reactable(
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
      # join column
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
        # no join column
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
    if (dev) {
      output$dev_c <- renderPrint({
        print(
          comp_var_diffs()
        )
      })
    }
    ### OUTPUT |-- (num_diffs_display) -----
    ### we want to extract the $diffs_byvar table from changed_data()
    observeEvent(input$go_changed_data, {
      if (!is.null(changed_data()[["diffs_byvar"]])) {
        output$num_diffs_display <- reactable::renderReactable({
          reactable::reactable(
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
        output$num_diffs_display <- reactable::renderReactable({
          empty_num_diffs <- tibble::tibble(
            variable = 0, no_of_differences = 0
          )
          reactable::reactable(
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
        # rename column names
        rename(diffs_byvar,
          variable = `Variable name`,
          mod_values = `Modified Values`) |>
          # create graph
          ggplot2::ggplot(
            ggplot2::aes(
              x = forcats::fct_reorder(.f = variable, .x = mod_values),
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
        dplyr::left_join(
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
        dplyr::left_join(
          x = changed_data()$diffs,
          y = compare_row_by_row,
          by = "rownumber"
        )
      }
    })

    ###  OUTPUT |-- (var_diffs_display) ----
    observeEvent(comp_var_diffs(), {
      if (!is.null(changed_data()[["diffs"]])) {
        output$var_diffs_display <- reactable::renderReactable({
          reactable::reactable(
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
        output$var_diffs_display <- reactable::renderReactable({
          empty_var_diffs <- tibble::tibble(
            variable = 0,
            join_column = 0,
            base = 0,
            compare = 0
          )
          reactable::reactable(
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
              # create changed_data with by column
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
                comp_var_diffs_dwnld <- dplyr::left_join(
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
              dplyr::left_join(
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
