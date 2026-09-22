#' mod_display_ui
#'
#' @importFrom bslib accordion accordion_panel
#'
#' @param id module id
#'
#' @return display data UI
#' @export mod_display_ui
#'
#' @description UI module that previews the uploaded base and compare data
mod_display_ui <- function(id) {
  tagList(
    bslib::accordion(
      id = NS(namespace = id, id = "display_accordion"),
      multiple = TRUE,
      bslib::accordion_panel(
        title = "Base Data",
        icon = icon("table"),
        ## OUTPUT [base_data_name] ---------
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "base_data_name"),
          placeholder = TRUE
        ),
        ## OUTPUT [base_data_display] ---------
        reactable::reactableOutput(
          outputId = NS(namespace = id, id = "base_data_display")
        )
      ),
      bslib::accordion_panel(
        title = "Compare Data",
        icon = icon("table"),
        ## OUTPUT [comp_data_name] ---------
        verbatimTextOutput(
          outputId = NS(namespace = id, id = "comp_data_name"),
          placeholder = TRUE
        ),
        ## OUTPUT [comp_data_display] ---------
        reactable::reactableOutput(
          outputId = NS(namespace = id, id = "comp_data_display")
        )
      )
    )
  )
}

#' mod_display_server
#'
#' @param id module id
#' @param data_upload the reactive list returned by \code{mod_upload_server()}
#'   (\code{base_data}, \code{base_name}, \code{comp_data}, \code{comp_name})
#'
#' @return no return value; renders the base/compare preview outputs
#' @export mod_display_server
#'
#' @description Server module that previews the uploaded base and compare data
mod_display_server <- function(id, data_upload) {
  moduleServer(id = id, module = function(input, output, session) {
    ### base_data_name (display) ---------
    output$base_data_name <- renderPrint({
      print(data_upload$base_name())
    })
    ### base_data_display (display) ---------
    output$base_data_display <- reactable::renderReactable({
      reactable::reactable(
        data = data_upload$base_data(),
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE
      )
    })

    ### comp_data_name (display) ---------
    output$comp_data_name <- renderPrint({
      print(data_upload$comp_name())
    })
    ### comp_data_display (display) ---------
    output$comp_data_display <- reactable::renderReactable({
      reactable::reactable(
        data = data_upload$comp_data(),
        defaultPageSize = 10,
        resizable = TRUE,
        highlight = TRUE,
        compact = TRUE,
        wrap = FALSE,
        bordered = TRUE,
        filterable = TRUE
      )
    })
  })
}
