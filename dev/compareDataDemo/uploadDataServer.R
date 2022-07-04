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
#' data upload (Server) for compareDataDemo
#'
#' @param id module id
#'
#' @export uploadDataServer
#'
#' @return list with data inputs
#' \describe{
#'   \item{prev_xlsx_data}{reactive dataset of imported 'previous' excel file}
#'   \item{prev_xlsx_data_name}{name of reactive dataset of imported 'previous' excel file}
#'   \item{prev_flat_file_data}{reactive dataset of imported 'previous' flat file}
#'   \item{prev_flat_file_data_name}{name of reactive dataset of imported 'previous' flat file}
#'   \item{curr_xlsx_data}{reactive dataset of imported 'current' excel file}
#'   \item{curr_xlsx_data_name}{name of reactive dataset of imported 'current' excel file}
#'   \item{curr_flat_file_data}{reactive dataset of imported 'current' flat file}
#'   \item{curr_flat_file_data_name}{name of reactive dataset of imported 'current' flat file}
#' }
#'
#' @examples # build server using uploadDataServer() and displayDataServer()
#' upload_data_list <- uploadDataServer(id = "upload_data")
#' displayDataServer(id = "display_data", data_upload = upload_data_list)
uploadDataServer <- function(id) {
  moduleServer(id = id, module = function(input, output, session) {

    # |-- INPUT [previous] xlsx sheets -----
    observeEvent(eventExpr = input$xlsx_file_prev, handlerExpr = {
      if (is.null(input$xlsx_file_prev)) {
        return(NULL)
      } else {
        xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file_prev$datapath)
        updateSelectInput(session, "xlsx_sheets_prev", choices = xlsx_sheets)
      }
    })

  # |-- OUTPUT [previous] xlsx file name -----
    output$xlsx_filename_prev <- renderPrint({
      req(input$xlsx_file_prev)
      xlsx_filename_prev <- as.character(input$xlsx_file_prev$name)
      paste0(
        tags$code(xlsx_filename_prev)
      )
    })

    # |-- OUTPUT display [previous] xlsx ----
    # require name
    observeEvent(eventExpr = input$new_xlsx_name_prev, handlerExpr = {
      req(input$xlsx_file_prev)
      req(input$xlsx_sheets_prev)
      req(input$new_xlsx_name_prev)
      worksheet_data <- readxl::read_excel(
        path = input$xlsx_file_prev$datapath,
        sheet = input$xlsx_sheets_prev
      )
      worksheet_names_tbl <- tibble::as_tibble(worksheet_data)
      output$xlsx_upload_prev <- reactable::renderReactable(
        reactable(
          data = worksheet_names_tbl,
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = reactableTheme(
          color = "hsl(235, 9%, 87%)",
          backgroundColor = "hsl(208,100%, 17%)",
          borderColor = "hsl(235, 9%, 22%)",
          stripedColor = "hsl(235, 12%, 22%)",
          highlightColor = "hsl(235, 12%, 24%)",
          inputStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          selectStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonHoverStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonActiveStyle = list(backgroundColor = "hsl(235, 9%, 28%)"))
        )
      )
    })

    # |-- INPUT [previous] flat file -----
      flat_file_prev <- reactive({
        req(input$flat_file_prev)
        req(input$new_flat_file_name_prev)
        flat_file_prev <- load_flat_file(
                                path = input$flat_file_prev$datapath)
          return(flat_file_prev)
      })

  # |-- OUTPUT [previous] flat file name -----
    output$flat_filename_prev <- renderPrint({
      req(input$flat_file_prev)
      flat_filename_prev <- as.character(input$flat_file_prev$name)
      paste0(
        tags$code(flat_filename_prev)
      )
    })

    # |-- OUTPUT display [previous] flat file -----
    observeEvent(eventExpr = input$new_flat_file_name_prev, handlerExpr = {
    output$flat_file_data_prev <- reactable::renderReactable(
        reactable(
          data = flat_file_prev(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = reactableTheme(
          color = "hsl(235, 9%, 87%)",
          backgroundColor = "hsl(208,100%, 17%)",
          borderColor = "hsl(235, 9%, 22%)",
          stripedColor = "hsl(235, 12%, 22%)",
          highlightColor = "hsl(235, 12%, 24%)",
          inputStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          selectStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonHoverStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonActiveStyle = list(backgroundColor = "hsl(235, 9%, 28%)"))
        )
      )
    })

    # |-- [current] xlsx sheets -----
    observeEvent(eventExpr = input$xlsx_file_curr, handlerExpr = {
      if (is.null(input$xlsx_file_curr)) {
        return(NULL)
      } else {
        xlsx_sheets <- readxl::excel_sheets(path = input$xlsx_file_curr$datapath)
        updateSelectInput(session, "xlsx_sheets_curr", choices = xlsx_sheets)
      }
    })

  # |-- [current] xlsx filename name -----
    output$xlsx_filename_curr <- renderPrint({
      req(input$xlsx_file_curr)
      xlsx_filename_curr <- as.character(input$xlsx_file_curr$name)
      paste0(
        tags$code(xlsx_filename_curr)
      )
    })

    # |-- display [current] xlsx ----
    observeEvent(eventExpr = input$xlsx_new_name_curr, handlerExpr = {
      req(input$xlsx_file_curr)
      req(input$xlsx_sheets_curr)
      req(input$xlsx_new_name_curr)
      worksheet_data <- readxl::read_excel(
        path = input$xlsx_file_curr$datapath,
        sheet = input$xlsx_sheets_curr
      )
      worksheet_names_tbl <- tibble::as_tibble(worksheet_data)
      output$xlsx_upload_curr <- reactable::renderReactable(
        reactable(
          data = worksheet_names_tbl,
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = reactableTheme(
          color = "hsl(235, 9%, 87%)",
          backgroundColor = "hsl(208,100%, 17%)",
          borderColor = "hsl(235, 9%, 22%)",
          stripedColor = "hsl(235, 12%, 22%)",
          highlightColor = "hsl(235, 12%, 24%)",
          inputStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          selectStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonHoverStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonActiveStyle = list(backgroundColor = "hsl(235, 9%, 28%)"))
        )
      )
    })

    # |-- import [current] flat file -----
      flat_file_curr <- reactive({
        req(input$flat_file_curr)
        req(input$new_flat_file_name_curr)
        flat_file_curr <- load_flat_file(
                                path = input$flat_file_curr$datapath)
          return(flat_file_curr)
      })

  # |-- [current] flat file name -----
    output$flat_filename_curr <- renderPrint({
      req(input$flat_file_curr)
      flat_filename_curr <- as.character(input$flat_file_curr$name)
      paste0(
        tags$code(flat_filename_curr)
      )
    })

    # |-- display [current] flat file -----
    observeEvent(eventExpr = input$new_flat_file_name_curr, handlerExpr = {
    output$flat_file_data_curr <- reactable::renderReactable(
        reactable(
          data = flat_file_curr(),
          defaultPageSize = 5,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE,
          theme = reactableTheme(
          color = "hsl(235, 9%, 87%)",
          backgroundColor = "hsl(208,100%, 17%)",
          borderColor = "hsl(235, 9%, 22%)",
          stripedColor = "hsl(235, 12%, 22%)",
          highlightColor = "hsl(235, 12%, 24%)",
          inputStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          selectStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonHoverStyle = list(backgroundColor = "hsl(235, 9%, 25%)"),
          pageButtonActiveStyle = list(backgroundColor = "hsl(235, 9%, 28%)"))
        )
      )
    })

  # |---- return list -----
  # assign this as 'upload_data_list'
    return(
      list(
        # |------ prev_xlsx_data ----
        prev_xlsx_data = reactive({
                req(input$xlsx_file_prev)
                req(input$xlsx_sheets_prev)
                req(input$new_xlsx_name_prev)
                worksheet_data <- readxl::read_excel(
                      path = input$xlsx_file_prev$datapath,
                      sheet = input$xlsx_sheets_prev)

            }),
        # |------ prev_xlsx_data_name ----
        prev_xlsx_data_name = reactive({
          # req(input$new_xlsx_name_prev)
          if (length(input$new_xlsx_name_prev) == 1) {
            as.character(input$new_xlsx_name_prev)
          } else {
            NULL
          }
        }),
        # |------ prev_flat_file_data ----
        prev_flat_file_data = reactive({
              req(input$flat_file_prev)
              req(input$new_flat_file_name_prev)
              flat_file_prev <- load_flat_file(
                                path = input$flat_file_prev$datapath)
          }),
        # |------ prev_flat_file_data_name ----
        prev_flat_file_data_name = reactive({
            # req(input$new_flat_file_name_prev)
          if (length(input$new_flat_file_name_prev) == 1) {
            as.character(input$new_flat_file_name_prev)
          } else {
            NULL
          }
        }),

        # |------ curr_xlsx_data ----
        curr_xlsx_data = reactive({
          req(input$xlsx_file_curr)
          req(input$xlsx_sheets_curr)
          req(input$xlsx_new_name_curr)
          curr_xlsx_data <- readxl::read_excel(
            path = input$xlsx_file_curr$datapath,
            sheet = input$xlsx_sheets_curr)
        }),
        # |------ curr_xlsx_data_name ----
        curr_xlsx_data_name = reactive({
          # req(input$xlsx_new_name_curr)
         if (length(input$xlsx_new_name_curr) == 1) {
            as.character(input$xlsx_new_name_curr)
          } else {
            NULL
          }
        }),
        # |------ curr_flat_file_data ----
        curr_flat_file_data = reactive({
          req(input$flat_file_curr)
          req(input$new_flat_file_name_curr)
          curr_flat_file <- load_flat_file(
            path = input$flat_file_curr$datapath)
        }),
        # |------ curr_flat_file_data_name ----
        curr_flat_file_data_name = reactive({
            # req(input$new_flat_file_name_curr)
         if (length(input$new_flat_file_name_curr) == 1) {
            as.character(input$new_flat_file_name_curr)
          } else {
            NULL
          }
        })

      )
    )

  })

}
