#' launch_select_demo
#'
#' @importFrom bslib page_navbar nav_panel card card_header card_body
#'
#' @export launch_select_demo
#' @description demo of the select module (\code{mod_select_ui()}/\code{mod_select_server()})
#'
#' @examples
#' \dontrun{
#' launch_select_demo()
#' }
launch_select_demo <- function() {
  select_data_theme <- dfdiffs_fresh_theme()
  ui <- bslib::page_navbar(
    title = "select demo",
    theme = select_data_theme,
    bslib::nav_panel(
      title = "1) Upload Data",
      icon = icon("file"),
      mod_upload_ui(id = "upload_data", dev = TRUE)
    ),
    bslib::nav_panel(
      title = "2) Select Data",
      icon = icon("table"),
      mod_select_ui(id = "select_data", dev = TRUE),
      ## reactive values -----
      bslib::card(
        full_screen = TRUE,
        bslib::card_header("Reactive values"),
        bslib::card_body(
          ## values -----
          verbatimTextOutput(
            outputId = "upload_values"
          )
        )
      )
    )
  )
  server <- function(input, output, session) {
    # upload data ------------------------------------------------
    upload_data_list <- mod_upload_server(id = "upload_data", dev = TRUE)
    # display data ------------------------------------------------
    select_data_list <- mod_select_server(id = "select_data",
                                         data_upload = upload_data_list, dev = TRUE)
    # reactive values ------------------------------------------------
    output$upload_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- grepl("upload_data", names(all_values))
      module_values <- all_values[module_names]
      reactable_names <- !grepl("__reactable__", names(module_values))
      values <- module_values[reactable_names]
      print(values)
    })
  }
  shinyApp(
    ui = ui, server = server
  )
}
