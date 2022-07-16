#' compareDataUI
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
        )
      )
    ),
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
        ),
        br(), br(),
        p(strong("Row-by-row Differences:")),
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
}
