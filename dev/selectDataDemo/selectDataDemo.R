
# packages ----------------------------------------------------------------
library(fresh)
library(tidyverse)
library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(shiny)
library(shinythemes)
library(bs4Dash)


# reactable.theme ----
options(reactable.theme = reactableTheme(
  color = "hsl(233, 9%, 87%)",
  backgroundColor = "hsl(233, 9%, 19%)",
  borderColor = "hsl(233, 9%, 22%)",
  stripedColor = "hsl(233, 12%, 22%)",
  highlightColor = "hsl(233, 12%, 24%)",
  inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
))

# bmrn_fresh_theme --------------------------------------------------------
#' BioMarin theme (fresh <> bs4Dash)
#'
#' @return theme shiny app
#' @export bmrn_fresh_theme
#'
#' @description this is the fresh theme with BioMarin colors.
bmrn_fresh_theme <- function() {
  fresh::create_theme(
    # theme vars  -------------------------------------------------------------
    fresh::bs4dash_vars(
      navbar_light_color = "#353d98", # purple
      navbar_light_active_color = "#353d98", # purple
      navbar_light_hover_color = "#f26631" # orange
    ),
    # # theme yiq -------------------------------------------------------------
    fresh::bs4dash_yiq(
      contrasted_threshold = 255,
      text_dark = "#0a0a0a", # dark_gray_s10
      text_light = "#f5f5f5" # gray_t10
    ),
    # theme layout ---------------------------------------------------------
    fresh::bs4dash_layout(
      main_bg = NULL, # #ececec
      font_size_root = 12
    ),
    # theme sidebar_light -------------------------------------------------
    fresh::bs4dash_sidebar_light(
      header_color = "#ccd5dd", # dark_blue_t9
      bg = "#eaebf4", # background of entire side-bar
      color = "#002E56", # text color (no hover)
      hover_color = "#ee304e", # text color on hover
      hover_bg = "#353D98", # color on hover
      active_color = "#f26631", # color is actually the 'primary' status color
      submenu_bg = "#f5f5f5", # purple
      submenu_color = "#002444",
      submenu_hover_color = "#353D98" # purple
    ),
    # # theme sidebar_dark -------------------------------------------------
    fresh::bs4dash_sidebar_dark(
      header_color = "#ccd5dd",
      bg = "#1a1e4c",
      color = "#EE304E", # text color (no hover)
      hover_bg = "#aeb1d5", # color on hover
      hover_color = "#EE304E", # text color on hover
      active_color = "#f26631" # color is actually the 'primary' status color
    ),
    # theme status -------------------------------------------------
    fresh::bs4dash_status(
      dark = "#323232",
      light = "#A0A0A0",
      warning = "#F26631", # orange
      primary = "#00509C", # blue
      secondary = "#353D98", # purple
      success = "#A9218E", # violet
      danger = "#EE304E", # red
      info = "#A0A0A0" # orange
    ),
    # theme color -------------------------------------------------
    fresh::bs4dash_color(
      gray_900 = "#1f245b",
      gray_800 = "#646464",
      lightblue = "#6696c3",
      blue = "#00509C"
    )
  )
}

# load_flat_file ----------------------------------------------------------
#' Load flat data files
#'
#' @param path path to data file (with extension)
#'
#' @return return_data
#' @export load_flat_file
#'
load_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = data.table::fread(path),
    csv = data.table::fread(path),
    tsv = data.table::fread(path),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  return_data <- as_tibble(data)
  return(return_data)
}


# uploadDataUI ------------------------------------------------------------
#' data upload (UI) for selectDataDemo
#'
#' @param id module id
#'
#' @export uploadDataUI
#'
#' @description `uploadDataUI()`/`uploadDataServer()` create the upload module
#' for the dfdiffs app.
uploadDataUI <- function(id) {
  tagList(
    h3("Upload a ", strong("base"), " (target) data source "),
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
          status = "success",
          width = 12,
          title = tags$strong("Upload Excel File (base)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [xlsx_file_base] -------
                inputId = NS(
                  namespace = id,
                  id = "xlsx_file_base"
                ),
                label = "Excel file input",
                accept = c(".xlsx")
              )
            ),
            column(
              width = 6,
              ### |-- INPUT [xlsx_sheets_base] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_sheets_base"
                ),
                label = "Select sheet:",
                choices = ""
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [xlsx_filename_base] ---------
              tags$strong("Excel data file:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_filename_base"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [xlsx_new_name_base] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_new_name_base"
                ),
                label = strong(
                  "Provide a name for the", code("base"), " excel fil:"
                )
              ),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [xlsx_upload_base] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_upload_base"
                )
              )
            )
          )
        )
      )
    ),
    # |- upload base xlsx file ----
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          collapsible = TRUE,
          closable = FALSE,
          solidHeader = TRUE,
          status = "success",
          width = 12,
          title = tags$strong("Upload Flat Data File (base)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [flat_file_base] -------
                inputId = NS(
                  namespace = id,
                  id = "flat_file_base"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"), code(".txt"), code(".tsv")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv")
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [flat_filename_base] ---------
              tags$strong("Flat file data:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_filename_base"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [flat_file_new_name_base] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "flat_file_new_name_base"
                ),
                label = strong(
                  "Provide a name for the ", code("base"), " flat file:"
                )
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              ## |-- OUTPUT [flat_file_upload_base] -------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_file_upload_base"
                )
              )
            )
          )
        )
      )
    ),
    h3("Upload a ", strong("compare"), " (current) data source"),
    # br(), br(),
    fluidRow(
      sortable(
        width = 12,
        # |- upload compare xlsx file ----
        box(
          maximizable = TRUE,
          collapsed = FALSE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload Excel File (compare)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [xlsx_file_comp] -------
                inputId = NS(
                  namespace = id,
                  id = "xlsx_file_comp"
                ),
                label = "Excel file upload",
                accept = c(".xlsx")
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [xlsx_sheets_comp] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_sheets_comp"
                ),
                label = "Select sheet:",
                choices = ""
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [xlsx_filename_comp] ---------
              tags$strong("Excel Data File:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_filename_comp"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [xlsx_new_name_comp] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "xlsx_new_name_comp"
                ),
                label = strong(
                  "Provide a name for the ", code("compare"), " excel file :"
                )
              ),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [xlsx_upload_comp] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "xlsx_upload_comp"
                )
              )
            )
          )
        )
      )
    ),
    # |- upload compare flat file ----
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsed = TRUE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload Flat Data File (compare)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [flat_file_comp] -------
                inputId = NS(
                  namespace = id,
                  id = "flat_file_comp"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"), code(".txt"), code(".tsv")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv")
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [flat_filename_comp] ---------
              tags$strong("Flat file data:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_filename_comp"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [flat_file_new_name_comp] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "flat_file_new_name_comp"
                ),
                label = strong(
                  "Provide a name for the ", code("compare"), " flat file:"
                )
              )
            )
          ),
          fluidRow(
            column(
              width = 12,
              ## |-- OUTPUT [flat_file_upload_comp] -------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "flat_file_upload_comp"
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
#' data upload (Server) for selectDataDemo()
#'
#' @param id module id
#'
#' @export uploadDataServer
#'
#' @return list with data inputs
#' \describe{
#'   \item{base_xlsx_data}{reactive dataset of imported 'base' excel file}
#'   \item{base_xlsx_data_name}{name of reactive dataset of imported 'base' excel file}
#'   \item{base_flat_file_data}{reactive dataset of imported 'base' flat file}
#'   \item{base_flat_file_data_name}{name of reactive dataset of imported 'base' flat file}
#'   \item{comp_xlsx_data}{reactive dataset of imported 'compare' excel file}
#'   \item{comp_xlsx_data_name}{name of reactive dataset of imported 'compare' excel file}
#'   \item{comp_flat_file_data}{reactive dataset of imported 'compare' flat file}
#'   \item{comp_flat_file_data_name}{name of reactive dataset of imported 'compare' flat file}
#' }
#'
#' @examples # build server using uploadDataServer() and displayDataServer()
#' upload_data_list <- uploadDataServer(id = "upload_data")
#' displayDataServer(id = "display_data", data_upload = upload_data_list)
uploadDataServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # |-- INPUT [base] xlsx sheets -----
    observeEvent(eventExpr = input$xlsx_file_base, handlerExpr = {
      if (is.null(input$xlsx_file_base)) {
        return(NULL)
      } else {
        xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file_base$datapath)
        updateSelectInput(session, "xlsx_sheets_base", choices = xlsx_sheets)
      }
    })

    # |-- OUTPUT [base] xlsx file name -----
    output$xlsx_filename_base <- renderPrint({
      req(input$xlsx_file_base)
      xlsx_filename_base <- as.character(input$xlsx_file_base$name)
      paste0(
        tags$code(xlsx_filename_base)
      )
    })

    # |-- OUTPUT display [base] xlsx ----
    # require name
    observeEvent(eventExpr = input$xlsx_new_name_base, handlerExpr = {
      req(input$xlsx_file_base)
      req(input$xlsx_sheets_base)
      req(input$xlsx_new_name_base)
      worksheet_data <- readxl::read_excel(
        path = input$xlsx_file_base$datapath,
        sheet = input$xlsx_sheets_base
      )
      worksheet_names_tbl <- tibble::as_tibble(worksheet_data)
      output$xlsx_upload_base <- reactable::renderReactable(
        reactable(
          data = worksheet_names_tbl,
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE
        )
      )
    })

    # |-- INPUT [base] flat file -----
    flat_file_base <- reactive({
      req(input$flat_file_base)
      req(input$flat_file_new_name_base)
      flat_file_base <- load_flat_file(
        path = input$flat_file_base$datapath
      )
      return(flat_file_base)
    })

    # |-- OUTPUT [base] flat file name -----
    output$flat_filename_base <- renderPrint({
      req(input$flat_file_base)
      flat_filename_base <- as.character(input$flat_file_base$name)
      paste0(
        tags$code(flat_filename_base)
      )
    })

    # |-- OUTPUT display [base] flat file -----
    observeEvent(eventExpr = input$flat_file_new_name_base, handlerExpr = {
      output$flat_file_upload_base <- reactable::renderReactable(
        reactable(
          data = flat_file_base(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE
        )
      )
    })

    # |-- [compare] xlsx sheets -----
    observeEvent(eventExpr = input$xlsx_file_comp, handlerExpr = {
      if (is.null(input$xlsx_file_comp)) {
        return(NULL)
      } else {
        xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file_comp$datapath)
        updateSelectInput(session, "xlsx_sheets_comp", choices = xlsx_sheets)
      }
    })

    # |-- [compare] xlsx filename name -----
    output$xlsx_filename_comp <- renderPrint({
      req(input$xlsx_file_comp)
      xlsx_filename_comp <- as.character(input$xlsx_file_comp$name)
      paste0(
        tags$code(xlsx_filename_comp)
      )
    })

    # |-- display [compare] xlsx ----
    observeEvent(eventExpr = input$xlsx_new_name_comp, handlerExpr = {
      req(input$xlsx_file_comp)
      req(input$xlsx_sheets_comp)
      req(input$xlsx_new_name_comp)
      worksheet_data <- readxl::read_excel(
        path = input$xlsx_file_comp$datapath,
        sheet = input$xlsx_sheets_comp
      )
      worksheet_names_tbl <- tibble::as_tibble(worksheet_data)
      output$xlsx_upload_comp <- reactable::renderReactable(
        reactable(
          data = worksheet_names_tbl,
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE
        )
      )
    })

    # |-- import [compare] flat file -----
    flat_file_comp <- reactive({
      req(input$flat_file_comp)
      req(input$flat_file_new_name_comp)
      flat_file_comp <- load_flat_file(
        path = input$flat_file_comp$datapath
      )
      return(flat_file_comp)
    })

    # |-- [compare] flat file name -----
    output$flat_filename_comp <- renderPrint({
      req(input$flat_file_comp)
      flat_filename_comp <- as.character(input$flat_file_comp$name)
      paste0(
        tags$code(flat_filename_comp)
      )
    })

    # |-- display [compare] flat file -----
    observeEvent(eventExpr = input$flat_file_new_name_comp, handlerExpr = {
      output$flat_file_upload_comp <- reactable::renderReactable(
        reactable(
          data = flat_file_comp(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE
        )
      )
    })

    # |---- return list -----
    # assign this as 'upload_data_list'
    return(
      list(
        # |------ base_xlsx_data ----
        base_xlsx_data = reactive({
          req(input$xlsx_file_base)
          req(input$xlsx_sheets_base)
          req(input$xlsx_new_name_base)
          worksheet_data <- readxl::read_excel(
            path = input$xlsx_file_base$datapath,
            sheet = input$xlsx_sheets_base
          )
        }),
        # |------ base_xlsx_data_name ----
        base_xlsx_data_name = reactive({
          # req(input$xlsx_new_name_base)
          if (length(input$xlsx_new_name_base) == 1) {
            as.character(input$xlsx_new_name_base)
          } else {
            NULL
          }
        }),
        # |------ base_flat_file_data ----
        base_flat_file_data = reactive({
          req(input$flat_file_base)
          req(input$flat_file_new_name_base)
          flat_file_base <- load_flat_file(
            path = input$flat_file_base$datapath
          )
        }),
        # |------ base_flat_file_data_name ----
        base_flat_file_data_name = reactive({
          # req(input$flat_file_new_name_base)
          if (length(input$flat_file_new_name_base) == 1) {
            as.character(input$flat_file_new_name_base)
          } else {
            NULL
          }
        }),

        # |------ comp_xlsx_data ----
        comp_xlsx_data = reactive({
          req(input$xlsx_file_comp)
          req(input$xlsx_sheets_comp)
          req(input$xlsx_new_name_comp)
          comp_xlsx_data <- readxl::read_excel(
            path = input$xlsx_file_comp$datapath,
            sheet = input$xlsx_sheets_comp
          )
        }),
        # |------ comp_xlsx_data_name ----
        comp_xlsx_data_name = reactive({
          # req(input$xlsx_new_name_comp)
          if (length(input$xlsx_new_name_comp) == 1) {
            as.character(input$xlsx_new_name_comp)
          } else {
            NULL
          }
        }),
        # |------ comp_flat_file_data ----
        comp_flat_file_data = reactive({
          req(input$flat_file_comp)
          req(input$flat_file_new_name_comp)
          comp_flat_file <- load_flat_file(
            path = input$flat_file_comp$datapath
          )
        }),
        # |------ comp_flat_file_data_name ----
        comp_flat_file_data_name = reactive({
          # req(input$flat_file_new_name_comp)
          if (length(input$flat_file_new_name_comp) == 1) {
            as.character(input$flat_file_new_name_comp)
          } else {
            NULL
          }
        })
      )
    )
  })
}


# selectDataUI ------------------------------------------------------------
selectDataUI <- function(id) {
  tagList(
    h3("Pick a ", strong("base"), "data source"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          status = "success",
          width = 12,
          title = tags$strong("Base Data Files"),
          ## |-- INPUT [base_data_select] ---------
          ## displays dummy data when initially loaded, then imports list
          ## of imported objects from baseUploadDataServer()
          selectInput(
            inputId = NS(
              namespace = id,
              id = "base_data_select"
            ),
            label = strong("Select ", code("base"), " data"),
            choices = c("", NULL),
            selected = NULL
          ),
          ## |-- OUTPUT [base_data_display] ---------
          ## displays uploaded/named/selected data
          strong("Base Data"),
          br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "base_data_display"
            )
          ),
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
          )
        )
      )
    ),
    ## reactive values -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          background = "gray",
          solidHeader = TRUE,
          closable = FALSE,
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          ## values -----
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "base_reactive_values"
            )
          )
        )
      )
    ),
    h3("Pick a ", strong("compare"), "data source"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          closable = FALSE,
          status = "success",
          width = 12,
          title = tags$strong("Compare Data Files"),
          ## |-- INPUT [comp_data_select] ---------
          ## displays dummy data when initially loaded, then imports list
          ## of imported objects from uploadDataServer()
          selectInput(
            inputId = NS(
              namespace = id,
              id = "comp_data_select"
            ),
            label = strong("Select ", code("comare"), " data"),
            choices = c("", NULL),
            selected = c("", NULL)
          ),
          ## |-- OUTPUT [comp_data_display] ---------
          ## displays uploaded/named/selected data
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "comp_data_display"
            )
          ),
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
          )
        )
      )
    ),
    ## reactive values -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          background = "gray",
          solidHeader = TRUE,
          closable = FALSE,
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          title = "Reactive values (comapre)",
          ## values -----
          verbatimTextOutput(
            outputId = NS(
              namespace = id,
              id = "compare_reactive_values"
            )
          )
        )
      )
    )
  )
}


# selectDataServer --------------------------------------------------------
#
selectDataServer <- function(id, data_upload) {

  moduleServer(id = id, module = function(input, output, session) {
    # BASE DATA |-- ----
    ## BASE EACTIVE |-- base_xlsx_data (reactive) ---------
    base_xlsx_data <- eventReactive(data_upload$base_xlsx_data(), {
      base_xlsx <- data_upload$base_xlsx_data()
      return(base_xlsx)
    })

    ## BASE REACTIVE |-- base_xlsx_data_name (reactive) ---------
    base_xlsx_data_name <- eventReactive(data_upload$base_xlsx_data_name(), {
      base_xlsx_name <- data_upload$base_xlsx_data_name()
      return(base_xlsx_name)
    })

    ## BASE REACTIVE |-- base_flat_file_data (reactive) ---------
    base_flat_file_data <- eventReactive(data_upload$base_flat_file_data(), {
      base_flat_file <- data_upload$base_flat_file_data()
      return(base_flat_file)
    })
    ## BASE REACTIVE |-- base_flat_file_data_name (reactive) ---------
    base_flat_file_data_name <- eventReactive(data_upload$base_flat_file_data_name(), {
      base_flat_file_name <- data_upload$base_flat_file_data_name()
      return(base_flat_file_name)
    })

    ## BASE REACTIVE |-- base_uploaded_data_names (reactive) ---------
    base_uploaded_data_names <- reactive({
      if (nchar(base_xlsx_data_name()) != 0 & nchar(base_flat_file_data_name()) != 0) {
        base_xlsx_data_name <- as.character(base_xlsx_data_name())
        base_flat_file_data_name <- as.character(base_flat_file_data_name())
        names <- c(base_flat_file_data_name, base_xlsx_data_name)
      } else if (nchar(base_xlsx_data_name()) != 0 & nchar(base_flat_file_data_name()) == 0) {
        names <- as.character(base_xlsx_data_name())
      } else if (nchar(base_xlsx_data_name()) == 0 & nchar(base_flat_file_data_name()) != 0) {
        names <- as.character(base_flat_file_data_name())
      } else {
        NULL
      }
      return(names)
    })

    ##  BASE UPDATE (input$base_data_select) |-- (base_data) --------
    observeEvent(base_uploaded_data_names(), {
      if (is.character(unclass(base_uploaded_data_names())) == TRUE) {
        data_choices <- base_uploaded_data_names()
        updated_select <- as.character(input$base_data_select)
        selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
      } else {
        data_choices <- c("", NULL)
        selected <- c("")
      }
      updateSelectInput(
        inputId = "base_data_select",
        choices = data_choices,
        selected = selected
      )
    })

    ## BASE REACTIVE |-- (base_data) ---------
    base_data <- reactive({
      req(input$base_data_select)
      # if the selected data is the excel data name
      if (as.character(input$base_data_select) == as.character(base_xlsx_data_name())) {
        data <- base_xlsx_data()
        base_data <- tibble::as_tibble(data)
        # if the selected data is the flat file name
      } else if (as.character(input$base_data_select) == as.character(base_flat_file_data_name())) {
        data <- base_flat_file_data()
        base_data <- tibble::as_tibble(data)
      } else {
        NULL
      }
      return(base_data)
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

    ## BASE OUTPUT |-- base_data_display (display) ---------
    output$base_data_display <- reactable::renderReactable({
      req(input$base_col_select)
      req(input$base_data_select)
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


    ## BASE OUTPUT |-- reactive_values (dev) ---------
    output$base_reactive_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- str_detect(names(all_values), "base")
      module_values <- all_values[module_names]
      reactable_names <- str_detect(
        names(module_values),
        "__reactable__",
        negate = TRUE
      )
      values <- module_values[reactable_names]
      print(values)
    })

    # COMPARE DATA |-- ----
    ## COMPARE REACTIVE |-- comp_xlsx_data (reactive) ---------
    comp_xlsx_data <- eventReactive(data_upload$comp_xlsx_data(), {
      comp_xlsx <- data_upload$comp_xlsx_data()
      return(comp_xlsx)
    })

    ## COMPARE REACTIVE |-- comp_xlsx_data_name (reactive) ---------
    comp_xlsx_data_name <- eventReactive(data_upload$comp_xlsx_data_name(), {
      comp_xlsx_name <- data_upload$comp_xlsx_data_name()
      return(comp_xlsx_name)
    })

    ## COMPARE REACTIVE |-- comp_flat_file_data (reactive) ---------
    comp_flat_file_data <- eventReactive(data_upload$comp_flat_file_data(), {
      comp_flat_file <- data_upload$comp_flat_file_data()
      return(comp_flat_file)
    })
    ## COMPARE REACTIVE |-- comp_flat_file_data_name (reactive) ---------
    comp_flat_file_data_name <- eventReactive(data_upload$comp_flat_file_data_name(), {
      comp_flat_file_name <- data_upload$comp_flat_file_data_name()
      return(comp_flat_file_name)
    })

    ## COMPARE REACTIVE |-- comp_uploaded_data_names (reactive) ---------
    ## comp_uploaded_data_names
    comp_uploaded_data_names <- reactive({
      if (nchar(comp_xlsx_data_name()) != 0 & nchar(comp_flat_file_data_name()) != 0) {
        comp_xlsx_data_name <- as.character(comp_xlsx_data_name())
        comp_flat_file_data_name <- as.character(comp_flat_file_data_name())
        names <- c(comp_flat_file_data_name, comp_xlsx_data_name)
      } else if (nchar(comp_xlsx_data_name()) != 0 & nchar(comp_flat_file_data_name()) == 0) {
        names <- as.character(comp_xlsx_data_name())
      } else if (nchar(comp_xlsx_data_name()) == 0 & nchar(comp_flat_file_data_name()) != 0) {
        names <- as.character(comp_flat_file_data_name())
      } else {
        NULL
      }
      return(names)
    })

    ## COMPARE UPDATE |-- (input$comp_data_select) ---------
    observeEvent(comp_uploaded_data_names(), {
      if (is.character(unclass(comp_uploaded_data_names())) == TRUE) {
        data_choices <- comp_uploaded_data_names()
        updated_select <- as.character(input$comp_data_select)
        selected <- data_choices[stringr::str_detect(data_choices, updated_select)]
      } else {
        data_choices <- c("", NULL)
        selected <- c("", NULL)
      }
      updateSelectInput(
        inputId = "comp_data_select",
        choices = data_choices,
        selected = selected
      )
    })

    ## COMPARE REACTIVE |-- (comp_data) ---------
    comp_data <- reactive({
      req(input$comp_data_select)
      # if the selected data is the excel data name
      if (as.character(input$comp_data_select) == as.character(comp_xlsx_data_name())) {
        data <- comp_xlsx_data()
        comp_data <- tibble::as_tibble(data)
        # if the selected data is the flat file name
      } else if (as.character(input$comp_data_select) == as.character(comp_flat_file_data_name())) {
        data <- comp_flat_file_data()
        comp_data <- tibble::as_tibble(data)
      } else {
        NULL
      }
      return(comp_data)
    })

    ## COMPARE UPDATE |-- input$comp_col_select   ---------
    observeEvent(comp_data(), {
      data_choices <- names(comp_data())
      updateSelectizeInput(
        inputId = "comp_col_select",
        choices = data_choices,
        selected = data_choices
      )
    })

    ## COMPARE OUTPUT |---- comp_data_display (display) ---------
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

    ## COMPARE OUTPUT |-- reactive_values (dev) ---------
    output$compare_reactive_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- str_detect(names(all_values), "comp")
      module_values <- all_values[module_names]
      reactable_names <- str_detect(
        names(module_values),
        "__reactable__",
        negate = TRUE
      )
      values <- module_values[reactable_names]
      print(values)
      # print(is.character(unclass(comp_uploaded_data_names())))
    })

    # RETURN LIST |-- ----
    return(
      list(
        ## |--- BASE DATA RETURN (base_data) ----
        base_data = reactive({
          req(input$base_data_select)
          req(input$base_col_select)
          # base selected xlsx data
          if (as.character(input$base_data_select) == as.character(base_xlsx_data_name())) {
            data <- base_xlsx_data()
            base_data <- tibble::as_tibble(data)
            # base selected flat file data
          } else {
            data <- base_flat_file_data()
            base_data <- tibble::as_tibble(data)
          }
          return_base_data <- select(base_data, all_of(input$base_col_select))
          return(return_base_data)
        }),
        ## |--- COMPARE DATA RETURN (comp_data) ----
        comp_data = reactive({
          req(input$comp_data_select)
          req(input$comp_col_select)
          # compare xlsx file
          if (as.character(input$comp_data_select) == as.character(comp_xlsx_data_name())) {
            data <- comp_xlsx_data()
            comp_data <- tibble::as_tibble(data)
            # compare flat file data
          } else {
            data <- comp_flat_file_data()
            comp_data <- tibble::as_tibble(data)
          }
          return_comp_data <- select(comp_data, all_of(input$comp_col_select))
          return(return_comp_data)
        })
      )
    )
  })
}

select_data_theme <- bmrn_fresh_theme()
selectDataDemo <- function() {
  ui <- bs4Dash::dashboardPage(
    title = "selectDataDemo",
    dark = FALSE,
    freshTheme = select_data_theme,
    header = bs4Dash::dashboardHeader(title = "selectDataDemo"),
    # sidebar (menuItem) --------------------------
    sidebar = bs4Dash::dashboardSidebar(
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
    # dashboardBody (tabItem) ----------------------
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
                background = "gray",
                solidHeader = TRUE,
                closable = FALSE,
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
    selectDataServer(id = "select_data", data_upload = upload_data_list)
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
    ui = ui, server = server
    # options = list(height = 1000, width = 800)
  )
}


# run selectDataDemo ------------------------------------------------------
selectDataDemo()
