#' compareDataUI
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
#' @export compareDataUI
#'
#' @description compare UI module
compareDataUI <- function(id) {
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
          bs4Dash::column(
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
          bs4Dash::column(
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
          bs4Dash::column(width = 12,
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
            bs4Dash::column(
              width = 12,
              ## INPUT |-- (go_new_data) ------
              h5(
                "The new data between", code("base"),
                " and ", code("compare"), " are below:"
              ),
              shiny::actionButton(
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
            bs4Dash::column(
              width = 12,
              h5(
                "The deleted data between", code("base"),
                " and ", code("compare"), " are below:"
              ),
              ## INPUT |-- (go_deleted_data) ------
              shiny::actionButton(
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
          bs4Dash::column(
            width = 12,
            ## OUTPUT |-- (go_changed_data) ------
            h5(
              "The changed data between", code("base"),
              " and ", code("compare"), " are below:"
            ),
            shiny::actionButton(
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
          bs4Dash::column(
            width = 5,
            ## OUTPUT |-- (num_diffs_display) ------
            reactableOutput(
              outputId = NS(
                namespace = id,
                id = "num_diffs_display"
              )
            )
          ),
          bs4Dash::column(
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
          bs4Dash::column(
            width = 12,
            h5(
              "Review the changes between", code("base"),
              " and ", code("compare"), " below:"
            ),
            ## OUTPUT |-- (go_changed_data) ------
            shiny::actionButton(
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
              " bs4Dash::column contains the bs4Dash::column(s) used to join ",
              code("base"), " and ", code("compare")
            )),
            p(em(
              "The ",
              code("data_source"),
              " bs4Dash::column contains original name of ",
              code("base"), " and ", code("compare")
            )),
            fluidRow(
              bs4Dash::column(
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
    )
  )
}
