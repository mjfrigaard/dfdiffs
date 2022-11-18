
# packages ----------------------------------------------------------------
library(fresh)

library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(shiny)
library(shinythemes)
library(bs4Dash)


source("helpers.R")

# uploadDataUI --------
uploadDataUI <- function(id) {
  tagList(
    h3("Upload a ", strong("base"), " (i.e., target) data source "),
    fluidRow(
      sortable(
        width = 12,
        # |- upload base xlsx file ----
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          title = tags$strong("Upload File (base)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [base_file] -------
                inputId = NS(
                  namespace = id,
                  id = "base_file"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"),
                  code(".txt"), code(".tsv"), code(".xlsx")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            column(
              width = 6,
              ### |-- INPUT [base_xlsx_sheets] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "base_xlsx_sheets"
                ),
                label = strong("Select sheet (if ", code(".xlsx"), " file):"),
                choices = c("", NULL)
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [base_filename] ---------
              tags$strong("Data file name:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_filename"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [base_new_name] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "base_new_name"
                ),
                label = strong(
                  "Provide a name to preview the", code("base"), " file:"
                )
              ),
              em("Not sure what name to use? Copy + paste the file name."),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [base_display_upload] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_display_upload"
                )
              )
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## base_dev_a -----
              code("base_dev_a"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_b -----
              code("base_dev_b"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_x -----
              code("base_dev_x"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_x"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_y -----
              code("base_dev_y"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_y"
                )
              )
            )
          )
        )
      )
    ),
    h3("Upload a ", strong("compare"), " (i.e., current) data source"),
    # br(), br(),
    fluidRow(
      sortable(
        width = 12,
        # |- upload compare xlsx file ----
        box(
          maximizable = TRUE,
          collapsed = FALSE,
          solidHeader = TRUE,
          status = "secondary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload File (compare)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [comp_file] -------
                inputId = NS(
                  namespace = id,
                  id = "comp_file"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"),
                  code(".txt"), code(".tsv"), code(".xlsx")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [comp_xlsx_sheets] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "comp_xlsx_sheets"
                ),
                label = strong("Select sheet (if ", code(".xlsx"), " file):"),
                choices = c("", NULL)
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [comp_filename] ---------
              tags$strong("Data file name:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_filename"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [comp_new_name] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "comp_new_name"
                ),
                label = strong(
                  "Provide a name to preview the ", code("compare"), " file:"
                )
              ),
              em("Not sure what name to use? Copy + paste the file name."),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [comp_display_upload] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_display_upload"
                )
              )
            )
          )
        )
      )
    ),
    ## DEV -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (compare)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## comp_dev_a -----
              code("comp_dev_a"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_b -----
              code("comp_dev_b"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_x -----
              code("comp_dev_x"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_x"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_y -----
              code("comp_dev_y"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_y"
                )
              )
            )
          )
        )
      )
    )
  )
}


# uploadDataServer --------------------------------------------------------
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


# selectDataUI ------------------------------------------------------------
selectDataUI <- function(id) {
  tagList(
    h3("Select columns from ", strong("base"), "data"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          status = "primary",
          width = 12,
          title = tags$strong("Select Base Data"),
          ## |-- INPUT [base_col_select] ---------
          ## displays the columns from the imported dataset
          br(),
          selectizeInput(
            inputId = NS(
              namespace = id,
              id = "base_col_select"
            ),
            label = strong("Select ", code("base"), " columns"),
            choices = c("", NULL),
            multiple = TRUE,
            selected = NULL
          ),
          ## |-- OUTPUT [base_data_display] ---------
          ## displays uploaded/named/selected data
          strong("Base Data"),
          br(), br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "base_data_display"
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## base_dev_a -----
              strong(code("base_dev_a"), "=", code("base_data()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_b -----
              strong(code("base_dev_b"), "=", code("base_name()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_c -----
              strong(code("base_dev_c"), "=", code("input$base_col_select")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_c"
                )
              )
            )
          )
        )
      )
    ),
    h3("Select columns from ", strong("compare"), "data"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          closable = FALSE,
          status = "secondary",
          width = 12,
          title = tags$strong("Select Compare Data"),
          ## |-- INPUT [comp_col_select] ---------
          ## displays the columns from the imported dataset
          br(),
          selectizeInput(
            inputId = NS(
              namespace = id,
              id = "comp_col_select"
            ),
            label = strong("Select ", code("compare"), " columns"),
            choices = c("", NULL),
            multiple = TRUE,
            selected = c("", NULL)
          ),
          ## |-- OUTPUT [comp_data_display] ---------
          ## displays uploaded/named/selected data
          strong("Compare Data"),
          br(), br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "comp_data_display"
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (comp)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## comp_dev_a -----
              strong(code("comp_dev_a"), "=", code("comp_data()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_b -----
              strong(code("comp_dev_b"), "=", code("comp_name()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_c -----
              strong(code("comp_dev_c"), "=", code("input$comp_col_select")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_c"
                )
              )
            )
          )
        )
      )
    ),
    h3("Select join columns between ", strong("base"), " and ", strong("compare")),
    br(),
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          solidHeader = FALSE,
          collapsed = TRUE,
          status = "info",
          width = 12,
          title = strong("Select Join Columns"),
          fluidRow(
            column(
              width = 5,
              h5(
                strong(
                  em("Intersecting columns:")
                )
              ),
              br(),
              ## OUTPUT |-- (intersecting_cols) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "intersecting_cols"
                )
              )
            ),
            column(
              width = 6,
              h5(
                strong(
                  em("Select Joining Column(s)")
                )
              ),
              ## INPUT |-- (by) ------
              selectizeInput(
                inputId = NS(
                  namespace = id,
                  id = "by"
                ),
                label =
                  em(
                    "Select the column (or columns) that create a unique observation between ",
                    code("base"), "and ", code("compare"), ""
                  ),
                choices = c("", NULL),
                multiple = TRUE,
                selected = c("", NULL)
              ),
              em(
                "The join column will be named", code("join_column"),
                "Leave blank for a row-by-row comparison"
              ),
              br(), br(),
              strong(
                "The final ", code("base"), " and ",
                code("compare"), "data are displayed below to review"
              )
              # h5( ## placeholder for 'Name Joining Column(s)'
              # ),
            )
          )
        )
      ),
      sortable(
        bs4Dash::box(
          width = 12,
          title = strong(code("base"), " data (for comparison)"),
          solidHeader = FALSE,
          maximizable = TRUE,
          collapsed = TRUE,
          status = "primary",
          fluidRow(
            column(
              width = 12,
              ## OUTPUT |-- (comp_join_col_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_join_col_display"
                )
              )
            )
          )
        )
      ),
      bs4Dash::sortable(
        bs4Dash::box(
          width = 12,
          title = strong(code("compare"), " data (for comparison)"),
          solidHeader = FALSE,
          collapsed = TRUE,
          maximizable = TRUE,
          status = "secondary",
          fluidRow(
            column(
              width = 12,
              ## OUTPUT |-- (comp_join_col_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_join_col_display"
                )
              )
            )
          )
        )
      ),
    )
  )
}


# selectDataServer --------------------------------------------------------
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
    ## DEV OUTPUT |-- base_dev_x (dev) ---------
    output$base_dev_a <- renderPrint({
      print(
        base_data()
      )
    })
    ## DEV OUTPUT |-- base_dev_y (dev) ---------
    output$base_dev_b <- renderPrint({
      print(
        base_name()
      )
    })
    ## DEV OUTPUT |-- base_dev_a (dev) ---------
    output$base_dev_c <- renderPrint({
      print(
        names(base_select())
      )
    })
    ## BASE OUTPUT |-- base_data_display (display) ---------
    output$base_data_display <- reactable::renderReactable({
      req(input$base_col_select)
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
        comp_data()
      )
    })
    ## |-- DEV OUTPUT |-- comp_dev_y (dev) ---------
    output$comp_dev_b <- renderPrint({
      print(
        comp_name()
      )
    })
    ## |-- DEV OUTPUT |-- comp_dev_a (dev) ---------
    output$comp_dev_c <- renderPrint({
      print(
        input$comp_col_select
      )
    })

    ## |-- COMP OUTPUT |-- comp_data_display (display) ---------
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
    # base_join_col_data <- eventReactive(input$by, {
    base_join_col_data <- reactive({
      # no by col, no new name
      if (length(input$by) != 0) {
        base_join_col <- create_join_column(
          df = base_select(),
          by_colums = input$by,
          new_by_column_name = "join_column"
        )
        base_join_col <- select(base_join_col,
          join_column, all_of(col_intersect()$Columns))
      } else {
        base_join_col <- base_select()
        # no by col, new name
        base_join_col <- select(base_join_col,
          all_of(col_intersect()$Columns))
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
    # comp_join_col_data <- eventReactive(input$by, {
    comp_join_col_data <- reactive({
      # no by col, no new name
      if (length(input$by) != 0) {
        comp_join_col <- create_join_column(
          df = comp_select(),
          by_colums = input$by,
          new_by_column_name = "join_column"
        )
        comp_join_col <- select(comp_join_col,
          join_column, all_of(col_intersect()$Columns))
      } else {
        comp_join_col <- comp_select()
        # no by col, new name
        comp_join_col <- select(comp_join_col,
          all_of(col_intersect()$Columns))
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
            if (length(input$by) != 0) {
              base_join_col <- create_join_column(
                df = base_select(),
                by_colums = input$by,
                new_by_column_name = "join_column"
              )
              # only intersecting columns
              base_join_col <- dplyr::select(base_join_col,
                join_column, all_of(col_intersect()$Columns))
              # join column
              base_join_col <- tibble::add_column(.data = base_join_col,
                join_source = input$by, .after = 1)
              # data source column
              base_join_col <- tibble::add_column(.data = base_join_col,
                data_source = base_name(), .after = 1)
            } else {
              # no by col, new name
              base_join_col <- base_select()
              base_join_col <- select(base_join_col,
                all_of(col_intersect()$Columns))
              # join column
              base_join_col <- tibble::add_column(.data = base_join_col,
                join_source = input$by, .after = 1)
              # data source column
              base_join_col <- tibble::add_column(.data = base_join_col,
                data_source = base_name(), .after = 1)
            }
          return(base_join_col)
        }),
        ## comp_join_col_data -----
        comp_join_col_data = reactive({
          # no by col, no new name
          if (length(input$by) != 0) {
            comp_join_col <- create_join_column(
              df = comp_select(),
              by_colums = input$by,
              new_by_column_name = "join_column"
            )
            # only intersecting columns
            comp_join_col <- select(comp_join_col,
              join_column, all_of(col_intersect()$Columns))
            # data source column
            comp_join_col <- tibble::add_column(.data = comp_join_col,
                join_source = input$by, .after = 1)
            # data source column
            comp_join_col <- tibble::add_column(.data = comp_join_col,
                data_source = comp_name(), .after = 1)
          } else {
             # no by col, new name
            comp_join_col <- comp_select()
            # only intersecting columns
            comp_join_col <- select(comp_join_col,
              all_of(col_intersect()$Columns))
            # data source column
            comp_join_col <- tibble::add_column(.data = comp_join_col,
                join_source = input$by, .after = 1)
            # data source column
            comp_join_col <- tibble::add_column(.data = comp_join_col,
                data_source = comp_name(), .after = 1)
          }
          return(comp_join_col)
        })
      )
    )
  })
}


# select_data_theme -------------------------------------------------------
select_data_theme <- bmrn_fresh_theme()

# selectDataDemo ----------------------------------------------------------
selectDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    title = "selectDataDemo",
    dark = FALSE,
    freshTheme = select_data_theme,
    header = bs4Dash::dashboardHeader(title = "selectDataDemo"),
    # sidebar (menuItem) ------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      bs4Dash::sidebarMenu(
        id = "sidebarmenu",
        bs4Dash::sidebarHeader("Data upload demo"),
        menuItem("Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file")
        ),
        menuItem("Select Data",
          tabName = "select_data_tab",
          icon = icon("table")
        )
      )
    ),
    # dashboardBody (tabItem) ------
    body = bs4Dash::dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## uploadDataUI -----
          uploadDataUI(id = "upload_data")
        ),
        tabItem(
          tabName = "select_data_tab",
          ## selectDataUI -----
          selectDataUI(id = "select_data"),
          ## reactive values -----
          fluidRow(
            sortable(
              width = 12,
              box(
                width = 12,
                status = "info",
                solidHeader = TRUE,
                closable = TRUE,
                maximizable = TRUE,
                collapsible = TRUE,
                collapsed = TRUE,
                title = "Reactive values",
                ## values -----
                verbatimTextOutput(
                  outputId = "upload_values"
                )
              )
            )
          )
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # upload data ------------------------------------------------
    upload_data_list <- uploadDataServer(id = "upload_data")
    # display data ------------------------------------------------
    select_data_list <- selectDataServer(id = "select_data",
                                         data_upload = upload_data_list)
    # reactive values ------------------------------------------------
    output$upload_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- str_detect(names(all_values), "upload_data")
      module_values <- all_values[module_names]
      reactable_names <- str_detect(
        names(module_values),
        "__reactable__",
        negate = TRUE
      )
      values <- module_values[reactable_names]
      print(values)
    })
  }
  shinyApp(
    ui = ui, server = server,
    options = list(height = 1200, width = 900)
  )
}

# run selectDataDemo ------------------------------------------------------
selectDataDemo()
