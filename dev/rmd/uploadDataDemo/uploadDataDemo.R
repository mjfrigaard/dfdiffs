# packages ----
library(shiny)
library(bs4Dash)

library(reactable)


# load modules ------------------------------------------------------------
source("helpers.R")

# source("uploadDataUI.R")
# uploadDataUI -----
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
                  code(".txt"), code(".tsv"), code(".xlsx")),
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
            bs4Dash::column(12,
              ## base_dev_a -----
              code("base_dev_a"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_a"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_b -----
              code("base_dev_b"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_b"
            )
          ))
          ),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_x -----
              code("base_dev_x"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_x"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## base_dev_y -----
              code("base_dev_y"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_dev_y"
            )
          ))
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
                  code(".txt"), code(".tsv"), code(".xlsx")),
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
            bs4Dash::column(12,
              ## comp_dev_a -----
              code("comp_dev_a"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_a"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_b -----
              code("comp_dev_b"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_b"
            )
          ))
          ),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_x -----
              code("comp_dev_x"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_x"
            )
          ))),
          fluidRow(
            bs4Dash::column(12,
              ## comp_dev_y -----
              code("comp_dev_y"),
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "comp_dev_y"
            )
          ))
          )
        )
      )
    )
  )
}

# source("uploadDataServer.R")
# uploadDataServer -----
uploadDataServer <- function(id) {

  moduleServer(id = id, module = function(input, output, session) {

    # |-- INPUT [base] base_xlsx_sheets -----
    observeEvent(eventExpr = input$base_file, handlerExpr = {
      if (tools::file_ext(input$base_file$name) == "xlsx") {
        choices <- readxl::excel_sheets(path = input$base_file$datapath)
      } else {
        choices <- c("", NULL)
      }
      updateSelectInput(session = session,
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
          uploaded <- upload_data(path = input$base_file$datapath,
                                  sheet = as.character(input$base_xlsx_sheets))
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
          paste0("input$base_xlsx_sheets = ",  as.character(input$base_xlsx_sheets))
          )
      })
      ## DEV OUTPUT |-- (base_dev_y) ---------
      output$base_dev_y <- renderPrint({
        print(
          paste0("input$base_new_name = ",  as.character(input$base_new_name))
          )
      })


    # |-- INPUT [comp] comp_xlsx_sheets -----
    observeEvent(eventExpr = input$comp_file, handlerExpr = {
      if (tools::file_ext(input$comp_file$name) == "xlsx") {
        choices <- readxl::excel_sheets(path = input$comp_file$datapath)
      } else {
        choices <- c("", NULL)
      }
      updateSelectInput(session = session,
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
          uploaded <- upload_data(path = input$comp_file$datapath,
                                  sheet = as.character(input$comp_xlsx_sheets))
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
          paste0("input$comp_filename = ",  as.character(input$comp_file$name))
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
          paste0("input$comp_xlsx_sheets = ",  as.character(input$comp_xlsx_sheets))
          )
      })
      ## DEV OUTPUT |-- comp_dev_b (dev) ---------
      output$comp_dev_y <- renderPrint({
        print(
          paste0("input$comp_new_name = ",  as.character(input$comp_new_name))
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
            uploaded <- upload_data(path = input$base_file$datapath,
                                  sheet = as.character(input$base_xlsx_sheets))
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
            uploaded <- upload_data(path = input$comp_file$datapath,
                                  sheet = as.character(input$comp_xlsx_sheets))
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

upload_theme <- dfdiffs_fresh_theme()


# uploadDataDemo ----------------------------------------------------------
#' uploadDataDemo
#'
#' @export uploadDataDemo
#'
#' @importFrom bs4Dash dashboardPage
#' @importFrom bs4Dash dashboardHeader
#' @importFrom bs4Dash dashboardControlbar
#' @importFrom bs4Dash dashboardFooter
#' @importFrom bs4Dash dashboardBody
#' @importFrom bs4Dash dashboardSidebar
#'
#' @examples # run app
#' uploadDataDemo()
uploadDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    freshTheme = upload_theme,
    dark = FALSE,
    title = "uploadDataDemo",
    header = dashboardHeader(title = "uploadDataDemo"),
    # sidebar (menuItem) -----
    sidebar = dashboardSidebar(
      sidebarMenu(
        id = "sidebarmenu",
        sidebarHeader("Data upload demo"),
        menuItem("Upload Data",
          tabName = "upload_data_tab",
          icon = icon("file")
        )
      )
    ),
    # dashboardBody (tabItem) -----
    body = dashboardBody(
      tabItems(
        tabItem(
          tabName = "upload_data_tab",
          ## uploadDataUI -----
          uploadDataUI(id = "upload_data")
        )
      )
    ),
    controlbar = dashboardControlbar(),
    footer = dashboardFooter()
  )

  server <- function(input, output, session) {
    uploadDataServer(id = "upload_data")
  }

  shinyApp(
    ui = ui, server = server,
    options = list(width = 800, height = 1000)
  )
}
uploadDataDemo()
