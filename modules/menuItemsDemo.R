library(shiny)
library(shinydashboard)
library(bs4Dash)
library(fresh)
library(tidyverse)

# theme -------------------------------------------------------------------
bmrn_theme <- function() {
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
      bg = "#d6d8ea", # background of entire side-bar
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
      dark = "#646464",
      light = "#A0A0A0",
      warning = "#EE304E", # red
      primary = "#00509C", # blue
      secondary = "#353D98", # purple
      success = "#A9218E", # violet
      danger = "#EE304E", # red
      info = "#F26631" #orange
    )
    # theme color -------------------------------------------------
    # fresh::bs4dash_color(
    #   orange = "#F26631", # orange
    #   blue = "#002E56", # blue
    #   gray_900 = "#A0A0A0", # gray
    #   white = "#FFFFFF" # white
    # )
  )
}

theme_demo <- bmrn_theme()

# item_A_UI --------------------------------------------------------------
item_A_UI <- function(id) {
  tagList(
    fluidRow(
      sortable(
        width = 12,
        bs4Dash::box(
          width = 6,
          collapsed = FALSE,
          status = "primary",
          solidHeader = TRUE,
          title = "Primary (blue = '#00509C')",
          textInput(
            # INPUT |-- text_A1 ------------------------
            inputId = NS(
              namespace = id,
              id = "text_A1"
            ),
            label = strong(
              "Text A1 input: ",
              code("text_A1")
            )
          ),
          br(),
          # print_A1 ------------------------
          strong("Print B1 Text: ", code("text_B1")),
          br(),
          htmlOutput(
            outputId = NS(namespace = id, id = "print_A1")
          ),
          br(),
          # values_A1 ------------------------
          strong("Look for A1 Values in: ", code(" print_C2")),
          verbatimTextOutput(
            outputId = NS(namespace = id, id = "values_A1")
          )
        )
      ),
      sortable(
        width = 12,
        bs4Dash::box(
          width = 6,
          status = "secondary",
          collapsed = TRUE,
          solidHeader = TRUE,
          title = "Secondary (purple = '#353D98')",
          # INPUT |-- text_A2 ------------------------
          textInput(
            inputId = NS(
              namespace = id,
              id = "text_A2"
            ),
            label = strong("Text A2 input:  ", code("  text_A2"))
          ),
          br(),
          # print_A2 ------------------------
          strong("Print C2 Text:  ", code("  text_C2")),
          br(),
          htmlOutput(
            outputId = NS(namespace = id, id = "print_A2")
          ),
          br(),
          # values_A2 ------------------------
          strong("Reactive A2 Values: ", code(" values_A2")),
          verbatimTextOutput(
            outputId = NS(namespace = id, id = "values_A2")
          )
        )
      )
    )
  )
}

theme_demo <- bmrn_theme()

# item_A_Server ----------------------------------------------------------
item_A_Server <- function(id, text_input) {
  moduleServer(id = id, module = function(input, output, session) {

    C1 <- eventReactive(text_input$text_C1(), {
              return_text <- text_input$text_C1()
              })

    observeEvent(eventExpr = C1(), handlerExpr = {
        output$print_A1 <- renderPrint({
            tags$h3(tags$code(C1()))
          })
        })


    C2 <- eventReactive(text_input$text_C2(), {
            return_text <- text_input$text_C2()
            })

    observeEvent(eventExpr = C2(), handlerExpr = {
      output$print_A2 <- renderPrint({
        tags$h3(tags$code(C2()))
          })
      })

    output$values_A1 <- renderPrint({
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values[names(values)[str_detect(names(values), "A1")]])
    })

    output$values_A2 <- renderPrint({
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values[names(values)[str_detect(names(values), "A2")]])
    })

    return(
      list(
        text_A1 = reactive({
          req(input$text_A1)
          as.character(input$text_A1)
        }),
        text_A2 = reactive({
          req(input$text_A2)
          as.character(input$text_A2)
        })
      )
    )
  })
}


# item_B_UI --------------------------------------------------------------
item_B_UI <- function(id) {
  tagList(
    bs4Dash::box(
      width = 6,
      status = "success",
      solidHeader = TRUE,
      title = "Success (violet = 'A9218E')",
      # INPUT |-- text_B1 ------------------------
      textInput(
        inputId = NS(namespace = id, id = "text_B1"),
        label = strong("Text B1 input:  ", code("  text_B1"))
      ),
      br(),
      # print_B1 ------------------------
      strong("Print C1 Text: ", code("  text_C1")),
      br(),
      htmlOutput(
        outputId = NS(namespace = id, id = "print_B1")
      ),
      br(),
      # values_B2 ------------------------
      strong("Reactive B1 Values: ", code(" values_B1")),
      verbatimTextOutput(
        outputId = NS(namespace = id, id = "values_B1")
      )
    )
  )
}

# item_B_Server ----------------------------------------------------------
item_B_Server <- function(id, text_input) {
  moduleServer(id = id, module = function(input, output, session) {

    C1 <- eventReactive(text_input$text_C1(), {
        return_text <- text_input$text_C1()
        })

    observeEvent(eventExpr = C1(), handlerExpr = {
            output$print_B1 <- renderPrint({
                    tags$h3(tags$code(C1()))
              })
    })


    output$values_B1 <- renderPrint({
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values)
    })

    return(
      list(
        text_B1 = reactive({
          req(input$text_B1)
          as.character(input$text_B1)
        })
      )
    )
  })
}

# item_C_UI --------------------------------------------------------------
item_C_UI <- function(id) {
  tagList(
    fluidRow(
      sortable(
        width = 12,
        bs4Dash::box(
          collapsed = TRUE,
          width = 6,
          status = "warning",
          solidHeader = TRUE,
          title = "Warning (red = '#EE304E')",
          # INPUT |-- text_C1 ------------------------
          textInput(
            inputId = NS(namespace = id, id = "text_C1"),
            label = strong("Text C1 input:  ", code("  text_C1"))
          ),
          br(),
          # print_C1 ------------------------
          strong("Print A2 Text: ", code("  text_A2")),
          br(),
          htmlOutput(
            outputId = NS(namespace = id, id = "print_C1")
          ),
          br(),
          # values_C1 ------------------------
          strong("Reactive C1 Values: ", code(" values_C1")),
          verbatimTextOutput(
            outputId = NS(namespace = id, id = "values_C1")
          )
        )
      ),
      sortable(
        width = 12,
        bs4Dash::box(
          status = "info",
          width = 6,
          solidHeader = TRUE,
          collapsed = FALSE,
          title = "Info (orange = '#F26631')",
         # print_C2 ------------------------
          strong("Print A1 Text: ", code("  print_C2")),
          br(),
          htmlOutput(
            outputId = NS(namespace = id, id = "print_C2")
          ),
           br(),
          # values_C2 ------------------------
          strong("Reactive C2 Values: ", code(" values_C2")),
          verbatimTextOutput(
            outputId = NS(namespace = id, id = "values_C2")
          ),
          br(),
         # INPUT |-- text_C2 ------------------------
          textInput(
            inputId = NS(namespace = id, id = "text_C2"),
            label = strong("Enter text and check:  ", code("  print_A2"))
          )
        )
      )
    )
  )
}

# item_C_Server ----------------------------------------------------------
item_C_Server <- function(id, text_input) {
  moduleServer(id = id, module = function(input, output, session) {

    observeEvent(eventExpr = input$sb_menu_id == "item_c", handlerExpr = {
      output$print_C1 <- renderPrint({
        return_text <- text_input$text_A2()
        tags$h3(tags$code(return_text))
      })
    })

    observeEvent(eventExpr = input$sb_menu_id == "item_c", handlerExpr = {
      output$print_C2 <- renderPrint({
        return_text <- text_input$text_A1()
        tags$h3(tags$code(return_text))
      })
    })

    output$values_C1 <- renderPrint({
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values[names(values)[str_detect(names(values), "C1")]])
    })

    output$values_C2 <- renderPrint({
      values <- reactiveValuesToList(x = input, all.names = TRUE)
      print(values[names(values)[str_detect(names(values), "C2")]])
    })

    return(
      list(
        text_C1 = reactive({
          req(input$text_C1)
          as.character(input$text_C1)
        }),
        text_C2 = reactive({
          req(input$text_C2)
          as.character(input$text_C2)
        })
      )
    )
  })
}


menuItemsDemo <- function() {

  ui <- bs4Dash::dashboardPage(
    # theme ----
    freshTheme = theme_demo,
    header = bs4Dash::dashboardHeader(
      compact = TRUE,
      title = "theme demo",
      skin = "light"),
    sidebar = bs4Dash::dashboardSidebar(
      skin = "light",
      fixed = TRUE,
      collapsed = FALSE,
      minified = TRUE,
      bs4Dash::sidebarMenu(
        id = "sb_menu_id",
        menuItem("item A",
          tabName = "item_a",
          icon = icon("file-upload")
        ),
        menuItem("item B",
          tabName = "item_b",
          icon = icon("th")
        ),
        menuItem("item C",
          tabName = "item_c",
          icon = icon("columns")
        )
      )
    ),
    body = bs4Dash::dashboardBody(
      tabItems(
        tabItem(
          tabName = "item_a",
          item_A_UI("mod_a")
        ),
        tabItem(
          tabName = "item_b",
          item_B_UI("mod_b")
        ),
        tabItem(
          tabName = "item_c",
          item_C_UI("mod_c")
        )
      )
    ),
    controlbar = bs4Dash::dashboardControlbar()
  )

  server <- function(input, output, session) {

    text_a <- item_A_Server(id = "mod_a", text_input = text_c)

    text_b <- item_B_Server(id = "mod_b", text_input = text_c)

    text_c <- item_C_Server(id = "mod_c", text_input = text_a)
  }

  shinyApp(ui = ui, server = server)
}

menuItemsDemo()
