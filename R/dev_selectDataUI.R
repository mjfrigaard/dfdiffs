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
          collapsed = TRUE,
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
