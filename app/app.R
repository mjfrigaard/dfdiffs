# =====================================================================#
# File name: app.R
# This is code to create: functions for the proc compare app
# Authored by and feedback to: ma904058@brmn.com
# Last updated:  2022-01-12
# MIT License
# Version: 0.4.3.2
# =====================================================================#

# packages --------
library(shiny)
library(shinydashboard)
library(dplyr)
library(tidyr)
library(arsenal)
library(stringr)
library(lubridate)
library(DT)
library(inspectdf)
library(openxlsx)
library(tibble)
library(purrr)
library(markdown)
library(feather)


# helpers -------------------------------------------------------
source("helpers.R")

# shiny.maxRequestSize -----------------------------------------
options(shiny.maxRequestSize = 2000 * 1024^2)
# options(shiny.maxRequestSize = 100 * 1024^2)
# https://shiny.rstudio.com/articles/upload.html
# (30*1024^2) / 1000000 = 31.46MB
# divide the digital storage value by 1e+6 


# data -----------------------------------------------------------
load("proc_app_data.rdata")

ui <- dashboardPage(
# dashboardHeader ---------------------------------------------------------
dashboardHeader(title = "pRoc  compare (v0.4.3.2)"),
# dashboardSidebar --------------------------------------------------------
dashboardSidebar(
  h5(
    HTML("&emsp;"),
    strong(
      "Welcome to ",
      code("pRoc", .noWS = "before"),
      " compare!"
    )
  ),
  collapsed = FALSE,
  sidebarMenu(
    menuItem(
      text = "Intro", tabName = "intro",
      icon = icon("file")
    ),
    ## data_upload menuItem -----------------
    menuItem(
      text = "1) Upload Data",
      icon = icon("file-upload"),
      tabName = "data_upload"
    ),
    ## select_columns menuItem -----------------
    menuItem(
      text = "2) Select Columns",
      icon = icon("columns"),
      tabName = "select_columns"
    ),
    
    ## preview_compare menuItem ----------
    menuItem(
      text = "3) Review & Compare",
      icon = icon("compress-alt"),
      tabName = "preview_compare"
    ),
    ## Output Tables menuSubItems -----------------
    menuItem(
      text = "4) Output Tables",
      icon = icon("table"),
      startExpanded = FALSE,
      ### SubItems summary ---------
      menuSubItem("Comparison summary",
                  tabName = "summary"
      ),
      ### SubItems new_records ---------
      menuSubItem("New records",
                  tabName = "new_records"
      ),
      ### SubItems diff_tables ---------
      menuSubItem("Modified records",
                  tabName = "diff_tables"
      ),
      ### SubItems new_records ---------
      menuSubItem("Deleted records",
                  tabName = "deleted_records"
      ),
      ### SubItems misc_tables ---------
      menuSubItem("Not shared",
                  tabName = "misc_tables"
      )
    ),
    ### Export menuItem  ---------
    menuItem(
      text = "5) Export",
      tabName = "export",
      icon = icon("file-download")
    ),
    ### About menuItem ---------
    menuItem(
      text = "About",
      tabName = "about"
    )
  ),
  textOutput(outputId = "sidebar_text")
),
# dashboardBody -------
dashboardBody(
  tabItems(
    tabItem(
      ## TAB 1: INTO ITEM (intro) -----
      tabName = "intro",
      tabBox(
        title = strong("Introduction"), width = 12,
        tabPanel(
          title = strong("Quick Start"),
          fluidRow(
            column(
              12,
              h3(em("Welcome to PROC Compare (an application for comparing multiple datasets).")),
              h4(" To get started:"),
              br(),
              h4("1) Click on the '", strong("Upload Data"), "' menu item to upload two datasets."),
              h5(HTML('&emsp;'), "1a) If you have a large dataset, upload it in the ", tags$a(href = "https://github.com/wesm/feather", code("feather"), " format.")),
              h5(HTML('&emsp;'), "1b) Use", tags$a(href = "https://aceshiny-dev.bmrn.com/content/735606b4-83da-4654-a6bf-93d97ea05115", "this dashboard "), "to convert a SAS dataset (.sas7bdat) to a feather format (.feather)."),
              h4("2) Specify the ", strong(code("by")), " column and columns you'd like to compare."),
              h4("3) Review your inputs and run", code("Compare!"), "."),
              h4("4) Check the ", strong("Output Tables"), " and change inputs as needed."),
              h4("5) Export the report as an excel file by clicking ", strong(code("Download Excel Report")), ".")
            )
          )
        ),
        tabPanel(
          title = strong("Tables"), width = 12,
          fluidRow(
            column(
              12,
              
              ### Intro (markdown) -------------
              includeMarkdown("assets/intro.md"),
              br(),
              tags$em("Please email Martin (ma904058@bmrn.com) about any bugs, questions, or feature requests")
            )
          )
        )
      )
    ),
    
    ## TAB 2: DATA UPLOAD TAB ITEM (data_upload) -----
    tabItem(
      tabName = "data_upload",
      tabBox(
        title = strong("Data Upload"), width = 12,
        tabPanel(
          title = strong("Data Upload"),
          tags$h4("To get started, import two", code(".sas7bdat"), " or ", code(".feather"), " datasets."),
          fluidRow(
            column(
              6,
              br(),
              ### TAB 2: Input X = Select a file (input$upload_file_x) ----
              fileInput(
                inputId = "upload_file_x",
                label = p("Current Data (", code("X"), ")"),
                multiple = TRUE,
                accept = c(".sas7bdat")
              ),
              ### TAB 2: Name X = Name Data X (input$file_name_x) ----
              tags$h5("Enter a name for the ", em("current"), " dataset:"),
              textInput(inputId = "file_name_x", label = "Current Data")
            ),
            column(
              6,
              br(),
              ### TAB 2: Input Y = Select a file (input$upload_file_y) ----
              fileInput("upload_file_y",
                        label = p("Previous Data (", code("Y"), ")"),
                        multiple = TRUE,
                        accept = c(".sas7bdat")
              ),
              ### TAB 2: Name Y = Name Data Y (input$file_name_y) ----
              tags$h5("Enter a name for the ", em("previous"), " dataset:"),
              textInput(inputId = "file_name_y", label = "Previous Data")
            )
          )
        )),
      tabBox(
        title = strong("Data Files"),
        width = 12,
        tabPanel(
          h5(strong("Current Data ", code("data x"))),
          ### TAB 2: Preview X Data columns (input$preview_x_cols) -----------
          tags$h4("A preview of the data will be displayed after a name has been entered."),
          fluidRow(
            column(
              8,
              selectizeInput(
                inputId = "preview_x_cols",
                label = strong("Preview current data columns"),
                choices = c(
                  " ",
                  as.character("x column 1"),
                  as.character("x column 2"),
                  as.character("x column ...")
                ),
                multiple = TRUE
              ),
              #### TAB 2: define selectizeInput size --------
              # tags$head(tags$style(HTML(".selectize-input {height: 60px; width: 480px; font-size: 12px;}")))
            ),
          ),
          ### TAB 2: Preview SAS Data X ---------
          fluidRow(
            column(
              12,
              reactable::reactableOutput(outputId = "contents_x")
            )
          )
        ),
        tabPanel(
          h5(strong("Previous Data ", code("data y"))),
          tags$h4("A preview of the data will be displayed after a name has been entered."),
          fluidRow(
            column(
              8,
              ### TAB 2: Preview Y Data columns (input$preview_y_cols) ---------
              selectizeInput(
                inputId = "preview_y_cols",
                label = strong("Preview previous data columns"),
                choices = c(
                  " ",
                  as.character("y column 1"),
                  as.character("y column 2"),
                  as.character("y column ...")
                ),
                multiple = TRUE
              )
            )
          ),
          ### TAB 2) Preview SAS Data Y ---------
          fluidRow(
            column(
              12,
              reactable::reactableOutput(outputId = "contents_y")
            )
          )
        ),
      )
    ),
    ## TAB 3: Select Columns ------------
    tabItem(
      tabName = "select_columns",
      tabBox(
        title = strong("Select Columns"),
        width = 12,
        tabPanel(
          title = strong("Columns"),
          fluidRow(
            column(
              6,
              strong(
                "Select the join column(s) between current (",
                code("data x"), ") and previous (", code("data y"), ") :"
              ),
              ### TAB 3: select join columns  (input$by_var) -----------
              selectizeInput(
                inputId = "by_var",
                label = em("Select", code("by"), "column(s):"),
                choices = c(
                  " ",
                  as.character("column 1"),
                  as.character("column 2"),
                  as.character("column ...")
                ),
                multiple = TRUE
              )
            ),
            ### TAB 3: new join column name (input$new_col_name) -----------
            column(
              6,
              br(), br(),
              shiny::textInput(
                inputId = "new_col_name",
                label = em("Enter join column name:")
              ),
              em(
                "The new join column combines the ",
                code("by"),
                " columns together to create a unique id between the two datasets."
              )
            )
          ),
          fluidRow(
            tags$style(all_cols_css),
            column(
              6,
              h5(strong(
                "Select the columns (fields) to compare:"
              )),
              ### TAB 3: select compare columns (input$compare_vars) -----------
              selectizeInput(
                inputId = "compare_vars",
                label = p(em("Select columns to compare")),
                choices = c(
                  " ",
                  as.character("column 1"),
                  as.character("column 2"),
                  as.character("column ...")
                ),
                multiple = TRUE
              ),
              ### TAB 3: checkbox all columns (input$all_cols) -----------
              checkboxInput(
                inputId = "all_cols",
                label = "Compare all columns",
                value = TRUE
              )
            ),
            column(
              6,
              tags$h5("Review the joining column(s):"),
              shiny::tableOutput(outputId = "join_col")
            )
          )
        )
      )
    ),
    ## TAB 4: Preview and COMPARE! ------------
    tabItem(
      tabName = "preview_compare",
      tabBox(
        width = 12,
        title = strong("Review Data"),
        #### TAB 4) PREVIEW COMPARISON X ------------
        tabPanel(
          title = strong("Review ", code("current"), " data"),
          reactable::reactableOutput(outputId = "compare_preview_x")
        ),
        #### TAB 4) PREVIEW COMPARISON Y ------------
        tabPanel(
          title = strong("Review ", code("previous"), " data"),
          reactable::reactableOutput(outputId = "compare_preview_y")
        )
      ),
      tabBox(
        title = strong("Run Compare"),
        width = 12,
        tabPanel(
          title = strong("Review and run ", code("compare")),
          fluidRow(
            column(
              6,
              h5("If the datasets look correct, click on the ", code("Compare!"), "button below:"),
              actionButton(
                ### TAB 4: RUN COMPARE! (input$run_comparedf) ------------
                inputId = "run_comparedf",
                label = code("Compare!")
              )),
            column(6,
                   h5("After clicking ", code("Compare!")," you'll see a summary of the tables and their dimensions:"),
                   shiny::tableOutput(outputId = "frame_summary_table_display")
            )
          )
        )
      )
    ),
    ## TAB 5.1: summary ------------
    tabItem(
      tabName = "summary",
      tabBox(
        title = strong("Summary"),
        tabPanel(
          title = strong("Comparison summary"),
          fluidRow(
            column(
              12,
              h5("Below is a summary of the overall comparison"),
              ### comparison_summary_table_display ----
              shiny::tableOutput(
                outputId = "comparison_summary_table_display"
              )
            )
          )
        )
      )
    ),
    ## TAB 5.2: New records ------------
    tabItem(
      tabName = "new_records",
      tabBox(
        title = strong("New records"),
        width = 12,
        tabPanel(
          title = strong("New records"),
          fluidRow(column(
            12,
            h5("Below are the new records"),
            reactable::reactableOutput(outputId = "new_records_display")
          ))
        )
      )
    ),
    ## TAB 5.4: diff_tables ------------
    tabItem(
      tabName = "diff_tables",
      tabBox(
        title = strong("Modified records"),
        width = 12,
        ### diffs_byvar_table_display -----
        tabPanel(
          title = strong("Changes detected per variable"),
          fluidRow(column(
            12,
            h5("Below is summary of the changes detected per variable"),
            reactable::reactableOutput(outputId = "diffs_byvar_table_display")
          ))
        ),
        ### diffs_table_display ----
        tabPanel(
          title = strong("Changes detected"),
          fluidRow(
            column(12,
                   h5("Below are the row-by-row changes (by the joining column)"),
                   #### sticky-cols.css! ----
                   tags$style(HTML("
        .sticky {
          position: sticky !important;
          background: #fff;
          z-index: 1;
        }
        
        .left-col-1 {
          left: 0;
        }
        
        .left-col-2 {
          left: 100px;
        }
        
        .left-col-3 {
          left: 200px;
          border-right: 1px solid #eee !important;
        }
        
        .right-col-1 {
          right: 0;
          border-left: 1px solid #eee !important;
        }")),
                   reactable::reactableOutput(outputId = "diffs_table_display")
            ))
        )
      ),
      tabBox(
        title = "Comparison Tables", width = 12,
        tabPanel(
          title = strong("Current Data"),
          fluidRow(column(
            12,
            h5("Below is the current dataset"),
            ### current_diffs_display ----
            reactable::reactableOutput(outputId = "current_diffs_display")
          ))
        ),
        tabPanel(
          title = strong("Previous Data"),
          fluidRow(column(
            12,
            h5("Below is the previous dataset"),
            ### previous_diffs_display ----
            reactable::reactableOutput(outputId = "previous_diffs_display")
          ))
        )
      )
    ),
    ## TAB 5.5: deleted_records ------------
    tabItem(
      tabName = "deleted_records",
      tabBox(
        title = strong("Deleted records"),
        width = 12,
        tabPanel(
          title = strong("Deleted records"),
          fluidRow(column(
            12,
            h5("Below are the deleted records"),
            reactable::reactableOutput(outputId = "deleted_records_display")
          ))
        )
      )
    ),
    ## TAB 5.3: vars_tables ------------
    tabItem(
      tabName = "misc_tables",
      tabBox(
        title = strong("Not shared"),
        width = 12,
        #### obs_table_display
        tabPanel(
          title = strong("Observations not shared"),
          fluidRow(column(
            12,
            h5("Below are the observations not shared in the datasets"),
            reactable::reactableOutput(outputId = "obs_table_display")
          ))
        ),
        #### vars_ns_table_display
        tabPanel(
          title = strong("Variables not shared"),
          fluidRow(column(
            12,
            h5("Below are the variables not shared in the datasets"),
            reactable::reactableOutput(outputId = "vars_ns_table_display")
          ))
        ),
        #### vars_nc_table_display
        tabPanel(
          title = strong("Other variables not compared"),
          fluidRow(column(
            12,
            h5("Below are the other variables not compared in the datasets"),
            reactable::reactableOutput(outputId = "vars_nc_table_display")
          ))
        )
      )
    ),
    ## TAB 6: Export ------------
    tabItem(
      tabName = "export",
      tabBox(
        title = strong("Export"),
        width = 12,
        ### Tab 6: downloadButton ----------------------
        tabPanel(
          title = strong("Export"),
          fluidRow(
            column(
              12,
              h5("Click the button below to download the current report:"),
              br(),
              downloadButton(
                outputId = "report_download",
                label = "Download Excel Report"
              )
            )
          )
        )
      )
    ),
    ## TAB 7: About ------------
    tabItem(
      tabName = "about",
      tabBox(
        title = "About", width = 12,
        tabPanel(
          title = "About",
          fluidRow(
            column(
              12,
              includeMarkdown("assets/about.md"),
              br(),
              tags$em("Please email Martin (ma904058@bmrn.com) about any bugs, questions, or feature requests")
            )
          )
        ),
        tabPanel(
          title = "Demo",
          fluidRow(
            column(
              12,
              includeMarkdown("assets/demo.md"),
              br(),
              tags$em("Please email Martin (ma904058@bmrn.com) about any bugs, questions, or feature requests")
            )
          )
        )
      )
    )
  )
)
)

server <- function(input, output, session) {

# TAB 2 = IMPORT X ----------
# here we build the imported reactive dataset x and add the original file
# name
data_input_x <- reactive({
  req(input$upload_file_x)
  df_x <- load_file(input$upload_file_x$name, input$upload_file_x$datapath)
  # add orginal name column
  dfx_orig_name <- add_column(
    .data = df_x,
    ORIGNAME = input$upload_file_x$name
  )
  # input$upload_file_y will be NULL initially. After the user selects
  # and uploads a file
  return(dfx_orig_name)
})
# TAB 2 = data_input_x_reactive() ----
# here we add the new_
data_input_x_reactive <- reactive({
  
  req(input$upload_file_x)
  req(input$file_name_x)
  
  # add app name column
  sas_app_name <- add_column(
    .data = data_input_x(),
    APPNAME = input$file_name_x
  )
  
  # reorganize
  data_input_x <- select(
    sas_app_name, ORIGNAME, APPNAME,
    everything()
  )
  
  return(data_input_x)
})
# TAB 2 = OBSERVE (X VARS PREVIEW) ----------
# this gives us the column names of the x dataset
observe({
  req(input$file_name_x)
  if (is.null(input$upload_file_x)) {
    x <- character(0)
  } else {
    data_input_x <- select(data_input_x_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,
                           ##### remove sys_vars! --------
                           -all_of(sys_vars))
    
    x <- names(data_input_x)
  }
  # Can also set the label and select items
  updateSelectizeInput(
    inputId = "preview_x_cols",
    choices = as.character(x),
    selected = x[1:5]
  )
})
# TAB 2 = X CONTENTS REACTIVE ----------
# this is the reactive x dataset for the preview
contents_x_reactive <- reactive({
  
  req(input$upload_file_x)
  req(input$file_name_x)
  
  contents_x <- select(
    data_input_x_reactive(),
    all_of(input$preview_x_cols),
    -ORIGNAME,
    -APPNAME
  )
  return(contents_x)
  
})
# TAB 2 = RENDER X (PREVIEW) ----------
output$contents_x <- reactable::renderReactable({
  
  req(input$upload_file_x)
  req(input$file_name_x)
  req(input$preview_x_cols)
  
  reactable::reactable(
    data = contents_x_reactive(),
    ##### reactable settings! ------
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    height = 220,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 2 = IMPORT Y ------------
data_input_y <- reactive({
  req(input$upload_file_y)
  df_y <- load_file(input$upload_file_y$name, input$upload_file_y$datapath)
  # add original name column
  dfy_orig_name <- add_column(
    .data = df_y,
    ORIGNAME = input$upload_file_y$name
  )
  # input$upload_file_y will be NULL initially. After the user selects
  # and uploads a file
  return(dfy_orig_name)
})

# TAB 2 = data_input_y_reactive() ----
data_input_y_reactive <- reactive({
  
  req(input$upload_file_y)
  req(input$file_name_y)
  
  # add app name column
  sas_app_name <- add_column(
    .data = data_input_y(),
    APPNAME = input$file_name_y
  )
  
  data_input_y <- select(
    sas_app_name, ORIGNAME, APPNAME,
    everything()
  )
  
  return(data_input_y)
})

# TAB 2 = OBSERVE (Y VARS PREVIEW)  ----------
# this gives us a preview of the y dataset columns
observe({
  req(input$file_name_y)
  if (is.null(input$upload_file_y)) {
    x <- character(0)
  } else {
    data_input_y <- select(data_input_y_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,
                           ##### remove sys_vars --------
                           -all_of(sys_vars))
    
    x <- names(data_input_y)
  }
  # Can also set the label and select items
  updateSelectizeInput(
    inputId = "preview_y_cols",
    choices = as.character(x),
    selected = x[1:5]
  )
})

# TAB 2 = Y CONTENTS REACTIVE ----------
# this is the reactive y dataset for the preview
contents_y_reactive <- reactive({
  
  req(input$upload_file_y)
  req(input$file_name_y)
  
  contents_y <- select(
    data_input_y_reactive(),
    all_of(input$preview_y_cols),
    -ORIGNAME,
    -APPNAME
  )
  return(contents_y)
  
})

# TAB 2 = RENDER Y (PREVIEW) ------------------
output$contents_y <- reactable::renderReactable({
  
  req(input$upload_file_y)
  req(input$file_name_y)
  req(input$preview_y_cols)
  
  reactable::reactable(
    # data = contents_y,
    data = contents_y_reactive(),
    ##### reactable settings ------
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    height = 220,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 3 =  OBSERVE by variable (by_var) ------
observe({
  if (is.null(input$upload_file_x) & is.null(input$upload_file_y)) {
    # define output x
    x <- character(0)
  } else {
    data_input_x <- select(data_input_x_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,
                           ##### remove sys_vars --------
                           -all_of(sys_vars))
    
    data_input_y <- select(data_input_y_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,
                           ##### remove sys_vars --------
                           -all_of(sys_vars))
    x <- intersect(
      x = names(data_input_x),
      y = names(data_input_y)
    )
  }
  # Can also set the label and select items
  updateSelectizeInput(
    inputId = "by_var",
    choices = c("", as.character(x))
  )
})

# TAB 3 = OBSERVE compare variables (compare_vars) ------
observe({
  req(input$by_var)
  if (is.null(input$upload_file_x) & is.null(input$upload_file_y)) {
    x <- character(0)
    ## TAB 3: ALL COLUMNS COMPARED -----
  } else if (input$all_cols == TRUE) {
    data_input_x <- select(data_input_x_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,
                           ##### remove sys_vars! --------
                           -all_of(sys_vars))
    data_input_y <- select(data_input_y_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,            
                           # remove sys_vars! --------
                           -all_of(sys_vars))
    x <- intersect(
      x = names(data_input_x),
      y = names(data_input_y)
    )
    
    # Can also set the label and select items
    updateSelectizeInput(
      inputId = "compare_vars",
      # choices = x,
      choices = c("", as.character(x)),
      selected = x
    )
  } else {
    ## TAB 3: SOME COLUMNS COMPARED -----
    data_input_x <- select(data_input_x_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,
                           ##### remove sys_vars! --------
                           -all_of(sys_vars))
    data_input_y <- select(data_input_y_reactive(), 
                           -ORIGNAME, 
                           -APPNAME,            
                           ### remove sys_vars! --------
                           -all_of(sys_vars))
    x <- intersect(
      x = names(data_input_x),
      y = names(data_input_y)
    )
    
    x <- stringr::str_remove(
      string = x,
      pattern = input$by_var
    )
    
    # Can also set the label and select items
    updateSelectizeInput(
      inputId = "compare_vars",
      # choices = x,
      choices = c("", as.character(x)),
      selected = head(x, 10)
    )
  }
})

# TAB 3 = DATA X REACTIVE (data_x_reactive) ------------
data_x_reactive <- reactive({
  # req(input$by_var)
  req(input$new_col_name)
  #### TAB 3: (DATA X) create new join col data -----
  join_data_x <- create_join_column(
    df = data_input_x_reactive(),
    join_cols = input$by_var,
    new_col_name = input$new_col_name
  )
  # define compare cols
  x_cols <- as.character(input$compare_vars)
  by_cols <- as.character(input$by_var)
  new_join_col <- as.character(input$new_col_name)
  # select data for comparison
  data_compare_x <- select(
    join_data_x,
    all_of(new_join_col),
    all_of(by_cols),
    any_of(x_cols)
  )
  # return data
  data_compare_x
})

# TAB 3 = DATA Y REACTIVE (data_y_reactive) -----
data_y_reactive <- reactive({
  # req(input$by_var)
  req(input$new_col_name)
  #### TAB 3: (DATA Y) create new join col data -----
  join_data_y <- create_join_column(
    df = data_input_y_reactive(),
    join_cols = input$by_var,
    new_col_name = input$new_col_name
  )
  # define cols
  y_cols <- as.character(input$compare_vars)
  by_cols <- as.character(input$by_var)
  new_join_col <- as.character(input$new_col_name)
  # select data for comparison
  data_compare_y <- select(
    join_data_y,
    all_of(new_join_col),
    all_of(by_cols),
    any_of(y_cols)
  )
  # return data
  data_compare_y
})

# TAB 3 = RENDER JOIN COL (PREVIEW) ----------
output$join_col <- shiny::renderTable({
  # req(input$by_var)
  # req(input$new_col_name)
  validate(
    need(input$new_col_name, "please provide a join column name")
  )
  preview_join_col <- select(
    data_x_reactive(),
    any_of(input$by_var),
    any_of(input$new_col_name)
  )
  
  preview_join_col <- mutate(
    .data = preview_join_col,
    across(where(is.numeric), .fns = as.integer)
  )
  
  head(preview_join_col, 10)
})

# TAB 3 (SLOW!!) = RENDER X PREVIEW ---------
output$compare_preview_x <- reactable::renderReactable({
  reactable::reactable(
    data = data_x_reactive(),
    ##### reactable settings ------
    # pagination = FALSE,
    resizable = TRUE,
    highlight = TRUE,
    height = 400,
    wrap = FALSE,
    # bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 3 (SLOW!!) = RENDER Y PREVIEW ----------
output$compare_preview_y <- reactable::renderReactable({
  reactable::reactable(
    data_y_reactive(),
    ##### reactable settings ------
    # pagination = FALSE,
    resizable = TRUE,
    highlight = TRUE,
    height = 400,
    wrap = FALSE,
    # bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 4 = COMPAREDF REACTIVE -------
comparedf_summary_reactive <- reactive({
  req(input$run_comparedf)
  comparedf_object <- comparedf(
    x = data_x_reactive(),
    y = data_y_reactive(),
    by = input$new_col_name
  )
  summary_comparedf_object <- summary(comparedf_object)
  return(summary_comparedf_object)
})

# TAB 5.1 = REACTIVE frame_summary_table() ----
frame_summary_table <- reactive({
  req(input$run_comparedf)
  # get data as strings
  current_data <- as.character(input$file_name_x)
  previous_data <- as.character(input$file_name_y)
  # extract  
  frame.summary.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "frame.summary.table",
    by_col = input$new_col_name
  )
  # change dataset names 
  frame_summary_table <- mutate(frame.summary.table,
                                Dataset = if_else(condition =
                                                    Dataset == "data_x_reactive()",
                                                  true = current_data,
                                                  false = previous_data
                                )
  )
  return(frame_summary_table)
})

## TAB 5.1 = RENDER [frame_summary_table_display] ----
output$frame_summary_table_display <- shiny::renderTable({
  req(input$run_comparedf)
  frame_summary_table()
})

# TAB 5.1 = REACTIVE comparison_summary_table() -----
comparison_summary_table <- reactive({
  req(input$run_comparedf)
  comparison.summary.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "comparison.summary.table",
    by_col = input$new_col_name
  )
  return(comparison.summary.table)
})

## TAB 5.1 = RENDER [comparison_summary_table_display] -----
output$comparison_summary_table_display <- shiny::renderTable({
  req(input$run_comparedf)
  comparison_summary_table()
})

# TAB 5.2 = REACTIVE new records new_data_reactive() --------
new_data_reactive <- reactive({
  new_data <- create_new_data(
    newdf = data_x_reactive(),
    olddf = data_y_reactive(),
    by = input$new_col_name
  )
})

## TAB 5.2 = Render New Records [new_records_display] -------
output$new_records_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = new_data_reactive(),
    ##### reactable settings ------
    # pagination = FALSE,
    resizable = TRUE,
    highlight = TRUE,
    wrap = FALSE,
    # bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 5.3 = REACTIVE  diffs_byvar_table() -----
diffs_byvar_table <- reactive({
  req(input$run_comparedf)
  diffs.byvar.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "diffs.byvar.table",
    by_col = input$new_col_name
  )
  return(diffs.byvar.table)
  
})

## TAB 5.3 = RENDER  [diffs_byvar_table_display] -----
output$diffs_byvar_table_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = diffs_byvar_table(),
    ##### reactable settings ------
    columns = list(
      Diffs = reactable::colDef(
        style = function(value) {
          color <- if (value > 0) {
            "#e00000"
          } else if (value < 0) {
            "#008000"
          }
          list(fontWeight = 500, color = color)
          
        }
      )
    ),
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    height = 300,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 5.3 = Diffs Table REACTIVE  -----
diffs_table <- reactive({
  req(input$run_comparedf)
  diffs.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "diffs.table",
    by_col = input$new_col_name
  )
  # # join to current data (data_x_reactive()), but first convert join 
  # # columns to character 
  data_x_join_data <- mutate(.data = data_x_reactive(),
    across(.fns = as.character))
  diffs_table_join_data <- mutate(.data = diffs.table,
    across(.fns = as.character))
  # join
  diffs_table <- inner_join(
    x = data_x_join_data,
    y = diffs_table_join_data,
    by = input$new_col_name
  )
  # reorganize cols
  diffs_table <- select(
    diffs_table,
    `Modified Column`,
    `Previous Value`,
    `Current Value`,
    all_of(input$new_col_name),
    everything()
  )
  return(diffs.table)
})

# TAB 5.3 = RENDER diffs_table_display -----
output$diffs_table_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = diffs_table(),
    ##### reactable settings ------
    columns = list(
      `Modified Column` = reactable::colDef(
        class = "sticky left-col-1",
        headerClass = "sticky left-col-1",
        style = function(value) {
          color <- "#3252a8"
          list(background = "#f7f7f7", color = color)
        },
        headerStyle = list(background = "#f7f7f7", color = "#3252a8", 
                           fontWeight = 600)
      ),
      `Previous Value` = reactable::colDef(
        class = "sticky left-col-2",
        headerClass = "sticky left-col-2",
        style = function(value) {
          color <- "#a83242"
          list(background = "#f7f7f7", color = color)
        },
        headerStyle = list(background = "#f7f7f7", 
                           color = "#a83242", 
                           fontWeight = 600)
      ),
      `Current Value` = reactable::colDef(
        class = "sticky left-col-3",
        headerClass = "sticky left-col-3",
        style = function(value) {
          color <- "#40a832"
          list(background = "#f7f7f7", color = color)
        },
        headerStyle = list(background = "#f7f7f7", 
                           color = "#40a832", 
                           fontWeight = 600)
      )
    ),
    resizable = TRUE,
    # pagination = FALSE,
    highlight = TRUE,
    height = 300,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE
  )
})

# TAB 5.3 = RENDER current_diffs_display -----
output$current_diffs_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = data_x_reactive(),
    ##### reactable settings ------
    resizable = TRUE,
    # pagination = FALSE,
    highlight = TRUE,
    height = 300,
    wrap = FALSE,
    # bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 5.3 = RENDER previous_diffs_display -----
output$previous_diffs_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = data_y_reactive(),
    ##### reactable settings ------
    resizable = TRUE,
    # pagination = FALSE,
    highlight = TRUE,
    height = 300,
    wrap = FALSE,
    # bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})
# TAB 5.4 = Deleted Records REACTIVE -----
deleted_data_reactive <- reactive({
  deleted_data <- create_deleted_data(
    newdf = data_x_reactive(),
    olddf = data_y_reactive(),
    by = input$by_var
  )
  return(deleted_data)
})

# TAB 5.4 = Render Deleted Records ------
output$deleted_records_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = deleted_data_reactive(),
    ##### reactable settings ------
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    height = 400,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 5.5 = REACTIVE Observations obs_table() -----
obs_table <- reactive({
  req(input$run_comparedf)
  current_data <- as.character(input$file_name_x)
  previous_data <- as.character(input$file_name_y)
  obs.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "obs.table",
    by_col = input$by_var
  )
  return(obs.table)
})

## TAB 5.5 = RENDER [obs_table_display] -----
output$obs_table_display <- reactable::renderReactable({
  reactable::reactable(
    data = obs_table(),
    ##### reactable settings ------
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    height = 400,
    wrap = FALSE,
    # bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})



# TAB 5.5 = REACTIVE Vars no share vars_ns_table() -----
vars_ns_table <- reactive({
  req(input$run_comparedf)
  vars.ns.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "vars.ns.table",
    by_col = input$by_var
  )
  return(vars.ns.table)
})
## TAB 5.5 = RENDER [vars_ns_table_display] -----
output$vars_ns_table_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = vars_ns_table(),
    ##### reactable settings ------
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 5.5 = REACTIVE Vars no comp vars_nc_table() -----
vars_nc_table <- reactive({
  req(input$run_comparedf)
  vars.nc.table <- proc_extract_table(
    comparedf_list = comparedf_summary_reactive(),
    table = "vars.nc.table",
    by_col = input$by_var
  )
  return(vars.nc.table)
})
## TAB 5.5 = RENDER  [vars_nc_table_display] -----
output$vars_nc_table_display <- reactable::renderReactable({
  req(input$run_comparedf)
  reactable::reactable(
    data = vars_nc_table(),
    ##### reactable settings ------
    resizable = TRUE,
    pagination = FALSE,
    highlight = TRUE,
    wrap = FALSE,
    bordered = TRUE,
    searchable = TRUE,
    filterable = TRUE
  )
})

# TAB 6 = DOWNLOAD REPORT -----
output$report_download <- downloadHandler(
  filename = function() {
    paste0(report_date, "-proc-compare-report", ".xlsx")
  },
  content = function(file) {
    # create report workbook
    report_wb <- createWorkbook()
    # add sheets
    addWorksheet(wb = report_wb, sheetName = "Comparison-summary")
    addWorksheet(wb = report_wb, sheetName = "New-records")
    addWorksheet(wb = report_wb, sheetName = "Changes-per-variable")
    addWorksheet(wb = report_wb, sheetName = "Changes-detected")
    addWorksheet(wb = report_wb, sheetName = "Deleted-records")
    addWorksheet(wb = report_wb, sheetName = "Obs-not-shared")
    addWorksheet(wb = report_wb, sheetName = "Vars-not-shared")
    addWorksheet(wb = report_wb, sheetName = "Vars-not-compared")
    # Disabled to account for larger file size
    # addWorksheet(wb = report_wb, sheetName = input$file_name_x)
    # addWorksheet(wb = report_wb, sheetName = input$file_name_y)
    # write to sheets
    
    ##### write comparison summary -----
    comparison.summary.table <- proc_extract_table(
      comparedf_list = comparedf_summary_reactive(),
      table = "comparison.summary.table",
      by_col = input$new_col_name
    )
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Comparison-summary",
      x = comparison.summary.table,
      startCol = 1, startRow = 1
    )
    
    ##### write new records -----
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "New-records",
      x = new_data_reactive(),
      startCol = 1, startRow = 1
    )
    
    ##### write diffs.byvar.table -----
    
    diffs.byvar.table <- proc_extract_table(
      comparedf_list = comparedf_summary_reactive(),
      table = "diffs.byvar.table",
      by_col = input$new_col_name
    )
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Changes-per-variable",
      x = diffs.byvar.table,
      startCol = 1, startRow = 1
    )
    
    ##### write diffs.table -----
    diffs.table <- proc_extract_table(
      comparedf_list = comparedf_summary_reactive(),
      table = "diffs.table",
      by_col = input$new_col_name
    )
    # join to current data (data_x_reactive())
    diffs_table <- inner_join(
      x = data_x_reactive(),
      y = diffs.table,
      by = input$new_col_name
    )
    
    # reorganize cols
    diffs_table <- select(
      diffs_table,
      all_of(input$new_col_name),
      `Modified Column`,
      `Previous Value`,
      `Current Value`,
      everything()
    )
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Changes-detected",
      x = diffs_table,
      startCol = 1, startRow = 1
    )
    
    ##### write deleted records -----
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Deleted-records",
      x = deleted_data_reactive(),
      startCol = 1,
      startRow = 1
    )
    
    ##### write obs not shared -----
    current_data <- as.character(input$file_name_x)
    previous_data <- as.character(input$file_name_y)
    obs.table <- proc_extract_table(
      comparedf_list = comparedf_summary_reactive(),
      table = "obs.table",
      by_col = input$by_var
    )
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Obs-not-shared",
      x = obs.table,
      startCol = 1, startRow = 1
    )
    
    ##### write vars not shared -----
    vars.ns.table <- proc_extract_table(
      comparedf_list = comparedf_summary_reactive(),
      table = "vars.ns.table",
      by_col = input$by_var
    )
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Vars-not-shared",
      x = vars.ns.table,
      startCol = 1, startRow = 1
    )
    
    ##### write vars not compared -----
    vars.nc.table <- proc_extract_table(
      comparedf_list = comparedf_summary_reactive(),
      table = "vars.nc.table",
      by_col = input$by_var
    )
    
    writeData(
      wb = report_wb,
      borders = "rows",
      headerStyle = report_header_style,
      sheet = "Vars-not-compared",
      x = vars.nc.table,
      startCol = 1, startRow = 1
    )
    
    ##### write current data (disabled) -----
    # writeData(
    #   wb = report_wb,
    #   borders = "rows",
    #   headerStyle = report_header_style,
    #   sheet = input$file_name_x,
    #   x = data_x_reactive(),
    #   startCol = 1, startRow = 1
    # )
    
    ##### write previous data (disabled) -----
    # writeData(
    #   wb = report_wb,
    #   borders = "rows",
    #   headerStyle = report_header_style,
    #   sheet = input$file_name_y,
    #   x = data_y_reactive(),
    #   startCol = 1, startRow = 1
    # )
    
    saveWorkbook(report_wb, file = file, overwrite = TRUE)
  }
)
}

shinyApp(ui, server)