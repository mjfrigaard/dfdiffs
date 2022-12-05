#' Display uploaded data (Server)
#'
#' @importFrom bs4Dash dashboardPage
#' @importFrom bs4Dash insertTab
#' @importFrom bs4Dash actionButton
#' @importFrom bs4Dash tabsetPanel
#' @importFrom bs4Dash column
#' @importFrom bs4Dash menuItem
#' @importFrom bs4Dash renderMenu
#' @importFrom bs4Dash sidebarUserPanel
#' @importFrom bs4Dash valueBox
#' @importFrom bs4Dash dropdownMenu
#' @importFrom bs4Dash dropdownMenuOutput
#' @importFrom bs4Dash renderInfoBox
#' @importFrom bs4Dash messageItem
#' @importFrom bs4Dash sidebarMenu
#' @importFrom bs4Dash dashboardBody
#' @importFrom bs4Dash tabItems
#' @importFrom bs4Dash notificationItem
#' @importFrom bs4Dash dashboardHeader
#' @importFrom bs4Dash renderValueBox
#' @importFrom bs4Dash menuSubItem
#' @importFrom bs4Dash dashboardSidebar
#' @importFrom bs4Dash updateTabItems
#' @importFrom bs4Dash tabItem
#' @importFrom bs4Dash box
#' @importFrom bs4Dash infoBox
#' @importFrom bs4Dash taskItem
#' @importFrom bs4Dash sidebarMenuOutput
#' @importFrom bs4Dash tabBox
#' @importFrom bs4Dash infoBoxOutput
#' @importFrom bs4Dash valueBoxOutput
#' @importFrom bs4Dash menuItemOutput
#' @importFrom bs4Dash dashboardPage
#'
#' @param id module id
#' @param data_upload list or uploaded xlsx and flat files
#'
#' @return list of previous xlsx/flat files and current xlsx/flat files
#' @export displayDataServer
#'
displayDataServer <- function(id, data_upload) {

  moduleServer(id = id, module = function(input, output, session) {

    ### prev_xlsx (reactive) ---------
    prev_xlsx <- reactive({
      prev_xlsx_data <- data_upload$prev_xlsx_data()
      return(prev_xlsx_data)
    })
    ### prev_xlsx_name (reactive) ---------
    prev_xlsx_name <- reactive({
      prev_xlsx_data_name <- data_upload$prev_xlsx_data_name()
      return(prev_xlsx_data_name)
    })

    ### prev_flat_file (reactive) ---------
    prev_flat_file <- reactive({
      prev_flat_file_data <- data_upload$prev_flat_file_data()
      return(prev_flat_file_data)
    })
    ### prev_flat_file_name (reactive) ---------
    prev_flat_file_name <- reactive({
      prev_flat_file_data_name <- data_upload$prev_flat_file_data_name()
      return(prev_flat_file_data_name)
    })

    ### curr_xlsx (reactive) ---------
    curr_xlsx <- reactive({
      curr_xlsx_data <- data_upload$curr_xlsx_data()
      return(curr_xlsx_data)
    })
    ### curr_xlsx_name (reactive) ---------
    curr_xlsx_name <- reactive({
      curr_xlsx_data_name <- data_upload$curr_xlsx_data_name()
      return(curr_xlsx_data_name)
    })

    ### curr_flat_file (reactive) ---------
    curr_flat_file <- reactive({
      curr_flat_file_data <- data_upload$curr_flat_file_data()
      return(curr_flat_file_data)
    })
    ### curr_flat_file_name (reactive) ---------
    curr_flat_file_name <- reactive({
      curr_flat_file_data_name <- data_upload$curr_flat_file_data_name()
      return(curr_flat_file_data_name)
    })

    ### prev_xlsx_data_name (display) ---------
    output$prev_xlsx_data_name <- renderPrint({
      print(prev_xlsx_name())
    })
    ### prev_xlsx_data (display) ---------
    output$prev_xlsx_data <- reactable::renderReactable({
      reactable::reactable(data = prev_xlsx(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

    ### prev_flat_file_data_name (display) ---------
    output$prev_flat_file_data_name <- renderPrint({
      print(prev_flat_file_name())
    })
    ### prev_flat_file_data (display) ---------
    output$prev_flat_file_data <- reactable::renderReactable({
      reactable::reactable(data = prev_flat_file(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

    ### curr_excel_data_name (display) ---------
    output$curr_excel_data_name <- renderPrint({
      print(curr_xlsx_name())
    })
    ### curr_excel_data (display) ---------
    output$curr_excel_data <- reactable::renderReactable({
      reactable::reactable(data = curr_xlsx(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

    ### curr_flat_file_data_name (display) ---------
    output$curr_flat_file_data_name <- renderPrint({
      print(curr_flat_file_name())
    })
    ### curr_flat_file_data (display) ---------
    output$curr_flat_file_data <- reactable::renderReactable({
      reactable::reactable(data = curr_flat_file(),
          defaultPageSize = 10,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE,
          filterable = TRUE)
    })

  })
}
