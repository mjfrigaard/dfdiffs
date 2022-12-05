# helpers -----------------------------------------------------------------
source("helpers.R")
# dev_uploadDataUI --------
dev_uploadDataUI <- function(id) {
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
# dev_uploadDataServer ----------------------------------------------------
dev_uploadDataServer <- function(id) {
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
# dev_selectDataUI --------------------------------------------------------
dev_selectDataUI <- function(id) {
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
            bs4Dash::column(
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
            bs4Dash::column(
              12,
              ## base_dev_b -----
              strong(code("base_dev_b"), "=", code("input$by")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_b"
                )
              )
            )
          ),
          fluidRow(
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
              12,
              ## comp_dev_b -----
              strong(code("comp_dev_b"), "=", code("input$by")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_b"
                )
              )
            )
          ),
          fluidRow(
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
                    "Select the bs4Dash::column (or columns) that create a unique observation between ",
                    code("base"), "and ", code("compare"), ""
                  ),
                choices = c("", NULL),
                multiple = TRUE,
                selected = c("", NULL)
              ),
              em(
                "The join bs4Dash::column will be named", code("join_column"),
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
            bs4Dash::column(
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
            bs4Dash::column(
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
# dev_selectDataServer ----------------------------------------------------
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
    # base_join_col_data <- eventReactive(input$by, {
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
    # comp_join_col_data <- eventReactive(input$by, {
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
            by_cols <- paste0(input$by, collapse = "-")
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
            # join bs4Dash::column
            base_join_col <- tibble::add_column(
              .data = base_join_col,
              join_source = by_cols, .after = 1
            )
            # data source bs4Dash::column
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
            # data source bs4Dash::column
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
            by_cols <- paste0(input$by, collapse = "-")
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
            # data source bs4Dash::column
            comp_join_col <- tibble::add_column(
              .data = comp_join_col,
              join_source = by_cols, .after = 1
            )
            # data source bs4Dash::column
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
            # data source bs4Dash::column
            comp_join_col <- tibble::add_column(
              .data = comp_join_col,
              data_source = comp_name(), .after = 1
            )
          }
          return(comp_join_col)
        })
      )
    )
    # return(
    #   list(
    #     ## base_join_col_data -----
    #     base_join_col_data = reactive({
    #       if (length(input$by) != 0) {
    #       base_join_col <- create_join_column(
    #         df = base_select(),
    #         by_colums = input$by,
    #         new_by_column_name = "join_column"
    #       )
    #       base_join_col <- select(
    #         base_join_col,
    #         join_column, all_of(col_intersect()$Columns)
    #       )
    #       } else {
    #         base_join_col <- base_select()
    #         # no by col, new name
    #         base_join_col <- select(
    #           base_join_col,
    #           all_of(col_intersect()$Columns)
    #       )
    #     }
    #     }),
    #     comp_join_col_data = reactive({
    #       # no by col, no new name
    #       if (length(input$by) != 0) {
    #         comp_join_col <- create_join_column(
    #           df = comp_select(),
    #           by_colums = input$by,
    #           new_by_column_name = "join_column"
    #         )
    #         comp_join_col <- select(
    #           comp_join_col,
    #           join_column, all_of(col_intersect()$Columns)
    #         )
    #       } else {
    #         comp_join_col <- comp_select()
    #         # no by col
    #         comp_join_col <- select(
    #           comp_join_col,
    #           all_of(col_intersect()$Columns)
    #         )
    #       }
    #     })
    #   )
    # )

  })
}
# dev_compareDataUI -------------------------------------------------------
dev_compareDataUI <- function(id) {
  tagList(
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        # Comparison Info ------
        title = strong("Comparison Info"),
        solidHeader = TRUE,
        maximizable = TRUE,
        collapsed = FALSE,
        status = "info",
        fluidRow(
          bs4Dash::column(
            width = 6,
            h5(
              "The comparison information between", code("base"),
              " and ", code("compare"), " is below:"
            ),
            ## INPUT |-- (base_info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "base_info"
              )
            ),
            br(),
            ## OUTPUT |-- (comp_info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "comp_info"
              )
            )
          ),
          bs4Dash::column(
            6,
            ## OUTPUT |-- (info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "info"
              )
            ),
            br(),
            ## OUTPUT |-- (display_compare_cols) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "display_compare_cols"
              )
            )
          )
        )
      )
    ),
    # New Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("New Data"),
        solidHeader = TRUE,
        maximizable = TRUE,
        collapsed = TRUE,
        status = "success",
        fluidRow(
          sortable(
            width = 12,
            bs4Dash::column(
              width = 12,
              ## INPUT |-- (go_new_data) ------
              h5(
                "The new data between", code("base"),
                " and ", code("compare"), " are below:"
              ),
              shiny::actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_new_data"
                ),
                label = strong("Get new data!"),
                status = "success"
              ),
              br(), br(),
              ## OUTPUT |-- (new_data_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "new_data_display"
                )
              )
            )
          )
        )
      )
    ),
    # Deleted Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Deleted Data"),
        solidHeader = TRUE,
        collapsed = TRUE,
        maximizable = TRUE,
        status = "danger",
        fluidRow(
          sortable(
            width = 12,
            bs4Dash::column(
              width = 12,
              h5(
                "The deleted data between", code("base"),
                " and ", code("compare"), " are below:"
              ),
              ## INPUT |-- (go_deleted_data) ------
              shiny::actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_deleted_data"
                ),
                status = "danger",
                label = strong("Get deleted data!")
              ),
              br(), br(),
              ## OUTPUT |-- (deleted_data_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "deleted_data_display"
                )
              )
            )
          )
        )
      )
    ),
    # Changed Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Changed Data"),
        solidHeader = TRUE,
        collapsed = TRUE,
        maximizable = TRUE,
        status = "warning",
        fluidRow(
          bs4Dash::column(
            width = 12,
            ## OUTPUT |-- (go_changed_data) ------
            h5(
              "The changed data between", code("base"),
              " and ", code("compare"), " are below:"
            ),
            shiny::actionButton(
              inputId = NS(
                namespace = id,
                id = "go_changed_data"
              ),
              status = "warning",
              label = strong("Get changed data!")
            )
          )
        ),
        br(), br(),
        p(strong("Differences by Variable:")),
        fluidRow(
          bs4Dash::column(
            width = 5,
            ## OUTPUT |-- (num_diffs_display) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "num_diffs_display"
              )
            )
          ),
          bs4Dash::column(
            width = 7,
            ## OUTPUT |-- (num_diffs_graph) ------
            plotOutput(outputId = NS(
              namespace = id,
              id = "num_diffs_graph"
            ))
          )
        )
      )
    ),
    # Changed Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Review Changes"),
        solidHeader = TRUE,
        collapsed = TRUE,
        maximizable = TRUE,
        status = "warning",
        fluidRow(
          bs4Dash::column(
            width = 12,
            h5(
              "Review the changes between", code("base"),
              " and ", code("compare"), " below:"
            ),
            ## OUTPUT |-- (go_changed_data) ------
            shiny::actionButton(
              inputId = NS(
                namespace = id,
                id = "go_review_changed_data"
              ),
              status = "warning",
              label = strong("Review changed data!")
            ),
            br(), br(),
            p(strong("The ",
              code("compare"),
              " columns have been included with the row-by-row changes:")),
            fluidRow(
              bs4Dash::column(
                width = 12,
                ## OUTPUT |-- (var_diffs_display) ------
                reactableOutput(
                  outputId = NS(
                    namespace = id,
                    id = "var_diffs_display"
                    )
                  )
                )
              )
            )
          )
        )
      ),
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
          bs4Dash::column(
            12,
            ## dev_a -----
            strong(code("dev_a"), "=", code("base_join_data()")),
            verbatimTextOutput(
              outputId = NS(
                namespace = id,
                id = "dev_a"
              )
            )
          )
        ),
        fluidRow(
          bs4Dash::column(
            12,
            ## dev_b -----
            strong(code("dev_b"), "=", code("comp_join_data()")),
            verbatimTextOutput(
              outputId = NS(
                namespace = id,
                id = "dev_b"
              )
            )
          )
        ),
        fluidRow(
          bs4Dash::column(
            12,
            ## dev_c -----
            strong(code("dev_c"), "=", code("compare_cols()")),
            verbatimTextOutput(
              outputId = NS(
                namespace = id,
                id = "dev_c"
              )
            )
          )
        )
      )
    )
  )
}
# dev_compareDataServer ---------------------------------------------------
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

    ## INFO --------------------------------------------------------------------    #### DEV OUTPUT |--  (dev_a) ---------
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
      # join bs4Dash::column
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
        # no join bs4Dash::column
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
    comp_var_diffs <- eventReactive(input$go_review_changed_data, {
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
# compareDataDemo ---------------------------------------------------------
#' compareDataDemo()
#'
#' @return UI module
#' @export compareDataDemo
#'
compareDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    skin = "light",
    freshTheme = compare_theme,
    title = "(dev) compareDataApp",
    header = bs4Dash::dashboardHeader(
      title = "(dev) compareDataApp",
      status = "secondary"
    ),
    # sidebar (menuItem) -------------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      minified = TRUE,
      expandOnHover = TRUE,
      bs4Dash::sidebarMenu(
        id = "sidebarmenu",
        # bs4Dash::sidebarHeader("Data upload demo"),
        menuItem("1) Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file-upload")
        ),
        menuItem("2) Select Data",
          tabName = "select_data_tab",
          icon = icon("columns")
        ),
        menuItem("3) Compare Data",
          tabName = "compare_data_tab",
          icon = icon("compress-alt")
        ),
        menuItem("About",
          tabName = "about_tab",
          icon = icon("book-open")
        )
      )
    ),
    # dashboardBody (tabItem) ----------
    body = bs4Dash::dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## dev_uploadDataUI -----
          dev_uploadDataUI(id = "upload_data"),
        ),
        tabItem(
          tabName = "select_data_tab",
          ## dev_selectDataUI -----
          dev_selectDataUI(id = "select_data")
        ),
        tabItem(
          tabName = "compare_data_tab",
          ## dev_compareDataUI -----
          dev_compareDataUI("compare_data")
        ),
        tabItem(
          tabName = "about_tab",
          ## about.md -----
          shiny::includeMarkdown("assets/about.md")
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(
      width = 320,
      pinned = TRUE,
      collapsed = FALSE,
      skin = "light",
      bs4Dash::column(
        width = 12,
        br(),
        shiny::includeMarkdown(path = "assets/intro.md")
        )
      ),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # dev_uploadDataServer --------------------
    upload_data_list <- dev_uploadDataServer(id = "upload_data")
    # dev_selectDataServer --------------------
    select_data_list <- dev_selectDataServer(
      id = "select_data",
      data_upload = upload_data_list
    )
    # dev_compareDataServer ------------------
    dev_compareDataServer(
      id = "compare_data",
      data_selected = select_data_list
    )
  }

  shinyApp(
    ui = ui, server = server
  )
}
