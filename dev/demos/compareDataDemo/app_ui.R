# packages ----------------------------------------------------------------
library(knitr)
library(arsenal)
library(diffdf)
library(stringr)
library(janitor)
library(dplyr)
library(tidyr)
library(tibble)
library(lubridate)
library(purrr)
library(rmdformats)
library(devtools)
library(hrbrthemes)
library(fs)
library(reactable)
library(rmarkdown)
library(markdown)
library(shiny)
library(shinythemes)
library(bs4Dash)
library(fresh)
library(RColorBrewer)

# dev_uploadDataUI --------------------------------------------------------
#' dev_uploadDataUI()
#'
#' @param id module id
#'
#' @export dev_uploadDataUI
#'
#' @description development UI module for upload
dev_uploadDataUI <- function(id) {
  tagList(
    h3("Upload a ", strong("base"), " (i.e., target) data source "),
    fluidRow(
      sortable(
        width = 12,
        # |- upload base file ----
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          title = tags$strong("Upload File (base)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [base_file] -------
                inputId = NS(
                  namespace = id,
                  id = "base_file"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"),
                  code(".txt"), code(".tsv"), code(".xlsx")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            column(
              width = 6,
              ### |-- INPUT [base_xlsx_sheets] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "base_xlsx_sheets"
                ),
                label = strong("Select sheet (if ", code(".xlsx"), " file):"),
                choices = c("", NULL)
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [base_filename] ---------
              tags$strong("Data file name:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_filename"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [base_new_name] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "base_new_name"
                ),
                label = strong(
                  "Provide a name to preview the", code("base"), " file:"
                )
              ),
              em("Not sure what name to use? Copy + paste the file name."),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [base_display_upload] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_display_upload"
                )
              )
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## base_dev_a -----
              code("base_dev_a"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_b -----
              code("base_dev_b"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_x -----
              code("base_dev_x"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_x"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_y -----
              code("base_dev_y"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_y"
                )
              )
            )
          )
        )
      )
    ),
    h3("Upload a ", strong("compare"), " (i.e., current) data source"),
    # br(), br(),
    fluidRow(
      sortable(
        width = 12,
        # |- upload compare file ----
        box(
          maximizable = TRUE,
          collapsed = FALSE,
          solidHeader = TRUE,
          status = "secondary",
          width = 12,
          collapsible = TRUE,
          closable = FALSE,
          title = tags$strong("Upload File (compare)"),
          fluidRow(
            column(
              width = 6,
              fileInput(
                ## |-- INPUT [comp_file] -------
                inputId = NS(
                  namespace = id,
                  id = "comp_file"
                ),
                label = tags$strong(
                  "Accepts: ",
                  code(".sas7bdat"), code(".csv"),
                  code(".txt"), code(".tsv"), code(".xlsx")
                ),
                accept = c(".sas7bdat", ".csv", ".txt", ".tsv", ".xlsx")
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [comp_xlsx_sheets] ---------
              selectInput(
                inputId = NS(
                  namespace = id,
                  id = "comp_xlsx_sheets"
                ),
                label = strong("Select sheet (if ", code(".xlsx"), " file):"),
                choices = c("", NULL)
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              ## |-- OUTPUT [comp_filename] ---------
              tags$strong("Data file name:"),
              shiny::htmlOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_filename"
                )
              )
            ),
            column(
              width = 6,
              ## |-- INPUT [comp_new_name] ---------
              textInput(
                inputId = NS(
                  namespace = id,
                  id = "comp_new_name"
                ),
                label = strong(
                  "Provide a name to preview the ", code("compare"), " file:"
                )
              ),
              em("Not sure what name to use? Copy + paste the file name."),
            )
          ),
          fluidRow(
            column(
              width = 12,
              br(), br(),
              ## |-- OUTPUT [comp_display_upload] ---------
              reactable::reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_display_upload"
                )
              )
            )
          )
        )
      )
    ),
    ## DEV -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (compare)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## comp_dev_a -----
              code("comp_dev_a"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_b -----
              code("comp_dev_b"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_x -----
              code("comp_dev_x"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_x"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_y -----
              code("comp_dev_y"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_y"
                )
              )
            )
          )
        )
      )
    )
  )
}

# dev_selectDataUI --------------------------------------------------------
#' dev_selectDataUI
#'
#' @param id module id
#'
#' @export dev_selectDataUI
#'
#' @description dev select UI module
dev_selectDataUI <- function(id) {
  tagList(
    h3("Select columns from ", strong("base"), "data"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = FALSE,
          closable = FALSE,
          status = "primary",
          width = 12,
          title = tags$strong("Select Base Data"),
          ## |-- INPUT [base_col_select] ---------
          ## displays the columns from the imported dataset
          br(),
          selectizeInput(
            inputId = NS(
              namespace = id,
              id = "base_col_select"
            ),
            label = strong("Select ", code("base"), " columns"),
            choices = c("", NULL),
            multiple = TRUE,
            selected = NULL
          ),
          ## |-- OUTPUT [base_data_display] ---------
          ## displays uploaded/named/selected data
          strong("Base Data"),
          br(), br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "base_data_display"
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (base)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## base_dev_a -----
              strong(code("base_dev_a"), "=", code("base_data()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_b -----
              strong(code("base_dev_b"), "=", code("base_name()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## base_dev_c -----
              strong(code("base_dev_c"), "=", code("input$base_col_select")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_dev_c"
                )
              )
            )
          )
        )
      )
    ),
    h3("Select columns from ", strong("compare"), "data"),
    br(),
    fluidRow(
      sortable(
        width = 12,
        box(
          maximizable = TRUE,
          collapsible = TRUE,
          collapsed = TRUE,
          closable = FALSE,
          status = "secondary",
          width = 12,
          title = tags$strong("Select Compare Data"),
          ## |-- INPUT [comp_col_select] ---------
          ## displays the columns from the imported dataset
          br(),
          selectizeInput(
            inputId = NS(
              namespace = id,
              id = "comp_col_select"
            ),
            label = strong("Select ", code("compare"), " columns"),
            choices = c("", NULL),
            multiple = TRUE,
            selected = c("", NULL)
          ),
          ## |-- OUTPUT [comp_data_display] ---------
          ## displays uploaded/named/selected data
          strong("Compare Data"),
          br(), br(),
          reactableOutput(
            outputId = NS(
              namespace = id,
              id = "comp_data_display"
            )
          )
        )
      )
    ),
    ## DEV (base) -----
    fluidRow(
      sortable(
        width = 12,
        box(
          width = 12,
          status = "info",
          solidHeader = TRUE,
          closable = TRUE,
          maximizable = TRUE,
          collapsed = TRUE,
          title = "Reactive values (comp)",
          strong(em("For DEV purposes only")),
          fluidRow(
            column(
              12,
              ## comp_dev_a -----
              strong(code("comp_dev_a"), "=", code("comp_data()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_a"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_b -----
              strong(code("comp_dev_b"), "=", code("comp_name()")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_b"
                )
              )
            )
          ),
          fluidRow(
            column(
              12,
              ## comp_dev_c -----
              strong(code("comp_dev_c"), "=", code("input$comp_col_select")),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_dev_c"
                )
              )
            )
          )
        )
      )
    ),
    h3("Select join columns between ", strong("base"), " and ", strong("compare")),
    br(),
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          solidHeader = FALSE,
          collapsed = FALSE,
          status = "info",
          width = 12,
          title = strong("Select Join Columns"),
          fluidRow(
            column(
              width = 5,
              h5(
                strong(
                  em("Intersecting columns:")
                )
              ),
              br(),
              ## OUTPUT |-- (intersecting_cols) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "intersecting_cols"
                )
              )
            ),
            column(
              width = 6,
              h5(
                strong(
                  em("Select Joining Column(s)")
                )
              ),
              ## INPUT |-- (by) ------
              selectizeInput(
                inputId = NS(
                  namespace = id,
                  id = "by"
                ),
                label =
                  em(
                    "Select the column (or columns) that create a unique observation between ",
                    code("base"), "and ", code("compare"), ""
                  ),
                choices = c("", NULL),
                multiple = TRUE,
                selected = c("", NULL)
              ),
              em(
                "The join column will be named", code("join_column"),
                "Leave blank for a row-by-row comparison"
              ),
              br(), br(),
              strong(
                "The final ", code("base"), " and ",
                code("compare"), "data are displayed below to review"
              )
              # h5( ## placeholder for 'Name Joining Column(s)'
              # ),
            )
          )
        )
      ),
      sortable(
        bs4Dash::box(
          width = 12,
          title = strong(code("base"), " data (for comparison)"),
          solidHeader = FALSE,
          maximizable = TRUE,
          collapsed = TRUE,
          status = "primary",
          fluidRow(
            column(
              width = 12,
              ## OUTPUT |-- (comp_join_col_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "base_join_col_display"
                )
              )
            )
          )
        )
      ),
      bs4Dash::sortable(
        bs4Dash::box(
          width = 12,
          title = strong(code("compare"), " data (for comparison)"),
          solidHeader = FALSE,
          collapsed = TRUE,
          maximizable = TRUE,
          status = "secondary",
          fluidRow(
            column(
              width = 12,
              ## OUTPUT |-- (comp_join_col_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "comp_join_col_display"
                )
              )
            )
          )
        )
      ),
    )
  )
}

# dev_compareDataUI ----------------------------------
#' dev_compareDataUI
#'
#' @param id module id
#'
#' @export dev_compareDataUI
#'
#' @description dev compare UI module
dev_compareDataUI <- function(id) {
  tagList(
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        # Comparison Info ------
        title = strong("Comparison Info"),
        solidHeader = TRUE,
        maximizable = TRUE,
        collapsed = FALSE,
        status = "info",
        fluidRow(
          column(
            width = 6,
            h5(
              "The comparison information between", code("base"),
              " and ", code("compare"), " is below:"
            ),
            ## INPUT |-- (base_info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "base_info"
              )
            ),
            br(),
            ## OUTPUT |-- (comp_info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "comp_info"
              )
            )
          ),
          column(
            6,
            ## OUTPUT |-- (info) ------
            uiOutput(
              outputId = NS(
                namespace = id,
                id = "info"
              )
            ),
            br(),
            ## OUTPUT |-- (display_compare_cols) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "display_compare_cols"
              )
            )
          )
        ),
        fluidRow(
          column(width = 12,
            downloadButton(outputId =
                NS(namespace = id, id = "download"),
              label = "Download Report")
            )
        )
      )
    ),
    # New Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("New Data"),
        solidHeader = TRUE,
        maximizable = TRUE,
        collapsed = TRUE,
        status = "success",
        fluidRow(
          sortable(
            width = 12,
            column(
              width = 12,
              ## INPUT |-- (go_new_data) ------
              h5(
                "The new data between", code("base"),
                " and ", code("compare"), " are below:"
              ),
              actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_new_data"
                ),
                label = strong("Get new data!"),
                status = "success"
              ),
              br(), br(),
              ## OUTPUT |-- (new_data_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "new_data_display"
                )
              )
            )
          )
        )
      )
    ),
    # Deleted Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Deleted Data"),
        solidHeader = TRUE,
        collapsed = TRUE,
        maximizable = TRUE,
        status = "danger",
        fluidRow(
          sortable(
            width = 12,
            column(
              width = 12,
              h5(
                "The deleted data between", code("base"),
                " and ", code("compare"), " are below:"
              ),
              ## INPUT |-- (go_deleted_data) ------
              actionButton(
                inputId = NS(
                  namespace = id,
                  id = "go_deleted_data"
                ),
                status = "danger",
                label = strong("Get deleted data!")
              ),
              br(), br(),
              ## OUTPUT |-- (deleted_data_display) ------
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "deleted_data_display"
                )
              )
            )
          )
        )
      )
    ),
    # Changed Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Changed Data"),
        solidHeader = TRUE,
        collapsed = TRUE,
        maximizable = TRUE,
        status = "warning",
        fluidRow(
          column(
            width = 12,
            ## OUTPUT |-- (go_changed_data) ------
            h5(
              "The changed data between", code("base"),
              " and ", code("compare"), " are below:"
            ),
            actionButton(
              inputId = NS(
                namespace = id,
                id = "go_changed_data"
              ),
              status = "warning",
              label = strong("Get changed data!")
            )
          )
        ),
        br(), br(),
        p(strong("Differences by Variable:")),
        fluidRow(
          column(
            width = 5,
            ## OUTPUT |-- (num_diffs_display) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "num_diffs_display"
              )
            )
          ),
          column(
            width = 7,
            ## OUTPUT |-- (num_diffs_graph) ------
            plotOutput(outputId = NS(
              namespace = id,
              id = "num_diffs_graph"
            ))
          )
        )
      )
    ),
    # Changed Data ------
    bs4Dash::sortable(
      bs4Dash::box(
        width = 12,
        title = strong("Review Changes"),
        solidHeader = TRUE,
        collapsed = TRUE,
        maximizable = TRUE,
        status = "warning",
        fluidRow(
          column(
            width = 12,
            h5(
              "Review the changes between", code("base"),
              " and ", code("compare"), " below:"
            ),
            ## OUTPUT |-- (go_changed_data) ------
            actionButton(
              inputId = NS(
                namespace = id,
                id = "go_review_changed_data"
              ),
              status = "warning",
              label = strong("Review changed data!")
            ),
            br(), br(),
            p(strong(
              "The columns from the ",
              code("compare"),
              " data have been included with the row-by-row changes:"
            )),
            p(em(
              "The ",
              code("join_source"),
              " column contains the column(s) used to join ",
              code("base"), " and ", code("compare")
            )),
            p(em(
              "The ",
              code("data_source"),
              " column contains original name of ",
              code("base"), " and ", code("compare")
            )),
            fluidRow(
              column(
                width = 12,
                ## OUTPUT |-- (var_diffs_display) ------
                reactableOutput(
                  outputId = NS(
                    namespace = id,
                    id = "var_diffs_display"
                  )
                )
              )
            )
          )
        )
      )
    ),
    sortable(
      width = 12,
      box(
        width = 12,
        status = "info",
        solidHeader = TRUE,
        closable = TRUE,
        maximizable = TRUE,
        collapsed = TRUE,
        title = "Reactive values (base)",
        strong(em("For DEV purposes only")),
        fluidRow(
          column(
            12,
            ## dev_a -----
            strong(code("dev_a"), "=", code("base_join_data()")),
            verbatimTextOutput(
              outputId = NS(
                namespace = id,
                id = "dev_a"
              )
            )
          )
        ),
        fluidRow(
          column(
            12,
            ## dev_b -----
            strong(code("dev_b"), "=", code("comp_join_data()")),
            verbatimTextOutput(
              outputId = NS(
                namespace = id,
                id = "dev_b"
              )
            )
          )
        ),
        fluidRow(
          column(
            12,
            ## dev_c -----
            strong(code("dev_c"), "=", code("compare_cols()")),
            verbatimTextOutput(
              outputId = NS(
                namespace = id,
                id = "dev_c"
              )
            )
          )
        )
      )
    )
  )
}
