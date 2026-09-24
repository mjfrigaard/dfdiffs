#' launch_app_dev
#'
#' @importFrom bslib page_navbar nav_panel nav_spacer nav_item navbar_options input_dark_mode
#'
#' @export launch_app_dev
#' @description dev variant of \code{launch_app()} with the modules' debug
#'   reactive-value outputs turned on (\code{dev = TRUE})
#'
#' @examples
#' \dontrun{
#' launch_app_dev()
#' }
launch_app_dev <- function() {
  compare_theme <- dfdiffs_fresh_theme()
  ui <- bslib::page_navbar(
    id = "main_nav",
    title = "(dev) dfdiffs",
    theme = compare_theme,
    navbar_options = bslib::navbar_options(bg = "#011627", theme = "dark"),
    # 1) upload data -----
    bslib::nav_panel(
      title = "1) Upload Data",
      icon = icon("file-upload"),
      mod_upload_ui(id = "upload_data", dev = TRUE)
    ),
    # 2) select data -----
    bslib::nav_panel(
      title = "2) Select Data",
      icon = icon("columns"),
      mod_select_ui(id = "select_data", dev = TRUE)
    ),
    # 3) compare data -----
    bslib::nav_panel(
      title = "3) Compare Data",
      icon = icon("compress-alt"),
      mod_compare_ui("compare_data", dev = TRUE)
    ),
    bslib::nav_spacer(),
    # getting started -----
    bslib::nav_panel(
      title = "Getting Started",
      icon = icon("compass"),
      shiny::includeMarkdown(
        system.file("compareDataApp/assets/intro.md", package = "dfdiffs")
      )
    ),
    # about -----
    bslib::nav_panel(
      title = "About",
      icon = icon("book-open"),
      shiny::includeMarkdown(
        system.file("compareDataApp/assets/about.md", package = "dfdiffs")
      )
    ),
    bslib::nav_item(uiOutput(outputId = "step_indicator", inline = TRUE)),
    bslib::nav_item(bslib::input_dark_mode(id = "dark_mode"))
  )
  server <- function(input, output, session) {
    dark_mode <- reactive({
      identical(input$dark_mode, "dark")
    })
    # mod_upload_server --------------------
    upload_data_list <- mod_upload_server(id = "upload_data", dev = TRUE, dark_mode = dark_mode)
    # mod_select_server --------------------
    select_data_list <- mod_select_server(
      id = "select_data",
      data_upload = upload_data_list,
      dev = TRUE,
      dark_mode = dark_mode
    )
    # mod_compare_server ------------------
    mod_compare_server(
      id = "compare_data",
      data_selected = select_data_list,
      dev = TRUE,
      dark_mode = dark_mode
    )

    output$step_indicator <- renderUI({
      nav_value <- input$main_nav
      if (is.null(nav_value) || length(nav_value) != 1) {
        return(NULL)
      }
      step <- switch(nav_value,
        "1) Upload Data" = 1L,
        "2) Select Data" = 2L,
        "3) Compare Data" = 3L,
        NA_integer_
      )
      if (is.na(step)) {
        return(NULL)
      }
      tags$span(class = "navbar-text", paste0("Step ", step, " of 3"))
    })

    observeEvent(
      {
        req(upload_data_list$base_data())
        req(upload_data_list$comp_data())
        TRUE
      },
      once = TRUE,
      {
        bslib::nav_select(id = "main_nav", selected = "2) Select Data", session = session)
      }
    )
    observeEvent(
      {
        req(length(select_data_list$join_selected()) > 0)
        TRUE
      },
      once = TRUE,
      {
        bslib::nav_select(id = "main_nav", selected = "3) Compare Data", session = session)
      }
    )
  }

  shinyApp(
    ui = ui, server = server
  )
}
