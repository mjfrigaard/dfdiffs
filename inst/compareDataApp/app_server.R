# packages ----------------------------------------------------------------
library(knitr)
library(arsenal)
library(diffdf)
library(stringr)
library(janitor)
library(dplyr)
library(tidyr)
library(tibble)
library(ggplot2)
library(forcats)
library(lubridate)
library(purrr)
library(rmdformats)
library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(markdown)
library(shiny)
library(shinythemes)
library(bs4Dash)
library(fresh)
library(RColorBrewer)

# uploadDataServer ----------------------------------------------------
#' uploadDataServer()
#'
#' @param id module id
#'
#' @export uploadDataServer
#'
#' @description development Server module for upload
uploadDataServer <- function(id) {
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
    # output$base_dev_a <- renderPrint({
    #   print(
    #     paste0("input$base_filename = ", input$base_file$name)
    #   )
    # })
    ## DEV OUTPUT |-- (base_dev_b) ---------
    # output$base_dev_b <- renderPrint({
    #   print(
    #     base_data()
    #   )
    # })
    ## DEV OUTPUT |-- (base_dev_x) ---------
    # output$base_dev_x <- renderPrint({
    #   print(
    #     paste0("input$base_xlsx_sheets = ", as.character(input$base_xlsx_sheets))
    #   )
    # })
    ## DEV OUTPUT |-- (base_dev_y) ---------
    # output$base_dev_y <- renderPrint({
    #   print(
    #     paste0("input$base_new_name = ", as.character(input$base_new_name))
    #   )
    # })


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

    # ## DEV OUTPUT |-- (comp_dev_a) ---------
    # output$comp_dev_a <- renderPrint({
    #   print(
    #     paste0("input$comp_filename = ", as.character(input$comp_file$name))
    #   )
    # })
    # ## DEV OUTPUT |-- comp_dev_y (dev) ---------
    # output$comp_dev_b <- renderPrint({
    #   print(
    #     comp_data()
    #   )
    # })
    # ## DEV OUTPUT |-- comp_dev_a (dev) ---------
    # output$comp_dev_x <- renderPrint({
    #   print(
    #     paste0("input$comp_xlsx_sheets = ", as.character(input$comp_xlsx_sheets))
    #   )
    # })
    # ## DEV OUTPUT |-- comp_dev_b (dev) ---------
    # output$comp_dev_y <- renderPrint({
    #   print(
    #     paste0("input$comp_new_name = ", as.character(input$comp_new_name))
    #   )
    # })

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

# selectDataServer ----------------------------------------------------
#' selectDataServer
#'
#' @param id module id
#'
#' @export selectDataServer
#'
#' @description select server module
selectDataServer <- function(id, data_upload) {
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
    # ## DEV OUTPUT |-- base_dev_x (dev) ---------
    # output$base_dev_a <- renderPrint({
    #   print(
    #     base_select()
    #   )
    # })
    # ## DEV OUTPUT |-- base_dev_y (dev) ---------
    # output$base_dev_b <- renderPrint({
    #   print(
    #     paste0(input$by, collapse = "-")
    #   )
    # })
    # ## DEV OUTPUT |-- base_dev_a (dev) ---------
    # output$base_dev_c <- renderPrint({
    #   print(
    #     as.character(input$base_col_select)
    #   )
    # })
    ## BASE OUTPUT |-- base_data_display (display) ---------
    output$base_data_display <- reactable::renderReactable({
      req(input$base_col_select)
      validate(
        need(base_data(), "please upload data")
      )
      reactable::reactable(
        data = select(
          base_data(),
          all_of(input$base_col_select)
        ),
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
    # ## |-- DEV OUTPUT |-- comp_dev_x (dev) ---------
    # output$comp_dev_a <- renderPrint({
    #   print(
    #     comp_select()
    #   )
    # })
    # ## |-- DEV OUTPUT |-- comp_dev_y (dev) ---------
    # output$comp_dev_b <- renderPrint({
    #   print(
    #     paste0(input$by, collapse = "-")
    #   )
    # })
    # ## |-- DEV OUTPUT |-- comp_dev_a (dev) ---------
    # output$comp_dev_c <- renderPrint({
    #   print(
    #     as.character(input$comp_col_select)
    #   )
    # })

    ## |-- COMP OUTPUT |-- comp_data_display (display) ---------
    output$comp_data_display <- reactable::renderReactable({
      req(input$comp_col_select)
      validate(
        need(comp_data(), "please upload data")
      )
      reactable::reactable(
        data = select(
          comp_data(),
          all_of(input$comp_col_select)
        ),
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

# compareDataServer ----------------------------------
#' compareDataServer
#'
#' @param id module id
#'
#' @export compareDataServer
#'
#' @description compare server module
compareDataServer <- function(id, data_selected) {
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
    # #### DEV OUTPUT |--  (dev_a) ---------
    # output$dev_a <- renderPrint({
    #   print(
    #     base_join_data()
    #   )
    # })
    # #### DEV OUTPUT |--  (dev_b) ---------
    # output$dev_b <- renderPrint({
    #   print(
    #     comp_join_data()
    #   )
    # })
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
    # #### DEV OUTPUT |--  (dev_c) ---------
    # output$dev_c <- renderPrint({
    #   print(
    #     changed_data()
    #   )
    # })
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
        # rename column names
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
