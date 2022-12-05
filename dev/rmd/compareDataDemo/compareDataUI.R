#' compareDataUI() (UI module for compareData)
#'
#' @param id module id (from NS)
#'
#' @return UI for compare data tab
#' @export compareDataUI
#'
compareDataUI <- function(id) {
  tagList(
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          solidHeader = TRUE,
          status = "primary",
          width = 12,
          title = "Join data tables",
          fluidRow(
            bs4Dash::column(
              width = 6,
              ## OUTPUT |-- (intersecting_cols) ------
              strong(em("The following columns are in both tables:")),
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "intersecting_cols"
                )
              )
            ),
            bs4Dash::column(
              width = 6,
              ## OUTPUT |-- (new_join_col) ------
              selectizeInput(
                inputId = NS(
                  namespace = id,
                  id = "new_join_col"
                ),
                label = strong(em("Select the bs4Dash::column (or columns) for joining the two datasets:")),
                choices = c("", NULL),
                multiple = TRUE,
                selected = c("", NULL)
              ),
              ## OUTPUT |-- (new_join_var) ------
              strong(em("Below is your new join variable:")),
              reactableOutput(
                outputId = NS(
                  namespace = id,
                  id = "new_join_var"
                )
              )
            )
          )
        )
      )
    ),

# dev display -------------------------------------------------------------
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          width = 12,
          title = "dev display",
          solidHeader = TRUE,
          status = "primary",
          fluidRow(
            sortable(
              width = 6,
              ## OUTPUT |-- (dev_display_a) ------
              strong("prev()"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "dev_display_a"
                )
              )
            ),
            sortable(
              width = 6,
              ## OUTPUT |-- (dev_display_b) ------
              strong("curr()"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "dev_display_b"
                )
              )
            )
          ),
          fluidRow(
            sortable(
              width = 6,
              ## OUTPUT |-- (new_data()) ------
              strong("new_data()"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "dev_display_x"
                )
              )
            ),
            sortable(
              width = 6,
              ## OUTPUT |-- (dev_display_y) ------
              strong("dev_display_y"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "dev_display_y"
                )
              )
            )
          )
        )
      )
    ),
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          width = 12,
          title = "New Records",
          solidHeader = TRUE,
          status = "primary",
          fluidRow(
            sortable(
              width = 12,
              ## OUTPUT |-- (new_records_display) ------
              strong("new_records_display"),
              verbatimTextOutput(
                outputId = NS(
                  namespace = id,
                  id = "new_records_display"
                )
              )
            )
          )
        )
      )
    ),
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          width = 12,
          title = "Deleted Records",
          solidHeader = TRUE,
          status = "primary",
          fluidRow(
            sortable(
              width = 6,
              ## OUTPUT |-- () ------
              strong("deleted_display")
            ),
            sortable(
              width = 6,
              ## OUTPUT |-- () ------
              strong("deleted_graph")
            )
          )
        )
      )
    ),
    fluidRow(
      bs4Dash::sortable(
        width = 12,
        bs4Dash::box(
          width = 12,
          title = "Modified Records",
          solidHeader = TRUE,
          status = "primary",
          h5(em(".")),
          fluidRow(
            sortable(
              width = 6,
              ## OUTPUT |-- () ------
              strong("Output = diffs_display")
            ),
            sortable(
              width = 6,
              ## OUTPUT |-- () ------
              strong("Output = diffs_byvar_display")
            )
          ),
          fluidRow(
            sortable(
              width = 12,
              ## OUTPUT |-- () ------
              strong("Output = diff_byvar_graph"))
          )
        )
      )
    )
  )
}
