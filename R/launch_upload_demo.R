#' launch_upload_demo
#'
#' @importFrom bslib page_navbar nav_panel
#'
#' @return app
#' @export launch_upload_demo
#'
#' @description demo of the upload module (\code{mod_upload_ui()}/\code{mod_upload_server()})
launch_upload_demo <- function() {
  upload_theme <- dfdiffs_fresh_theme()
  ui <- bslib::page_navbar(
    title = "dev upload demo",
    theme = upload_theme,
    bslib::nav_panel(
      title = "1) Upload Data",
      icon = icon("file"),
      mod_upload_ui(id = "upload_data", dev = TRUE)
    )
  )

  server <- function(input, output, session) {
    mod_upload_server(id = "upload_data", dev = TRUE)
  }

  shinyApp(
    ui = ui, server = server
  )
}
