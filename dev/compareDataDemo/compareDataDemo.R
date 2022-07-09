source("helpers.R")
source("uploadDataUI.R")
source("uploadDataServer.R")
source("selectDataUI.R")
source("selectDataServer.R")

# compareDataUI -----------------------------------------------------------
compareDataUI <- function(id) {
  tagList(
    bs4Dash::sortable(
      width = 12,
      bs4Dash::box(
        solidHeader = TRUE,
        status = "info",
        width = 12,
        title = strong("Join columns"),
        fluidRow(
          column(
            width = 5,
            ## OUTPUT |-- (intersecting_cols) ------
            h5(
              strong(
                em("The following columns are in both tables:")
              )
            ),
            br(),
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "intersecting_cols"
              )
            )
          ),
          column(
            width = 6,
            ## INPUT |-- (by) ------
            h5(
              strong(
                em("Select Join Columns")
              )
            ),
            selectizeInput(
              inputId = NS(
                namespace = id,
                id = "by"
              ),
              label = "Select the column (or columns) to create a unique id",
              choices = c("", NULL),
              multiple = TRUE,
              selected = c("", NULL)
            ),
          em("Leave blank for a row-by-row comparison"),
            ## INPUT |-- (by_col) ------
            br(), br(),
            h5(
              strong(
                em("Join Column Name")
              )
            ),
            textInput(
              inputId = NS(namespace = id, id = "by_col"),
              label = "New join column name",
              value = NULL
            ),
          em("If no name is provided, the join column will be named",
            code("join")),
          )
        )
      )
    ),
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("The ", code("base"), " data"),
        solidHeader = FALSE,
        collapsed = TRUE,
        status = "primary",
        fluidRow(
          column(
            width = 12,
            ## OUTPUT |-- (base_join_col_display) ------
            # br(),
            # h5(strong(
            #   em("The ", code("base"), " data are displayed below"))),
            # br(),
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
        title = strong("The ", code("compare"), " data"),
        solidHeader = FALSE,
        collapsed = TRUE,
        status = "secondary",
        fluidRow(
          column(
            width = 12,
            ## OUTPUT |-- (comp_join_col_display) ------
            # br(),
            # h5(strong(
            #   em("The ", code("compare"), " data are displayed below"))),
            # br(),
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
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("New Data"),
        solidHeader = FALSE,
        collapsed = TRUE,
        status = "success",
        fluidRow(
          sortable(
            width = 12,
            column(
              width = 12,
              ## OUTPUT |-- (go_new_data) ------
              h5("The new data between", code("base"),
                " and ", code("compare"), " are below:"),
              actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_new_data"
                ),
                label = strong("Get new data!"),
                status = "success"
              ),
              br(), br(),
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
    bs4Dash::sortable(
      bs4Dash::box(
        closable = TRUE,
        width = 12,
        title = strong("Deleted Data"),
        solidHeader = FALSE,
        collapsed = TRUE,
        status = "danger",
        fluidRow(
          sortable(
            width = 12,
            column(
              width = 12,
              ## OUTPUT |-- (dev_display_y) ------
              h5("The deleted data between", code("base"),
                " and ", code("compare"), " are below:"),
              actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_deleted_data"
                ),
                status = "danger",
                label = strong("Get deleted data!")
              ),
              br(),
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
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Changed Data"),
        solidHeader = FALSE,
        collapsed = TRUE,
        status = "warning",
        fluidRow(
          sortable(
            width = 12,
            column(
              width = 12,
              ## OUTPUT |-- (dev_display_y) ------
              h5("The deleted data between", code("base"),
                " and ", code("compare"), " are below:"),
              actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_deleted_data"
                ),
                status = "warning",
                label = strong("Get deleted data!")
              ),
              br(),
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
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = "DEV",
        solidHeader = TRUE,
        status = "info",
        h5(em("DEV")),
        fluidRow(
          sortable(
            width = 12,
            column(
              width = 6,
              ## OUTPUT |-- (dev_display_x) ------
              code("input$by_col"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "dev_display_x"
                )
              )
            ),
            column(
              width = 6,
              ## OUTPUT |-- (dev_display_y) ------
              code("input$by"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "dev_display_y"
                )
              )
            )
          )
        )
      )
    )
  )
}


# compareDataServer -------------------------------------------------------

compareDataServer <- function(id, data_selected) {
  moduleServer(id = id, module = function(input, output, session) {

    # |-- REACTIVE data_base() --------------------------------------
    data_base <- eventReactive(data_selected$base_data(), {
      data_base <- data_selected$base_data()
      return(data_base)
    })

    # |-- REACTIVE data_comp() --------------------------------------
    data_comp <- eventReactive(data_selected$comp_data(), {
      data_comp <- data_selected$comp_data()
      return(data_comp)
    })

    # |-- OUTPUT (dev_display_x) --------------------------------------
    output$dev_display_x <- renderPrint({
      print(input$by_col)
    })

    # |-- OUTPUT (dev_display_y) --------------------------------------
    output$dev_display_y <- renderPrint({
      print(input$by)
    })

    # |-- REACTIVE col_intersect() --------------------------------------
    col_intersect <- reactive({
      base_cols <- names(data_base())
      comp_cols <- names(data_comp())
      intersecting_cols <- intersect(x = base_cols, y = comp_cols)
      col_intersect <- tibble::tibble(Columns = intersecting_cols)
      return(col_intersect)
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

    ##  REACTIVE |--  base_join_col_data  ---------
    base_join_col_data <- reactive({
       # no by col, no new name
      if (length(input$by) == 0 & nchar(input$by_col) == 0) {
        base_join_col <- data_base()
      # by col, no by_col
      } else if (length(input$by) > 0 & nchar(input$by_col) == 0) {
        base_join_col <- create_join_column(
          df = data_base(),
          by_colums = input$by,
          new_by_column_name = "join"
        )
        # no by col, new name
      } else if (length(input$by) == 0 & nchar(input$by_col) != 0) {
        base_join_col <- data_base()
        # by col and new col name
      } else if (length(input$by) > 0 & nchar(input$by_col) != 0) {
        base_join_col <- create_join_column(
          df = data_base(),
          by_colums = input$by,
          new_by_column_name = as.character(input$by_col)
        )
        # no by col, no new name
      } else {
        base_join_col <- data_base()
      }
    })

    ##  REACTIVE |--  comp_join_col_data ---------
    comp_join_col_data <- reactive({
      # no by col, no new name
      if (length(input$by) == 0 & nchar(input$by_col) == 0) {
        comp_join_col <- data_comp()
      # by col, no by_col
      } else if (length(input$by) > 0 & nchar(input$by_col) == 0) {
        comp_join_col <- create_join_column(
          df = data_comp(),
          by_colums = input$by,
          new_by_column_name = "join"
        )
        # no by col, new name
      } else if (length(input$by) == 0 & nchar(input$by_col) != 0) {
        comp_join_col <- data_comp()
        # by col and new col name
      } else if (length(input$by) > 0 & nchar(input$by_col) != 0) {
        comp_join_col <- create_join_column(
          df = data_comp(),
          by_colums = input$by,
          new_by_column_name = as.character(input$by_col)
        )
        # no by col, no new name
      } else {
        comp_join_col <- data_comp()
      }
    })



    # |-- OUTPUT (base_join_col_display) --------------------------------------
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

    # |-- OUTPUT (comp_join_col_display) --------------------------------------
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
        theme = compare_react_theme
      )
    })

    ##  REACTIVE |--  new_data ---------
    new_data <- reactive({
      # no by_col, no by
      if (nchar(input$by_col) == 0 & length(input$by) == 0) {
          new <- create_new_data(
                  compare = data_comp(),
                  base = data_base())
          # by_col, no by
      } else if (nchar(input$by_col) > 0 & length(input$by) == 0) {
          new <- create_new_data(
                  compare = data_comp(),
                  base = data_base())
          # no by_col, by
      } else if (nchar(input$by_col) == 0 & length(input$by) > 0) {
          new <- create_new_data(
                  compare = data_comp(),
                  base = data_base(),
                  by = as.character(input$by))
          # by_col, by
      } else if (nchar(input$by_col) > 0 & length(input$by) > 0) {
          new <- create_new_data(
                  compare = data_comp(),
                  base = data_base(),
                  by = as.character(input$by),
                  by_col = as.character(input$by_col))
          # all else
      } else {
          new <- create_new_data(
                  compare = data_comp(),
                  base = data_base())
      }
        return(new)
    })

    # |-- OUTPUT (new_data_display) --------------------------------------
    observeEvent(input$go_new_data, {
    output$new_data_display <- renderReactable({
      reactable(
        data = new_data(),
        resizable = TRUE,
        defaultPageSize = 5,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE,
        theme = new_react_theme
      )
    })

    })


    ##  REACTIVE |--  deleted_data ---------

    ##  REACTIVE |--  new_data ---------


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
    title = "compareDataDemo",
    header = bs4Dash::dashboardHeader(
      title = "compareDataDemo",
      status = "secondary"
    ),
    # sidebar (menuItem) ------------------------------------------------------
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      minified = TRUE,
      expandOnHover = TRUE,
      bs4Dash::sidebarMenu(
        id = "sidebarmenu",
        # bs4Dash::sidebarHeader("Data upload demo"),
        menuItem("Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file-upload")
        ),
        menuItem("Select Data",
          tabName = "select_data_tab",
          icon = icon("columns")
        ),
        menuItem("Compare Data",
          tabName = "compare_data_tab",
          icon = icon("compress-alt")
        ),
        menuItem("Tables",
          tabName = "table_output_tab",
          icon = icon("table")
        )
      )
    ),
    # dashboardBody (tabItem) ------------------------------------------------
    body = bs4Dash::dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## uploadDataUI -----
          uploadDataUI(id = "upload_data"),
        ),
        tabItem(
          tabName = "select_data_tab",
          ## selectDataUI -----
          selectDataUI(id = "select_data")
        ),
        tabItem(
          tabName = "compare_data_tab",
          ## compareDataUI -----
          compareDataUI("compare_data")
        ),
        tabItem(
          tabName = "table_output_tab",
          ## tableOutputUI -----
          # tableOutputUI("tables")
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar(),
    footer = bs4Dash::dashboardFooter()
  )
  server <- function(input, output, session) {
    # upload data ------------------------------------------------
    upload_data_list <- uploadDataServer(id = "upload_data")
    # select data ------------------------------------------------
    select_data_list <- selectDataServer(
      id = "select_data",
      data_upload = upload_data_list
    )
    # compare data ------------------------------------------------
    compareDataServer(
      id = "compare_data",
      data_selected = select_data_list
    )
  }
  # tableOutputServer ------------------------------------------------
  shinyApp(
    ui = ui, server = server, options = list(height = 1000, width = 800)
  )
}

compareDataDemo()
