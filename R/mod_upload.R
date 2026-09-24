#' mod_upload_ui()
#'
#' @import shiny
#' @importFrom bslib accordion accordion_panel layout_columns
#'
#' @param id module id
#' @param dev show developer reactive-value outputs (default FALSE)
#'
#' @return A `tagList` of the upload module's UI (file inputs and preview
#'   tables for `base` and `compare`)
#' @export mod_upload_ui
#'
#' @description UI module for upload
mod_upload_ui <- function(id, dev = FALSE) {
  panels <- list(
    # |- upload base file ----
    bslib::accordion_panel(
      title = "Upload File (base)",
      icon = icon("upload"),
      bslib::layout_columns(
        col_widths = c(6, 6),
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
        ),
        ### |-- INPUT [base_xlsx_sheets] ---------
        selectInput(
          inputId = NS(
            namespace = id,
            id = "base_xlsx_sheets"
          ),
          label = strong("Select sheet (if ", code(".xlsx"), " file):"),
          choices = c("", NULL)
        )
      ),
      bslib::layout_columns(
        col_widths = c(6, 6),
        tagList(
          ## |-- OUTPUT [base_filename] ---------
          tags$strong("Data file name:"),
          shiny::htmlOutput(
            outputId = NS(
              namespace = id,
              id = "base_filename"
            )
          )
        ),
        tagList(
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

  if (dev) {
    panels <- c(panels, list(
      bslib::accordion_panel(
        title = "Reactive values (base)",
        icon = icon("bug"),
        strong(em("For DEV purposes only")),
        code("base_dev_a"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "base_dev_a")
        ),
        code("base_dev_b"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "base_dev_b")
        ),
        code("base_dev_x"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "base_dev_x")
        ),
        code("base_dev_y"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "base_dev_y")
        )
      )
    ))
  }

  panels <- c(panels, list(
    # |- upload compare file ----
    bslib::accordion_panel(
      title = "Upload File (compare)",
      icon = icon("upload"),
      bslib::layout_columns(
        col_widths = c(6, 6),
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
        ),
        ## |-- INPUT [comp_xlsx_sheets] ---------
        selectInput(
          inputId = NS(
            namespace = id,
            id = "comp_xlsx_sheets"
          ),
          label = strong("Select sheet (if ", code(".xlsx"), " file):"),
          choices = c("", NULL)
        )
      ),
      bslib::layout_columns(
        col_widths = c(6, 6),
        tagList(
          ## |-- OUTPUT [comp_filename] ---------
          tags$strong("Data file name:"),
          shiny::htmlOutput(
            outputId = NS(
              namespace = id,
              id = "comp_filename"
            )
          )
        ),
        tagList(
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
      br(), br(),
      ## |-- OUTPUT [comp_display_upload] ---------
      reactable::reactableOutput(
        outputId = NS(
          namespace = id,
          id = "comp_display_upload"
        )
      )
    )
  ))

  if (dev) {
    panels <- c(panels, list(
      bslib::accordion_panel(
        title = "Reactive values (compare)",
        icon = icon("bug"),
        strong(em("For DEV purposes only")),
        code("comp_dev_a"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "comp_dev_a")
        ),
        code("comp_dev_b"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "comp_dev_b")
        ),
        code("comp_dev_x"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "comp_dev_x")
        ),
        code("comp_dev_y"),
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "comp_dev_y")
        )
      )
    ))
  }

  tagList(
    h3("Upload a ", strong("base"), " (i.e., target) data source, then a ", strong("compare"), " (i.e., current) data source"),
    do.call(
      bslib::accordion,
      c(
        list(
          id = NS(namespace = id, id = "upload_accordion"),
          multiple = TRUE,
          open = c("Upload File (base)", "Upload File (compare)")
        ),
        panels
      )
    )
  )
}

#' mod_upload_server()
#'
#'
#' @param id module id
#' @param dev show developer reactive-value outputs (default FALSE)
#' @param dark_mode reactive returning TRUE when the app is in dark mode
#'   (default reactive(FALSE))
#'
#' @return A list of reactives: `base_data`, `base_name`, `comp_data`,
#'   `comp_name`
#' @export mod_upload_server
#'
#' @description Server module for upload
mod_upload_server <- function(id, dev = FALSE, dark_mode = reactive(FALSE)) {
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
        reactable::reactable(
          data = base_data(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = base_react_theme(dark_mode())
        )
      )
    })

    ## DEV OUTPUT |-- (base_dev_a/b/x/y) ---------
    if (dev) {
      output$base_dev_a <- renderPrint({
        print(
          paste0("input$base_filename = ", input$base_file$name)
        )
      })
      output$base_dev_b <- renderPrint({
        print(
          base_data()
        )
      })
      output$base_dev_x <- renderPrint({
        print(
          paste0("input$base_xlsx_sheets = ", as.character(input$base_xlsx_sheets))
        )
      })
      output$base_dev_y <- renderPrint({
        print(
          paste0("input$base_new_name = ", as.character(input$base_new_name))
        )
      })
    }


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
        reactable::reactable(
          data = comp_data(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = comp_react_theme(dark_mode())
        )
      )
    })

    ## DEV OUTPUT |-- (comp_dev_a/b/x/y) ---------
    if (dev) {
      output$comp_dev_a <- renderPrint({
        print(
          paste0("input$comp_filename = ", as.character(input$comp_file$name))
        )
      })
      output$comp_dev_b <- renderPrint({
        print(
          comp_data()
        )
      })
      output$comp_dev_x <- renderPrint({
        print(
          paste0("input$comp_xlsx_sheets = ", as.character(input$comp_xlsx_sheets))
        )
      })
      output$comp_dev_y <- renderPrint({
        print(
          paste0("input$comp_new_name = ", as.character(input$comp_new_name))
        )
      })
    }

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
