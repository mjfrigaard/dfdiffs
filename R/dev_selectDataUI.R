#' dev_selectDataUI
#'
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
            bs4Dash::column(
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
                    "Select the bs4Dash::column (or columns) that create a unique observation between ",
                    code("base"), "and ", code("compare"), ""
                  ),
                choices = c("", NULL),
                multiple = TRUE,
                selected = c("", NULL)
              ),
              em(
                "The join bs4Dash::column will be named", code("join_column"),
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
            bs4Dash::column(
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
            bs4Dash::column(
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
