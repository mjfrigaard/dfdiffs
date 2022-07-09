#' Load flat file
#'
#' @param path path to flat file
#'
#' @importFrom tools file_ext
#' @importFrom data.table fread
#' @importFrom haven read_sas
#' @importFrom haven read_sav
#' @importFrom haven read_dta
#' @importFrom tibble as_tibble
#'
#' @return return_data imported tibble
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
  return_data <- tibble::as_tibble(data)
  return(return_data)
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
          filterable = TRUE,
          theme = base_react_theme
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
          filterable = TRUE,
          theme = base_react_theme
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
          filterable = TRUE,
          theme = compare_react_theme
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
          filterable = TRUE,
          theme = compare_react_theme
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
