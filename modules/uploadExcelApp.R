# ===================================================#
# File name: app.R
# This is code to create: uploadExcelApp
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-02-04
# MIT License
# Version: 0.1.1
# ===================================================#


# packages ------------------------------------------
library(shiny)
library(data.table)
library(tidyverse)
library(purrr)
library(vroom)
library(reactable)
library(haven)
library(readxl)

# shiny.maxRequestSize -----------------------------
options(shiny.maxRequestSize = 2000 * 1024^2)
bgl <- tagList(tags$hr(style = "border-top: 3px solid #00B500;"))
mgl <- tagList(tags$hr(style = "border-top: 2px solid #00B500;"))
lgl <- tagList(tags$hr(style = "border-top: 1px solid #00B500;"))

# uploadExcelUI ------------------------------------
uploadExcelUI <- function(id) {
  tagList(
    fluidRow(
      column(6,
       h4(tags$code("xlsx_file")),
       br(),
        fileInput(
          # INPUT [xlsx_file] -------
          inputId = NS(namespace = id, id = "xlsx_file"),
          label = tags$p("Excel file input (",
            tags$em(tags$a(href = "https://bit.ly/3N1Klgz",
              "example file")), ")"),
          accept = c(".xlsx")
        )
      ),
      column(6,
        h4(tags$code("sheets")),
        br(),
        # OUTPUT [sheets] ---------
        tags$p(tags$strong("Sheets:")),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "sheets"),
          placeholder = TRUE
        )
      )
    ),
    fluidRow(
      column(6,
         h4(tags$code("select_sheets")),
         br(),
        # INPUT [select_sheets] ---------
        selectInput(
          inputId = NS(namespace = id, id = "select_sheets"),
          label = tags$p("Select sheet:"),
          choices = ""
        )
      ),
      column(6,
        h4(tags$code("getData")),
        br(),
        # INPUT [getData] ----------
        tags$strong("Click to import:"),
        br(), br(),
        actionButton(
          inputId = NS(namespace = id, id = "getData"),
          label = "Get Data"
        )
      )),
    fluidRow(
      column(12,
        h4(tags$code("display")),
        br(),
        # OUTPUT [display] ---------
        tags$strong("Excel table:"),
        br(),
        reactable::reactableOutput(
          outputId = NS(namespace = id, id = "display"
        ))
      )
    ),
    fluidRow(
      column(12,
        # OUTPUT [values] ---------
        tags$em("Reactive values:", tags$code("output$values")),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "values"),
          placeholder = TRUE
        )
      )
    )
  )
}

# uploadExcelServer ---------------------------------
uploadExcelServer <- function(id) {

  moduleServer(id, function(input, output, session) {
    # 1) xlsx_sheets() ----
    xlsx_sheets <- reactive({
      req(input$xlsx_file)
      xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file$datapath)
      return(xlsx_sheets)
    })
    # print sheets
    output$sheets <- renderPrint({
      req(input$xlsx_file)
      print(xlsx_sheets())
    })

    # 2) sheet drop-down options
    observe({
      inFile <- input$xlsx_file
      if (is.null(inFile)) {
        return(NULL)
      } else {
        xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file$datapath)
        updateSelectInput(session, "select_sheets", choices = xlsx_sheets)
      }
    })

    # 3) action button/display data ----
    observeEvent(input$getData, {
      worksheet_data <- readxl::read_excel(path = input$xlsx_file$datapath,
                                            sheet = input$select_sheets)
      # display table
      output$display <- reactable::renderReactable(
        reactable(data = worksheet_data,
        # reactable settings ------
        defaultPageSize = 10,
        width = 1000,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        height = 350,
        wrap = FALSE,
        bordered = TRUE,
        searchable = TRUE,
        filterable = TRUE)
      )
    })

    # reactive values
    reactive_values <- reactive({
      req(input$xlsx_file)
      reactive_values <- reactiveValuesToList(x = input, all.names = TRUE)
      # remove reactable values
      values <- reactive_values[str_detect(string = names(reactive_values),
                                           pattern = "reactable",
                                           negate = TRUE)]
      print(values)
    })
    # print reactive values
    output$values <- shiny::renderPrint({
      print(reactive_values())
    })
  })
}

# uploadExcelApp -----------------------------
uploadExcelApp <- function() {
  ui <- fluidPage(
    title = h3("uploadExcelApp"),
        uploadExcelUI(id = "xlsx"),
  )

  server <- function(input, output, session) {
    uploadExcelServer(id = "xlsx")
  }

  shinyApp(ui = ui, server = server,
           options = list(height = 800, width = 800))
}

uploadExcelApp()
