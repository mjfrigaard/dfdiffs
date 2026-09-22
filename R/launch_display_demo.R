# packages ----
library(shiny)
library(bslib)

library(reactable)

#' launch_display_demo
#'
#' @importFrom bslib page_navbar nav_panel card card_header card_body
#'
#' @return launch_display_demo app
#' @export launch_display_demo
#'
#' @description demo of the display module (\code{mod_display_ui()}/\code{mod_display_server()})
launch_display_demo <- function() {
  # reactable.theme (scoped to this app, not package load) ----
  options(reactable.theme = reactable::reactableTheme(
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
  ui <- bslib::page_navbar(
    title = "display demo",
    theme = bslib::bs_theme(version = 5),
    bslib::nav_panel(
      title = "Upload Data",
      icon = icon("file"),
      mod_upload_ui(id = "upload_data"),
      ## reactive values -----
      bslib::card(
        full_screen = TRUE,
        bslib::card_header("Reactive values"),
        bslib::card_body(
          verbatimTextOutput(outputId = "upload_values")
        )
      )
    ),
    bslib::nav_panel(
      title = "Display Data",
      icon = icon("table"),
      mod_display_ui(id = "display_data")
    )
  )

  server <- function(input, output, session) {

    upload_data_list <- mod_upload_server(id = "upload_data")

    mod_display_server(id = "display_data", data_upload = upload_data_list)

    output$upload_values <- renderPrint({
      all_values <- reactiveValuesToList(x = input, all.names = TRUE)
      module_names <- str_detect(names(all_values), "upload_data")
      module_values <- all_values[module_names]
      reactable_names <- str_detect(names(module_values), "__reactable__", negate = TRUE)
      values <- module_values[reactable_names]
      print(values)
    })

  }

  shinyApp(ui = ui, server = server,
    options = list(height = 800, width = 900))
}
