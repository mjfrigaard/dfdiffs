#' Display uploaded data (UI)
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
#' @param id
#'
#' @return display data UI
#' @export displayDataUI
#'
displayDataUI <- function(id) {
  tagList(
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "success",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Excel File Data (previous)"),
          ## OUTPUT [prev_xlsx_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "prev_xlsx_data_name"),
            placeholder = TRUE),
          ## OUTPUT [prev_xlsx_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "prev_xlsx_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "primary",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Flat File Data (previous)"),
          ## OUTPUT [prev_flat_file_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "prev_flat_file_data_name"),
            placeholder = TRUE),
          ## OUTPUT [prev_flat_file_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "prev_flat_file_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "success",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Excel File Data (current)"),
          ## OUTPUT [curr_excel_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
              id = "curr_excel_data_name"),
            placeholder = TRUE),
          ## OUTPUT [curr_excel_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "curr_excel_data"
            )
          )
        )
      ),
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          status = "primary",
          collapsed = TRUE,
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Flat File Data (current)"),
          ## OUTPUT [curr_flat_file_data_name] ---------
          verbatimTextOutput(
            outputId = NS(namespace = id,
            id = "curr_flat_file_data_name"),
            placeholder = TRUE),
          ## OUTPUT [curr_flat_file_data] ---------
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "curr_flat_file_data"
            )
          )
        )
      ),
    )
  )
}
